//
//  APIClient.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - APIClientProtocol

protocol APIClientProtocol: Sendable {
    func fetch<T: Decodable>(endpoint: Endpoints) async throws -> T
    func fetchRaw(endpoint: Endpoints) async throws -> String
}

// MARK: - APIClient

final class APIClient: APIClientProtocol {

    // MARK: - Properties

    private let session: URLSession
    private let decoder: JSONDecoder

    // MARK: - Init

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    // MARK: - Public Methods

    func fetch<T: Decodable>(endpoint: Endpoints) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        let data = try await performRequest(url: url)

        return try decode(data: data)
    }

    func fetchRaw(endpoint: Endpoints) async throws -> String {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        let data = try await performRequest(url: url)

        guard let text = String(data: data, encoding: .utf8) else {
            throw NetworkError.invalidData
        }

        return text
    }

    // MARK: - Private Methods

    private func performRequest(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        return data
    }

    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
