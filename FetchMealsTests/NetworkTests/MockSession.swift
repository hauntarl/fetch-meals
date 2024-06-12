//
//  MockSession.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/11/24.
//

import FetchMeals
import Foundation

struct MockSession: Session {
    var data: Data = .init()
    var response: URLResponse = .init()
    var error: Error? = nil
    
    init() {}
    
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
