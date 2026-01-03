//
//  AuthStateManager.swift
//  POInterest
//
//  Created by Davit Muradyan on 03.01.26.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
class AuthStateManager: ObservableObject {
    @Published var isAuthenticated = false
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
    }
    
    private func registerAuthStateHandler() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
