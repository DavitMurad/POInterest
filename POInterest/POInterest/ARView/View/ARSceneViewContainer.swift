//
//  ARSceneViewContainer.swift
//  POInterest
//
//  Created by Davit Muradyan on 17.11.25.
//


import SwiftUI
import ARKit
import SceneKit
import CoreLocation
import Combine

struct ARSceneViewContainer: UIViewRepresentable {
    var locationManager: LocationManager
    var places: [PlaceModel]
    @Binding var selectedPlace: PlaceModel?
    
    func makeCoordinator() -> ARLocationCoordinator {
        let sceneView = ARSCNView(frame: .zero)
        let coordinator = ARLocationCoordinator(sceneView: sceneView, locationManager: locationManager, places: places)
        
        coordinator.onPlaceTapped = { place in
            selectedPlace = place
        }
        
        return coordinator
        
        
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = context.coordinator.sceneView
        
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        configuration.planeDetection = []
        
        sceneView.session.run(configuration)
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        context.coordinator.updatePlaces(places)
        context.coordinator.onPlaceTapped = { place in
                   selectedPlace = place
               }
    }
    
    static func dismantleUIView(_ uiView: ARSCNView, coordinator: ARLocationCoordinator) {
        coordinator.updateTimer?.invalidate()
        uiView.session.pause()
    }
}
