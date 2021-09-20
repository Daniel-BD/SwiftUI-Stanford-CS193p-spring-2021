//
//  CardView.swift
//  Set Game
//
//  Created by Daniel Duvanå on 2021-09-07.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    let card: SetGameViewModel.Card
    let hint: HintState
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                let shape = RoundedRectangle(cornerRadius: scaleConstants(constant: DrawingConstants.cornerRadius))
                shape.strokeBorder(getBorderColor(card),
                    lineWidth: getSelected(card) ?
                        scaleConstants(constant: DrawingConstants.selectedLineWidth) :
                        scaleConstants(constant: DrawingConstants.lineWidth))
                    .foregroundColor(getBorderColor(card))
                HStack {
                    ForEach(0..<getNumber(card), id: \.self) {_ in
                        getShape(card)
                            .frame(width: (cardWidth / 3) * DrawingConstants.shapeScaleFactor,
                                   height: cardHeight * DrawingConstants.shapeScaleFactor)
                            .foregroundColor(getColor(card))
                    }
                }
            }
            
        }.padding(.all, scaleConstants(constant: DrawingConstants.cardPadding))
    }
    
    private func getShadedShape<CustomShape: Shape>(@ViewBuilder shape: @escaping () -> CustomShape) -> some View {
        ZStack{
            switch card.shadingType {
            case .variantA: shape()
            case .variantB: Stripes().stroke(lineWidth: scaleConstants(constant: DrawingConstants.stripeThickness)).clipShape(shape())
            case .variantC: EmptyView()
            }
            shape().stroke(lineWidth: scaleConstants(constant: DrawingConstants.lineWidth))
            
        }
    }
    
    private func getColor(_ card: SetGameViewModel.Card) -> Color {
        switch card.colorType {
        case .variantA: return .green
        case .variantB: return .pink
        case .variantC: return .purple
        }
    }
    
    private func getNumber(_ card: SetGameViewModel.Card) -> Int {
        switch card.numberOfShapes {
        case .variantA: return 1
        case .variantB: return 2
        case .variantC: return 3
        }
    }
    
    private func getShape(_ card: SetGameViewModel.Card) -> some View {
        Group {
            switch card.shapeType {
            case .variantA: getShadedShape(){ Squiggle() }
            case .variantB: getShadedShape(){ Diamond() }
            case .variantC: getShadedShape(){ Capsule() }
            }
        }.padding(.all, scaleConstants(constant: DrawingConstants.shapePadding))
    }
    
    private func getSelected(_ card: SetGameViewModel.Card) -> Bool {
        switch card.cardState {
        case .playing(selected: true): return true
        default: return false
        }
    }
    
    private func getBorderColor(_ card: SetGameViewModel.Card) -> Color {
        if !getSelected(card) {
            return colorScheme == .dark ? Color.white : Color.black
        } else if hint == .correct {
            return .green
        } else if hint == .wrong {
            return .red
        } else if hint == .hintMatching {
            return .orange
        } else {
            return .blue
        }
    }
    
    private func scaleConstants(constant: CGFloat) -> CGFloat {
        return constant * cardHeight / 100
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2.0
        static let shapeScaleFactor: CGFloat = 0.7
        static let selectedLineWidth = lineWidth * 2
        static let cardPadding: CGFloat = 3.0
        static let stripeThickness: CGFloat = 0.75
        static let shapePadding: CGFloat = 4.0
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let cards = [
            SetGameViewModel.Card(
                numberOfShapes: CardFeature.variantA,
                shapeType: CardFeature.variantA,
                shadingType: CardFeature.variantA,
                colorType: CardFeature.variantA,
                cardState: CardState.playing(selected: true),
                id: 0),
            SetGameViewModel.Card(
                numberOfShapes: CardFeature.variantB,
                shapeType: CardFeature.variantB,
                shadingType: CardFeature.variantB,
                colorType: CardFeature.variantB,
                cardState: CardState.playing(selected: false),
                id: 1),
            SetGameViewModel.Card(
                numberOfShapes: CardFeature.variantC,
                shapeType: CardFeature.variantC,
                shadingType: CardFeature.variantC,
                colorType: CardFeature.variantC,
                cardState: CardState.playing(selected: false),
                id: 2)
        ]
        
        
        VStack {
            AspectVGrid(items: cards, aspectRatio: 3/2) { card in
                GeometryReader { geometry in
                    CardView(card: card,
                             hint: HintState.neutral,
                             cardWidth: geometry.size.width,
                             cardHeight: geometry.size.height
                    )
                }
            }
            AspectVGrid(items: cards, aspectRatio: 3/2) { card in
                GeometryReader { geometry in
                    CardView(card: card,
                             hint: HintState.correct,
                             cardWidth: geometry.size.width,
                             cardHeight: geometry.size.height
                    )
                }
            }
            AspectVGrid(items: cards, aspectRatio: 3/2) { card in
                GeometryReader { geometry in
                    CardView(card: card,
                             hint: HintState.wrong,
                             cardWidth: geometry.size.width,
                             cardHeight: geometry.size.height
                    )
                }
            }
        }.preferredColorScheme(.dark)
        
        VStack {
            AspectVGrid(items: cards, aspectRatio: 3/2) { card in
                GeometryReader { geometry in
                    CardView(card: card,
                             hint: HintState.neutral,
                             cardWidth: geometry.size.width,
                             cardHeight: geometry.size.height
                    )
                }
            }
            AspectVGrid(items: cards, aspectRatio: 3/2) { card in
                GeometryReader { geometry in
                    CardView(card: card,
                             hint: HintState.correct,
                             cardWidth: geometry.size.width,
                             cardHeight: geometry.size.height
                    )
                }
            }
            AspectVGrid(items: cards, aspectRatio: 3/2) { card in
                GeometryReader { geometry in
                    CardView(card: card,
                             hint: HintState.wrong,
                             cardWidth: geometry.size.width,
                             cardHeight: geometry.size.height
                    )
                }
            }
        }
    }
}
