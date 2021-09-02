//
//  MemoryGame.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-08-31.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var score: Int = 0
    
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    private var timeOfLastTouch: Date?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard, let timeOfLastTouch = timeOfLastTouch {
                // Second card (of two) tapped - determine if cards match or mismatch and score points
                let secondsBetweenTouches = abs(timeOfLastTouch.timeIntervalSinceNow.rounded())
                let cardsToScoreIndices = [chosenIndex, potentialMatchIndex]
                
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    // Sucessfull match
                    cardsToScoreIndices.forEach { cards[$0].isMatched = true }
                    score += max(10 - Int(secondsBetweenTouches), 1) * 2
                } else {
                    // Mismatch
                    cardsToScoreIndices.forEach {
                        score -= cards[$0].hasAlreadyBeenSeen ? min(max(Int(secondsBetweenTouches) * 3, 2), 10) : 0
                        cards[$0].hasAlreadyBeenSeen = true
                    }
                }
                self.timeOfLastTouch = nil
                cards[chosenIndex].isFaceUp = true
            } else {
                // First card (of two) tapped
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                timeOfLastTouch = Date.init()
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var hasAlreadyBeenSeen = false
        let content: CardContent
        let id: Int
    }
}

extension Array {
    /// If there's exactly one element in the array, oneAndOnly returns that element, otherwise returns nil.
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        }
        else {
            return nil
        }
    }
}
