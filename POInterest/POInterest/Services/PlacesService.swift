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
    case gasStaion
    case hostpial
    case parking
    case publicTransport
    case fitnessCenter
    case school
    case university
    case amusmentPark
    
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
        case .gasStaion:
            return ("fuelpump", "Gas Station")
        case .hostpial:
            return ("cross.case", "Hospital")
        case .parking:
            return ("parkingsign", "Parking")
        case .publicTransport:
            return ("bus.fill", "Public Transport")
        case .fitnessCenter:
            return ("figure.run.treadmill", "Fitness Center")
        case .school:
            return ("backpack", "School")
        case .university:
            return ("graduationcap", "University")
        case .amusmentPark:
           return ("figure.2.and.child.holdinghands", "Amusement Park")
        }
    }
}

class PlacesService {
    
    func fethNearbyPlaces(location: CLLocation, radius: Double, query: String) async throws -> [PlaceModel] {
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
            
            return PlaceModel(id: item.identifier?.rawValue, name: item.name, description: item.description, location: address, imageName: nil, category: query, rating: nil, status: nil, reviews: [nil], phone: item.phoneNumber, url: item.url?.absoluteString, coordinates: item.placemark.coordinate, distance: distance)
            
        }
    }
}
