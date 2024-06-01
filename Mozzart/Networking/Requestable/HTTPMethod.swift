//
//  HTTPMethod.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
