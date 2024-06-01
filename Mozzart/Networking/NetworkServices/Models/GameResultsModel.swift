//
//  GameResultsModel.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

// MARK: - GameResultsModel
struct GameResultsModel: Codable {
    let content: [Content]?
    let totalPages, totalElements: Int?
    let last: Bool?
    let numberOfElements: Int?
    let first: Bool?
    let sort: [Sort]?
    let size, number: Int?
}

extension GameResultsModel {
    static func emptyElement() -> GameResultsModel {
        GameResultsModel(
            content: nil,
            totalPages: nil,
            totalElements: nil,
            last: nil,
            numberOfElements: nil,
            first: nil,
            sort: nil,
            size: nil,
            number: nil
        )
    }
}

// MARK: - Content
struct Content: Codable {
    let gameID, drawID, drawTime: Int
    let status: Status?
    let drawBreak, visualDraw: Int?
    let pricePoints: PricePoints?
    let winningNumbers: WinningNumbers?
    let prizeCategories: [PrizeCategory]?
    let wagerStatistics: WagerStatistics?

    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case drawID = "drawId"
        case drawTime, status, drawBreak, visualDraw, pricePoints, winningNumbers, prizeCategories, wagerStatistics
    }
}

// MARK: - Sort
struct Sort: Codable {
    let direction, property: String?
    let ignoreCase: Bool?
    let nullHandling: String?
    let descending, ascending: Bool?
}
