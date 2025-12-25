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
        NavigationStack {
            TabView {
                Tab("Explore", systemImage: "camera.viewfinder") {
                    PreARView()
                }
                
                Tab("Saved Places", systemImage: "mappin.and.ellipse") {
                    SavedPlacesView()
                        .environmentObject(savedPlacesVM)
                }
                
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
            .conditionaGlassEffect()
            
        }
        .navigationBarBackButtonHidden()
       
     }
}

//#Preview {
//    RootView()
//}
