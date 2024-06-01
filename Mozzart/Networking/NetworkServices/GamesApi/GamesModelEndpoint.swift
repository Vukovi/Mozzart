//
//  GamesModelEndpoint.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

enum GamesModelEndpoint {
    case fetchGames(_ request: GamesModelApi.Request)
}

extension GamesModelEndpoint: Requestable {
   
    var environment: EnvironmentConfiguration.Environment {
        switch self {
        case .fetchGames:
            return .kino
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchGames:
            return .GET
        }
    }
    
    var pathAddOns: [String]? {
        switch self {
        case .fetchGames:
            return nil
        }
    }
    
    var path: String? {
        switch self {
        case .fetchGames:
            return "upcoming/20"
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchGames:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchGames:
            return nil
        }
    }
}
