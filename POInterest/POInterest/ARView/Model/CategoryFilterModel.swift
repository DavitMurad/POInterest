//
//  CategoryFilterModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 08.11.25.
//

import Foundation

struct CategoryFilterModel: Equatable, Hashable {
    var title: String
    var imageName: String
    let isDropDown: Bool
    let categoryRawValue: String
}
