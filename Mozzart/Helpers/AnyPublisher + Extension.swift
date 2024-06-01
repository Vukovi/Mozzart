//
//  AnyPublisher + Extension.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 29.05.24.
//

import Foundation
import Combine

public extension Publisher {
    func ignoreNil<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        return self.compactMap { $0 }
    }

    func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
    
    func toNetworkErrorAnyPublisher() -> AnyPublisher<Output, NetworkError> {
        return self.mapError(NetworkError.init(error:))
            .eraseToAnyPublisher()
    }
    
    func handleOutput(_ block: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
        return handleEvents(receiveOutput: block)
    }
    
    func handleCompletion(_ block: @escaping (Subscribers.Completion<Failure>) -> Void) -> Publishers.HandleEvents<Self> {
        return handleEvents(receiveCompletion: block)
    }
}


public extension Publisher where Failure == NetworkError {
    func mapToVoid() -> AnyPublisher<Void, NetworkError> {
        return self.map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func toOptionalNever() -> AnyPublisher<Output?, Never> {
        return self.map { value -> Output? in
            return value
        }
        .catch { error -> AnyPublisher<Output?, Never> in
            return Just(nil).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
