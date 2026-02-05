//
//  ExplanationView.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import SwiftUI
import WebKit

// MARK: - ExplanationView

struct ExplanationView: View {

    // MARK: - Properties

    let comicNumber: Int

    @State private var page = WebPage()

    private var explanationURL: URL? {
        URL(string: "https://www.explainxkcd.com/wiki/index.php/\(comicNumber)")
    }

    // MARK: - Body

    var body: some View {
        Group {
            if let url = explanationURL {
                ZStack {
                    WebView(page)

                    if page.isLoading {
                        LoadingView(message: Strings.Common.loading)
                    }
                }
                .onAppear {
                    page.load(url)
                }
            } else {
                ErrorView(
                    title: Strings.Errors.generic,
                    message: Strings.Errors.invalidComic
                )
            }
        }
        .navigationTitle(Strings.ComicExplanation.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ExplanationView(comicNumber: 3202)
    }
}
