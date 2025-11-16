//
//  Place.swift
//  POInterest
//
//  Created by Davit Muradyan on 07.11.25.
//

import Foundation
import CoreLocation

struct PlaceModel: Identifiable  {
    let id: String?
    let name: String?
    let description: String?
    let location: String?
    let imageName: String?
    let category: String
    let rating: Double?
    let status: Bool?
    let reviews: [String?]
    let phone: String?
    let url: String?
    let coordinates: CLLocationCoordinate2D
    let distance: Double
    
}


//{
//  "id": "IA5C4DE24D6D25317",
//  "name": "The Grosvenor Cafe",
//  "category": "cafe",
//  "location": {
//    "address": "24 Ashton Lane, Glasgow, G12 8SJ, Scotland",
//    "coordinates": {
//      "latitude": 55.875,
//      "longitude": -4.293
//    },
//    "distance_meters": 458.99993731322064,
//    "time_zone": "Europe/London (GMT)"
//  },
//  "contact": {
//    "phone": "+44 141 341 1234",
//    "url": "https://grosvenorcafe.co.uk"
//  },
//  "rating": null,
//  "status": null,
//  "reviews": []
//}
