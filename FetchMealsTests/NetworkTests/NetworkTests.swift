//
//  NetworkTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/11/24.
//

import FetchMeals
import XCTest

final class NetworkTests: XCTestCase {
    private static let fetchURL = URL(string: "https://fetch.com/")!
    
    private var session: Session!
    private var network: Network!

    override func tearDownWithError() throws {
        session = nil
        network = nil
    }

    /// Test successful `execute` request, aims to run the protocol's default implementation
    func testExecuteSuccess() async throws {
        // Setup
        let expected = MealItem.sample
        session = MockSession(
            data: MealItem.sampleJSON,
            response: HTTPURLResponse(
                url: Self.fetchURL,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        
        // Test
        let request = URLRequest(url: Self.fetchURL)
        let (data, response) = try await network.execute(request: request)
        
        // Validate
        XCTAssertEqual(response.statusCode, Http.Status.ok, "Response status code should match.")
        
        let got = try JSONDecoder().decode(MealItem.self, from: data)
        XCTAssertEqual(got, expected, "The meal items should be equal.")
    }
    
    /// Test session throws error, aims to run the protocol's default implementation
    func testExecuteFailure() async throws {
        session = MockSession(error: NetworkError.malformedURL)
        network = MockNetworkProvider(session: session)
        
        do {
            let request = URLRequest(url: Self.fetchURL)
            _ = try await network.execute(request: request)
        } catch NetworkError.malformedURL {
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test unexpected `URLResponse`, aims to run the protocol's default implementation
    func testExecuteUnexpectedResponse() async throws {
        session = MockSession()
        network = MockNetworkProvider(session: session)
        
        do {
            let request = URLRequest(url: Self.fetchURL)
            _ = try await network.execute(request: request)
        } catch NetworkError.unknown(_) {
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test http error response, aims to run the protocol's default implementation
    func testExecuteHttpError() async throws {
        let errorCode = Http.Status.errors.randomElement()!
        session = MockSession(response: HTTPURLResponse(
            url: Self.fetchURL,
            statusCode: errorCode,
            httpVersion: nil,
            headerFields: nil
        )!)
        network = MockNetworkProvider(session: session)
        
        do {
            let request = URLRequest(url: Self.fetchURL)
            _ = try await network.execute(request: request)
        } catch NetworkError.http(let statusCode, _) {
            XCTAssertEqual(errorCode, statusCode, "The http status codes should match.")
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test successful `buildURL` request, aims to run the protocol's default implementation
    func testBuildURLSuccess() throws {
        session = MockSession()
        network = MockNetworkProvider(session: session)
        let expected = "\(Self.fetchURL.absoluteString)new-hire/sameer-mungole"
        
        let got = try network.buildURL(
            for: "new-hire/sameer-mungole",
            relativeTo: Self.fetchURL,
            queryItems: []
        )
        
        XCTAssertEqual(expected, got.absoluteString, "Let's make fetch happen!")
    }
    
    /// Test build url when provided query parameters, aims to run the protocol's default implementation
    func testBuildURLWithQueryParameters() throws {
        session = MockSession()
        network = MockNetworkProvider(session: session)
        let baseURL = URL(string: "https://themealdb.com/api/json/v1/1/")
        let expected = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        
        let got = try network.buildURL(
            for: "filter.php",
            relativeTo: baseURL,
            queryItems: [
                .init(name: "c", value: "Dessert")
            ]
        )
        
        XCTAssertEqual(expected, got.absoluteString, "Let's make fetch happen!")
    }
    
    /// Test malformed url error response, aims to run the protocol's default implementation
    func testBuildURLFailure() throws {
        session = MockSession()
        network = MockNetworkProvider(session: session)
        
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
