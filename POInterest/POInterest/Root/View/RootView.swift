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

    var body: some View {
        TabView {

            NavigationStack {
                PreARView()
                    .navigationTitle("Explore")
            }
            .tabItem {
                Label("Explore", systemImage: "camera.viewfinder")
            }

            NavigationStack {
                SavedPlacesView()
                    .environmentObject(savedPlacesVM)
                    .navigationTitle("Saved Places")
            }
            .tabItem {
                Label("Saved Places", systemImage: "mappin.and.ellipse")
            }

            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .conditionaGlassEffect()
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}


//#Preview {
//    RootView()
//}
