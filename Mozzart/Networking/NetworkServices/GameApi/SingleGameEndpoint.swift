//
//  SingleGameEndpoint.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

enum SingleGameEndpoint {
    case fetchSingleGame(_ request: SingleGameModelApi.Request)
}

extension SingleGameEndpoint: Requestable {
    
    var environment: EnvironmentConfiguration.Environment {
        switch self {
        case .fetchSingleGame:
            return .kino
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchSingleGame:
            return .GET
        }
    }
    
    var pathAddOns: [String]? {
        switch self {
        case .fetchSingleGame(let request):
            return [
                request.drawId
            ]
        }
    }
    
    var path: String? {
        switch self {
        case .fetchSingleGame:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchSingleGame:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchSingleGame:
            return nil
        }
    }
}
