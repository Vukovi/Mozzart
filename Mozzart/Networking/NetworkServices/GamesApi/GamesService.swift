//
//  GamesService.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation
import Combine

protocol GamesServiceProtocol {
    func fetchGames(
        _ request: GamesModelApi.Request
    ) -> AnyPublisher<GamesModelApi.Response, NetworkError>
}


public struct GamesService: GamesServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchGames(
        _ request: GamesModelApi.Request
    ) -> AnyPublisher<GamesModelApi.Response, NetworkError> {
        networkService.execute(
            request: GamesModelEndpoint.fetchGames(request)
        )
    }
    
}
