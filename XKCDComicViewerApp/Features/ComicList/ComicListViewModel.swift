//
//  ComicListViewModel.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation
import Observation

// MARK: - ComicListViewModel

@Observable
final class ComicListViewModel {

    // MARK: - State

    private(set) var state: ViewState<Comic> = .idle
    private(set) var latestComicId: Int?

    // MARK: - Computed Properties

    var isLoading: Bool {
        state == .loading
    }

    var canGoNext: Bool {
        guard let currentId = currentComicId,
              let latestId = latestComicId else {
            return false
        }
        return currentId < latestId
    }

    var canGoPrevious: Bool {
        guard let currentId = currentComicId else {
            return false
        }
        return currentId > 1
    }

    private var currentComicId: Int? {
        if case .loaded(let comic) = state {
            return comic.id
        }
        return nil
    }

    // MARK: - Dependencies

    private let repository: ComicRepositoryProtocol

    // MARK: - Init

    init(repository: ComicRepositoryProtocol = ComicRepository()) {
        self.repository = repository
    }

    // MARK: - Public Methods

    @MainActor
    func fetchLatestComic() async {
        state = .loading

        do {
            let comic = try await repository.getLatestComic()
            latestComicId = comic.id
            state = .loaded(comic)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    @MainActor
    func fetchComic(id: Int) async {
        guard id >= 1 else { return }

        state = .loading

        do {
            let comic = try await repository.getComic(id: id)
            state = .loaded(comic)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    @MainActor
    func fetchFirstComic() async {
        await fetchComic(id: 1)
    }

    @MainActor
    func fetchPreviousComic() async {
        guard let currentId = currentComicId, currentId > 1 else { return }
        await fetchComic(id: currentId - 1)
    }

    @MainActor
    func fetchNextComic() async {
        guard let currentId = currentComicId,
              let latestId = latestComicId,
              currentId < latestId else { return }
        await fetchComic(id: currentId + 1)
    }

    @MainActor
    func fetchRandomComic() async {
        guard let latestId = latestComicId else {
            await fetchLatestComic()
            return
        }

        let randomId = Int.random(in: 1...latestId)
        await fetchComic(id: randomId)
    }
}
