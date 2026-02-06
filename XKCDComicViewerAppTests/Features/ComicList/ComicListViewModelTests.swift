//
//  ComicListViewModelTests.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Testing
@testable import XKCDComicViewerApp

// MARK: - ComicListViewModelTests

@Suite("ComicListViewModel Tests")
struct ComicListViewModelTests {

    // MARK: - Properties

    private let mockRepository = MockComicRepository()
    
    // MARK: - Type Aliases

    private typealias ComicState = ViewState<Comic>

    // MARK: - Factory

    private func makeSUT() -> ComicListViewModel {
        mockRepository.reset()
        return ComicListViewModel(repository: mockRepository)
    }
}

// MARK: - Initial State Tests

extension ComicListViewModelTests {

    @Suite("Initial State")
    struct InitialStateTests {

        @Test("Initial state is idle")
        func initialStateIsIdle() {
            let sut = ComicListViewModel(repository: MockComicRepository())

            #expect(sut.state == ViewState<Comic>.idle)
            #expect(sut.latestComicId == nil)
            #expect(sut.isLoading == false)
            #expect(sut.canGoNext == false)
            #expect(sut.canGoPrevious == false)
        }
    }
}

// MARK: - Fetch Latest Comic Tests

extension ComicListViewModelTests {

    @Suite("Fetch Latest Comic")
    struct FetchLatestComicTests {

        private let mockRepository = MockComicRepository()

        @Test("Successfully fetches and updates state")
        @MainActor
        func fetchLatestComicSuccess() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.comicToReturn = .latestComic

            await sut.fetchLatestComic()

            #expect(sut.state == .loaded(.latestComic))
            #expect(sut.latestComicId == 3203)
            #expect(sut.isLoading == false)
        }

        @Test("Sets error state on failure")
        @MainActor
        func fetchLatestComicFailure() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.errorToThrow = NetworkError.invalidResponse

            await sut.fetchLatestComic()

            if case .error(let message) = sut.state {
                #expect(message.isEmpty == false)
            } else {
                Issue.record("Expected error state")
            }
        }
    }
}

// MARK: - Fetch Comic By ID Tests

extension ComicListViewModelTests {

    @Suite("Fetch Comic By ID")
    struct FetchComicByIDTests {

        private let mockRepository = MockComicRepository()

        @Test("Fetches comic with valid ID")
        @MainActor
        func fetchComicWithValidId() async {
            let sut = ComicListViewModel(repository: mockRepository)
            let expectedComic = Comic.mock(id: 42, title: "Comic 42")
            mockRepository.comicToReturn = expectedComic

            await sut.fetchComic(id: 42)

            #expect(sut.state == .loaded(expectedComic))
            #expect(mockRepository.lastRequestedComicId == 42)
        }

        @Test("Does not fetch with zero ID")
        @MainActor
        func fetchComicWithZeroId() async {
            let sut = ComicListViewModel(repository: mockRepository)

            await sut.fetchComic(id: 0)

            #expect(sut.state == .idle)
            #expect(mockRepository.getComicCallCount == 0)
        }

        @Test("Does not fetch with negative ID")
        @MainActor
        func fetchComicWithNegativeId() async {
            let sut = ComicListViewModel(repository: mockRepository)

            await sut.fetchComic(id: -1)

            #expect(sut.state == .idle)
            #expect(mockRepository.getComicCallCount == 0)
        }
    }
}

// MARK: - Navigation State Tests

extension ComicListViewModelTests {

    @Suite("Navigation State")
    struct NavigationStateTests {

        private let mockRepository = MockComicRepository()

        @Test("Cannot go previous on first comic")
        @MainActor
        func cannotGoPreviousOnFirstComic() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.comicToReturn = .firstComic

            await sut.fetchLatestComic()

            #expect(sut.canGoPrevious == false)
        }

        @Test("Can go previous on later comic")
        @MainActor
        func canGoPreviousOnLaterComic() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.comicToReturn = .middleComic

            await sut.fetchLatestComic()

            #expect(sut.canGoPrevious == true)
        }

        @Test("Cannot go next on latest comic")
        @MainActor
        func cannotGoNextOnLatestComic() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.comicToReturn = .latestComic

            await sut.fetchLatestComic()

            #expect(sut.canGoNext == false)
        }

        @Test("Can go next on earlier comic")
        @MainActor
        func canGoNextOnEarlierComic() async {
            let sut = ComicListViewModel(repository: mockRepository)

            // First fetch latest to set latestComicId
            mockRepository.comicToReturn = .latestComic
            await sut.fetchLatestComic()

            // Then fetch an earlier comic
            mockRepository.comicToReturn = .middleComic
            await sut.fetchComic(id: 1000)

            #expect(sut.canGoNext == true)
        }
    }
}

// MARK: - Navigation Action Tests

extension ComicListViewModelTests {

    @Suite("Navigation Actions")
    struct NavigationActionTests {

        private let mockRepository = MockComicRepository()

        @Test("Fetch previous decrements comic ID")
        @MainActor
        func fetchPreviousDecrementsId() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.comicToReturn = .mock(id: 100)

