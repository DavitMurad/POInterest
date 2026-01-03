//
//  SettingsViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 03.11.25.
//

import Foundation
import Combine

@MainActor
class SettingsViewModel: ObservableObject {

    @Published var hasSignedOut = false
    @Published var hasDeletedAcc = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    func signOut() {
        isLoading = true
        defer { isLoading = false }

        do {
            try AuthManager.shared.signOut()
            hasSignedOut = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteUser() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AuthManager.shared.deleteAccount()
            hasDeletedAcc = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

