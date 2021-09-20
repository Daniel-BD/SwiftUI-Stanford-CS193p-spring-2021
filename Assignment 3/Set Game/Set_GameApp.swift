//
//  Set_GameApp.swift
//  Set Game
//
//  Created by Daniel Duvanå on 2021-09-03.
//

import SwiftUI

@main
struct Set_GameApp: App {
    private let game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
