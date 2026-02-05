//
//  Untitled.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - Strings

enum Strings {

    // MARK: - App

    enum App {
        static let title = "XKCD Comics"
    }

    // MARK: - ComicList

    enum ComicList {
        static let title = "Comics"
        static let loading = "Loading comic..."
        static let errorTitle = "Oops!"
        static let retryButton = "Try Again"
        static let firstButton = "First"
        static let previousButton = "Previous"
        static let nextButton = "Next"
        static let latestButton = "Latest"
        static let randomButton = "Random"
    }

    // MARK: - ComicDetail

    enum ComicDetail {
        static let descriptionTitle = "Description"
        static let shareButton = "Share"
        static let favoriteButton = "Favorite"
    }

    // MARK: - Search

    enum Search {
        static let placeholder = "Search by comic number..."
        static let noResults = "No comics found"
    }

    // MARK: - Favorites

    enum Favorites {
        static let title = "Favorites"
        static let empty = "No favorites yet"
        static let emptyDescription = "Tap the heart icon on a comic to add it here"
    }

    // MARK: - Errors

    enum Errors {
        static let generic = "Something went wrong"
        static let network = "Please check your internet connection"
        static let invalidComic = "Comic not found"
    }
}
