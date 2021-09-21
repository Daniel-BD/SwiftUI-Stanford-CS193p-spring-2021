//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-08-31.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    static private func createMemoryGame(numberOfPairs: Int, emojis: [String]) -> MemoryGame<String> {
        let numberOfPairs = min(emojis.count, numberOfPairs)
        let emojis = emojis.shuffled()
        
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String>
    private var theme: EmojiMemoryTheme
    private(set) var gradientColor: Gradient
    
    init() {
        let startTheme = EmojiMemoryTheme.Themes.randomElement()!
        theme = startTheme
        gradientColor = Self.translateStringArrayToGradient(colors: startTheme.gradientColors)
        model = Self.createMemoryGame(numberOfPairs: startTheme.numberOfPairsOfCards, emojis: startTheme.emojis)
    }
    
    static private func translateStringArrayToGradient(colors: [String]) -> Gradient {
        var gradientColors = [Color]()
        
        for color in colors {
            switch color {
            case "blue":
                gradientColors.append(.blue)
            case "green":
                gradientColors.append(.green)
            case "red":
                gradientColors.append(.red)
            case "yellow":
                gradientColors.append(.yellow)
            case "orange":
                gradientColors.append(.orange)
            case "purple":
                gradientColors.append(.purple)
            default:
                gradientColors.append(.blue)
            }
        }
        
        return Gradient(colors: gradientColors)
    }
    
    // MARK: - Model access
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var themeName: String {
        return theme.name
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {

        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        let oldTheme = theme
        
        while oldTheme.name == theme.name {
            theme = EmojiMemoryTheme.Themes.randomElement()!
        }
        
        gradientColor = Self.translateStringArrayToGradient(colors: theme.gradientColors)
        model = Self.createMemoryGame(numberOfPairs: theme.numberOfPairsOfCards, emojis: theme.emojis)
    }
}
