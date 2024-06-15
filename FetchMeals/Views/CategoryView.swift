//
//  CategoryView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import SwiftUI

public struct CategoryView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: ViewModel
    
    public var body: some View {
        List(MealCategory.allCases, rowContent: buildRow(for:))
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
    }
    
    private func buildRow(for category: MealCategory) -> some View {
        Button {
            defer {
                Task {
                    try? await Task.sleep(for: .seconds(0.4))
                    router.dismiss()
                }
            }
            guard viewModel.category != category else {
                return
            }
            viewModel.update(category: category)
        } label: {
            HStack {
                viewModel.category != category
                ? nil
                : Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.accent)
                    .transition(.blurReplace.combined(with: .scale))

                Text(category.rawValue)
            }
        }
        .foregroundStyle(.primary)
        .animation(.easeOut, value: viewModel.category)
    }
}

#Preview {
    struct CategoryPreview: View {
        @StateObject private var router = NavigationRouter()
        @StateObject private var viewModel = CategoryView.ViewModel()
        
        var body: some View {
            return CategoryView()
                .environmentObject(viewModel)
                .environmentObject(router)
        }
    }
    
    return CategoryPreview()
        .preferredColorScheme(.dark)
}
