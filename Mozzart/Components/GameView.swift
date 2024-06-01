//
//  GameView.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 31.05.24.
//

import SwiftUI

struct GameView: View {
    
    @State var viewModel: ViewModel
        
    @State var game: GameModel =  GameModel(gameID: 1100, drawID: 123123123, drawTime: 1916926100000)
    
    var goBack: (() -> Void)? = nil
    
    var sendChosenGames: (([String : [Int : Int]]) -> Void)? = nil
    
    @State private var timerSeconds: Int = 0
    
    @State private var progressTimerSeconds: Int = 0
    
    @State var gameData: GameData = GameData.emptyElement()
    
    @State var choosenIndexes: [Int : Int] = [:]
    
    private let columns = Array(repeating: GridItem.init(.flexible(), spacing: 0, alignment: nil), count: 10)
    
    private let progressTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var progressStarted: Bool = false
        
    var body: some View {
        ZStack {
            Color.kinoDarkGray.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if timerSeconds >= 0 {
                    header
                }
                                
                if !gameData.games.isEmpty {
                    grid
                    
                    Text("games played:   \(choosenIndexes.count) : 15")
                        .font(.title)
                        .foregroundStyle(.kinoWhite)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.trailing)
                } else {
                    if progressStarted {
                        Text("No games to play at the moment.")
                            .font(.title)
                            .foregroundStyle(.kinoWhite)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ProgressView()
                            .tint(.kinoWhite)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchSingleGame("\(game.drawID)")
        }
        .onReceive(viewModel.$singleGame.dropFirst(), perform: { game in
            gameData = game
        })
        .onReceive(game.timer, perform: { _ in
            timerSeconds += 1
            if !game.isBetOpen {
                game.timer.upstream.connect().cancel()
                goBack?()
            }
        })
        .onReceive(progressTimer, perform: { _ in
            progressTimerSeconds += 1
            if !progressStarted && progressTimerSeconds > 10 {
                progressStarted = true
            }
        })
        .onDisappear {
            sendChosenGames?(["\(game.drawID)" : choosenIndexes])
        }
    }
    
    private var header: some View {
        let stopwatch = StopWatch(totalSeconds: game.drawTime / 1000)
        
        let drawHoursString: String = stopwatch.hours < 10 ? "0\(stopwatch.hours)" : "\(stopwatch.hours)"
        let drawMinutesString: String = stopwatch.minutes < 10 ? "0\(stopwatch.minutes)" : "\(stopwatch.minutes)"
        
        let secondsString: String = game.stopwatch.seconds < 10 ? "0\(game.stopwatch.seconds)" : "\(game.stopwatch.seconds)"
        let minutesString: String = game.stopwatch.minutes < 10 ? "0\(game.stopwatch.minutes)" : "\(game.stopwatch.minutes)"
        let hoursString: String = game.stopwatch.hours > 0 ?
        game.stopwatch.hours < 10 ? "0\(game.stopwatch.hours) : " : "\(game.stopwatch.hours) : " : ""
        
         
        return Text("Drawing time: \(drawHoursString):\(drawMinutesString) | Drawing ID: \(game.drawID) | Remaining time: \(hoursString)\(minutesString) : \(secondsString)")
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.kinoGray)
            .foregroundStyle(.kinoWhite)
            .font(.headline)
            .fontWeight(.semibold)
    }
    
    private var grid: some View {
        ZStack {
            
            Color.kinoDarkGray.ignoresSafeArea()
            
            let cellSize: CGFloat = (UIScreen.main.bounds.width - 20) / 10
            let gridHeight: CGFloat = (8 * cellSize)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                ForEach(1..<gameData.games.count + 1, id: \.self) { index in
                    
                    ZStack {
                        Circle()
                            .stroke(Color.red.opacity(choosenIndexes[index - 1] == nil ? 0 : gameData.games[index - 1].id == choosenIndexes[index - 1] ? 1 : 0), lineWidth: 3)
                            .frame(width: cellSize - 8, height: cellSize - 8)
                            .zIndex(999)
                        
                        Button("\(index)") {
                            if choosenIndexes[index - 1] != nil {
                                choosenIndexes.removeValue(forKey: index - 1)
                            } else {
                                guard choosenIndexes.count < 15 else { return }
                                choosenIndexes[index - 1] = gameData.games[index - 1].id
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.kinoDarkGray)
                        .padding(1)
                    }
                    .background(.kinoLightGray)
                    .frame(width: cellSize, height: cellSize)
                    
                }
            }
            .frame(height: gridHeight)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 10)
            
        }
        .ignoresSafeArea()
    }
    
}

#Preview {
    GameView(viewModel: ViewModel())
}
