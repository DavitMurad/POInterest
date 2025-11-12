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
            
            return PlaceModel(id: item.identifier?.rawValue ?? "2", name: item.name ?? "Place", description: item.description, address: "item.location.description ", imageName: nil, category: query, rating: nil, status: nil, reviews: [nil], phone: item.phoneNumber, coordinates: item.placemark.coordinate, distance: distance)
            
        }
    }
}
