//
//  TabViewExtension.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//


import SwiftUI

extension View {
    func conditionaGlassEffect() -> some View {
        if #available(iOS 26.0, *) {
            return self.glassEffect()
        }
        return self
    }
}
