//
//  SingleGameModelApi.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

public enum SingleGameModelApi {
    public struct Request: Encodable {
        let drawId: String
        
        public init(drawId: String) {
            self.drawId = drawId
        }
    }
    
    typealias Response = GameElement
    
}
