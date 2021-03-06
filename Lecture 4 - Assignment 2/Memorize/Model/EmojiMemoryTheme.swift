//
//  EmojiTheme.swift
//  Memorize
//
//  Created by Daniel DuvanΓ₯ on 2021-09-01.
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
                                ["πΆ","π―","π±","π­","π¦","π»","πΌ","π·","π¨","π΅","π¦", "π"],
                             gradientColors: ["green", "blue"]),
            
            EmojiMemoryTheme(name: "Faces", emojis:
                                ["π","π","π","π","π","π","π€","π€©","π€¬","π₯Ά","π€’","π€ ","π·","π€","π±","π","π₯΅","π€‘","π©","π₯³"],
                             numberOfPairsOfCards: .random, gradientColors: ["blue", "purple"]),
            
            EmojiMemoryTheme(name: "Vehicles", emojis:
                                ["π","π","π","π","π","π","π","π","π ","π","π","βοΈ","π³","π","π"],
                             numberOfPairsOfCards: .specific(numberOfPairs: 8), gradientColors: ["red", "pink"]),
            
            EmojiMemoryTheme(name: "Sports", emojis:
                                [ "β½οΈ","π","π","βΎοΈ","π","π","π₯","π","πΎ","π","ποΈββοΈ",
                                                       "ππ»","πββοΈ","π΄ββοΈ","πββοΈ"],
                             numberOfPairsOfCards: .random, gradientColors: ["yellow", "blue"]),
            
            EmojiMemoryTheme(name: "Halloween", emojis:
                                ["π»","π","π·","πΈ","π§"],
                             numberOfPairsOfCards: .specific(numberOfPairs: 200), gradientColors: ["orange", "red", "orange"]),
            
            EmojiMemoryTheme(name: "Flags", emojis:
                                ["πΈπ¬","π―π΅","π΄ββ οΈ","π³οΈβπ","π¬π§","πΉπΌ","πΊπΈ","π¦πΆ","π°π΅","π­π°","π²π¨","πΌπΈ"],
                             numberOfPairsOfCards: .random, gradientColors: ["purple", "green"])
        ]
}


