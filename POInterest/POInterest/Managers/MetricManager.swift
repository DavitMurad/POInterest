//
//  MetricManager.swift
//  POInterest
//
//  Created by Davit Muradyan on 06.12.25.
//

import Foundation
import SwiftUI
enum DistanceMeasureUnit: CaseIterable {
    case m
    case feet
    
}

enum DistanceOptionEnumMeters: Double, CaseIterable {
    case fiftyMeters = 50.0
    case hundredMeters = 100.0
    case twoHundredFiftyMeters = 250.0
    case fiveHundedMeters = 500.0
}


class MetricManager {
    static let shared = MetricManager()
    
    @AppStorage("defaultRadiusMeters") private var defaultRadiusMeters: Double = 250.0
    
    var defaultMeter: DistanceOptionEnumMeters {
          get {
              DistanceOptionEnumMeters(rawValue: defaultRadiusMeters) ?? .twoHundredFiftyMeters
          }
          set {
              defaultRadiusMeters = newValue.rawValue
          }
      }
    
    var searchRadius: Double {
        defaultRadiusMeters
    }
}
