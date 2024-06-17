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
    @StateObject private var settingsViewModel = SettingsView.ViewModel()
    
    @State private var showingMessage = true
    @State private var messageScale = 0.0
    
    var body: some View {
        if showingMessage {
            message.transition(.scale)
        }
        else {
            content.transition(.opacity)
        }
    }
    
    private let letters = "Making Fetch Happen..."
        .split(separator: " ")
        .map {
            $0.split(separator: "").map { String($0) }
        }
    
    // App launch message
    private var message: some View {
        GridLayout {
            ForEach(0..<letters.count, id: \.self) { i in
                GridRow {
                    ForEach(0..<letters[i].count, id: \.self) { j in
                        Text(letters[i][j])
                    }
                }
            }
        }
        .foregroundStyle(.accent)
        .font(.largeTitle)
        .bold()
        .scaleEffect(messageScale)
        .opacity(messageScale)
        .task {
            withAnimation(.easeOut) {
                messageScale = 1.0
            }
            
            try? await Task.sleep(for: .seconds(1))
            withAnimation(.easeOut) {
                showingMessage = false
            }
        }
    }
    
    // App's main content
    private var content: some View {
        NavigationStack(path: $router.path) {
            MealsView()
                .navigationDestination(
                    for: NavigationRouter.Destination.self,
                    destination: destination(for:)
                )
        }
        .environmentObject(router)
        .environmentObject(settingsViewModel)
    }
    
    // App's navigation manager
    @ViewBuilder
    private func destination(for value: NavigationRouter.Destination) -> some View {
        switch value {
        case .mealDetailsView(let id, let name):
            MealDetailsView(id: id, name: name)
        case .settingsView:
            SettingsView()
        }
    }
}

#Preview {
    RootView()
        .preferredColorScheme(.dark)
}
