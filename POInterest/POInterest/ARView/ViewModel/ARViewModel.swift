//
//  ARViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 09.11.25.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI

@MainActor
class ARViewModel: ObservableObject {
    @Published var places: [PlaceModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var categoryFilters = [CategoryFilterModel]()
    
    @Published var selectedFilterCategoy: String? = nil
    var savedPlacesVM = SavedPlacesViewModel()
    
    let locationManager = LocationManager()
    private let placesService = PlacesService()
    private var cancellables = Set<AnyCancellable>()
    
    var userLocation: CLLocation? {
        locationManager.currentLocation
    }
    
    var authStatus: CLAuthorizationStatus? {
        locationManager.authorizationStatus
    }
    
    init() {
        getCategoryFilters()
        
        print("PlacesViewModel initialized")
        locationManager.requestAuthorization()
        
        locationManager.$currentLocation
            .compactMap { $0 }
            .removeDuplicates { abs($0.coordinate.latitude - $1.coordinate.latitude) < 0.0001 }
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] location in
                print("Location changed significantly, fetching places...")
                Task {
                    await self?.fetchPlaces(at: location)
                }
            }
            .store(in: &cancellables)
    }
    
    func startTracking() {
        print("Starting location tracking...")
        locationManager.startUpdating()
        Task {
            await savedPlacesVM.getSavedPlaces()
        }
    }
    
    func stopTracking() {
        print("Stopping location tracking...")
        locationManager.stopUpdating()
    }
    
    func fetchPlaces(at location: CLLocation) async {
        isLoading = true
        errorMessage = nil
        
        do {
            
            guard let selectedFilterCategoy = selectedFilterCategoy else {return}
            let savedPlaces = savedPlacesVM.savedPlaces
            let fetchedPlaces = try await placesService.fethNearbyPlaces(location: location, radius: MetricManager.shared.defaultMeter.rawValue, query: selectedFilterCategoy, savedPlaces: savedPlaces)
            
            self.places = fetchedPlaces
            print("Successfully updated places array with \(fetchedPlaces.count) places")
        } catch {
            print("Error fetching places: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func manualRefresh() {
        print("Manual refresh requested")
        guard let location = userLocation else {
            print("No location available yet")
            return
        }
        Task {
            await fetchPlaces(at: location)
        }
    }
    
    func getCategoryFilters() {
        for placeCategory in PlaceCategoryEnum.allCases {
            categoryFilters.append(CategoryFilterModel(title: placeCategory.iconName.1, imageName: placeCategory.iconName.0, isDropDown: false, categoryRawValue: placeCategory.rawValue))
        }
    }
    
    func removePlaces() {
        self.places = []
    }
    
    func setSavedPlacesViewModel(_ viewModel: SavedPlacesViewModel) {
            self.savedPlacesVM = viewModel
        }
}
