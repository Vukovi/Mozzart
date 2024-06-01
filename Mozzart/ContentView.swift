//
//  ContentView.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 28.05.24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State var selection: KinoName = .games
    
    @State private var games: [GameModel] = []
    
    @State var results: [ResultData] = []
    
    @State private var paths: [PathObjects] = []
    
    @State var choosenBetGames: [String: [Int : Int]] = [:]
            
    let transition: AnyTransition = .asymmetric(
        insertion: .push(from: .leading),
        removal: .push(from: .trailing)
    )
        
    var body: some View {
        NavigationStack(path: $paths) {
            ZStack {
                Color.kinoDarkGray.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    segmentedControl
                    
                    screens
                }
            }
            .environmentObject(viewModel)
            .navigationTitle("Greek Game")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathObjects.self) { value in
                switch value {
                case .game(let gameModel):
                    GameView(viewModel: viewModel, game: gameModel, goBack: {
                        paths.removeLast()
                    }, sendChosenGames: { chosenGames in
                        guard let key = chosenGames.keys.first else { return }
                        choosenBetGames[key] = chosenGames[key]
                    }, choosenIndexes: choosenBetGames["\(gameModel.drawID)"] != nil ? choosenBetGames["\(gameModel.drawID)"]! : [:])
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.fetchGames()
            }
            .onReceive(viewModel.$games.dropFirst(), perform: { games in
                self.games = games
            })
            .onReceive(viewModel.$gameResults.dropFirst(), perform: { results in
                self.results = results
            })
            .onReceive(viewModel.$error.dropFirst(), perform: { error in
                print(error)
            })
        }
    }
    
    private var segmentedControl: some View {
        KinoSegmentedControl(
            options: [
                KinoSegmentElement.init(
                    name: .games,
                    image: "square.grid.2x2"
                ),
                KinoSegmentElement.init(
                    name: .drawing,
                    image: "play.circle"
                ),
                KinoSegmentElement.init(
                    name: .results,
                    image: "r.circle"
                )
            ],
            selection: $selection,
            colors: KinoSegmentsColors(
                foreground: .kinoYellow,
                background: .kinoLightGray
            )
        )
        .padding(.bottom, 5)
        .background(Color.kinoBlue)
    }
    
    private var screens: some View {
        ZStack {
            switch selection {
            case .games: kinoGamesView.transition(transition)
            case .drawing: drawingView.transition(transition)
            case .results: resultsView.transition(transition)
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var drawingView: some View {
        if let url = URL(string: EnvironmentConfiguration.Environment.results.host) {
            LoadingWebView(url: url)
                .transition(transition)
        } else {
            EmptyView()
                .transition(transition)
        }
    }
    
    private var kinoGamesView: some View {
        KinoGamesView(games: $games) { pathObject in
            paths.append(pathObject)
        }
    }
    
    private var resultsView: some View {
        ResultsView(results: results)
    }
}

#Preview {
    ContentView()
}
