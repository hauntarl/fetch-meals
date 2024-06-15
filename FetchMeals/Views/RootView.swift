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
    @StateObject var categoryViewModel = CategoryView.ViewModel()
    
    @State private var showingMessage = true
    @State private var currentLayout = 0

    private let letters = "Lets Make Fetch Happen."
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
        if showingMessage {
            message
                .transition(.move(edge: .leading))
        }
        else {
            content
                .transition(.move(edge: .trailing))
        }
    }
    
    private var message: some View {
        layout {
            ForEach(0..<letters.count, id: \.self) { i in
                GridRow {
                    ForEach(0..<letters[i].count, id: \.self) { j in
                        Text(letters[i][j])
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .foregroundStyle(.accent)
        .font(.largeTitle)
        .bold()
        .onAppear(perform: transition)
    }
    
    private var content: some View {
        NavigationStack(path: $router.path) {
            MealsView()
                .navigationDestination(
                    for: NavigationRouter.Destination.self,
                    destination: destination(for:)
                )
        }
        .environmentObject(router)
        .environmentObject(categoryViewModel)
    }
    
    @ViewBuilder
    private func destination(for value: NavigationRouter.Destination) -> some View {
        switch value {
        case .mealDetailsView(let id, let name):
            MealDetailsView(id: id, name: name)
        case .categoryView:
            CategoryView()
        }
    }
    
    private func transition() {
        withAnimation(
            .easeOut(duration: 0.75)
            .delay(0.25)
        ) {
            currentLayout = 1
        }
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation(.easeOut) {
                showingMessage = false
            }
        }
    }
}

#Preview {
    RootView()
        .preferredColorScheme(.dark)
}
