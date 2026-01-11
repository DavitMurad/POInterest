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
              let retrievedPlaces = try await DatabaseManager.shared.getUser(uid: user.uid).savedPlaces
              
              await MainActor.run {
                  self.savedPlaces = retrievedPlaces
                  self.hasFetchedPlaces = true
              }
          } catch {
              await MainActor.run {
                  self.hasFetchedPlaces = true
                  print("Error fetching saved places: \(error)")
              }
          }
      }
    
    func savePlace(place: PlaceModel) async {
           do {
               guard let uid = AuthManager.shared.currentUser?.uid else { return }
               try await DatabaseManager.shared.savePlace(uid: uid, place: place)
               await getSavedPlaces()
           } catch {
               print("Error saving place: \(error)")
           }
       }
       
       func removePlace(place: PlaceModel) async {
           do {
               guard let uid = AuthManager.shared.currentUser?.uid else { return }
               try await DatabaseManager.shared.removePlace(uid: uid, place: place)
               await getSavedPlaces()
           } catch {
               print("Error removing place: \(error)")
           }
       }
}
