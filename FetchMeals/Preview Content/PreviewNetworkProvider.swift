//
//  PreviewNetworkProvider.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import Foundation

/// A mock network provider used across previews, responsible for providing
/// necessary data to the view models
final class PreviewNetworkProvider: Network {
    var session: any Session = PreviewSession()
    
    var decoder: JSONDecoder = .init()
    
    private let error: Error?
    
    init(error: Error? = nil) {
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
    
    func fetchCategories() async throws -> [MealCategory] {
        if let error {
            throw error
        }
        return MealCategory.sample
    }
}

/// A mock session for the `PreviewNetworkProvider`
final class PreviewSession: Session {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        (.init(), .init())
    }
}
