//
//  Place.swift
//  POInterest
//
//  Created by Davit Muradyan on 07.11.25.
//

import Foundation
import CoreLocation

struct PlaceModel: Identifiable  {
    let id: String
    let name: String
    let description: String?
    let address: String
    let imageName: String?
    let category: String
    let rating: Double?
    let status: Bool?
    let reviews: [String?]
    let phone: String?
    
    let coordinates: CLLocationCoordinate2D
    let distance: Double
    
}
