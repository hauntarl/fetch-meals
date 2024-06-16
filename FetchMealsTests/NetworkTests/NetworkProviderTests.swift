//
//  NetworkProviderTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/13/24.
//

import FetchMeals
import XCTest

final class NetworkProviderTests: XCTestCase {
    private var session: Session!
    private var network: Network!
    
    override func tearDownWithError() throws {
        session = nil
        network = nil
    }
    
    /// Test successful `fetchMeals` request
    func testFetchMeals_Success() async throws {
        session = MockSession(
            data: MealItemWrapper.sampleJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = NetworkProvider(
            session: session,
            decoder: .init(),
            baseURL: NetworkURL.base
        )
        let expected = MealItemWrapper.sample.meals
        
        let got = try await network.fetchMeals(for: "Test")
        
        XCTAssertEqual(got, expected, "Fetched meals should be equal")
    }
    
    /// Test successful `fetchMealDetails` request
    func testFetchMealDetails_Success() async throws {
        session = MockSession(
            data: Meal.sampleJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = NetworkProvider(
            session: session,
            decoder: .init(),
            baseURL: NetworkURL.base
        )
        let expected = Meal.sample
        
        let got = try await network.fetchMealDetails(for: "12345")
        
        XCTAssertEqual(got.name, expected.name, "Fetched meal details should be equal")
        XCTAssertEqual(got.instructions, expected.instructions, "Fetched meal details should be equal")
        XCTAssertEqual(got.sourceURL, expected.sourceURL, "Fetched meal details should be equal")
        XCTAssertEqual(got.tags, expected.tags, "Fetched meal details should be equal")
        XCTAssertEqual(got.thumbnailURL, expected.thumbnailURL, "Fetched meal details should be equal")
        XCTAssertEqual(got.youtubeURL, expected.youtubeURL, "Fetched meal details should be equal")
        XCTAssertEqual(got.ingredients.sorted(), expected.ingredients.sorted(), "Fetched meal details should be equal")
    }
    
    /// Test `fetchMealDetails` missing data error
    func testFetchMealDetails_MissingDataError() async throws {
        session = MockSession(
            data: MealItemWrapper.sampleNullJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = NetworkProvider(
            session: session,
            decoder: .init(),
            baseURL: NetworkURL.base
        )
        
        do {
            _ = try await network.fetchMealDetails(for: "12345")
        } catch NetworkError.missingData {
            return
        }
        XCTFail("Should never reach here")
    }
    
    /// Test successful `fetchCategories` request
    func testFetchCategories_Success() async throws {
        session = MockSession(
            data: MealCategory.sampleJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = NetworkProvider(
            session: session,
            decoder: .init(),
            baseURL: NetworkURL.base
        )
        let expected = MealCategory.sample
        
        let got = try await network.fetchCategories()
        
        XCTAssertEqual(got, expected, "Fetched categories should be equal")
    }
}
