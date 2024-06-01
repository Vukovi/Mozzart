//
//  SingleGameService.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation
import Combine

protocol SingleGameServiceProtocol {
    func fetchSingleGame(
        _ request: SingleGameModelApi.Request
    ) -> AnyPublisher<SingleGameModelApi.Response, NetworkError>
}


public struct SingleGameService: SingleGameServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchSingleGame(
        _ request: SingleGameModelApi.Request
    ) -> AnyPublisher<SingleGameModelApi.Response, NetworkError> {
        networkService.execute(
            request: SingleGameEndpoint.fetchSingleGame(request)
        )
    }
    
}

