//
//  WebSocketManager.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import UIKit



final class WebSocketManager {
    
    static let shared: WebSocketManager = WebSocketManager()
    
    private init() {
        guard let _ = WebSocketManager.stream else {
            fatalError("Error - you must call setup before accessing WebSocketManager.shared")
        }
    }
    
    class func setup(_ urlString: String) {
        if self.stream == nil {
            guard let url = URL(string: urlString) else { return }
            let socketConnection = URLSession.shared.webSocketTask(with: url)
            self.stream = SocketStream(task: socketConnection)
        }
    }
    
    class func update(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        Task {
            try await stream?.cancel()
        }
        let socketConnection = URLSession.shared.webSocketTask(with: url)
        self.stream = SocketStream(task: socketConnection)
    }
    
    static private(set) var stream: SocketStream?
    
    
    
    func start() {
        guard let socketStream = WebSocketManager.stream else { return }
        
        Task {
            do {
                for try await message in socketStream {
                    print("vukknezvuk message: ", message)
                }
            } catch {
                print("vukknezvuk error: ", error.localizedDescription)
            }

            print("this will be printed once the stream ends")
        }
    }
    
}
