//
//  ComicImageView.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import SwiftUI

// MARK: - ComicImageView

struct ComicImageView: View {

    // MARK: - Properties

    let url: URL?

    // MARK: - Body

    var body: some View {
        Group {
            if let imageURL = url {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        loadingView

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()

                    case .failure:
                        errorView

                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                errorView
            }
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        ProgressView()
            .frame(height: 200)
    }

    private var errorView: some View {
        Image(systemName: Icons.photo)
            .font(.largeTitle)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Preview

#Preview {
    ComicImageView(url: URL(string: "https://imgs.xkcd.com/comics/groundhog_day_meaning.png"))
}
