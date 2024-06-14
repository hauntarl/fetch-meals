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
    
    init(
        session: any Session,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchMeals(for category: String) async throws -> [MealItem] {
        let result: MealItemWrapper = try await fetch(from: NetworkURL.base, headers: [:])
        return result.meals
    }
    
    func fetchMealDetails(for id: String) async throws -> Meal {
        let result: MealWrapper = try await fetch(from: NetworkURL.base, headers: [:])
        return result.meals.first!
    }
}
