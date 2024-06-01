//
//  ResultsView.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 01.06.24.
//

import SwiftUI

struct ResultsView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State var results: [ResultData] = []
    
    var body: some View {
        ZStack {
            
            if !results.isEmpty {
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(results) { resultData in
                            ResultsCell(resultData: resultData)
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
        
    }
    
    func makeGrid(items: [Int]) {
        
    }
    
}

#Preview {
    ResultsView()
}
