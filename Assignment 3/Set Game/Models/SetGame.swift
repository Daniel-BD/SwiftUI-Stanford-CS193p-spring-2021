//
//  SetGameView.swift
//  Set Game
//
//  Created by Daniel Duvanå on 2021-09-03.
//

import Foundation

struct SetGame {
    
    private var cards: Array<Card>
    private(set) var hintState: HintState = .neutral
    private(set) var playerScores: [Player: Int] = [.playerOne : 0, .playerTwo : 0, .playerThree : 0, .playerFour : 0]
    private(set) var activePlayer: Player = .none
    
    var deckIsEmpty: Bool {
        cards.filter { card in
            card.cardState == .inDeck
        }.count == 0
    }
    
    var deltCards: Array<Card> {
        cards.filter { card in
            if case .playing = card.cardState {
                return true
            } else {
                return false
            }
        }
    }
    
    var selectedCards: Array<Card> {
        cards.filter { card in
            card.cardState == .playing(selected: true)
        }
    }
    
    var noMatchingSetLeft: Bool {
        return findMatchingSets().count == 0
    }
    
    mutating func activatePlayer(_ player: Player) {
        //print("Running activatePlayer in Model: player: \(player)")
        activePlayer = player
        /// If we are hinting at a matching set, remove that set and deal new cards
        removeHintedCards()
        deselectAllCards()
    }
    
    mutating func select(_ card: Card) {
        //print("Running select in Model: active player: \(activePlayer)")
        /// It's not allowed to select cards when no player is active or when we are hinting at a matching set
        guard activePlayer != .none || hintState == .hintMatching else {
            return
        }
        
        if let selectedCardIndex = cards.firstIndex(where: {$0.id == card.id}),
           case .playing = cards[selectedCardIndex].cardState
        {
            if selectedCards.count == 3 {
                // Three cards have already been selected, this new selection should start a new process
                if isMatchingSet(selectedCards) {
                    /// Cards are a match, remove them and deal new cards
                    removeMatchingSet()
                    dealCards()
                }
                hintState = .neutral
                deselectAllCards()
                _ = selectOrDeselectCard(card)
            } else if selectedCards.count == 2 {
                // This selection completes a set of three (unless it's a deselection).
                // Evaluate if the set is matching or not.
                if selectOrDeselectCard(card) == true {
                    // Card was selected (not deselected), meaning we have 3 selected cards.
                    assert(selectedCards.count == 3, "There should be 3 selected cards")
                    scoreSelectedCards()
                    if isMatchingSet(selectedCards) {
                        // Cards match
                        hintState = .correct
                    } else {
                        // Cards don't match.
                        hintState = .wrong
                    }
                }
            } else if selectedCards.count <= 1 {
                // 0 or 1 card(s) have been selected, select or deselect this card
                _ = selectOrDeselectCard(card)
            }
        }
    }
    
    mutating func dealCards(_ n: Int = 3, forceDeal: Bool = true) {
        //print("Running dealCards(\(n)) in Model")
        for _ in 0..<n {
            if !forceDeal && deltCards.count >= 12 {
                return
            }
            if let cardIndex = cards.firstIndex(where: { $0.cardState == .inDeck }) {
                cards[cardIndex].cardState = .playing(selected: false)
            }
        }
    }
    
    mutating func newGame() {
        hintState = .neutral
        for index in 0..<cards.count {
            cards[index].cardState = .inDeck
        }
        playerScores = [.playerOne : 0, .playerTwo : 0, .playerThree : 0, .playerFour : 0]
        cards.shuffle()
        dealCards(12)
    }
    
    mutating func endCurrentPlayersTurn() {
        if (isMatchingSet(selectedCards)) {
            /// Cards are a match, remove them and deal new cards
            removeMatchingSet()
            dealCards(forceDeal: false)
        }
        hintState = .neutral
        deselectAllCards()
        activePlayer = .none
    }
    
    mutating func showHintForMatchingSet() {
        deselectAllCards()
        
        if let cardsToHint = findMatchingSets().randomElement() {
            /// There is at least one matching set
            for index in 0..<cards.count {
                if cardsToHint.contains(cards[index]) == true {
                    //print("Selecting card with index: \(index)")
                    cards[index].cardState = .playing(selected: true)
                }
            }
            
            hintState = .hintMatching
        }
    }
    
