//
//  CategoryFilterCell.swift
//  POInterest
//
//  Created by Davit Muradyan on 08.11.25.
//

import SwiftUI

struct CategoryFilterCell: View {
    var title: String
    var imageName: String
    var isSelected: Bool
    var isDropDown: Bool
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: imageName)
                .padding(.trailing, 5)
            Text(title)
            
            if isDropDown {
                Image(systemName: "chevron.down")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            ZStack {
                Capsule(style: .circular)
                    .fill(.blue)
                    .opacity(isSelected ? 1 : 0)
                Capsule(style: .circular)
                    .stroke(lineWidth: 1)
                
            }
        )
    }
}

//#Preview {
//    CategoryFilterCell(title: "Restuarants", imageName: "fork.knife", isSelected: true, isDropDown: true)
//}
