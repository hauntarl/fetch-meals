//
//  MealsView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

/// Displays the list of meals for the selected category
public struct MealsView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var categoryViewModel: CategoryView.ViewModel
    @StateObject var viewModel: ViewModel
    
    public init(_ viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            switch (viewModel.state) {
            case .loading:
                progress
                    .transition(.opacity)
                    .zIndex(1)
            case .success(let meals):
                content(for: meals)
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
        .animation(.easeOut, value: viewModel.state)
        .environmentObject(categoryViewModel)
        .onReceive(categoryViewModel.$category, perform: onChange(category:))
    }
    
    private var progress: some View {
        ProgressView()
            .task {
                viewModel.state = .loading
                await viewModel.fetchMeals(for: categoryViewModel.category)
            }
    }
    
    private func content(for meals: [MealItem]) -> some View {
        return List(viewModel.filtered(meals), rowContent: buildRow(for:))
            .searchable(
                text: $viewModel.searchText,
                prompt: "What are you craving for?"
            )
            .refreshable {
                await viewModel.fetchMeals(for: categoryViewModel.category)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(categoryViewModel.category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .animation(.easeOut, value: viewModel.searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Category", systemImage: "gearshape.fill") {
                        router.navigate(to: .categoryView)
                    }
                }
            }
    }
    
    private func buildRow(for item: MealItem) -> some View {
        Button {
            router.navigate(to: .mealDetailsView(
                id: item.id,
                name: item.name
            ))
        }
        label: {
            HStack {
                AsyncImage(url: item.thumbnailURL) { thumbnail in
                    thumbnail
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(.regularMaterial)
                }
                .frame(width: 30, height: 30)
                .clipShape(.circle)
                
                Text(item.name)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundStyle(.accent)
            }
        }
        .foregroundStyle(.primary)
    }
    
    private func error(with message: String) -> some View {
        ErrorView(
            title: "Couldn't fetch **\(categoryViewModel.category.rawValue)**",
            message: message
        ) {
            viewModel.state = .loading
        }
    }
    
    private func onChange(category: MealCategory) {
        Task {
            await viewModel.fetchMeals(for: category)
        }
    }
}

#Preview {
    struct MealsPreview: View {
        @StateObject private var router = NavigationRouter()
        @StateObject private var categoryViewModel = CategoryView.ViewModel()
        
        var body: some View {
            NavigationStack(path: $router.path) {
                MealsView(MealsView.ViewModel(
                    network: PreviewNetworkProvider(
                        error: nil  // Set an error to test the error state
                    )
                ))
                .navigationDestination(for: NavigationRouter.Destination.self) {
                    switch ($0) {
                    case .categoryView:
                        CategoryView()
                    case .mealDetailsView(let id, let name):
                        MealDetailsView(
                            id: id,
                            name: name,
                            MealDetailsView.ViewModel(network: PreviewNetworkProvider())
                        )
                    }
                }
            }
            .environmentObject(router)
            .environmentObject(categoryViewModel)
        }
    }
    
    return MealsPreview()
        .preferredColorScheme(.dark)
}
