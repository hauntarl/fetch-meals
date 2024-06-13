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
        switch (viewModel.state) {
        case .loading:
            ProgressView()
                .task {
                    await viewModel.fetchMeals()
                }
        case .success(let meals):
            List(meals, rowContent: buildRow(for:))
                .navigationTitle(viewModel.category.rawValue)
                .navigationBarTitleDisplayMode(.large)
                .navigationBarBackButtonHidden()
        case .failure(let message):
            ContentUnavailableView(
                "Error occurred",
                systemImage: "hazard",
                description: Text(message)
            )
            .onTapGesture {
                Task {
                    await viewModel.fetchMeals()
                }
            }
        }
    }
    
    func buildRow(for item: MealItem) -> some View {
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
        }
        .onTapGesture {
            router.navigate(to: .mealDetailsView(
                id: item.id, previewURL: item.thumbnailURL
            ))
        }
    }
}

#Preview {
    MealsView()
}