    mutating func removeHintedCards() {
        if (hintState == .hintMatching) {
            removeMatchingSet()
            deselectAllCards()
            hintState = .neutral
            dealCards(forceDeal: false)
        }
    }
    
    // MARK: - Private functions
    
    private func findMatchingSets() -> Set<Set<Card>> {
        var matchedSet: Set<Set<Card>> = []
        
        for card1 in deltCards {
            for card2 in deltCards {
                for card3 in deltCards {
                    /// Put the cards in a set to make sure we're comparing three different cards and not the same card two or three times
                    let cardSet: Set<Card> = [card1, card2, card3]
                    if cardSet.count == 3 {
                        if isMatchingSet([card1, card2, card3]) {
                            matchedSet.insert(cardSet)
                        }
                    }
                }
            }
        }
        
        return matchedSet
    }
    
    mutating private func deselectAllCards() {
        //print("Running deselectAllCards in Model")
        for index in 0..<cards.count {
            if cards[index].cardState == .playing(selected: true) {
                cards[index].cardState = .playing(selected: false)
            }
        }
    }
    
    // Returns true if selected, false if deselected. Returns nil if card is invalid.
    mutating private func selectOrDeselectCard(_ card: Card) -> Bool? {
        //print("Running selectOrDeselect in Model")
        if let cardIndex = cards.firstIndex(of: card) {
            switch cards[cardIndex].cardState {
            case .playing(selected: true):
                cards[cardIndex].cardState = .playing(selected: false)
                return false
            case .playing(selected: false):
                cards[cardIndex].cardState = .playing(selected: true)
                return true
            default:
                break
            }
        }
        
        return nil
    }
    
    mutating private func removeMatchingSet() {
        //print("running removeMatchingSet in Model");
        if isMatchingSet(selectedCards) {
            // Cards match
            for index in 0..<cards.count {
                if selectedCards.contains(cards[index]) {
                    cards[index].cardState = .matched
                }
            }
        }
    }
    
    private func isMatchingSet(_ cards: [Card]) -> Bool {
        //print("Running isMatchingSet in Model")
        guard cards.count == 3 else {
            return false
        }
        var numberOfShapes = Set<CardFeature>()
        var shapeType = Set<CardFeature>()
        var shadingType = Set<CardFeature>()
        var colorType = Set<CardFeature>()
        
        for card in cards {
            numberOfShapes.insert(card.numberOfShapes)
            shapeType.insert(card.shapeType)
            shadingType.insert(card.shadingType)
            colorType.insert(card.colorType)
        }
        
        var isMatchingSet = true
        
        for set in [numberOfShapes, shapeType, shadingType, colorType] {
            if !(set.count == 1 || set.count == 3) {
                isMatchingSet = false
            }
        }
        
        return isMatchingSet
    }
    
    mutating private func scoreSelectedCards() {
        guard selectedCards.count == 3 else { return }
        
        if isMatchingSet(selectedCards) {
            /// Give out points to active player
            playerScores[activePlayer]! += 1
        } else {
            /// If it's a mismatch, remove points from the active players score
            playerScores[activePlayer]! -= 1
        }
    }
    
    init() {
        cards = []
        var idIndex = 0
        for numberOfShapes in CardFeature.allCases {
            for shapeType in CardFeature.allCases {
                for shadingType in CardFeature.allCases {
                    for colorType in CardFeature.allCases {
                        cards.append(
                            Card(
                                numberOfShapes: numberOfShapes,
                                shapeType: shapeType,
                                shadingType: shadingType,
                                colorType: colorType,
                                id: idIndex
                            )
                        )
                        idIndex += 1
                    }
                }
            }
        }
        
        cards.shuffle()
        dealCards(12)
    }
    
    struct Card: Identifiable, Equatable, Hashable {
        let numberOfShapes: CardFeature
        let shapeType: CardFeature
        let shadingType: CardFeature
        let colorType: CardFeature
        var cardState: CardState = .inDeck
        let id: Int
    }
}

enum CardFeature: CaseIterable, Hashable {
    case variantA
    case variantB
    case variantC
}

enum CardState: Equatable, Hashable {
    case inDeck
    case playing(selected: Bool)
    case matched
}

enum HintState {
    case wrong
    case correct
    case neutral
    case hintMatching
}

enum Player {
    case none
    case playerOne
    case playerTwo
    case playerThree
    case playerFour
}
