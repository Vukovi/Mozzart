//
//  PathObjects.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 31.05.24.
//

import Foundation

enum PathObjects: Hashable {

    case game(GameModel)
    
    var title: String {
        switch self {
        case .game(let gameModel):
            let stopwatch = StopWatch(totalSeconds: gameModel.drawTime / 1000)
            
            let drawHoursString: String = stopwatch.hours < 10 ? "0\(stopwatch.hours)" : "\(stopwatch.hours)"
            let drawMinutesString: String = stopwatch.minutes < 10 ? "0\(stopwatch.minutes)" : "\(stopwatch.minutes)"
            
            let secondsString: String = gameModel.stopwatch.seconds < 10 ? "0\(gameModel.stopwatch.seconds)" : "\(gameModel.stopwatch.seconds)"
            let minutesString: String = gameModel.stopwatch.minutes < 10 ? "0\(gameModel.stopwatch.minutes)" : "\(gameModel.stopwatch.minutes)"
            let hoursString: String = gameModel.stopwatch.hours > 0 ?
            gameModel.stopwatch.hours < 10 ? "0\(gameModel.stopwatch.hours) : " : "\(gameModel.stopwatch.hours) : " : ""
            
            
            return "Drawing time: \(drawHoursString):\(drawMinutesString) | Drawing ID: \(gameModel.drawID) | Remaining time: \(hoursString)\(minutesString) : \(secondsString)"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(UUID().hashValue)
        hasher.combine(title)
    }
    
    static func == (lhs: PathObjects, rhs: PathObjects) -> Bool {
        return lhs.title == rhs.title
    }
}
