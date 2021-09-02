//
//  EmojiTheme.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-09-01.
//

import Foundation

struct EmojiMemoryTheme {
    var name: String
    var emojis: [String]
    var numberOfPairsOfCards: Int
    var gradientColors: [String]
    
    enum numberOfPairs {
        case all
        case random
        case specific(numberOfPairs: Int)
    }
    
    
    init(name: String, emojis: [String], numberOfPairsOfCards: numberOfPairs = .all, gradientColors: [String]) {
        self.name = name
        self.emojis = emojis
        self.gradientColors = gradientColors
        switch numberOfPairsOfCards {
        case .all:
            self.numberOfPairsOfCards = emojis.count - 1
        case .random:
            self.numberOfPairsOfCards = Int.random(in: 2..<emojis.count)
        case .specific(let pairs):
            self.numberOfPairsOfCards = max(min(emojis.count, pairs), 2)
        }
        
    }
    
    static var Themes: Array<EmojiMemoryTheme> =
        [
            EmojiMemoryTheme(name: "Animals", emojis:
                                ["🐶","🐯","🐱","🐭","🦊","🐻","🐼","🐷","🐨","🐵","🦁", "🐔"],
                             gradientColors: ["green", "blue"]),
            
            EmojiMemoryTheme(name: "Faces", emojis:
                                ["😃","😂","😍","🙃","😇","😎","🤓","🤩","🤬","🥶","🤢","🤠","😷","🤕","😱","😜","🥵","🤡","💩","🥳"],
                             numberOfPairsOfCards: .random, gradientColors: ["blue", "purple"]),
            
            EmojiMemoryTheme(name: "Vehicles", emojis:
                                ["🚕","🚌","🚓","🚑","🚒","🚜","🚚","🚛","🚠","🚋","🚄","✈️","🛳","🚁","🚂"],
                             numberOfPairsOfCards: .specific(numberOfPairs: 8), gradientColors: ["red", "pink"]),
            
            EmojiMemoryTheme(name: "Sports", emojis:
                                [ "⚽️","🏀","🏈","⚾️","🏓","🏏","🥊","🏉","🎾","🏒","🏌️‍♂️",
                                                       "🏇🏻","🏄‍♂️","🚴‍♀️","🏊‍♂️"],
                             numberOfPairsOfCards: .random, gradientColors: ["yellow", "blue"]),
            
            EmojiMemoryTheme(name: "Halloween", emojis:
                                ["👻","🎃","🕷","🕸","🧟"],
                             numberOfPairsOfCards: .specific(numberOfPairs: 200), gradientColors: ["orange", "red", "orange"]),
            
            EmojiMemoryTheme(name: "Flags", emojis:
                                ["🇸🇬","🇯🇵","🏴‍☠️","🏳️‍🌈","🇬🇧","🇹🇼","🇺🇸","🇦🇶","🇰🇵","🇭🇰","🇲🇨","🇼🇸"],
                             numberOfPairsOfCards: .random, gradientColors: ["purple", "green"])
        ]
}


