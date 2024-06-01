//
//  Requestable.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

public protocol Requestable {
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var pathAddOns: [String]? { get }
    var path: String? { get }
    var body: Encodable? { get }
    var queryItems: [URLQueryItem]? { get }
    var environment: EnvironmentConfiguration.Environment { get }
}

extension Requestable {
    
    public var headers: HTTPHeaders? {
        nil
    }
    
    public func createURLRequest(with configuration: NetworkConfigurationProtocol) -> URLRequest? {
        guard var url = URL(string: environment.host) else {
            return nil
        }
        
        if let path = path {
            url.appendPathComponent(path)
        }
        
        if let pathAddOns = pathAddOns {
            for pathAddOn in pathAddOns {
                url.appendPathComponent(pathAddOn)
            }
        }

        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            return nil
        }

        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body?.encode()
        urlRequest.allHTTPHeaderFields = configuration.headers
        headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
    
}

// MARK: - Encodable

private extension Encodable {
    
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
