//
//  UserViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 18.12.25.
//

import Foundation
import Combine
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var currentDBUser: DBUser?
    
    func loadCurrentUser() async throws {
        guard let uid = AuthManager.shared.currentUser?.uid else { return }
        currentDBUser = try await DatabaseManager.shared.getUser(uid: uid)
    }
}
