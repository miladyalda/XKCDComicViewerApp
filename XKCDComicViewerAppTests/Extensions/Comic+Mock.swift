//
//  Comic+Mock.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation
@testable import XKCDComicViewerApp

// MARK: - Comic+Mock

extension Comic {

    static func mock(
        id: Int = 1,
        title: String = "Test Comic",
        safeTitle: String = "Test Comic",
        description: String = "A test comic description",
        imageURL: URL? = URL(string: "https://imgs.xkcd.com/comics/test.png"),
        transcript: String? = nil,
        publishedDate: Date? = nil,
        link: URL? = nil
    ) -> Comic {
        Comic(
            id: id,
            title: title,
            safeTitle: safeTitle,
            description: description,
            imageURL: imageURL,
            transcript: transcript,
            publishedDate: publishedDate,
            link: link
        )
    }

    // MARK: - Predefined Mocks

    static var latestComic: Comic {
        .mock(
            id: 3203,
            title: "Binary Star",
            description: "The latest XKCD comic"
        )
    }

    static var firstComic: Comic {
        .mock(
            id: 1,
            title: "Barrel - Part 1",
            description: "The first XKCD comic"
        )
    }

    static var middleComic: Comic {
        .mock(
            id: 1000,
            title: "1000 Comics",
            description: "A milestone comic"
        )
    }
}
