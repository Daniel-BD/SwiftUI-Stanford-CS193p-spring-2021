//
//  CardShapes.swift
//  Set Game
//
//  Created by Daniel Duvanå on 2021-09-07.
//

import SwiftUI

struct Stripes: Shape {
    let numberOfStripes = 20
    
    func path(in rect: CGRect) -> Path {
        let stripeSpace = rect.size.height / CGFloat(numberOfStripes)
        
        var p = Path()
        for i in 0..<numberOfStripes {
            p.move(to: CGPoint(x: rect.minX, y: rect.minY + (stripeSpace * CGFloat(i))))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + (stripeSpace * CGFloat(i))))
        }
        
        return p
    }
}

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

/// Squiqqle shape created by Sean Tai.
/// https://github.com/xtai/CS193p-SetGame/blob/dd0d11349a00c03c33c809f7c79308852a2d1ff4/SetGame/SetGameView/CardView/Squiggle.swift

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: getCGPoint(x: 0.70, y: 0.00, rect: rect))
        p.addCurve(to: getCGPoint(x: 0.05, y: 0.25, rect: rect), control1: getCGPoint(x: 0.50, y: 0.00, rect: rect), control2: getCGPoint(x: 0.05, y: 0.05, rect: rect))
        p.addCurve(to: getCGPoint(x: 0.25, y: 0.65, rect: rect), control1: getCGPoint(x: 0.05, y: 0.45, rect: rect), control2: getCGPoint(x: 0.25, y: 0.50, rect: rect))
        p.addCurve(to: getCGPoint(x: 0.00, y: 0.90, rect: rect), control1: getCGPoint(x: 0.25, y: 0.80, rect: rect), control2: getCGPoint(x: 0.00, y: 0.80, rect: rect))
        p.addCurve(to: getCGPoint(x: 0.30, y: 1.00, rect: rect), control1: getCGPoint(x: 0.00, y: 0.95, rect: rect), control2: getCGPoint(x: 0.10, y: 1.00, rect: rect))
        p.addCurve(to: getCGPoint(x: 0.95, y: 0.75, rect: rect), control1: getCGPoint(x: 0.50, y: 1.00, rect: rect), control2: getCGPoint(x: 0.95, y: 0.95, rect: rect))
        p.addCurve(to: getCGPoint(x: 0.75, y: 0.35, rect: rect), control1: getCGPoint(x: 0.95, y: 0.55, rect: rect), control2: getCGPoint(x: 0.75, y: 0.50, rect: rect))
        p.addCurve(to: getCGPoint(x: 1.00, y: 0.10, rect: rect), control1: getCGPoint(x: 0.75, y: 0.20, rect: rect), control2: getCGPoint(x: 1.00, y: 0.20, rect: rect))
        p.addCurve(to: getCGPoint(x: 0.70, y: 0.00, rect: rect), control1: getCGPoint(x: 1.00, y: 0.05, rect: rect), control2: getCGPoint(x: 0.90, y: 0.00, rect: rect))
        p.closeSubpath()
        return p
    }
    
    private func getCGPoint(x: Double, y: Double, rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.origin.x + (CGFloat(x) * rect.size.width), y: rect.origin.y + (CGFloat(y) * rect.size.height))
    }
}
