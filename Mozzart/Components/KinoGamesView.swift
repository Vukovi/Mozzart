//
//  KinoGamesView.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 30.05.24.
//

import SwiftUI

struct KinoGamesView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var games: [GameModel]
    
    private func onCellPressed(_ pathObject: PathObjects) {
        onCellPressed?(pathObject)
    }
    
    var onCellPressed: ((PathObjects) -> Void)? = nil
    
    @State var choosenIndexes: [Int: Int] = [:]
    
    private func allTimersEnded() {
        games.removeAll()
        viewModel.fetchGames()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            header
            
            if !games.isEmpty {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        let gamesArray = Array(games.enumerated())
                        ForEach(gamesArray, id:\.offset) { (rowIndex, gameModel) in
                            KinoCell(
                                hasDivider: rowIndex < gamesArray.count - 1,
                                isLastCell: rowIndex == gamesArray.count - 1,
                                game: gameModel,
                                onCellPressed: onCellPressed,
                                onLastCellTimerEnded: allTimersEnded
                            )
                        }
                    }
                }
                .scrollIndicators(.hidden)
            } else {
                ProgressView()
                    .tint(.kinoWhite)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(.kinoDarkGray)
        .onReceive(viewModel.$games.dropFirst(), perform: { games in
            self.games = games
        })
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🇬🇷  Greek Game".uppercased())
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            RoundedRectangle(cornerRadius: 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 2)
                .foregroundStyle(.kinoBlue)
                .padding(.trailing, 15)
            
            HStack {
                Text("Drawing time:")
                Spacer()
                Text("Until bet is off:")
                    .padding(.trailing, 15)
            }
            .padding(.bottom, 15)
            .font(.title3)
            .fontWeight(.medium)
        }
        .padding(.leading)
        .padding(.top, 15)
        .foregroundStyle(.kinoWhite)
        .background(.kinoGray)
    }
    
}

#Preview {
    KinoGamesView(games: .constant([]))
        .environmentObject(ViewModel())
}
