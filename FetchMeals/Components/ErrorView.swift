//
//  ErrorView.swift
//  FetchMeals
//
//  Created by Sameer Mungole on 6/14/24.
//

import SwiftUI

struct ErrorView: View {
    let title: LocalizedStringKey
    let message: String
    let action: () async -> Void
    
    var body: some View {
        ContentUnavailableView {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                Text(title)
                    .font(.title)
            }
        } description: {
            Text(message)
        } actions: {
            Button("Tap to Retry") {
                Task {
                    await action()
                }
            }
            .font(.headline)
        }
    }
}

#Preview {
    ErrorView(
        title: "**Supports** `markdown` *syntax*",
        message: "Network Error: Please try again later",
        action: {}
    )
    .preferredColorScheme(.dark)
}
