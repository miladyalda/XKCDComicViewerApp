//
//  NetworkError.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import Foundation

// MARK: - NetworkError

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingFailed(Error)
    case serverError(statusCode: Int)
    case noInternetConnection
    case unknown(Error)

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received"
        case .decodingFailed:
            return "Failed to decode response"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .noInternetConnection:
            return "No internet connection"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
