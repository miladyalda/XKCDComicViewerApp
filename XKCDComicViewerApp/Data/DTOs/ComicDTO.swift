//
//  ComicDTO.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - ComicDTO

struct ComicDTO: Decodable {
    let month: String
    let num: Int
    let link: String
    let year: String
    let news: String
    let safeTitle: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case month
        case num
        case link
        case year
        case news
        case safeTitle = "safe_title"
        case transcript
        case alt
        case img
        case title
        case day
    }
}
