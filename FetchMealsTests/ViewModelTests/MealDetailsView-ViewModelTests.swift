//
//  MealDetailsView-ViewModelTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/13/24.
//

import FetchMeals
import XCTest

final class MealDetailsView_ViewModelTests: XCTestCase {
    private var session: Session!
    private var network: Network!
    private var viewModel: MealDetailsView.ViewModel!

    override func tearDownWithError() throws {
        session = nil
        network = nil
        viewModel = nil
    }
    
    /// Test if fetch meal details successfully processes the network response
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
        network = MockNetworkProvider(session: session)
        viewModel = MealDetailsView.ViewModel(network: network)
        let expected = Meal.sample
        
        await viewModel.fetchMealDetails(for: "12345")
        
        switch (viewModel.state) {
        case .success(let got):
            XCTAssertEqual(got, expected, "Meal details should match")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        case .failure(let message):
            XCTFail("ViewState should not be in failure state: \(message)")
        }
    }
    
    /// Test if fetch meal details successfully catches the network error
    func testFetchMealDetails_NetworkError() async throws {
        session = MockSession(
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.errors.lowerBound,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        viewModel = MealDetailsView.ViewModel(network: network)
        
        await viewModel.fetchMealDetails(for: "12345")
        
        switch (viewModel.state) {
        case .failure(let message):
            XCTAssertEqual(message, "Please try again after some time", "Should return a network error")
        case .success(_):
            XCTFail("ViewState should not be in success state")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        }
    }
    
    /// Test if fetch meal details successfully catches the parsing error
    func testFetchMealDetails_ParsingError() async throws {
        session = MockSession(
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        viewModel = MealDetailsView.ViewModel(network: network)
        
        await viewModel.fetchMealDetails(for: "12345")
        
        switch (viewModel.state) {
        case .failure(let message):
            XCTAssertEqual(message, "Data could not be processed", "Should return a network error")
        case .success(_):
            XCTFail("ViewState should not be in success state")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        }
    }

    /// Test if fetch meal details successfully catches the unexpected error
    func testFetchMealDetails_UnexpectedError() async throws {
        session = MockSession(error: MockError())
        network = MockNetworkProvider(session: session)
        viewModel = MealDetailsView.ViewModel(network: network)
        
        await viewModel.fetchMealDetails(for: "12345")
        
        switch (viewModel.state) {
        case .failure(_):
            return
        case .success(_):
            XCTFail("ViewState should not be in success state")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        }
    }
}
