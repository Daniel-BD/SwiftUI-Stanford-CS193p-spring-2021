//
//  SetGameView.swift
//  Set Game
//
//  Created by Daniel Duvanå on 2021-09-03.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    ForEach([Player.playerThree, Player.playerFour], id: \.self) { player in
                        PlayerButtonAndScoreView(
                            game: game,
                            player: player,
                            geometry: geometry,
                            requestToPlayCallback: { game.activatePlayer($0) },
                            endOfTurnCallback: { game.endCurrentPlayersTurn() }
                        )
                        if player != .playerFour {
                            Spacer()
                        }
                    }
                }
                .padding([.bottom, .horizontal])
                .padding(.top, 2)
                .rotationEffect(.degrees(180))
                
                AspectVGrid(items: game.cards, aspectRatio: 3/2) { card in
                    GeometryReader { geometry in
                        CardView(card: card,
                                 hint: game.hintState,
                                 cardWidth: geometry.size.width,
                                 cardHeight: geometry.size.height
                        )
                        .onTapGesture {
                            game.select(card)
                        }
                    }
                }
                .border(game.noMatchingSetLeft ? Color.red : Color.clear)
                .padding(.all)
                if geometry.size.height > Self.largeSizeHeightBreakPoint {
                    GameButtonsView(game: game)
                }
                
                HStack {
                    ForEach([Player.playerOne, Player.playerTwo], id: \.self) { player in
                        PlayerButtonAndScoreView(
                            game: game,
                            player: player,
                            geometry: geometry,
                            requestToPlayCallback: { game.activatePlayer($0) },
                            endOfTurnCallback: { game.endCurrentPlayersTurn() }
                        )
                        if player == .playerOne {
                            Spacer()
                        }
                        if (player == .playerOne &&
                            geometry.size.height < Self.largeSizeHeightBreakPoint )
                        {
                            GameButtonsView(game: game)
                        }
                        if player == .playerOne {
                            Spacer()
                        }
                    }
                }
                .padding([.bottom, .horizontal])
                .padding(.top, 2)
            }
        }
    }
    
    static let largeSizeHeightBreakPoint: CGFloat = 600
}

struct SetGameView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let game = SetGameViewModel()
        
        SetGameView(game: game)
            .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
        
        SetGameView(game: game)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
        
//        SetGameView(game: game)
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
//
//        SetGameView(game: game)
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
        
        //SetGameView(game: game).preferredColorScheme(.dark)
    }
}


struct GameButtonsView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        HStack() {
            Button ("New Game") { game.newGame() }
            Spacer()
            if game.hintState != .hintMatching {
                Button (game.noMatchingSetLeft ? "No matching cards" : "Hint") { game.hintAtMatchingCards() }
                    .disabled(game.noMatchingSetLeft)
                    .font(game.noMatchingSetLeft ? .caption2 : .body)
            }
            if game.hintState == .hintMatching {
                Button ("Remove Hint") { game.removeHintedCards() }
            }
            Spacer()
            Button ("Deal 3 Cards") { game.dealMoreCards() }
                .disabled(game.deckIsEmpty)
        }
        .padding(.all)
    }
}
