//
//  ErrorView.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import SwiftUI

// MARK: - ErrorView

struct ErrorView: View {

    // MARK: - Properties

    let title: String
    let message: String
    var retryTitle: String?
    var onRetry: (() -> Void)?

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Icons.error)
                .font(.largeTitle)
                .foregroundStyle(.red)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let retryTitle, let onRetry {
                Button(retryTitle, action: onRetry)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("With Retry") {
    ErrorView(
        title: "Oops!",
        message: "Something went wrong",
        retryTitle: Strings.Common.retryButton,
        onRetry: {}
    )
}

#Preview("Without Retry") {
    ErrorView(
        title: Strings.Errors.generic,
        message: Strings.Errors.invalidComic
    )
}
