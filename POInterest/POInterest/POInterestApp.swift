//
//  POInterestApp.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.10.25.
//

import SwiftUI
import Firebase
import GoogleSignIn


@main
struct POInterestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authStateManager = AuthStateManager()
    
    var body: some Scene {
        WindowGroup {
            if authStateManager.isAuthenticated {
                RootView()
                    .environmentObject(authStateManager)
            } else {
                LoginView()
                    .environmentObject(authStateManager)
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("Error restoring sign-in: \(error.localizedDescription)")
            }
        }
        print("Firebase is set up")
        return true
    }
}
