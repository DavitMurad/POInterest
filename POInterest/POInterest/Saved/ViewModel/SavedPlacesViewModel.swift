//
//  SavedPlacesViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.11.25.
//

import Foundation

import Combine

class SavedPlacesViewModel: ObservableObject {
    @Published var savedPlaces = [String]()
    
    init() {
        savedPlaces += ["Blacksheep", "Ronzio"]
    }
}
