//
//  Comic.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - Comic

struct Comic: Identifiable, Equatable, Sendable {
    let id: Int
    let title: String
    let safeTitle: String
    let description: String
    let imageURL: URL?
    let transcript: String?
    let publishedDate: Date?
    let link: URL?
}
