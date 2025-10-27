//
//  RootView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.10.25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            TabView {
                Tab("Place", systemImage: "camera.viewfinder") {
                    PreARView()
                }
                
                Tab("Place", systemImage: "heart.fill") {
                    PreARView()
                }
                Tab("Place", systemImage: "camera.viewfinder") {
                    PreARView()
                }
                
            }
            .glassEffect()
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    RootView()
}
