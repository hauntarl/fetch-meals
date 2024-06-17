//
//  NavigationRouter.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

/// This model controls the the app's navigation stack
final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    @ViewBuilder func view(for destination: Destination) -> some View {
        switch destination {
        case .mealDetailsView(let id, let name):
            MealDetailsView(id: id, name: name)
        case .settingsView:
            SettingsView()
        }
    }
    
    enum Destination: Hashable {
        case settingsView
        case mealDetailsView(id: String, name: String)
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
