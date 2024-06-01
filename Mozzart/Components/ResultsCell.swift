//
//  ResultsCell.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 01.06.24.
//

import SwiftUI

struct ResultsCell: View {
    
    @State var resultData: ResultData = ResultData.emptyElement()
    
    private let columns = Array(repeating: GridItem.init(.flexible(), spacing: 0, alignment: nil), count: 7)
    
    private let cellSize: CGFloat = (UIScreen.main.bounds.width - 20) / 7
    
    private let colors: [Color] = [.red, .purple, .pink, .cyan, .indigo, .green, .orange]
    
    var body: some View {
        VStack {
            Text(resultData.title)
                .foregroundStyle(.white)
                .font(.caption)
                .foregroundStyle(.kinoWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(.kinoGray)
                .padding(.horizontal)
                .padding(.vertical)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 0, pinnedViews: [.sectionHeaders], content: {
                ForEach(resultData.results.list, id: \.self) { resultData in
                    ZStack {
                        Circle()
                            .stroke(colors.randomElement() ?? .red)
                            .frame(width: cellSize - 8, height: cellSize - 8)
                            .zIndex(999)
                        
                        Text("\(resultData)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.kinoDarkGray)
                            .foregroundStyle(.kinoLightGray)
                            .padding(1)
                    }
                    .frame(width: cellSize, height: cellSize)
                }
            })
            .padding(.bottom)
        }
    }
}

#Preview {
    ResultsCell()
}
