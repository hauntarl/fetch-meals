//
//  MealDetailsView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import Foundation


public extension MealDetailsView {
    /// Responsible for managing the state of `MealDetailsView` and providing
    /// the meal details for given meal id
    final class ViewModel: ObservableObject {
        @Published public var state: ViewState<Meal> = .loading
        
        private let network: Network
        
        /// Initializes the view model with provided Network object
        public init(network: Network = NetworkProvider.shared) {
            self.network = network
        }
        
        /// Fetches meal details for the given meal id
        @MainActor
        public func fetchMealDetails(for id: String) async {
            do {
                let result = try await network.fetchMealDetails(for: id)
                state = .success(result: result)
            } catch is NetworkError {
                state = .failure(message: "Network Error: Please try again after some time")
            } catch is DecodingError {
                state = .failure(message: "Parsing Error: Data could not be processed")
            } catch {
                state = .failure(message: "Error: \(error.localizedDescription)")
            }
        }
    }
}
