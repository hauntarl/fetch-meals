//
//  MealDetailsView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

/// Displays meal details for the provided meal id
public struct MealDetailsView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject var viewModel: ViewModel
    
    @State var areInstructionsExpanded = false
    @State var recipeURL: URL?
    
    public init(id: String, name: String, _ viewModel: ViewModel = .init()) {
        self.id = id
        self.name = name
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private let id: String
    private let name: String
    
    public var body: some View {
        ZStack {
            switch (viewModel.state) {
            case .loading:
                progress
                    .zIndex(1)
            case .success(let meal):
                content(for: meal)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                    .zIndex(2)
            case .failure(let message):
                error(with: message)
                    .transition(.scale)
                    .zIndex(2)
            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeOut, value: viewModel.state)
        .sheet(item: $recipeURL) { url in
            WebView(url: url)
                .ignoresSafeArea()
        }
    }
    
    private var progress: some View {
        ProgressView()
            .task {
                await viewModel.fetchMealDetails(for: id)
            }
    }
    
    private func content(for meal: Meal) -> some View {
        List {
            Section {
                mealImage(for: meal.thumbnailURL)
                Text(meal.tags).font(.subheadline)
            }
            
            Section("Ingredients") {
                content(for: meal.ingredients)
            }
            
            Section("Instructions") {
                content(for: meal.instructions)
            }
            
            Section("Links") {
                // Opens the recipe website in a WebView through .sheet() modifier
                recipeLink(for: meal.sourceURL)
                // Opens the youtube link in a browser
                youtubeLink(for: meal.youtubeURL)
            }
        }
    }
    
    private func error(with message: String) -> some View {
        ErrorView(
            title: "Couldn't fetch **\(name)**",
            message: message
        ) {
            viewModel.state = .loading
        }
    }
}

// Make URL conform to Identifiable protocol so that it can be used with
// the .sheet() modifier.
extension URL: Identifiable {
    public var id: String { self.absoluteString }
}

#Preview {
    struct MealDetailsPreview: View {
        var body: some View {
            MealDetailsView(
                id: MealItem.sample.id,
                name: MealItem.sample.name,
                MealDetailsView.ViewModel(
                    network: PreviewNetworkProvider(
                        error: nil
                    )
                )
            )
        }
    }
    
    return MealDetailsPreview()
        .preferredColorScheme(.dark)
}
