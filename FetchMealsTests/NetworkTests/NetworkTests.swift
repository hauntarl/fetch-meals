//
//  NetworkTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/11/24.
//

import FetchMeals
import XCTest

final class NetworkTests: XCTestCase {

    private struct TestNetwork: Network {}
    
    private static let fetchURL = URL(string: "https://fetch.com/")!
    
    private var session: MockSession!
    private var network: Network = TestNetwork()
    
    override func setUpWithError() throws {
        session = MockSession()
    }

    override func tearDownWithError() throws {
        session = nil
    }

    /// Test successful `execute` request
    func testExecuteSuccess() async throws {
        // Setup
        let expected = MealItem.sample
        session.data = MealItem.sampleJSON
        session.response = HTTPURLResponse(
            url: Self.fetchURL,
            statusCode: Http.Status.ok,
            httpVersion: nil,
            headerFields: nil
        )!
        
        // Test
        let (data, response) = try await network.execute(
            request: URLRequest(url: Self.fetchURL),
            using: session
        )
        
        // Validate
        XCTAssertEqual(response.statusCode, Http.Status.ok, "Response status code should match.")
        
        let got = try JSONDecoder().decode(MealItem.self, from: data)
        XCTAssertEqual(got, expected, "The meal items should be equal.")
    }
    
    /// Test session throws error
    func testExecuteFailure() async throws {
        session.error = NetworkError.malformedURL
        
        do {
            _ = try await network.execute(
                request: URLRequest(url: Self.fetchURL),
                using: session
            )
        } catch NetworkError.malformedURL {
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test unexpected `URLResponse`
    func testExecuteUnexpectedResponse() async throws {
        do {
            _ = try await network.execute(
                request: URLRequest(url: Self.fetchURL),
                using: session
            )
        } catch NetworkError.unexpected(_) {
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test http error response
    func testExecuteHttpError() async throws {
        let errorCode = Http.Status.errors.randomElement()!
        session.response = HTTPURLResponse(
            url: Self.fetchURL,
            statusCode: errorCode,
            httpVersion: nil,
            headerFields: nil
        )!
        
        do {
            _ = try await network.execute(
                request: URLRequest(url: Self.fetchURL),
                using: session
            )
        } catch NetworkError.http(let statusCode, _) {
            XCTAssertEqual(errorCode, statusCode, "The http status codes should match.")
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test successful `buildURL` request
    func testBuildURLSuccess() throws {
        let expected = "\(Self.fetchURL.absoluteString)new-hire/sameer-mungole"
        let got = try network.buildURL(
            for: "new-hire/sameer-mungole",
            relativeTo: Self.fetchURL,
            queryItems: []
        )
        
        XCTAssertEqual(expected, got.absoluteString, "Let's make fetch happen!")
    }
    
    /// Test malformed url error response
    func testBuildURLFailure() throws {
        do {
            let got = try network.buildURL(
                for: "malformed/url",
                relativeTo: nil,
                queryItems: []
            )
            print(got.absoluteString)
        } catch NetworkError.malformedURL {
            return
        }
        XCTFail("Should never reach here.")
    }
}
