//
//  MealsView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import Observation
import SwiftUI

public extension MealsView {
    class ViewModel: ObservableObject {
        @Published public var state: ViewState<[MealItem]> = .loading
        @Published public var searchText: String = ""
        
        private let network: Network
        
        public init(network: Network = NetworkProvider.shared) {
            self.network = network
        }
        
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
        
        @MainActor
        public func filtered(_ meals: [MealItem]) -> [MealItem] {
            searchText.isEmpty ? meals : meals.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

extension Array where Element == MealItem {
    func clean() -> [Element] {
        lazy.filter { item in
            !item.id.isEmpty 
            && !item.name.isEmpty
            && item.thumbnailURL != nil
        }
    }
}
