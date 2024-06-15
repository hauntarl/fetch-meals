//
//  MealDetailsView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

public struct MealDetailsView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject var viewModel: ViewModel
    
    private let id: String
    private let name: String
    
    public init(id: String, name: String, _ viewModel: ViewModel = .init()) {
        self.id = id
        self.name = name
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            switch (viewModel.state) {
            case .loading:
                ProgressView()
                    .task {
                        await viewModel.fetchMealDetails(for: id)
                    }
            case .success(let result):
                Text(result.tags)
            case .failure(let message):
                ErrorView(
                    title: "Couldn't fetch **\(name)**",
                    message: message
                ) {
                    await viewModel.fetchMealDetails(for: id)
                }
            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    struct MealDetailsPreview: View {
        var body: some View {
            MealDetailsView(
                id: MealItem.sample.id,
                name: MealItem.sample.name,
                MealDetailsView.ViewModel(
                    network: PreviewNetworkProvider(
                        error: NetworkError.missingData
                    )
                )
            )
        }
    }
    
    return MealDetailsPreview()
        .preferredColorScheme(.dark)
}
