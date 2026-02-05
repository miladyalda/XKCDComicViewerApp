//
//  SearchResultDTO.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - SearchResultDTO

struct SearchResultDTO {
    let isSuccess: Bool
    let results: [SearchResultItem]

    // MARK: - SearchResultItem

    struct SearchResultItem {
        let comicId: Int
        let relevanceScore: Double
    }

    // MARK: - Parsing

    /// Parses plain text response into SearchResultDTO
    static func parse(from text: String) -> SearchResultDTO {
        let lines = text.components(separatedBy: "\n").filter { !$0.isEmpty }

        guard lines.count >= 2 else {
            return SearchResultDTO(isSuccess: false, results: [])
        }

        let isSuccess = lines[0].lowercased() == "success"

        guard isSuccess else {
            return SearchResultDTO(isSuccess: false, results: [])
        }

        var results: [SearchResultItem] = []

        // Skip first two lines (success + count), parse comic results
        for index in 2..<lines.count {
            let components = lines[index].components(separatedBy: " ")

            if components.count >= 2,
               let comicId = Int(components[0]),
               let score = Double(components[1]) {
                results.append(SearchResultItem(comicId: comicId, relevanceScore: score))
            }
        }

        return SearchResultDTO(isSuccess: true, results: results)
    }
}
