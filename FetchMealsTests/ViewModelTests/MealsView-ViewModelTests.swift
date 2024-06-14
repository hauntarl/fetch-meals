//
//  MealsView-ViewModelTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/13/24.
//

import FetchMeals
import XCTest

final class MealsView_ViewModelTests: XCTestCase {
    private var session: Session!
    private var network: Network!
    private var viewModel: MealsView.ViewModel!

    override func tearDownWithError() throws {
        session = nil
        network = nil
        viewModel = nil
    }
    
    /// Test if fetch meals successfully processes the network response
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
        network = MockNetworkProvider(session: session)
        viewModel = await MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals()
        
        switch await (viewModel.state) {
        case .success(let got):
            XCTAssertEqual(got.count, 1, "Only one meal is expected after cleaning")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        case .failure(let message):
            XCTFail("ViewState should not be in failure state: \(message)")
        }
    }
    
    /// Test if fetch meals successfully cleans the network response
    func testFetchMeals_Empty() async throws {
        session = MockSession(
            data: MealItemWrapper.sampleNullJSON,
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        viewModel = await MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals()
        
        switch await (viewModel.state) {
        case .success(let got):
            XCTAssertTrue(got.isEmpty, "Only one meal is expected after cleaning")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        case .failure(let message):
            XCTFail("ViewState should not be in failure state: \(message)")
        }
    }
    
    /// Test if fetch meals successfully catches the network error
    func testFetchMeals_NetworkError() async throws {
        session = MockSession(
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.errors.lowerBound,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        viewModel = await MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals()
        
        switch await (viewModel.state) {
        case .failure(let message):
            XCTAssertTrue(message.hasPrefix("Network Error"), "Should return a network error")
        case .success(_):
            XCTFail("ViewState should not be in success state")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        }
    }
    
    /// Test if fetch meals successfully catches the parsing error
    func testFetchMeals_ParsingError() async throws {
        session = MockSession(
            response: HTTPURLResponse(
                url: NetworkURL.base,
                statusCode: Http.Status.ok,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        network = MockNetworkProvider(session: session)
        viewModel = await MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals()
        
        switch await (viewModel.state) {
        case .failure(let message):
            XCTAssertTrue(message.hasPrefix("Parsing Error"), "Should return a parsing error")
        case .success(_):
            XCTFail("ViewState should not be in success state")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        }
    }

    /// Test if fetch meals successfully catches the unexpected error
    func testFetchMeals_UnexpectedError() async throws {
        session = MockSession(error: MockError())
        network = MockNetworkProvider(session: session)
        viewModel = await MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals()
        
        switch await (viewModel.state) {
        case .failure(let message):
            XCTAssertTrue(message.hasPrefix("Error"), "Should return an unexpected error")
        case .success(_):
            XCTFail("ViewState should not be in success state")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        }
    }
}
