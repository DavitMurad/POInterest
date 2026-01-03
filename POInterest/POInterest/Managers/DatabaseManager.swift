//
//  DatabaseManager.swift
//  POInterest
//
//  Created by Davit Muradyan on 17.12.25.
//

import Foundation
import FirebaseFirestore
struct DBUser: Codable {
    let uid: String
    let email: String?
    let name: String?
    var savedPlaces: [PlaceModel]
    
    init(uid: String, email: String?, name: String?, savedPlaces: [PlaceModel]) {
        self.uid = uid
        self.email = email
        self.name = name
        self.savedPlaces = savedPlaces
    }
    
}

class DatabaseManager {
    static let shared = DatabaseManager()
    
    func createORUpdateDBUser(user: DBUser) async throws {
        try Firestore.firestore()
            .collection("users")
            .document(user.uid)
            .setData(from: user, merge: true)
        
        print("Successfully stored the data")
    }
    
    func getUser(uid: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        
        let user = try snapshot.data(as: DBUser.self)
        return user
    }
    
    
    func isPlaceSaved(uid: String, place: PlaceModel) async throws -> Bool {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        
        let user = try snapshot.data(as: DBUser.self)
        if user.savedPlaces.contains(where: {$0.id == place.id}) {
            return true
        }
        return false
    }
    
    
    func savePlace(uid: String, place: PlaceModel) async throws {
    
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        
        var user = try snapshot.data(as: DBUser.self)
        if !user.savedPlaces.contains(where: {$0.id == place.id}) {
            user.savedPlaces.append(place)
        }

       try await createORUpdateDBUser(user: user)
    }
    
    func removePlace(uid: String, place: PlaceModel) async throws {
        
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        
        var user = try snapshot.data(as: DBUser.self)
        
        user.savedPlaces.removeAll(where: {$0.id == place.id})
        

       try await createORUpdateDBUser(user: user)
    }
    
    func deleteUser(uid: String) async throws {
        try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .delete()
        
        print("Successfully deleted user data")
    }
    
}

