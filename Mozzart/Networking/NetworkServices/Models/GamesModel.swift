//
//  Games.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import Foundation

// MARK: - GameElement
struct GameElement: Codable {
    let gameID, drawID, drawTime: Int
    let status: Status?
    let drawBreak, visualDraw: Int?
    let pricePoints: PricePoints?
    let prizeCategories: [PrizeCategory]?
    let wagerStatistics: WagerStatistics?
    let winningNumbers: WinningNumbers?

    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case drawID = "drawId"
        case drawTime, status, drawBreak, visualDraw, pricePoints, winningNumbers, prizeCategories, wagerStatistics
    }
}

extension GameElement {
    static func emptyElement() -> GameElement {
        GameElement(
            gameID: 99999,
            drawID: 9999999,
            drawTime: 999999999,
            status: nil,
            drawBreak: nil,
            visualDraw: nil,
            pricePoints: nil,
            prizeCategories: nil,
            wagerStatistics: nil,
            winningNumbers: nil
        )
    }
}

// MARK: - PricePoints
struct PricePoints: Codable {
    let addOn: [AddOn]
    let amount: Double
}

// MARK: - WinningNumbers
struct WinningNumbers: Codable {
    let list, bonus: [Int]
    let sidebets: Sidebets
}

// MARK: - Sidebets
struct Sidebets: Codable {
    let evenNumbersCount, oddNumbersCount, winningColumn: Int
    let winningParity: WinningParity
    let oddNumbers, evenNumbers: [Int]
    let columnNumbers: [String: [Int]]
}

enum WinningParity: String, Codable {
    case draw
    case even
    case odd
}

// MARK: - AddOn
struct AddOn: Codable {
    let amount: Double
    let gameType: AddOnGameType
}

enum AddOnGameType: String, Codable {
    case kinoBonus = "KinoBonus"
    case sideBets = "SideBets"
}

// MARK: - PrizeCategory
struct PrizeCategory: Codable {
    let id: Int
    let divident: Double
    let winners: Int
    let distributed: Double
    let jackpot: Int
    let fixed: Double
    let categoryType: Int
    let gameType: PrizeCategoryGameType
}

enum PrizeCategoryGameType: String, Codable {
    case column = "Column"
    case draw = "Draw"
    case kino = "Kino"
    case kinoBonus = "KinoBonus"
    case oddEven = "OddEven"
}

enum Status: String, Codable {
    case active
    case future
    case results
}

// MARK: - WagerStatistics
struct WagerStatistics: Codable {
    let columns, wagers: Int
    let addOn: [JSONAny]
}

typealias Games = [GameElement]

struct GameModel: Identifiable, Hashable {
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(gameID)
        hasher.combine(id)
    }
    
    let id: String = UUID().uuidString
    let gameID, drawID, drawTime: Int
    
    var timedifference: Int {
        drawTime / 1000 - Int(Date().timeIntervalSince1970)
    }
    
    var stopwatch: StopWatch {
        StopWatch(totalSeconds: timedifference)
    }
    
    var isBetOpen: Bool {
        timedifference > 0
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

struct GameData: Identifiable {
    let id: String
    let games: [PrizeCategory]
    
    static func emptyElement() -> GameData {
        GameData(id: UUID().uuidString, games: [])
    }
}

struct ResultData: Identifiable {
    let id, drawTime: Int
    let results: WinningNumbers
    
    var timedifference: Int {
        drawTime / 1000 - Int(Date().timeIntervalSince1970)
    }
    
    var title: String {
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(timedifference))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        let dateString: String = dateFormatter.string(from: dateVar)
        return "Drawing time: \(dateString) | GameID: \(id)"
    }
    
    static func emptyElement() -> ResultData {
        ResultData(
            id: UUID().hashValue,
            drawTime: UUID().hashValue,
            results: WinningNumbers(
                list: [],
                bonus: [],
                sidebets: Sidebets(
                    evenNumbersCount: 0,
                    oddNumbersCount: 0,
                    winningColumn: 0,
                    winningParity: .draw,
                    oddNumbers: [],
                    evenNumbers: [],
                    columnNumbers: [:]
                )
            )
        )
    }
    
}
