//
//  KinoSegmentedControl.swift
//  Mozzart
//
//  Created by Vuk Knezevic on 29.05.24.
//

import SwiftUI

struct KinoSegmentElement: Identifiable {
    let id: String = UUID().uuidString
    let name: KinoName
    let image: String?
}

struct KinoSegmentsColors {
    let foreground: Color
    let background: Color
}

enum KinoName: String {
    case games = "Games"
    case drawing = "Drawing"
    case results = "Results"
}

struct KinoSegmentedControl: View {
    
    @State var options: [KinoSegmentElement] = [
        KinoSegmentElement.init(
            name: .games,
            image: "square.grid.2x2"
        ),
        KinoSegmentElement.init(
            name: .drawing,
            image: "play.circle"
        )
    ]
    
    @Binding var selection: KinoName
    
    var colors: KinoSegmentsColors = KinoSegmentsColors(
        foreground: .kinoYellow,
        background: .kinoWhite
    )
    
    @Namespace private var namespace
    
    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            ForEach(options, id: \.id) { option in
                HStack(alignment: .top, spacing: 0) {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        
                        if let image = option.image {
                            Image(systemName: image)
                        }
                        
                        Text(option.name.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        if selection == option.name {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(height: 1.5)
                                .matchedGeometryEffect(
                                    id: "selection",
                                    in: namespace
                                )
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(.top, 8)
                .background(.black.opacity(0.001))
                .foregroundStyle(selection == option.name ? colors.foreground : colors.background)
                .onTapGesture {
                    selection = option.name
                }
            }
        }
        .animation(.smooth, value: selection)
    }
}

fileprivate struct KinoSegmentedControlPreview: View {
    
    var options: [KinoSegmentElement] = [
        KinoSegmentElement.init(
            name: .games,
            image: "square.grid.2x2"
        ),
        KinoSegmentElement.init(
            name: .drawing,
            image: "play.circle"
        )
    ]
    @State var selection: KinoName = .games
    
    var colors: KinoSegmentsColors = KinoSegmentsColors(
        foreground: .kinoYellow,
        background: .kinoWhite
    )
    
    var body: some View {
        KinoSegmentedControl(
            options: options,
            selection: $selection,
            colors: colors
        )
    }
    
}

#Preview {
    KinoSegmentedControlPreview()
        .padding()
}
