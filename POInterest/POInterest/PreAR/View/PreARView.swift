//
//  PreARView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.10.25.
//

import SwiftUI
import FirebaseAuth

struct PreARView: View {

    var body: some View {
        VStack {
            Text("Hi \(AuthManager.shared.currentUser?.displayName ?? "no user")")
                .font(Font.title2)
            
            Button {
                
            } label: {
                Label("Start AR Experience", systemImage: "camera.viewfinder")
                    .frame(width: 175, height: 50)
                    .padding(.horizontal)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.3), radius: 5)
                 
            }

        }
      
    }
}

#Preview {
    PreARView()
}
