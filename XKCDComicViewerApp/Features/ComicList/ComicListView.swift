//
//  ComicListView.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import SwiftUI

// MARK: - ComicListView

struct ComicListView: View {

    // MARK: - Properties

    @State private var viewModel: ComicListViewModel
    @State private var currentComic: Comic?

    // MARK: - Init

    init(viewModel: ComicListViewModel = ComicListViewModel()) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(Strings.ComicList.title)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        shareLink
                    }
                    ToolbarItem(placement: .primaryAction) {
                        randomButton
                    }
                    ToolbarItem(placement: .primaryAction) {
                        explanationLink
                    }
                }
        }
        .task {
            await viewModel.fetchLatestComic()
        }
        .onChange(of: viewModel.state) { _, newState in
            if case .loaded(let comic) = newState {
                currentComic = comic
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var explanationLink: some View {
        if let comic = currentComic {
            NavigationLink(Strings.ComicExplanation.title) {
                ExplanationView(comicNumber: comic.id)
            }
            .disabled(viewModel.isLoading)
        }
    }

    // MARK: - Share Link

    @ViewBuilder
    private var shareLink: some View {
        if let comic = currentComic {
            ShareLink(item: URL(string: "https://xkcd.com/\(comic.id)")!) {
                Image(systemName: Icons.share)
            }
            .disabled(viewModel.isLoading)
        }
    }

    // MARK: - Content View

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            Color.clear

        case .loading:
            LoadingView(message: Strings.Common.loading)

        case .loaded(let comic):
            comicView(comic: comic)

        case .error(let message):
            ErrorView(
                title: Strings.Errors.generic,
                message: message,
                retryTitle: Strings.Common.retryButton
            ) {
                Task { await viewModel.fetchLatestComic() }
            }
        }
    }

    // MARK: - Comic View

    private func comicView(comic: Comic) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    comicHeader(comic: comic)
                    ComicImageView(url: comic.imageURL)
                    comicDescription(comic: comic)
                }
                .padding()
            }

            Divider()

            ComicNavigationBar(
                canGoPrevious: viewModel.canGoPrevious,
                canGoNext: viewModel.canGoNext,
                onFirst: { Task { await viewModel.fetchFirstComic() } },
                onPrevious: { Task { await viewModel.fetchPreviousComic() } },
                onNext: { Task { await viewModel.fetchNextComic() } },
                onLatest: { Task { await viewModel.fetchLatestComic() } }
            )
        }
    }

    private func comicHeader(comic: Comic) -> some View {
        VStack(spacing: 4) {
            Text("#\(comic.id)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(comic.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }

    private func comicDescription(comic: Comic) -> some View {
        Text(comic.description)
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }

    // MARK: - Random Button

    private var randomButton: some View {
        Button {
            Task { await viewModel.fetchRandomComic() }
        } label: {
            Image(systemName: Icons.shuffle)
        }
        .disabled(viewModel.isLoading)
    }
}

// MARK: - Preview

#Preview {
    ComicListView()
}
