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
        @Published public var searchText: String = ""
        
        private let network: Network
        
        /// Initializes the view model with provided Network object
        public init(network: Network = NetworkProvider.shared) {
            self.network = network
        }
        
        /// Fetches meals for the given category and cleans it
        @MainActor
        public func fetchMeals(for category: MealCategory) async {
            do {
                let result = try await network.fetchMeals(for: category.rawValue)
                state = .success(result: result.clean())
            } catch is NetworkError {
                state = .failure(message: "Network Error: Please try again after some time")
            } catch is DecodingError {
                state = .failure(message: "Parsing Error: Data could not be processed")
            } catch {
                state = .failure(message: "Error: \(error.localizedDescription)")
            }
        }
        
        /// Returns a filtered list of meals based on the current `searchText`
        @MainActor
        public func filtered(_ meals: [MealItem]) -> [MealItem] {
            searchText.isEmpty ? meals : meals.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

extension Array where Element == MealItem {
    /// Removes meals with missing data
    func clean() -> [Element] {
        lazy.filter { item in
            !item.id.isEmpty 
            && !item.name.isEmpty
            && item.thumbnailURL != nil
        }
    }
}
