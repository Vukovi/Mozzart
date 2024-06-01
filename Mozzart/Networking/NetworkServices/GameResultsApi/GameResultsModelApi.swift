//
//  GameResultsModelApi.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

public enum GameResultsModelApi {
    public struct Request: Encodable {
        let fromDate: String
        let toDate: String
        
        public init(fromDate: Date, toDate: Date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.fromDate = dateFormatter.string(from: fromDate)
            self.toDate = dateFormatter.string(from: toDate)
        }
    }
    
    typealias Response = GameResultsModel
    
}
