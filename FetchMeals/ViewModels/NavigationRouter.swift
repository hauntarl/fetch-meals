//
//  NavigationRouter.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

/// This model controls the the app's navigation stack
class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    enum Destination: Hashable {
        case changeCategoryView
        case mealDetailsView(id: String)
    }
    
    /// Convenience wrapper to restrict navigation to only `Destination` type,
    /// as the `NavigationPath` holds type-erased objects.
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    /// Safely pops the last element from the `NavigationPath`.
    func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
