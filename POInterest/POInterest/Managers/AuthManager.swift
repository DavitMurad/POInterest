//
//  AuthManager.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let name: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.name = user.displayName
    }
    
}

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    var userName: String? {
        currentUser?.displayName
    }
    
    var userEmail: String? {
        currentUser?.email
    }
    
    func createUser(email: String, password: String, name: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let changeRequest = authDataResult.user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        try await changeRequest.commitChanges()
        try await authDataResult.user.reload()
        return AuthDataResultModel(user: authDataResult.user)
        
    }
    
    func loginUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
