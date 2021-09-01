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
    var color: String
    
    static var Themes: Array<EmojiMemoryTheme> =
        [
            EmojiMemoryTheme(name: "Animals", emojis: ["🐶","🐯","🐱","🐭","🦊","🐻","🐼","🐷","🐨","🐵","🦁", "🐔"], numberOfPairsOfCards: 4, color: "green"),
            EmojiMemoryTheme(name: "Faces", emojis: ["😃","😂","😍","🙃","😇","😎","🤓","🤩","🤬","🥶","🤢","🤠","😷","🤕","😱","😜","🥵","🤡","💩","🥳"], numberOfPairsOfCards: 6, color: "blue"),
            EmojiMemoryTheme(name: "Vehicles", emojis: ["🚕","🚌","🚓","🚑","🚒","🚜","🚚","🚛","🚠","🚋","🚄","✈️","🛳","🚁","🚂"], numberOfPairsOfCards: 8, color: "red"),
            EmojiMemoryTheme(name: "Sports", emojis: [ "⚽️","🏀","🏈","⚾️","🏓","🏏","🥊","🏉","🎾","🏒","🏌️‍♂️",
                                                       "🏇🏻","🏄‍♂️","🚴‍♀️","🏊‍♂️"], numberOfPairsOfCards: 10, color: "yellow"),
            EmojiMemoryTheme(name: "Halloween", emojis: ["👻","🎃","🕷","🕸","🧟"], numberOfPairsOfCards: 4, color: "orange"),
            EmojiMemoryTheme(name: "Flags", emojis: ["🇸🇬","🇯🇵","🏴‍☠️","🏳️‍🌈","🇬🇧","🇹🇼","🇺🇸","🇦🇶","🇰🇵","🇭🇰","🇲🇨","🇼🇸"], numberOfPairsOfCards: 8, color: "purple")
        ]
}


