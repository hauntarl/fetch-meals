//
//  SettingsView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import SwiftUI

/// Allows the user to change the meal category
public struct SettingsView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: ViewModel
    
    public var body: some View {
        List {
            Section("Sort By") {
                ForEach(MealSortKey.allCases, content: buildRow(for:))
            }
            
            Section("Order By") {
                ForEach(MealSortOrder.allCases, content: buildRow(for:))
            }
            
            Section("Categories") {
                ForEach(viewModel.categories, content: buildRow(for:))
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.fetchCategories()
        }
    }
    
    private func buildRow(for category: MealCategory) -> some View {
        Button {
            guard viewModel.category != category else {
                return
            }
            
            viewModel.category = category
            Task {
                try? await Task.sleep(for: .seconds(0.4))
                router.dismiss()
            }
        } label: {
            HStack {
                viewModel.category == category
                ? Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.accent)
                    .transition(.blurReplace.combined(with: .scale))
                : nil
                
                Text(category.name)
            }
        }
        .foregroundStyle(.primary)
        .animation(.easeOut, value: viewModel.category)
    }
    
    private func buildRow(for sortKey: MealSortKey) -> some View {
        Button {
            guard viewModel.sortKey != sortKey else {
                return
            }
            
            viewModel.sortKey = sortKey
            Task {
                try? await Task.sleep(for: .seconds(0.4))
                router.dismiss()
            }
        } label: {
            HStack {
                viewModel.sortKey == sortKey
                ? Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.accent)
                    .transition(.blurReplace.combined(with: .scale))
                : nil
                
                Text(sortKey.rawValue)
            }
        }
        .foregroundStyle(.primary)
        .animation(.easeOut, value: viewModel.sortKey)
    }
    
    private func buildRow(for sortOrder: MealSortOrder) -> some View {
        Button {
            guard viewModel.sortOrder != sortOrder else {
                return
            }
            
            viewModel.sortOrder = sortOrder
            Task {
                try? await Task.sleep(for: .seconds(0.4))
                router.dismiss()
            }
        } label: {
            HStack {
                viewModel.sortOrder == sortOrder
                ? Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.accent)
                    .transition(.blurReplace.combined(with: .scale))
                : nil

                Text(sortOrder.rawValue)
            }
        }
        .foregroundStyle(.primary)
        .animation(.easeOut, value: viewModel.sortOrder)
    }
}

#Preview {
    struct SettingsPreview: View {
        @StateObject private var router = NavigationRouter()
        @StateObject private var viewModel = SettingsView.ViewModel(network: PreviewNetworkProvider())
        
        var body: some View {
            SettingsView()
                .environmentObject(viewModel)
                .environmentObject(router)
                .task {
                    await viewModel.fetchCategories()
                }
        }
    }
    
    return SettingsPreview()
        .preferredColorScheme(.dark)
}
