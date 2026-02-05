//
//  Comic.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - Comic

struct Comic: Identifiable, Sendable, Hashable {
    let id: Int
    let title: String
    let safeTitle: String
    let description: String
    let imageURL: URL?
    let transcript: String?
    let publishedDate: Date?
    let link: URL?
}

extension Comic: Equatable {
    nonisolated static func == (lhs: Comic, rhs: Comic) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.safeTitle == rhs.safeTitle &&
        lhs.description == rhs.description &&
        lhs.imageURL == rhs.imageURL &&
        lhs.transcript == rhs.transcript &&
        lhs.publishedDate == rhs.publishedDate &&
        lhs.link == rhs.link
    }
}
