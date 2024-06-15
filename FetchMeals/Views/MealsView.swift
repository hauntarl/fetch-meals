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
    @EnvironmentObject var settingsViewModel: SettingsView.ViewModel
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
            case .success(_):
                content
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
        .environmentObject(settingsViewModel)
    }
    
    private var progress: some View {
        ProgressView()
            .task {
                viewModel.state = .loading
                await viewModel.fetchMeals(for: settingsViewModel.category)
            }
    }
    
    private var content: some View {
        return List(viewModel.meals, rowContent: buildRow(for:))
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(settingsViewModel.category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .animation(.easeOut, value: viewModel.meals)
            .animation(.easeOut, value: viewModel.searchText)
            .toolbar {
                toolbarContent
            }
            .refreshable {
                await viewModel.fetchMeals(for: settingsViewModel.category)
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "What are you craving for?"
            )
            .onChange(of: viewModel.searchText) {
                viewModel.filter()
            }
            .onChange(of: viewModel.meals) {
                viewModel.sortBy(
                    key: settingsViewModel.sortKey,
                    order: settingsViewModel.sortOrder
                )
            }
            .onReceive(settingsViewModel.$sortKey) { newValue in
                viewModel.sortBy(
                    key: newValue,
                    order: settingsViewModel.sortOrder
                )
            }
            .onReceive(settingsViewModel.$sortOrder) { newValue in
                viewModel.sortBy(
                    key: settingsViewModel.sortKey,
                    order: newValue
                )
            }
            .onReceive(settingsViewModel.$category) { newValue in
                Task {
                    await viewModel.fetchMeals(for: newValue)
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
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Settings", systemImage: "gearshape.fill") {
                router.navigate(to: .settingsView)
            }
        }
    }
    
    private func error(with message: String) -> some View {
        ErrorView(
            title: "Couldn't fetch **\(settingsViewModel.category.rawValue)**",
            message: message
        ) {
            viewModel.state = .loading
        }
    }
}

#Preview {
    struct MealsPreview: View {
        @StateObject private var router = NavigationRouter()
        @StateObject private var settingsViewModel = SettingsView.ViewModel()
        
        var body: some View {
            NavigationStack(path: $router.path) {
                MealsView(MealsView.ViewModel(
                    network: PreviewNetworkProvider(
                        error: nil  // Set an error to test the error state
                    )
                ))
                .navigationDestination(for: NavigationRouter.Destination.self) {
                    switch ($0) {
                    case .settingsView:
                        SettingsView()
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
            .environmentObject(settingsViewModel)
        }
    }
    
    return MealsPreview()
        .preferredColorScheme(.dark)
}
