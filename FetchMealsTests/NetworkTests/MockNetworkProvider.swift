//
//  MockNetworkProvider.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/12/24.
//

import FetchMeals
import Foundation

final class MockNetworkProvider: Network {
    let session: any Session
    let decoder: JSONDecoder
    let error: Error?
    
    init(
        session: any Session,
        decoder: JSONDecoder = .init(),
        error: Error? = nil
    ) {
        self.session = session
        self.decoder = decoder
        self.error = error
    }
    
    func fetchMeals(for category: String) async throws -> [MealItem] {
        if let error {
            throw error
        }
        return MealItemWrapper.sample.meals
    }
    
    func fetchMealDetails(for id: String) async throws -> Meal {
        if let error {
            throw error
        }
        return Meal.sample
    }
}
