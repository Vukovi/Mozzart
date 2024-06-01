//
//  URLSessionWebSocketTask + Extension.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

typealias WebSocketStream = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>

extension URLSessionWebSocketTask {
    var stream: WebSocketStream {
        return WebSocketStream { continuation in
            Task {
                var isAlive = true

                while isAlive && closeCode == .invalid {
                    do {
                        let value = try await receive()
                        continuation.yield(value)
                    } catch {
                        continuation.finish(throwing: error)
                        isAlive = false
                    }
                }
            }
        }
    }
}
