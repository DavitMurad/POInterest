//
//  POInterestApp.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.10.25.
//

import SwiftUI
import Firebase

@main
struct POInterestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if let _ = AuthManager.shared.currentUser {
                RootView()
            } else {
                LoginView()
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("Firebase is set up")
    return true
  }
}
