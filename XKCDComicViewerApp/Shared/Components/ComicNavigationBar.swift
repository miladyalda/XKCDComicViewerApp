//
//  ComicNavigationBar.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import SwiftUI

// MARK: - ComicNavigationBar

struct ComicNavigationBar: View {

    // MARK: - Properties

    let canGoPrevious: Bool
    let canGoNext: Bool
    let onFirst: () -> Void
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onLatest: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            navigationButton(
                title: Strings.ComicList.firstButton,
                systemImage: Icons.firstComic,
                isEnabled: canGoPrevious,
                action: onFirst
            )

            navigationButton(
                title: Strings.ComicList.previousButton,
                systemImage: Icons.previousComic,
                isEnabled: canGoPrevious,
                action: onPrevious
            )

            Spacer()

            navigationButton(
                title: Strings.ComicList.nextButton,
                systemImage: Icons.nextComic,
                isEnabled: canGoNext,
                action: onNext
            )

            navigationButton(
                title: Strings.ComicList.latestButton,
                systemImage: Icons.latestComic,
                isEnabled: canGoNext,
                action: onLatest
            )
        }
        .padding()
        .background(.bar)
    }

    // MARK: - Navigation Button

    private func navigationButton(
        title: String,
        systemImage: String,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.title3)
                Text(title)
                    .font(.caption2)
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.4)
    }
}

// MARK: - Preview

#Preview {
    ComicNavigationBar(
        canGoPrevious: true,
        canGoNext: true,
        onFirst: {},
        onPrevious: {},
        onNext: {},
        onLatest: {}
    )
}
