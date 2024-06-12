//
//  MockSession.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/11/24.
//

import FetchMeals
import Foundation

final class MockSession: Session {
    private let data: Data
    private let response: URLResponse
    private let error: Error?
    
    init(
        data: Data = .init(), 
        response: URLResponse = .init(),
        error: Error? = nil
    ) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        return (data, response)
    }
}
