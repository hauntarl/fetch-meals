//
//  CategoryView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import Observation
import SwiftUI

public extension CategoryView {
    class ViewModel: ObservableObject {
        @Published public var category: MealCategory = .dessert
        
        public init() {}
        
        @MainActor
        public func update(category: MealCategory) {
            self.category = category
        }
    }
}
