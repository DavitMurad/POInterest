//
//  SettingsViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 03.11.25.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    @Published var hasSignedOut = false
    
    func signOut() throws {
       try AuthManager.shared.signOut()
        hasSignedOut = true
    }
    
}
