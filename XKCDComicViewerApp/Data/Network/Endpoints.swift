//
//  Endpoints.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - Endpoints

enum Endpoints {
    case latestComic
    case comic(id: Int)

    // MARK: - Base URL

    private var baseURL: String {
        switch self {
        case .latestComic, .comic:
            return "https://xkcd.com"
        }
    }

    // MARK: - Path

    private var path: String {
        switch self {
        case .latestComic:
            return "/info.0.json"
        case .comic(let id):
            return "/\(id)/info.0.json"
        }
    }

    // MARK: - URL

    var url: URL? {
        return URL(string: baseURL + path)
    }
}
