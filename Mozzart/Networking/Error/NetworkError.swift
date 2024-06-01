//
//  NetworkError.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case networkConnection
    case cancelled
    case timeOut
    case unknown(Error)
}

extension NetworkError {
    public struct ValidationError: Decodable, Error {
        public let status: String?
        public let code: String?
        public let message: String?
    }
}

extension NetworkError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "No valid HTTP response from server"
        case .networkConnection:
            return "Request was failure."
        case .cancelled:
            return "Request cancelled."
        case .timeOut:
            return "Request timeout."
        case .unknown(let error):
            return "Unknown error occurred: \(error.localizedDescription)"
        }
    }
}

extension NetworkError {
    init(error: Error) {
        if let networkError = error as? NetworkError {
            self = networkError
        } else {
            self = .unknown(error)
        }
    }
}
