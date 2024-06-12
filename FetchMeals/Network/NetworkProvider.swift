//
//  NetworkProvider.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/11/24.
//

import Foundation

public final class NetworkProvider: Network {
    public static let shared = NetworkProvider(
        session: URLSession.shared,
        baseURL: .init(string: "https://themealdb.com/api/json/v1/1/"),
        decoder: .init()
    )
    
    public let session: Session
    public let baseURL: URL?
    public let decoder: JSONDecoder
    
    public init(
        session: Session,
        baseURL: URL?,
        decoder: JSONDecoder
    ) {
        self.session = session
        self.baseURL = baseURL
        self.decoder = decoder
    }
    
    public func fetchMeals(for category: String) async throws -> [MealItem] {
        let params: [URLQueryItem] = [
            .init(name: "c", value: category)
        ]
        let url = try buildURL(
            for: "filter.php",
            relativeTo: baseURL,
            queryItems: params
        )
        
        let result: MealItemWrapper = try await fetch(from: url)
        return result.meals
    }
    
    public func fetchMealDetails(for id: String) async throws -> Meal {
        let params: [URLQueryItem] = [
            .init(name: "i", value: id)
        ]
        let url = try buildURL(
            for: "lookup.php",
            relativeTo: baseURL,
            queryItems: params
        )
        
        let result: MealWrapper = try await fetch(from: url)
        guard let meal = result.meals.first else {
            throw NetworkError.missingData
        }
        return meal
    }
    
    private func fetch<Result>(from url: URL) async throws -> Result where Result : Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = Http.Request.get
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await execute(request: request)
        guard response.statusCode == Http.Status.ok else {
            throw NetworkError.unexpectedResponse(
                statusCode: response.statusCode,
                description: response.description
            )
        }
        
        let result = try decoder.decode(Result.self, from: data)
        return result
    }
}
