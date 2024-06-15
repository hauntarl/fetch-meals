//
//  SettingsView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import Observation
import SwiftUI

public extension SettingsView {
    /// Responsible for managing the state of `SettingsView` by providing
    /// the currently selected category, sort key, and sort order
    final class ViewModel: ObservableObject {
        @Published public var category: MealCategory
        @Published public var sortKey: MealSortKey
        @Published public var sortOrder: MealSortOrder
        
        public init(
            category: MealCategory = .dessert,
            sortKey: MealSortKey = .name,
            sortOrder: MealSortOrder = .ascending
        ) {
            self.category = category
            self.sortKey = sortKey
            self.sortOrder = sortOrder
        }
    }
}
