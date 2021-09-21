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
    
    mutating func shuffle() {
        cards.shuffle()
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
        var hasAlreadyBeenSeen = false
        let content: CardContent
        let id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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
