//
//  CustomToggleView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//


import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    var offTrackColor: Color = .red
    var offThumbColor: Color = .yellow
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? Color.accentColor : offTrackColor)
                    .frame(width: 50, height: 32)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(configuration.isOn ? .white : offThumbColor)
                    .frame(width: 28, height: 28)
                    .padding(2)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
        .padding(.vertical, 8)
    }
}
