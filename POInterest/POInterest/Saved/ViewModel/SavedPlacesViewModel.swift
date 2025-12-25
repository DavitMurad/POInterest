//
//  SavedPlacesViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.11.25.
//

import Foundation

import Combine
import FirebaseAuth

class SavedPlacesViewModel: ObservableObject {
    @Published var savedPlaces = [PlaceModel]()
    @Published var hasFetchedPlaces = false
    
    func getSavedPlaces() async {
        do {
            guard let user = AuthManager.shared.currentUser else { return }
            let retrivedPlaces = try await DatabaseManager.shared.getUser(uid:  user.uid).savedPlaces
            if !savedPlaces.contains(where: {$0 == retrivedPlaces[0]}) {
                savedPlaces.append(contentsOf: retrivedPlaces)
                hasFetchedPlaces = true
                
            }
           
        }  catch(let error) {
            hasFetchedPlaces = false
        }
       
    }
    
    func savePlace(place: PlaceModel) async {
        do {
            try await DatabaseManager.shared.savePlace(uid: AuthManager.shared.currentUser?.uid ?? "12345", place: place)
        } catch (let error) {
            print("Error saving place: \(error)")
        }
    }
    
    func removePlace(place: PlaceModel) async {
        do {
            try await DatabaseManager.shared.removePlace(uid: AuthManager.shared.currentUser?.uid ?? "12345", place: place)
        } catch (let error) {
            print("Error removing place: \(error)")
        }
    }
}
