//
//  MealsView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

public struct MealsView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject var viewModel = ViewModel()
    
    public var body: some View {
        ZStack {
            switch (viewModel.state) {
            case .loading:
                progress
                    .transition(.opacity)
                    .zIndex(1)
            case .success(let meals):
                content(for: meals)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        )
                    )
                    .zIndex(2)
            case .failure(let message):
                error(with: message)
                    .transition(.scale)
                    .zIndex(2)
            }
        }
        .animation(.easeOut, value: viewModel.state)
    }
    
    private var progress: some View {
        ProgressView()
            .task {
                viewModel.state = .loading
                await viewModel.fetchMeals()
            }
    }
    
    private func content(for meals: [MealItem]) -> some View {
        return List(viewModel.filtered(meals), rowContent: buildRow(for:))
            .searchable(
                text: $viewModel.searchText,
                prompt: "What are you craving for?"
            )
            .refreshable {
                await viewModel.fetchMeals()
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(viewModel.category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .animation(.easeOut, value: viewModel.searchText)
    }
    
    private func buildRow(for item: MealItem) -> some View {
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
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .onTapGesture {
            router.navigate(to: .mealDetailsView(id: item.id))
        }
    }
    
    private func error(with message: String) -> some View {
        ContentUnavailableView {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                Text("Couldn't fetch \(viewModel.category)")
                    .font(.title)
            }
        } description: {
            Text(message)
        } actions: {
            Button("Tap to Retry") {
                Task {
                    viewModel.state = .loading
                    await viewModel.fetchMeals()
                }
            }
        }
    }
}

#Preview {
    MealsView()
}
