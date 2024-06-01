//
//  GamesResultsService.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation
import Combine

protocol GamesResultsServiceProtocol {
    func fetchGameResults(
        _ request: GameResultsModelApi.Request
    ) -> AnyPublisher<GameResultsModelApi.Response, NetworkError>
}


public struct GamesResultsService: GamesResultsServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchGameResults(
        _ request: GameResultsModelApi.Request
    ) -> AnyPublisher<GameResultsModelApi.Response, NetworkError> {
        networkService.execute(
            request: GameResultsEndpoint.fetchGameResults(request)
        )
    }
    
}
