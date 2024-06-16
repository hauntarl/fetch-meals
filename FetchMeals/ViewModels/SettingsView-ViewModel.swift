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
        @Published public private(set) var categories: [MealCategory] = []
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
        
        public func fetchCategories() async {
            guard let response = try? await network.fetchCategories() else {
                return
            }
            categories = response
        }
    }
}
