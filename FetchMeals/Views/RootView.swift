//
//  RootView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = NavigationRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Text("Let's make Fetch happen!")
                .font(.largeTitle)
                .task {
                    try? await Task.sleep(for: .seconds(1))
                    router.navigate(to: .mealsView)
                }
                .navigationDestination(
                    for: NavigationRouter.Destination.self,
                    destination: destination(for:)
                )
        }
        .environmentObject(router)
    }
    
    /// Navigation destination controller
    @ViewBuilder
    private func destination(for value: NavigationRouter.Destination) -> some View {
        switch value {
        case .mealsView:
            MealsView()
        case .mealDetailsView(let id, let previewURL):
            MealDetailsView(id: id, previewURL: previewURL)
        }
    }
}

#Preview {
    RootView()
}
