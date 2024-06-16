//
//  SettingsView-ViewModelTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/15/24.
//

import FetchMeals
import XCTest

final class SettingsView_ViewModelTests: XCTestCase {
    private var session: Session!
    private var network: Network!
    private var viewModel: SettingsView.ViewModel!

    override func tearDownWithError() throws {
        session = nil
        network = nil
        viewModel = nil
    }

    /// Test if fetch categories successfully processes the network response
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
        network = MockNetworkProvider(session: session)
        viewModel = SettingsView.ViewModel(network: network)
        
        let expected = MealCategory.sample
        await viewModel.fetchCategories()
        
        XCTAssertEqual(viewModel.categories, expected, "Returned categories should match expected")
    }
    
    /// Test if fetch categories successfully handles errors
    func testFetchCategories_Empty() async throws {
        session = MockSession(error: MockError())
        network = MockNetworkProvider(session: session)
        viewModel = SettingsView.ViewModel(network: network)
        
        await viewModel.fetchCategories()
        
        XCTAssertTrue(viewModel.categories.isEmpty, "Returned categories should be empty")
    }

}
