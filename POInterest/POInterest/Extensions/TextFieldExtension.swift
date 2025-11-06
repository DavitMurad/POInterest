//
//  TextFieldExtension.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

extension TextField {
    func customTextFieldStyle() -> some View {
        return self
            .padding()
            .background(Color.gray.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.headline)
        
    }
}

extension SecureField {
    func customTextFieldStyle() -> some View {
        return self
            .padding()
            .background(Color.gray.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.headline)
        
    }
}
