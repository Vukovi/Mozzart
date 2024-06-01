//
//  KinoCell.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 29.05.24.
//

import SwiftUI
import Combine

struct KinoCell: View {
    
    @State var hasDivider: Bool = true
    
    @State var isLastCell: Bool = false
    
    @State var game: GameModel = GameModel(gameID: 1100, drawID: 123123123, drawTime: 1916926100000)
    
    @State private var timerSeconds: Int = 0
    
    var onCellPressed: ((PathObjects) -> Void)? = nil
    
    var onLastCellTimerEnded: (() -> Void)? = nil
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    if timerSeconds >= 0 {
                        cellTextView
                    }               
                }
                .background(.clear)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(game.isBetOpen ? .kinoWhite : .kinoGray)
            }
            .padding()
            .background(.clear)
            .asButton(game.isBetOpen ? .press : .tap) {
                if game.isBetOpen {
                    let pathObject: PathObjects = PathObjects.game(game)
                    onCellPressed?(pathObject)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                     .frame(height: 2)
                     .foregroundStyle(hasDivider ? .kinoWhite.opacity(0.7) : .clear)
                , alignment: .bottom
            )
            .padding(.horizontal, 20)
        }
        .background(.black.opacity(0.001))
        .onReceive(game.timer, perform: { _ in
            timerSeconds += 1
            if !game.isBetOpen {
                game.timer.upstream.connect().cancel()
                if isLastCell {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                        onLastCellTimerEnded?()
                    }
                }
            }
        })
    }
    
    private var cellTextView: some View {
        Group {
            let stopwatch = StopWatch(totalSeconds: game.drawTime / 1000)
            let drawHoursString: String = stopwatch.hours < 10 ? "0\(stopwatch.hours)" : "\(stopwatch.hours)"
            let drawMinutesString: String = stopwatch.minutes < 10 ? "0\(stopwatch.minutes)" : "\(stopwatch.minutes)"
            Text("\(drawHoursString) : \(drawMinutesString)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.black.opacity(0.001))
            
            let secondsString: String = game.stopwatch.seconds < 10 ? "0\(game.stopwatch.seconds)" : "\(game.stopwatch.seconds)"
            let minutesString: String = game.stopwatch.minutes < 10 ? "0\(game.stopwatch.minutes)" : "\(game.stopwatch.minutes)"
            let hoursString: String = game.stopwatch.hours > 0 ?
            game.stopwatch.hours < 10 ? "0\(game.stopwatch.hours) : " : "\(game.stopwatch.hours) : " : ""
            
            Group {
                if game.isBetOpen {
                    Text("\(hoursString)\(minutesString) : \(secondsString)")
                } else {
                    Text("00 : 00")
                }
                    
            }
            .foregroundStyle(game.timedifference <= 10 ? game.isBetOpen ? .kinoRed : .kinoGray : .kinoWhite)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(.black.opacity(0.001))
            
                
        }
    }
    
}

#Preview {
    KinoCell()
}
