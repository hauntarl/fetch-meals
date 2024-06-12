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
    /// Executes provided request, performs verification against errors, 
    /// returns response data and associated meta data.
    func execute(
        request: URLRequest,
        using session: Session
    ) async throws -> (Data, HTTPURLResponse)
    
    /// Utility method that builds a URL from given path and query parameters.
    func buildURL(
        for path: String,
        relativeTo baseURL: URL?,
        queryItems: [URLQueryItem]
    ) throws -> URL
}

public extension Network {
    // Default implementation for the generic execute method, other methods of
    // this protocol may use this to execute an HTTP request.
    func execute(
        request: URLRequest,
        using session: Session
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        
        // Check for unexpected response
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unexpected(description: response.description)
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
    func buildURL(
        for path: String,
        relativeTo baseURL: URL?,
        queryItems: [URLQueryItem]
    ) throws -> URL {
        guard let baseURL, var url = URL(string: path, relativeTo: baseURL) else {
            throw NetworkError.malformedURL
        }
        if !queryItems.isEmpty {
            url.append(queryItems: queryItems)
        }
        return url
    }
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

/// NetworkError enum used for throwing and handling specific network errors.
public enum NetworkError: Error {
    case malformedURL
    case unexpected(description: String)
    case http(statusCode: Int, description: String)
}
