//
//  RootView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

/// The root view of the application
struct RootView: View {
    @StateObject private var router = NavigationRouter()
    @State private var showingWelcomeMessage = true
    @State private var currentLayout = 0

    private let letters = "Making Fetch Happen..."
        .split(separator: " ")
        .map { $0.split(separator: "").map { String($0) } }
    private let layouts = [
        AnyLayout(ZStackLayout()),
        AnyLayout(GridLayout())
    ]
    private var layout: AnyLayout {
        layouts[currentLayout]
    }
    
    var body: some View {
        if showingWelcomeMessage {
            welcomeMessage
        }
        else {
            meals
        }
    }
    
    private var welcomeMessage: some View {
        layout {
            ForEach(0..<letters.count, id: \.self) { i in
                GridRow {
                    ForEach(0..<letters[i].count, id: \.self) { j in
                        Text(letters[i][j])
                    }
                }
            }
        }
        .font(.largeTitle)
        .bold()
        .onAppear(perform: transition)
    }
    
    private var meals: some View {
        NavigationStack(path: $router.path) {
            MealsView()
                .navigationDestination(
                    for: NavigationRouter.Destination.self,
                    destination: destination(for:)
                )
        }
        .environmentObject(router)
    }
    
    private func transition() {
        withAnimation(
            .bouncy(duration: 0.5)
            .repeatForever(autoreverses: true)
            .delay(0.25)
        ) {
            currentLayout = 1
        }
        
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeOut) {
                showingWelcomeMessage = false
            }
        }
    }
    
    /// Navigation destination controller
    @ViewBuilder
    private func destination(for value: NavigationRouter.Destination) -> some View {
        switch value {
        case .mealDetailsView(let id):
            MealDetailsView(id: id)
        case .changeCategoryView:
            EmptyView()
        }
    }
}

#Preview {
    RootView()
        .preferredColorScheme(.dark)
}
