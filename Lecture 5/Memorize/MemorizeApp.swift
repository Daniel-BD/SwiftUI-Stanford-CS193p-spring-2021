//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-08-31.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
