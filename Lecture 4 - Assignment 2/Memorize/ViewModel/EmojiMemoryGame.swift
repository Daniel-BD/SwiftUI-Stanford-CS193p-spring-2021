//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-08-31.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static private func createMemoryGame(numberOfPairs: Int, emojis: [String]) -> MemoryGame<String> {
        let numberOfPairs = min(emojis.count, numberOfPairs)
        let emojis = emojis.shuffled()
        
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String>
    private var theme: EmojiMemoryTheme
    private(set) var color: Color
    
    init() {
        let startTheme = EmojiMemoryTheme.Themes.randomElement()!
        theme = startTheme
        color = Self.translateStringToColor(colorName: startTheme.color)
        model = Self.createMemoryGame(numberOfPairs: startTheme.numberOfPairsOfCards, emojis: startTheme.emojis)
    }
    
    static private func translateStringToColor(colorName: String) -> Color {
        switch colorName {
        case "blue":
            return .blue
        case "green":
            return .green
        case "red":
            return .red
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "purple":
            return .purple
        default:
            return .blue
        }
    }
    
    // MARK: Model access
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var themeName: String {
        return theme.name
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {

        model.choose(card)
    }
    
    func newGame() {
        let oldTheme = theme
        
        while oldTheme.name == theme.name {
            theme = EmojiMemoryTheme.Themes.randomElement()!
        }
        
        color = Self.translateStringToColor(colorName: theme.color)
        model = Self.createMemoryGame(numberOfPairs: theme.numberOfPairsOfCards, emojis: theme.emojis)
    }
}
