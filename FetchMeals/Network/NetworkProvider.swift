//
//  NetworkProvider.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/11/24.
//

import Foundation

public final class NetworkProvider: Network {
    public static let shared = NetworkProvider()
    
    public let session: Session
    public let decoder: JSONDecoder
    public let baseURL: URL?
    
    public init(
        session: Session = URLSession.shared,
        decoder: JSONDecoder = .init(),
        baseURL: URL? = NetworkURL.base
    ) {
        self.session = session
        self.decoder = decoder
        self.baseURL = baseURL
    }
    
    /// Executes an HTTP GET request to fetch meals for the provided category.
    public func fetchMeals(for category: String) async throws -> [MealItem] {
        let params: [URLQueryItem] = [
            .init(name: "c", value: category)
        ]
        let url = try buildURL(
            for: "filter.php",
            relativeTo: baseURL,
            queryItems: params
        )
        
        let result: MealItemWrapper = try await fetch(
            from: url,
            headers: ["Accept": "application/json"]
        )
        return result.meals
    }
    
    /// Executes an HTTP GET request to fetch meal details for the provided meal id.
    public func fetchMealDetails(for id: String) async throws -> Meal {
        let params: [URLQueryItem] = [
            .init(name: "i", value: id)
        ]
        let url = try buildURL(
            for: "lookup.php",
            relativeTo: baseURL,
            queryItems: params
        )
        
        let result: MealWrapper = try await fetch(
            from: url,
            headers: ["Accept": "application/json"]
        )
        guard let meal = result.meals.first else {
            throw NetworkError.missingData
        }
        return meal
    }
}
