//
//  RootView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.10.25.
//

import SwiftUI

struct RootView: View {

    let userName = AuthManager.shared.userName
    @StateObject var savedPlacesVM = SavedPlacesViewModel()
    @StateObject var locationManager = LocationManager()

    var body: some View {
        TabView {
            NavigationStack {
                PreARView()
                    .navigationTitle("Explore")
                    .environmentObject(savedPlacesVM)
                    .environmentObject(locationManager)
            }
            .tabItem {
                Label("Explore", systemImage: "camera.viewfinder")
                    .accessibilityLabel("Explore places in augmented reality")
                    .accessibilityHint("Switches to the AR exploration tab")
            }

            NavigationStack {
                SavedPlacesView()
                    .environmentObject(savedPlacesVM)
                    .environmentObject(locationManager)
                    .navigationTitle("Saved Places")
            }
            .tabItem {
                Label("Saved Places", systemImage: "mappin.and.ellipse")
                    .accessibilityLabel("View the saved places")
                    .accessibilityHint("Switches to Saved Places tab")
            }

            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
                    .accessibilityLabel("Go to settings")
                    .accessibilityHint("Switches to Settings tab")
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}


//#Preview {
//    RootView()
//}
