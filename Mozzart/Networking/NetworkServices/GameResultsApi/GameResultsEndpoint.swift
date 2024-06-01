//
//  GameResultsEndpoint.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

enum GameResultsEndpoint {
    case fetchGameResults(_ request: GameResultsModelApi.Request)
}

extension GameResultsEndpoint: Requestable {
    
    var environment: EnvironmentConfiguration.Environment {
        switch self {
        case .fetchGameResults:
            return .kino
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchGameResults:
            return .GET
        }
    }
    
    var pathAddOns: [String]? {
        switch self {
        case .fetchGameResults(let request):
            return [
                request.fromDate,
                request.toDate
            ]
        }
    }
    
    var path: String? {
        switch self {
        case .fetchGameResults:
            return "draw-date"
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchGameResults:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchGameResults:
            return nil
        }
    }
}
