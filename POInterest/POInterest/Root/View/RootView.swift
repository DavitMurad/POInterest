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
                Tab("Explore", systemImage: "camera.viewfinder") {
                    PreARView()
                }
                
                Tab("Saved Places", systemImage: "mappin.and.ellipse") {
                    PreARView()
                }
                Tab("Settings", systemImage: "gear") {
                    PreARView()
                }
                
            }
            .conditionaGlassEffect()
        }
    }
}

//#Preview {
//    RootView()
//}
