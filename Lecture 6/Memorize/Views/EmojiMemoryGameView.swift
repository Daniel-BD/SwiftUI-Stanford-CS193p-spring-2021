//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-08-31.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text(game.themeName)
                .fontWeight(.bold)
                .font(.title)
            Text("Score: \(game.score)")
                .fontWeight(.regular)
                .font(.title2)
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    CardView(card: card, gradient: game.gradientColor)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                        }
            }
            .padding(.all)
            Button ("New Game") { game.newGame() }
        }
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    let gradient: Gradient
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: 110 - 90))
                        .padding(5).opacity(0.5).foregroundColor(.red)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        
//        EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.dark)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
