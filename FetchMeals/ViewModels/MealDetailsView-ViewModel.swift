//
//  MealDetailsView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import Foundation

public extension MealDetailsView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var state: ViewState<Meal> = .loading
        
        private let network: Network
        
        init(network: Network = NetworkProvider.shared) {
            self.network = network
        }
        
        func fetchMealDetails(for id: String) async {
            do {
                state = .loading
                let result = try await network.fetchMealDetails(for: id)
                state = .success(result: result)
            } catch is NetworkError {
                state = .failure(message: "`Network Error:` Please try again after some time.")
            } catch {
                state = .failure(message: "`Unknown Error:` \(error.localizedDescription)")
            }
        }
    }
}
