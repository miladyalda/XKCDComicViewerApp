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

    // MARK: - Task Management

    private var currentTask: Task<Void, Never>?

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
        await executeCancellableTask(
            { try await self.repository.getLatestComic() },
            onSuccess: { [weak self] comic in
                self?.latestComicId = comic.id
            }
        )
    }

    @MainActor
    func fetchComic(id: Int) async {
        guard id >= 1 else { return }

        await executeCancellableTask {
            try await self.repository.getComic(id: id)
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

    // MARK: - Private Methods

    private func executeCancellableTask(
        _ operation: @escaping () async throws -> Comic,
        onSuccess: ((Comic) -> Void)? = nil
    ) async {
        cancelCurrentTask()

        currentTask = Task {
            state = .loading

            do {
                let comic = try await operation()
                guard !Task.isCancelled else { return }

                onSuccess?(comic)
                state = .loaded(comic)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }

        await currentTask?.value
    }

    private func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
    }
}
