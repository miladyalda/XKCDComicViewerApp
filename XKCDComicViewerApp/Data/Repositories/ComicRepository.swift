//
//  ComicRepository.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - ComicRepository

final class ComicRepository: ComicRepositoryProtocol {

    // MARK: - Properties

    private let apiClient: APIClientProtocol

    // MARK: - Init

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - ComicRepositoryProtocol

    func getLatestComic() async throws -> Comic {
        let dto: ComicDTO = try await apiClient.fetch(endpoint: .latestComic)
        return mapToComic(dto: dto)
    }

    func getComic(id: Int) async throws -> Comic {
        let dto: ComicDTO = try await apiClient.fetch(endpoint: .comic(id: id))
        return mapToComic(dto: dto)
    }

    // MARK: - Private Methods

    private func mapToComic(dto: ComicDTO) -> Comic {
        Comic(
            id: dto.num,
            title: dto.title,
            safeTitle: dto.safeTitle,
            description: dto.alt,
            imageURL: URL(string: dto.img),
            transcript: dto.transcript.isEmpty ? nil : dto.transcript,
            publishedDate: createDate(year: dto.year, month: dto.month, day: dto.day),
            link: dto.link.isEmpty ? nil : URL(string: dto.link)
        )
    }

    private func createDate(year: String, month: String, day: String) -> Date? {
        var components = DateComponents()
        components.year = Int(year)
        components.month = Int(month)
        components.day = Int(day)
        return Calendar.current.date(from: components)
    }
}
