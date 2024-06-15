//
//  MealDetailsView+Extension.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import SwiftUI

extension MealDetailsView {
    func mealImage(for url: URL?) -> some View {
        asyncImage(for: url, animation: .bouncy(duration: 0.5)) {
            Rectangle()
                .fill(.clear)
                .overlay(ProgressView())
        }
        .aspectRatio(1.5, contentMode: .fill)
        .containerRelativeFrame(.horizontal) { length, _ in
            length
        }
        .clipShape(.rect(cornerRadius: 10))
    }
    
    func content(for ingredients: [Ingredient]) -> some View {
        ForEach(ingredients, id: \.self) { ingredient in
            HStack {
                asyncImage(for: ingredient.thumbnailURL) {
                    Image(systemName: "fork.knife")
                        .font(.body)
                }
                .frame(width: 25, height: 25)
                
                Text(ingredient.name)
                    .bold()
                
                Spacer()
                
                Text(ingredient.quantity)
            }
        }
        .font(.subheadline)
    }
    
    @ViewBuilder
    func content(for instructions: [String]) -> some View {
        let steps = instructions.prefix(
            areInstructionsExpanded ? instructions.count : 1
        )
        ForEach(steps, id: \.self) { step in
            Text(step)
        }
        
        if instructions.count > 1 {
            Button(areInstructionsExpanded ? "Close" : "Read more") {
                withAnimation(.easeOut) {
                    areInstructionsExpanded.toggle()
                }
            }
        }
    }
    
    func recipeLink(for url: URL?) -> some View {
        Button {
            recipeURL = url
        } label: {
            Label("Recipe", systemImage: "book.pages")
        }
        .foregroundStyle(.mint)
        .colorMultiply(.white)
        .disabled(url == nil)
    }
    
    @ViewBuilder
    func youtubeLink(for url: URL?) -> some View {
        if let url {
            Link(destination: url) {
                Label("Youtube", systemImage: "video.badge.checkmark")
            }
            .foregroundStyle(.red)
            .colorMultiply(.white)
        }
    }
    
    func asyncImage(
        for url: URL?,
        animation: Animation = .easeOut,
        placeholder: @escaping () -> some View
    ) -> some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: animation)
        ) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .transition(.blurReplace)
            default:
                placeholder()
                    .transition(.opacity)
            }
        }
    }
}
