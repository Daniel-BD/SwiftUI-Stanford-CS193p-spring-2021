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
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    // Sucessfull match
                    
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    // Mismatch
                    if cards[chosenIndex].hasAlreadyBeenSeen {
                        score -= 1
                    } else {
                        cards[chosenIndex].hasAlreadyBeenSeen = true
                    }
                    
                    if cards[potentialMatchIndex].hasAlreadyBeenSeen {
                        score -= 1
                    } else {
                        cards[potentialMatchIndex].hasAlreadyBeenSeen = true
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
        
        //print("\(cards)")
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var hasAlreadyBeenSeen = false
        var content: CardContent
        var id: Int
    }
}
