//
//  Network.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/11/24.
//

import Foundation

/// A networking protocol that provides a common interface to interact with
/// the [themealdb.com](https://themealdb.com/api.php) APIs.
public protocol Network {
    
    /// The current session that is responsible for communicating with the APIs.
    var session: Session { get }
    
    /// Executes provided request, performs verification against errors,
    /// returns response data and associated meta data.
    func execute(request: URLRequest) async throws -> (Data, HTTPURLResponse)
    
    /// Utility method that builds a URL from given path and query parameters.
    func buildURL(for path: String, relativeTo url: URL?, queryItems: [URLQueryItem]) throws -> URL
    
    /// Executes an HTTP GET request to fetch meals for the provided category
    func fetchMeals(for category: String) async throws -> [MealItem]
    
    /// Executes an HTTP GET request to fetch meal details for the provided meal id
    func fetchMealDetails(for id: String) async throws -> Meal
    
}

public extension Network {
    // Default implementation for the generic execute method, other methods of
    // this protocol may use this to execute an HTTP request.
    func execute(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        
        // Check for unexpected response
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown(description: response.description)
        }
        
        // Check for error response
        if Http.Status.errors ~= response.statusCode {
            throw NetworkError.http(
                statusCode: response.statusCode,
                description: response.description
            )
        }
        
        return (data, response)
    }
    
    // Default implementation for the generic buildURL method, other methods of
    // this protocol may use this to generate API endpoints.
    func buildURL(for path: String, relativeTo url: URL?, queryItems: [URLQueryItem]) throws -> URL {
        guard let url, var url = URL(string: path, relativeTo: url) else {
            throw NetworkError.malformedURL
        }
        if !queryItems.isEmpty {
            url.append(queryItems: queryItems)
        }
        return url
    }
}

/// NetworkError enum used for throwing and handling specific network errors.
public enum NetworkError: Error {
    case malformedURL
    case unknown(description: String)
    case http(statusCode: Int, description: String)
    case unexpectedResponse(statusCode: Int, description: String)
    case missingData
}

/// Encapsulates common HTTP protocol data.
public struct Http {
    /// HTTP request methods.
    public struct Request {
        public static let get = "GET"
        public static let post = "POST"
        public static let put = "PUT"
        public static let delete = "DELETE"
    }
    
    /// HTTP response codes.
    public struct Status {
        public static let ok = 200
        public static let created = 201
        public static let noContent = 204
        public static let errors = 400...500
    }
}
