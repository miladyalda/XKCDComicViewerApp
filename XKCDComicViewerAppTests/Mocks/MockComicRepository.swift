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

    // MARK: - ComicRepositoryProtocol

    func getLatestComic() async throws -> Comic {
        getLatestComicCallCount += 1

        if let error = errorToThrow {
            throw error
        }

        return comicToReturn ?? .mock()
    }

    func getComic(id: Int) async throws -> Comic {
        getComicCallCount += 1
        lastRequestedComicId = id

        if let error = errorToThrow {
            throw error
        }

        return comicToReturn ?? .mock(id: id)
    }

    func searchComics(query: String) async throws -> [Comic] {
        if let error = errorToThrow {
            throw error
        }

        return comicsToReturn
    }

    // MARK: - Test Helpers

    func reset() {
        comicToReturn = nil
        comicsToReturn = []
        errorToThrow = nil
        getLatestComicCallCount = 0
        getComicCallCount = 0
        lastRequestedComicId = nil
    }
}
