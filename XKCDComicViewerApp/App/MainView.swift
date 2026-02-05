//
//  MainView.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import SwiftUI

struct MainView: View {

    @State private var comicTitle: String = "Loading..."

    private let repository: ComicRepositoryProtocol = ComicRepository()

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.pages")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text(comicTitle)
                .font(.headline)
        }
        .padding()
        .task {
            await fetchComic()
        }
    }

    private func fetchComic() async {
        do {
            let comic = try await repository.getLatestComic()
            comicTitle = comic.title
        } catch {
            comicTitle = "Error: \(error.localizedDescription)"
        }
    }
}

#Preview {
    MainView()
}
