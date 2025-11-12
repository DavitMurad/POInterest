//
//  LocationManager.swift
//  POInterest
//
//  Created by Davit Muradyan on 07.11.25.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var heading: CLHeading?
    @Published var authorizationStatus: CLAuthorizationStatus?

    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 5
        locationManager.headingFilter = 5
    }
    
    func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
          locationManager.startUpdatingLocation()
          locationManager.startUpdatingHeading()
      }
      
      func stopUpdating() {
          locationManager.stopUpdatingLocation()
          locationManager.stopUpdatingHeading()
      }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
           heading = newHeading
       }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           authorizationStatus = manager.authorizationStatus
       }
    
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.first
//    }
}