            await sut.fetchLatestComic()

            mockRepository.comicToReturn = .mock(id: 99)
            await sut.fetchPreviousComic()

            if case .loaded(let comic) = sut.state {
                #expect(comic.id == 99)
            } else {
                Issue.record("Expected loaded state")
            }
        }

        @Test("Fetch next increments comic ID")
        @MainActor
        func fetchNextIncrementsId() async {
            let sut = ComicListViewModel(repository: mockRepository)

            // Set latest
            mockRepository.comicToReturn = .latestComic
            await sut.fetchLatestComic()

            // Go to earlier comic
            mockRepository.comicToReturn = .mock(id: 100)
            await sut.fetchComic(id: 100)

            // Go next
            mockRepository.comicToReturn = .mock(id: 101)
            await sut.fetchNextComic()

            if case .loaded(let comic) = sut.state {
                #expect(comic.id == 101)
            } else {
                Issue.record("Expected loaded state")
            }
        }

        @Test("Fetch first gets comic with ID 1")
        @MainActor
        func fetchFirstGetsComicId1() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.comicToReturn = .firstComic

            await sut.fetchFirstComic()

            #expect(mockRepository.lastRequestedComicId == 1)

            if case .loaded(let comic) = sut.state {
                #expect(comic.id == 1)
            } else {
                Issue.record("Expected loaded state")
            }
        }

        @Test("Fetch random fetches latest first if no latestComicId")
        @MainActor
        func fetchRandomFetchesLatestFirst() async {
            let sut = ComicListViewModel(repository: mockRepository)
            mockRepository.comicToReturn = .latestComic

            await sut.fetchRandomComic()

            #expect(mockRepository.getLatestComicCallCount == 1)
        }
    }
}

// MARK: - Task Cancellation Tests

extension ComicListViewModelTests {

    @Suite("Task Cancellation")
    struct TaskCancellationTests {

        private let mockRepository = MockComicRepository()

        @Test("Cancels previous task when fetching new comic")
        @MainActor
        func cancelsPreviousTaskOnNewFetch() async {
            let sut = ComicListViewModel(repository: mockRepository)
            
            // Set up repository to return different comics with delay
            mockRepository.comicToReturn = .mock(id: 100, title: "First")
            mockRepository.shouldDelay = true
            mockRepository.delayDuration = 0.1
            
            // Start first fetch
            let firstTask = Task {
                await sut.fetchComic(id: 100)
            }
            
            // Immediately start second fetch (should cancel first)
            try? await Task.sleep(for: .milliseconds(10))
            mockRepository.comicToReturn = .mock(id: 200, title: "Second")
            await sut.fetchComic(id: 200)
            
            // Wait for first task to complete
            await firstTask.value
            
            // Should show second comic, not first
            if case .loaded(let comic) = sut.state {
                #expect(comic.id == 200)
                #expect(comic.title == "Second")
            } else {
                Issue.record("Expected loaded state with second comic")
            }
        }

        @Test("Cancels previous task when navigating rapidly")
        @MainActor
        func cancelsPreviousTaskOnRapidNavigation() async {
            let sut = ComicListViewModel(repository: mockRepository)
            
            // Set up initial state
            mockRepository.comicToReturn = .latestComic
            await sut.fetchLatestComic()
            
            // Simulate rapid button tapping
            mockRepository.shouldDelay = true
            mockRepository.delayDuration = 0.05
            
            mockRepository.comicToReturn = .mock(id: 3202)
            let task1 = Task { await sut.fetchPreviousComic() }
            
            try? await Task.sleep(for: .milliseconds(10))
            mockRepository.comicToReturn = .mock(id: 3201)
            let task2 = Task { await sut.fetchPreviousComic() }
            
            try? await Task.sleep(for: .milliseconds(10))
            mockRepository.comicToReturn = .mock(id: 3200)
            await sut.fetchPreviousComic()
            
            await task1.value
            await task2.value
            
            // Should show only the last comic
            if case .loaded(let comic) = sut.state {
                #expect(comic.id == 3200)
            } else {
                Issue.record("Expected loaded state with final comic")
            }
        }

        @Test("Handles cancellation during latest comic fetch")
        @MainActor
        func handlesCancellationDuringLatestFetch() async {
            let sut = ComicListViewModel(repository: mockRepository)
            
            mockRepository.shouldDelay = true
            mockRepository.delayDuration = 0.1
            mockRepository.comicToReturn = .latestComic
            
            // Start fetch
            let firstTask = Task {
                await sut.fetchLatestComic()
            }
            
            // Cancel by starting new fetch
            try? await Task.sleep(for: .milliseconds(10))
            mockRepository.comicToReturn = .mock(id: 100)
            await sut.fetchComic(id: 100)
            
            await firstTask.value
            
            // Should not have latest comic state
            if case .loaded(let comic) = sut.state {
                #expect(comic.id == 100)
            } else {
                Issue.record("Expected loaded state with comic 100")
            }
        }
    }
}
