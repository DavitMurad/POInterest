//
//  ARLocationCoordinator.swift
//  POInterest
//
//  Created by Davit Muradyan on 17.11.25.
//


import SwiftUI
import RealityKit
import ARKit
import CoreLocation
import Combine

class ARLocationCoordinator: NSObject, ARSCNViewDelegate {
    var sceneView: ARSCNView
    var locationManager: LocationManager
    var places: [PlaceModel]
    var labelNodes: [String: SCNNode] = [:]
    var updateTimer: Timer?
    
    init(sceneView: ARSCNView, locationManager: LocationManager, places: [PlaceModel]) {
        self.sceneView = sceneView
        self.locationManager = locationManager
        self.places = places
        super.init()
        
        sceneView.delegate = self
        startUpdateTimer()
    }
    
    deinit {
        updateTimer?.invalidate()
    }
    
    func startUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateAllLabels()
        }
    }
    
    func updatePlaces(_ newPlaces: [PlaceModel]) {
        let newPlaceIds = Set(newPlaces.compactMap { $0.id })
        let currentPlaceIds = Set(labelNodes.keys)
        
        for removedId in currentPlaceIds.subtracting(newPlaceIds) {
            if let node = labelNodes[removedId] {
                node.removeFromParentNode()
                labelNodes.removeValue(forKey: removedId)
            }
        }
        self.places = newPlaces
        updateAllLabels()
    }
    
    func updateAllLabels() {
        guard let userLocation = locationManager.currentLocation else { return }
        let heading = locationManager.heading
        
        for place in places {
            guard let placeId = place.id else { continue }
            
            let poiLocation = CLLocation(
                latitude: place.coordinates.latitude,
                longitude: place.coordinates.longitude
            )
            
            let distance = userLocation.distance(from: poiLocation)
            let bearing = userLocation.bearing(to: poiLocation)
            
            // Adjust bearing based on device heading
            var adjustedBearing = bearing
            if let heading = heading {
                adjustedBearing = bearing - heading.trueHeading
            }
            
            // Create or update AR label
            if labelNodes[placeId] == nil {
                createARLabel(for: place, bearing: adjustedBearing, distance: distance)
            } else {
                updateARLabel(for: place, bearing: adjustedBearing, distance: distance)
            }
        }
    }
    
    func createARLabel(for place: PlaceModel, bearing: Double, distance: Double) {
        guard let placeId = place.id else { return }
        
        // Create parent node
        let parentNode = SCNNode()
        
        // Calculate position based on bearing and distance
        let position = calculateARPosition(bearing: bearing, distance: distance)
        parentNode.position = position
        
        // Create text with place name and distance
        let placeName = place.name ?? "Unknown"
        let text = "\(placeName)\n\(Int(distance))m"
        
        // Create text geometry
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        textGeometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        textGeometry.firstMaterial?.specular.contents = UIColor.white
        textGeometry.flatness = 0.1
        
        let textNode = SCNNode(geometry: textGeometry)
        
        // Center the text
        let (min, max) = textGeometry.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, 0)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        // Create background plane
        let backgroundGeometry = SCNPlane(width: 2.5, height: 1.0)
        backgroundGeometry.cornerRadius = 0.1
        backgroundGeometry.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.9)
        
        let backgroundNode = SCNNode(geometry: backgroundGeometry)
        backgroundNode.position = SCNVector3(0, 0, -0.05)
        
        // Create marker sphere
//        let markerGeometry = SCNSphere(radius: 0.15)
//        markerGeometry.firstMaterial?.diffuse.contents = UIColor.systemRed
        
//        let markerNode = SCNNode(geometry: markerGeometry)
//        markerNode.position = SCNVector3(0, 0.7, 0)
        
        // Add all to parent
        parentNode.addChildNode(backgroundNode)
        parentNode.addChildNode(textNode)
//        parentNode.addChildNode(markerNode)
        
        // Make label face camera
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = [.Y]
        parentNode.constraints = [constraint]
        
        sceneView.scene.rootNode.addChildNode(parentNode)
        labelNodes[placeId] = parentNode
    }
    
    func updateARLabel(for place: PlaceModel, bearing: Double, distance: Double) {
        guard let placeId = place.id,
              let parentNode = labelNodes[placeId] else { return }
        
        let position = calculateARPosition(bearing: bearing, distance: distance)
        parentNode.position = position
        
        // Update text
        if let textNode = parentNode.childNodes.first(where: { $0.geometry is SCNText }) {
            let placeName = place.name ?? "Unknown"
            let text = "\(placeName)\n\(Int(distance))m"
            
            if let textGeometry = textNode.geometry as? SCNText {
                textGeometry.string = text
            }
        }
    }
    
    func calculateARPosition(bearing: Double, distance: Double) -> SCNVector3 {
        // Scale factor: real distance to AR space
        // For distances up to 500m, we map to max 20m in AR space
        let maxARDistance: Float = 20
        let maxRealDistance: Float = 500
        let scaledDistance = min(Float(distance) / maxRealDistance * maxARDistance, maxARDistance)
        
        // Convert bearing to radians (bearing is clockwise from north)
        let bearingRad = Float(bearing * .pi / 180.0)
        
        // Calculate position
        let x = scaledDistance * sin(bearingRad)
        let z = -scaledDistance * cos(bearingRad)
        let y: Float = 0 // At eye level
        
        return SCNVector3(x, y, z)
    }
}


extension CLLocation {
    func bearing(to destination: CLLocation) -> CLLocationDegrees {
        let lat1 = self.coordinate.latitude.degreesToRadians
        let lon1 = self.coordinate.longitude.degreesToRadians
        let lat2 = destination.coordinate.latitude.degreesToRadians
        let lon2 = destination.coordinate.longitude.degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let radiansBearing = atan2(y, x)
        
        // Convert from radians to degrees
        var degreesBearing = radiansBearing.radiansToDegrees
        
        // Normalize 0–360°
        if degreesBearing < 0 {
            degreesBearing += 360
        }
        
        return degreesBearing
    }
}

extension CLLocationDegrees {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}
