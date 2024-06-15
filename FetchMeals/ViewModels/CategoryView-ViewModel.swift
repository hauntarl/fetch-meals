//
//  CategoryView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import Observation
import SwiftUI

public extension CategoryView {
    /// Responsible for managing the state of `CategoryView` by providing
    /// the currently selected category
    final class ViewModel: ObservableObject {
        @Published public var category: MealCategory
        
        /// Initializes the view model with the given category
        public init(category: MealCategory = .dessert) {
            self.category = category
        }
        
        /// Updates the selected category with the new value
        public func update(category: MealCategory) {
            self.category = category
        }
    }
}
