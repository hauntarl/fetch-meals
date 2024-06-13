//
//  MealsView-ViewModel.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import Observation
import SwiftUI

public extension MealsView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var category: MealCategory = .seafood
        @Published var state: ViewState<[MealItem]> = .loading
        
        private let network: Network
        
        init(network: Network = NetworkProvider.shared) {
            self.network = network
        }
        
        func fetchMeals() async {
            do {
                state = .loading
                let result = try await network.fetchMeals(for: category.rawValue)
                state = .success(result: result.clean())
            } catch is NetworkError {
                state = .failure(message: "`Network Error:` Please try again after some time.")
            } catch {
                state = .failure(message: "`Unknown Error:` \(error.localizedDescription)")
            }
        }
    }
    
    enum MealCategory: String {
        case dessert = "Dessert"
        case seafood = "Seafood"
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
