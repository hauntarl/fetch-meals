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
    
    public init(id: String, _ viewModel: ViewModel = .init()) {
        self.id = id
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        switch (viewModel.state) {
        case .loading:
            ProgressView()
                .task {
                    await viewModel.fetchMealDetails(for: id)
                }
        case .success(let result):
            Text(result.tags)
                .navigationTitle(result.name)
        case .failure(let message):
            ContentUnavailableView(
                "Error occurred",
                systemImage: "hazard",
                description: Text(message)
            )
            .onTapGesture {
                Task {
                    await viewModel.fetchMealDetails(for: id)
                }
            }
        }
    }
}

#Preview {
    struct MealDetailsPreview: View {
        var body: some View {
            MealDetailsView(
                id: MealItem.sample.id,
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
