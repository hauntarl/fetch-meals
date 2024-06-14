//
//  CategoryView-ViewModelTests.swift
//  FetchMealsTests
//
//  Created by Sameer Mungole on 6/14/24.
//

import FetchMeals
import XCTest

final class CategoryView_ViewModelTests: XCTestCase {

    /// Test if category is updated
    func testUpdateCategory_ToSeafood() async throws {
        let viewModel = await CategoryView.ViewModel()
        
        await viewModel.update(category: .seafood)
        let newCategory = await viewModel.get()
        XCTAssertEqual(newCategory, .seafood, "Category should be updated to Seafood")
    }

}
