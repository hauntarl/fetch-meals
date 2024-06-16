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
        viewModel = MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals(for: .dessert)
        
        switch (viewModel.state) {
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
        viewModel = MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals(for: .dessert)
        
        switch (viewModel.state) {
        case .success(let got):
            XCTAssertTrue(got.isEmpty, "Zero meals are expected after cleaning")
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
        viewModel = MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals(for: .dessert)
        
        switch (viewModel.state) {
        case .failure(let message):
            XCTAssertEqual(message, "Please try again after some time", "Should return a network error")
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
        viewModel = MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals(for: .dessert)
        
        switch (viewModel.state) {
        case .failure(let message):
            XCTAssertEqual(message, "Data could not be processed", "Should return a network error")
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
        viewModel = MealsView.ViewModel(network: network)
        
        await viewModel.fetchMeals(for: .dessert)
        
        switch (viewModel.state) {
        case .failure(_):
            return
        case .success(_):
            XCTFail("ViewState should not be in success state")
        case .loading:
            XCTFail("ViewState should not be in loading state")
        }
    }
    
    /// Test sorting meals by name in ascending order
    func testFiltered_SortMeals_ByName_Ascending() async throws {
        let meals = MealItemWrapper.sample.meals
        session = MockSession()
        network = MockNetworkProvider(session: session)
        viewModel = MealsView.ViewModel(network: network)
        
        let expected = meals.sorted { $0.name < $1.name }
        viewModel.meals = meals
        await viewModel.sortBy(key: .name, order: .ascending)
        
        XCTAssertEqual(viewModel.meals, expected, "Sorted meals should match")
    }
    
    /// Test sorting meals by name in descending order
    func testFiltered_SortMeals_ByName_Descending() async throws {
        let meals = MealItemWrapper.sample.meals
        session = MockSession()
        network = MockNetworkProvider(session: session)
        viewModel = MealsView.ViewModel(network: network)
        
        let expected = meals.sorted { $0.name > $1.name }
        viewModel.meals = meals
        await viewModel.sortBy(key: .name, order: .descending)
        
        XCTAssertEqual(viewModel.meals, expected, "Sorted meals should match")
    }
    
    /// Test sorting meals by id in ascending order
    func testFiltered_SortMeals_ById_Ascending() async throws {
        let meals = MealItemWrapper.sample.meals
        session = MockSession()
        network = MockNetworkProvider(session: session)
        viewModel = MealsView.ViewModel(network: network)
        
        let expected = meals.sorted { $0.id < $1.id }
        viewModel.meals = meals
        await viewModel.sortBy(key: .id, order: .ascending)
        
        XCTAssertEqual(viewModel.meals, expected, "Sorted meals should match")
    }
    
    /// Test sorting meals by id in descending order
    func testFiltered_SortMeals_ById_Descending() async throws {
        let meals = MealItemWrapper.sample.meals
        session = MockSession()
        network = MockNetworkProvider(session: session)
        viewModel = MealsView.ViewModel(network: network)
        viewModel.searchText.removeAll()
        
        let expected = meals.sorted { $0.id > $1.id }
        viewModel.meals = meals
        await viewModel.sortBy(key: .id, order: .descending)
        
        XCTAssertEqual(viewModel.meals, expected, "Sorted meals should match")
    }

    
    /// Test if filtered method returns the same list of meals when search text is empty
    func testFiltered_SearchTextIsEmpty() async throws {
        let meals = MealItemWrapper.sample.meals
        session = MockSession()
        network = MockNetworkProvider(session: session)
        viewModel = MealsView.ViewModel(network: network)
        viewModel.searchText.removeAll()
        
        let expected = meals.first!
        viewModel.result = meals
        await viewModel.filter()
        
        XCTAssertEqual(viewModel.meals.first, expected, "Filtered meals should match")
    }
    
    /// Test if filtered method returns all meals containing the search text
    func testFiltered_SearchTextIsNotEmpty() async throws {
        let meals = MealItemWrapper.sample.meals
        session = MockSession()
        network = MockNetworkProvider(session: session)
        viewModel = MealsView.ViewModel(network: network)
        viewModel.searchText = "Apam"
        
        viewModel.result = meals
        await viewModel.filter()
        
        XCTAssertEqual(viewModel.meals.count, 5, "After filtering the meals count should be 5")
        XCTAssertTrue(
            viewModel.meals.allSatisfy { $0.name.localizedCaseInsensitiveContains("Apam")},
            "All meals should contain the search text"
        )
    }
}
