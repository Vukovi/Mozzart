//
//  ViewModel.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 29.05.24.
//

import Foundation
import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    
    @Published var games: [GameModel] = []
    @Published var singleGame: GameData = GameData.emptyElement()
    @Published var gameResults: [ResultData] = []
    @Published var error: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var gamesService: GamesServiceProtocol
    private var singleGameService: SingleGameServiceProtocol
    private var gameResultsService: GamesResultsServiceProtocol
    
    private var gameElements: Games = []
    
    init() {
        let networkConfiguration = NetworkConfiguration.init()
        let network = NetworkService.init(
            session: URLSession.shared,
            networkConfiguration: networkConfiguration
        )
        gamesService = GamesService.init(networkService: network)
        singleGameService = SingleGameService(networkService: network)
        gameResultsService = GamesResultsService(networkService: network)
    }
    
    func fetchGames() {
        gamesService.fetchGames(.init())
            .receive(on: DispatchQueue.main)
            .handleCompletion({ [weak self] completion in
                switch completion {
                case .finished:
                    self?.fetchResults()
                case .failure(_): break
                }
            })
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure( let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] games in
                self?.gameElements = games
                self?.games = games
                    .map { GameModel(gameID: $0.gameID, drawID: $0.drawID, drawTime: $0.drawTime) }
                    .sorted { $0.drawTime < $1.drawTime }
            }
            .store(in: &cancellables)
    }
    
    func fetchSingleGame(_ id: String) {
        singleGameService.fetchSingleGame(.init(drawId: id))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure( let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] game in
                guard let prizes = game.prizeCategories else {
                    self?.singleGame = GameData.emptyElement()
                    return
                }
    
                self?.singleGame = GameData(id: "\(game.drawID)", games: Array(prizes.prefix(80)))
            }
            .store(in: &cancellables)
    }
    
    func fetchResults() {
        gameResultsService.fetchGameResults(.init(fromDate: Date(), toDate: Date()))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure( let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] gameResults in
                guard let content = gameResults.content else {
                    self?.gameResults = []
                    return
                }

                let allWins = content.filter { $0.winningNumbers != nil }
                self?.gameResults = allWins.map {
                    ResultData(id: $0.drawID, drawTime: $0.drawTime, results: $0.winningNumbers!)
                }
            }
            .store(in: &cancellables)
    }

}
