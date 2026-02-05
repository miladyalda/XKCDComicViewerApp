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
                        randomButton
                    }
                }
        }
        .task {
            await viewModel.fetchLatestComic()
        }
    }

    // MARK: - Content View

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            idleView

        case .loading:
            loadingView

        case .loaded(let comic):
            comicView(comic: comic)

        case .error(let message):
            errorView(message: message)
        }
    }

    // MARK: - Idle View

    private var idleView: some View {
        Color.clear
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text(Strings.ComicList.loading)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Comic View

    private func comicView(comic: Comic) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    comicHeader(comic: comic)
                    comicImage(comic: comic)
                    comicDescription(comic: comic)
                }
                .padding()
            }

            Divider()
            navigationBar
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

    private func comicImage(comic: Comic) -> some View {
        ComicImageView(url: comic.imageURL)
    }

    private func comicDescription(comic: Comic) -> some View {
        Text(comic.description)
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }

    // MARK: - Navigation Bar

    private var navigationBar: some View {
        HStack(spacing: 12) {
            navigationButton(
                title: Strings.ComicList.firstButton,
                systemImage: Icons.firstComic,
                isEnabled: viewModel.canGoPrevious
            ) {
                Task { await viewModel.fetchFirstComic() }
            }

            navigationButton(
                title: Strings.ComicList.previousButton,
                systemImage: Icons.previousComic,
                isEnabled: viewModel.canGoPrevious
            ) {
                Task { await viewModel.fetchPreviousComic() }
            }

            Spacer()

            navigationButton(
                title: Strings.ComicList.nextButton,
                systemImage: Icons.nextComic,
                isEnabled: viewModel.canGoNext
            ) {
                Task { await viewModel.fetchNextComic() }
            }

            navigationButton(
                title: Strings.ComicList.latestButton,
                systemImage: Icons.latestComic,
                isEnabled: viewModel.canGoNext
            ) {
                Task { await viewModel.fetchLatestComic() }
            }
        }
        .padding()
        .background(.bar)
    }

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

    // MARK: - Random Button

    private var randomButton: some View {
        Button {
            Task { await viewModel.fetchRandomComic() }
        } label: {
            Image(systemName: Icons.shuffle)
        }
    }

    // MARK: - Error View

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: Icons.error)
                .font(.largeTitle)
                .foregroundStyle(.red)

            Text(Strings.ComicList.errorTitle)
                .font(.headline)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(Strings.ComicList.retryButton) {
                Task { await viewModel.fetchLatestComic() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    ComicListView()
}
