//
//  PlacesService.swift
//  POInterest
//
//  Created by Davit Muradyan on 07.11.25.
//

import Foundation
import MapKit

enum PlaceCategoryEnum: String, CaseIterable{
    case restaurant
    case cafe
    case hotel
    case store
    case bank
    case gasStation
    case hostpial
    case parking
    case publicTransport
    case fitness
    case school
    case university
    case park
    
    var iconName: (String, String) {
        switch self {
        case .restaurant:
            return ("fork.knife", "Restuarant")
        case .cafe:
            return ("cup.and.saucer", "Café")
        case .hotel:
            return ("bed.double", "Hotel")
        case .store:
            return ("storefront", "Store")
        case .bank:
            return ("sterlingsign.bank.building", "Bank")
        case .gasStation:
            return ("fuelpump", "Gas Station")
        case .hostpial:
            return ("cross.case", "Hospital")
        case .parking:
            return ("parkingsign", "Parking")
        case .publicTransport:
            return ("bus.fill", "Public Transport")
        case .fitness:
            return ("figure.run.treadmill", "Fitness Center")
        case .school:
            return ("backpack", "School")
        case .university:
            return ("graduationcap", "University")
        case .park:
           return ("figure.2.and.child.holdinghands", "Amusement Park")
        }
    }
    
    var imageName: String {
        switch self {
        case .restaurant:
            return "POIRestaurant"
        case .cafe:
            return "POICafe"
        case .hotel:
            return "POIHotel"
        case .store:
            return "POIStore"
        case .bank:
            return "POIBank"
        case .gasStation:
            return "POIGas"
        case .hostpial:
            return "POIHospital"
        case .parking:
            return "POIParking"
        case .publicTransport:
            return "POIPublicTransport"
        case .fitness:
            return "POIFitness"
        case .school:
            return "POISchool"
        case .university:
            return "POIUni"
        case .park:
            return "POIAmPark"
        }
    }
}

class PlacesService {
    
    func fethNearbyPlaces(location: CLLocation, radius: Double, query: String, savedPlaces: [PlaceModel] = []) async throws -> [PlaceModel] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems.compactMap { item -> PlaceModel? in
            guard let itemLocation = item.placemark.location else { return nil }

            let distance = location.distance(from: itemLocation)
            guard distance <= radius else { return nil }
            
            
            let placemark = item.placemark
            var addressComponents: [String] = []
            
            if let subThoroughfare = placemark.subThoroughfare {
                addressComponents.append(subThoroughfare)
            }
            if let thoroughfare = placemark.thoroughfare {
                addressComponents.append(thoroughfare)
            }
            if let locality = placemark.locality {
                addressComponents.append(locality)
            }
            if let administrativeArea = placemark.administrativeArea {
                addressComponents.append(administrativeArea)
            }
            if let postalCode = placemark.postalCode {
                addressComponents.append(postalCode)
            }
            
            let address = addressComponents.joined(separator: ", ")
            let placesEnum = PlaceCategoryEnum(query: query.lowercased())
            let placeId = item.identifier?.rawValue ?? "\(item.placemark.coordinate.latitude)_\(item.placemark.coordinate.longitude)"
            let isSaved = savedPlaces.contains { $0.id == placeId }
            
            return PlaceModel(id: item.identifier?.rawValue ?? "1", name: item.name, location: address, imageName: placesEnum?.imageName, iconName: placesEnum?.iconName.0 ?? "fork.knife", category: query, phone: item.phoneNumber, url: item.url?.absoluteString, coordinates: Coordinates(lat: item.placemark.coordinate.latitude, long: item.placemark.coordinate.longitude), distance: distance, isSaved: isSaved)
        }
    }
}

extension PlaceCategoryEnum {
    init?(query: String) {
        self.init(rawValue: query.lowercased())
    }
}
