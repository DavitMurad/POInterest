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
    
    func getSavedPlaces() async {
        do {
            guard let user = AuthManager.shared.currentUser else { return }
            let retrivedPlaces = try await DatabaseManager.shared.getUser(uid:  user.uid).savedPlaces
            if !savedPlaces.contains(where: {$0 == retrivedPlaces[0]}) {
                savedPlaces.append(contentsOf: retrivedPlaces)
            }
           
        }  catch(let error) {
            print(error.localizedDescription)
        }
       
    }
}
