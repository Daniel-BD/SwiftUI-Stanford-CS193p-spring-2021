//
//  PlayerButtonAndScoreView.swift
//  Set Game
//
//  Created by Daniel Duvanå on 2021-09-10.
//

import SwiftUI

struct PlayerButtonAndScoreView: View {
    @ObservedObject var game: SetGameViewModel
    let player: Player
    let geometry: GeometryProxy
    let requestToPlayCallback: (_: Player) -> Bool
    let endOfTurnCallback: () -> Void
    
    @State private var fillAmount: CGFloat = 0.0
    
    
    var body: some View {
        VStack(spacing: getPadding()) {
            Text("Score: \(game.playerScores[player]!)")
            Button (getButtonText()) {
                if (requestToPlayCallback(player)) {
                    withAnimation(.linear(duration: game.playerTurnDuration)){
                        fillAmount = 1.0
                    }
                }
            }
            .buttonStyle(PlayerButtonStyle(
                game: game,
                player: player,
                duration: game.getAnimationDuration(player),
                width: getButtonWidth(),
                fillAmount: fillAmount,
                padding: getPadding()
            )
            )
            .onAnimationCompleted(for: fillAmount) {
                fillAmount = 0.0
                endOfTurnCallback()
            }
        }
        .font(getFont())
        
    }
    
    private func getFont() -> Font {
        if (geometry.size.height > PlayerButtonAndScoreView.largeSizeHeightBreakPoint) {
            return getButtonWidth() > 200 ? .title : .title3
        } else {
            return .headline
        }
    }
    
    private func getPadding() -> CGFloat {
        if (geometry.size.height > PlayerButtonAndScoreView.largeSizeHeightBreakPoint) {
            return 16
        } else {
            return 8
        }
    }
    
    
    private func getButtonWidth() -> CGFloat {
        if (geometry.size.height > Self.largeSizeHeightBreakPoint) {
            return min(geometry.size.width * 0.4, 300)
        } else {
            return min(geometry.size.width * 0.3, 150)
        }
    }
    
    private func getButtonText() -> String {
        switch player {
        case .playerOne: return "Player 1"
        case .playerTwo: return "Player 2"
        case .playerThree: return "Player 3"
        case .playerFour: return "Player 4"
        default: return ""
        }
    }
    
    static let largeSizeHeightBreakPoint: CGFloat = 600
    
}

struct PlayerButtonStyle: ButtonStyle {
    @ObservedObject var game: SetGameViewModel
    let player: Player
    let duration: Double
    let width: CGFloat
    var fillAmount: CGFloat
    let padding: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Text("")
                .padding(padding)
                .frame(width: width * fillAmount)
                .background(getPlayerColor())
                .foregroundColor(.white)
                .frame(width: width, alignment: Alignment.leading)
                .cornerRadius(scaleConstants(DrawingConstants.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: scaleConstants(DrawingConstants.cornerRadius))
                        .stroke(getPlayerColor().opacity(3), lineWidth: scaleConstants(DrawingConstants.lineWidth) * 4)
                )
            
            configuration.label
        }
    }
    
    private func getPlayerColor() -> Color {
        switch player {
        case .playerOne: return .green.opacity(0.35)
        case .playerTwo: return .blue.opacity(0.35)
        case .playerThree: return .pink.opacity(0.35)
        case .playerFour: return.orange.opacity(0.35)
        default: return .black
        }
    }
    
    private func scaleConstants(_ constant: CGFloat) -> CGFloat {
        return constant * width / 300
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 40
        static let lineWidth: CGFloat = 1.0
    }
}

//  Code courtsey of Antoine Van Der Lee. Source:
//  https://www.avanderlee.com/swiftui/withanimation-completion-callback/
extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}
