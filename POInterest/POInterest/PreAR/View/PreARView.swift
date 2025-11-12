//
//  PreARView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.10.25.
//

import SwiftUI
import FirebaseAuth

struct PreARView: View {
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
                    .shadow(color: .black.opacity(0.3), radius: 5)
                 
            }
            

        }.navigationDestination(isPresented: $pressedStart) {
            ARView()
        }
      
    }
}

//#Preview {
//    PreARView()
//}
