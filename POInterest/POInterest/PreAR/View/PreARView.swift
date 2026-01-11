//
//  PreARView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.10.25.
//

import SwiftUI
import FirebaseAuth

struct PreARView: View {
    @EnvironmentObject var savedPlacesVM: SavedPlacesViewModel
    @State var pressedStart = false
    var body: some View {
        VStack {
            Text("Hi \(AuthManager.shared.currentUser?.displayName ?? "Explorer")")
                .font(Font.title2)
            
            Button {
                pressedStart = true
            } label: {
                Label("Start AR Experience", systemImage: "camera.viewfinder")
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .primary.opacity(0.2), radius: 5)
            }
            
        }.navigationDestination(isPresented: $pressedStart) {
            ARView().toolbarVisibility(.hidden, for: .tabBar)
                .environmentObject(savedPlacesVM)
        }
        
    }
}

//#Preview {
//    PreARView()
//}
