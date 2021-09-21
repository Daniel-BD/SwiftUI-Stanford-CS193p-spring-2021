//
//  Cardify.swift
//  Memorize
//
//  Created by Daniel Duvanå on 2021-09-20.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool, gradient: Gradient) {
        rotation = isFaceUp ? 0 : 180
        self.gradient = gradient
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var gradient: Gradient
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }
             else {
                shape.fill(LinearGradient(gradient: gradient, startPoint: .topTrailing, endPoint: .bottomLeading))
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool, gradient: Gradient) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp, gradient: gradient))
    }
}
