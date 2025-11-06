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
    @Published var hasDeletedAcc = false
    func signOut() throws {
       try AuthManager.shared.signOut()
        hasSignedOut = true
    }
    
    func deleteUser() async throws {
        try await AuthManager.shared.deleteAcoount()
        hasDeletedAcc = true
    }
    
}
