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

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
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
        let authDataResultModel = AuthDataResultModel(user: authDataResult.user)
        try await DatabaseManager.shared.createORUpdateDBUser(user: DBUser(uid: authDataResultModel.uid, email:  authDataResultModel.email, name:  authDataResultModel.name, savedPlaces: []))
        return AuthDataResultModel(user: authDataResult.user)
        
    }
    
    func loginUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInWithGoogle(token: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credentials = GoogleAuthProvider.credential(withIDToken: token.idToken, accessToken: token.accessToken)
        return try await signIn(credentials: credentials)
    }
    
    func signIn(credentials: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credentials)
        let authDataResultModel = AuthDataResultModel(user: authDataResult.user)
        try await DatabaseManager.shared.createORUpdateDBUser(user: DBUser(uid: authDataResultModel.uid, email:  authDataResultModel.email, name:  authDataResultModel.name, savedPlaces: []))
        return authDataResultModel
    }
    
    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        try await DatabaseManager.shared.deleteUser(uid: user.uid)

        try await user.delete()
    }

}
