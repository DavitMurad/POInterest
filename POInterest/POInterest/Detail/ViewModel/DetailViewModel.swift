//
//  DetailViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 18.12.25.
//

import Foundation
import Combine
import FirebaseAuth

class DetailViewModel: ObservableObject {
    
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
