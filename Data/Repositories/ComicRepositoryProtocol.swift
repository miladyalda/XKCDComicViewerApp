//
//  ComicRepositoryProtocol.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - ComicRepositoryProtocol

protocol ComicRepositoryProtocol: Sendable {
    /// Fetches the latest comic from XKCD
    func getLatestComic() async throws -> Comic

    /// Fetches a specific comic by its ID
    func getComic(id: Int) async throws -> Comic

    /// Searches for comics by text query
    /// Returns an array of comics matching the search query
    func searchComics(query: String) async throws -> [Comic]
}
