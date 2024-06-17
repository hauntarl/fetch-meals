//
//  MealsView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import Observation
import SwiftUI

public extension MealsView {
    /// Responsible for managing the state of `MealsView` and providing
    /// the list of meals
    final class ViewModel: ObservableObject {
        @Published public var state: ViewState<[MealItem]> = .loading
        @Published public var meals: [MealItem] = []
        @Published public var searchText: String = ""
        public var result: [MealItem] = []
                
        /// Initializes the view model with provided Network object
        public init(network: Network = NetworkProvider.shared) {
            self.network = network
        }

        private let network: Network
        
        /// Fetches meals for the given category and cleans it
        @MainActor
        public func fetchMeals(for category: MealCategory) async {
            do {
                let response = try await network.fetchMeals(for: category.name)
                result = response.cleaned()
                meals = result
                state = .success(result: meals)
            } catch is NetworkError {
                state = .failure(message: "Please try again after some time")
            } catch is DecodingError {
                state = .failure(message: "Data could not be processed")
            } catch {
                state = .failure(message: error.localizedDescription)
            }
        }
        
        /// Sorts list of meals based on the current value of the `sortOrder`
        @MainActor
        public func sortBy(key: MealSortKey, order: MealSortOrder) {
            switch key {
            case .id:
                meals = meals.sorted(by: \.id, order: order)
            case .name:
                meals = meals.sorted(by: \.name, order: order)
            }
        }
        
        /// Filters list of meals based on the current value of the `searchText`
        @MainActor
        public func filter() {
            meals = result.filtered(by: searchText)
        }
    }
}

public extension Array where Element == MealItem {
    /// Remove meals with missing data
    func cleaned() -> [Element] {
        self.lazy.filter { item in
            !item.id.isEmpty && !item.name.isEmpty
        }
    }
    
    /// Sort meals using the given key path and sort order
    func sorted<Key>(
        by keyPath: KeyPath<Element, Key>,
        order: MealSortOrder
    ) -> [Element] where Key: Comparable {
        switch order {
        case .ascending:
            self.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        case .descending:
            self.sorted { $0[keyPath: keyPath] > $1[keyPath: keyPath] }
        }
    }
    
    /// Filter meals by name based on the input query
    func filtered(by query: String) -> [Element] {
        query.isEmpty ? self : self.lazy.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }
}
