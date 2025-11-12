//
//  CategoryFilterViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 08.11.25.
//

import Foundation
import Combine

class CategoryFilterViewModel: ObservableObject {
    
    @Published var categoryFilters = [CategoryFilterModel]()
 
    @Published var selectedFilterCategoy: String? = nil
    
    init() {
        getCategoryFilters()
    }
    
    func getCategoryFilters() {
        for placeCategory in PlaceCategoryEnum.allCases {
            categoryFilters.append(CategoryFilterModel(title: placeCategory.rawValue, imageName: placeCategory.rawValue, isDropDown: false))
        }
    }
    
    
    
}
