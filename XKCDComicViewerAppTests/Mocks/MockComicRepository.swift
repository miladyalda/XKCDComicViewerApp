//
//  MockComicRepository.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation
@testable import XKCDComicViewerApp

// MARK: - MockComicRepository

final class MockComicRepository: ComicRepositoryProtocol, @unchecked Sendable {

    // MARK: - Properties

    var comicToReturn: Comic?
    var comicsToReturn: [Comic] = []
    var errorToThrow: Error?

    private(set) var getLatestComicCallCount = 0
    private(set) var getComicCallCount = 0
    private(set) var lastRequestedComicId: Int?
    
    // MARK: - Task Cancellation Support
    
    var shouldDelay = false
    var delayDuration: TimeInterval = 0.1

    // MARK: - ComicRepositoryProtocol

    func getLatestComic() async throws -> Comic {
        getLatestComicCallCount += 1
        
        if shouldDelay {
            try? await Task.sleep(for: .seconds(delayDuration))
        }

        if let error = errorToThrow {
            throw error
        }

        return comicToReturn ?? .mock()
    }

    func getComic(id: Int) async throws -> Comic {
        getComicCallCount += 1
        lastRequestedComicId = id
        
        if shouldDelay {
            try? await Task.sleep(for: .seconds(delayDuration))
        }

        if let error = errorToThrow {
            throw error
        }

        return comicToReturn ?? .mock(id: id)
    }

    // MARK: - Test Helpers

    func reset() {
        comicToReturn = nil
        comicsToReturn = []
        errorToThrow = nil
        getLatestComicCallCount = 0
        getComicCallCount = 0
        lastRequestedComicId = nil
        shouldDelay = false
        delayDuration = 0.1
    }
}
