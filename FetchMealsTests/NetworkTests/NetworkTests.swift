//
//  NetworkTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/11/24.
//

import FetchMeals
import XCTest

final class NetworkTests: XCTestCase {
    private var session: Session!
    private var network: Network!

    override func tearDownWithError() throws {
        session = nil
        network = nil
    }
    
    /// Test successful `buildURL` request, aims to run the protocol's default implementation
    func testBuildURL_Success() throws {
        session = MockSession()
        network = MockNetworkProvider(session: session)
        let expected = "\(NetworkURL.base.absoluteString)new-hire/sameer-mungole"
        
        let got = try network.buildURL(
            for: "new-hire/sameer-mungole",
            relativeTo: NetworkURL.base,
            queryItems: []
        )
        
        XCTAssertEqual(expected, got.absoluteString, "Let's make fetch happen!")
    }
    
    /// Test build url when provided query parameters, aims to run the protocol's default implementation
    func testBuildURL_Success_WithQueryParameters() throws {
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
    func testBuildURL_MalformedURL() throws {
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

    /// Test successful `execute` request, aims to run the protocol's default implementation
    func testExecute_Success() async throws {
        let expected = MealItem.sample
        session = MockSession(
            data: MealItem.sampleJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        
        let request = URLRequest(url: NetworkURL.base)
        let (data, response) = try await network.execute(request: request)
        
        XCTAssertEqual(response.statusCode, Http.Status.ok, "Response status code should match.")
        
        let got = try JSONDecoder().decode(MealItem.self, from: data)
        XCTAssertEqual(got, expected, "The meal items should be equal.")
    }
    
    /// Test session throws error, aims to run the protocol's default implementation
    func testExecute_SessionError() async throws {
        session = MockSession(error: NetworkError.malformedURL)
        network = MockNetworkProvider(session: session)
        
        do {
            let request = URLRequest(url: NetworkURL.base)
            _ = try await network.execute(request: request)
        } catch NetworkError.malformedURL {
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test unknown `URLResponse`, aims to run the protocol's default implementation
    func testExecute_UnknownError() async throws {
        session = MockSession()
        network = MockNetworkProvider(session: session)
        
        do {
            let request = URLRequest(url: NetworkURL.base)
            _ = try await network.execute(request: request)
        } catch NetworkError.unknown(_) {
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test http error response, aims to run the protocol's default implementation
    func testExecute_HttpError() async throws {
        let errorCode = Http.Status.errors.randomElement()!
        session = MockSession(response: HTTPURLResponse(
            url: NetworkURL.base,
            statusCode: errorCode,
            httpVersion: nil,
            headerFields: nil
        )!)
        network = MockNetworkProvider(session: session)
        
        do {
            let request = URLRequest(url: NetworkURL.base)
            _ = try await network.execute(request: request)
        } catch NetworkError.http(let statusCode, _) {
            XCTAssertEqual(errorCode, statusCode, "The http status codes should match.")
            return
        }
        XCTFail("Should never reach here.")
    }
    
    /// Test successful `fetch` request, aims to run the protocol's default implementation
    func testFetch_Success() async throws {
        let expected = Meal.sample
        session = MockSession(
            data: Meal.sampleJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        
        let got: MealWrapper = try await network.fetch(from: NetworkURL.base, headers: [:])
        XCTAssertEqual(got.meals.first, expected, "The meal items should be equal.")
    }
    
    /// Test unexpected success status code, aims to run the protocol's default implementation
    func testFetch_UnexpectedResponse() async throws {
        session = MockSession(
            data: Meal.sampleJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.noContent,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        
        do {
            let _: MealWrapper = try await network.fetch(from: NetworkURL.base, headers: [:])
        } catch NetworkError.unexpectedResponse(_) {
            return
        }
        XCTFail("Should never reach here.")
    }
    
    func testFetch_ParsingError() async throws {
        session = MockSession(
            data: Data(),
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        
        do {
            let _: MealItemWrapper = try await network.fetch(from: NetworkURL.base, headers: [:])
        } catch DecodingError.dataCorrupted(_) {
            return
        }
        XCTFail("Should never reach here")
    }
}
