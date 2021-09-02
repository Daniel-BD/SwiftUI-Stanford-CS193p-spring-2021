//
//  ContentView.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-08-31.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text(viewModel.themeName)
                .fontWeight(.bold)
                .font(.title)
            Text("Score: \(viewModel.score)")
                .fontWeight(.regular)
                .font(.title2)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, gradientColor: viewModel.gradientColor)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .padding(.all)
            Button ("New Game") { viewModel.newGame() }
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let gradientColor: Gradient
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill(LinearGradient(gradient: gradientColor, startPoint: .top, endPoint: .bottom))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
