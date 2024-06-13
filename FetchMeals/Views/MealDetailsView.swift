//
//  MealDetailsView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/12/24.
//

import SwiftUI

public struct MealDetailsView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject var viewModel = ViewModel()
    
    let id: String
    let previewURL: URL?
    
    public init(id: String, previewURL: URL?) {
        self.id = id
        self.previewURL = previewURL
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
    MealDetailsView(
        id: MealItem.sample.id,
        previewURL: MealItem.sample.thumbnailURL
    )
}
