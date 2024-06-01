//
//  EnvironmentConfiguration.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

public protocol EnvironmentProtocol {
    var host: String { get }
}

public enum EnvironmentConfiguration {
    public enum Environment: String {
        case kino
        case results
    }
}

extension EnvironmentConfiguration.Environment: EnvironmentProtocol {
    
    public var host: String {
        switch self {
        case .kino:
            return "https://api.opap.gr/draws/v3.0/1100"
        case .results:
            return "https://www.mozzartbet.com/sr/lotto-animation/26#/"
        }
    }
}
