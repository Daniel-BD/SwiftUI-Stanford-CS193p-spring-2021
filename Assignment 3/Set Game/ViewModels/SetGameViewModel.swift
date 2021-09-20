//
//  SetGameView.swift
//  Set Game
//
//  Created by Daniel Duvanå on 2021-09-03.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGame.Card
    @Published private var model = SetGame()
    let playerTurnDuration: Double = 5.0
    
    // MARK: - Model access

    var cards: Array<Card> {
        model.deltCards
    }
    
    var hintState: HintState {
        model.hintState
    }
    
    var deckIsEmpty: Bool {
        model.deckIsEmpty
    }
    
    var playerScores: [Player: Int] {
        model.playerScores
    }
    
    var noMatchingSetLeft: Bool {
        false
        //model.noMatchingSetLeft
    }
    
    func getAnimationDuration(_ player: Player) -> Double {
        if isActivePlayer(player) {
            return playerTurnDuration
        } else {
            return 0
        }
    }
    
    func isActivePlayer(_ player: Player) -> Bool {
        return player == model.activePlayer
    }
    
    // MARK: - Intent(s)
    
    func select(_ card: Card) {
        model.select(card)
    }
    
    func dealMoreCards() {
        model.dealCards()
    }
    
    func newGame() {
        model.newGame()
    }
    
    func activatePlayer(_ player: Player) -> Bool {
        if (player != .none && model.activePlayer == .none) {
            model.activatePlayer(player)
            return true
        } else {
            return false
        }
    }
    
    func endCurrentPlayersTurn() {
        model.endCurrentPlayersTurn()
    }
    
    func hintAtMatchingCards() {
        model.showHintForMatchingSet()
    }
    
    func removeHintedCards() {
        guard model.hintState == .hintMatching else { return }
        model.removeHintedCards()
        
    }
}
