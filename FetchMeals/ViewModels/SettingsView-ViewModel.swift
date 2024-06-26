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
        @Published public var categories: [MealCategory] = []
        @Published public var category: MealCategory = MealCategory.dessert
        @Published public var sortKey: MealSortKey
        @Published public var sortOrder: MealSortOrder
        
        public init(
            network: Network = NetworkProvider.shared,
            sortKey: MealSortKey = .name,
            sortOrder: MealSortOrder = .ascending
        ) {
            self.network = network
            self.sortKey = sortKey
            self.sortOrder = sortOrder
        }
        
        private let network: Network
        
        @MainActor
        public func fetchCategories() async {
            guard categories.isEmpty else {
                return
            }
            guard let response = try? await network.fetchCategories() else {
                return
            }
            categories = response.filter { category in
                !category.id.isEmpty && !category.name.isEmpty
            }
        }
    }
}
