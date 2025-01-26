//
//  GameViewModel.swift
//  E-Card
//
//  Created by Lukas Zima on 25.01.2025.
//

import Foundation
import SwiftUI
@Observable
class GameViewModel {
    var cards: [Card]
    var tablecards: [Card] = .init()
    var screenSize: CGSize
    
    var isFocusedHand: Bool = false
    var draggedCard: Card?
    
    private var myCardsWidthBase: CGFloat {
        return screenSize.width / 8
    }
    var myCardsWidth: CGFloat {
        isFocusedHand ? myCardsWidthBase * 1.5 : myCardsWidthBase
    }
    var focusedHandOffset: CGSize {
        .init(width: 0, height: -1 * myCardsWidth)
    }
    var tableWidth: CGFloat {
        return screenSize.width * 0.8
    }
    var tableHeight: CGFloat {
        return screenSize.height * 0.4
    }
    private static let MAX_SPREAD_ANGLE: Double = 45
    private static let MAX_CARDS_AMOUNT: Double = 5
    private static var angleStepAmount: Double {
        GameViewModel.MAX_SPREAD_ANGLE / max(1, (GameViewModel.MAX_CARDS_AMOUNT - 1))
    }
    
    
    init(cards: [Card], screenSize: CGSize = .init(width: 393, height: 700)) {
        self.cards = cards
        self.screenSize = screenSize
    }
    /**
     Calculates the `Angle` by which a `Card` at `cardIndex` should be rotated in the Hand
     */
    func calculateAngle(cardIndex: Int) -> Angle {
        let cardCount = Double(cards.count)
        // Edge case check
        if (cardCount <= 1) {
            return Angle(degrees: 0)
        }
        // The leftmost Angle
        let startingAngle = -1.0 * GameViewModel.angleStepAmount * (cardCount - 1)
        // The angular spread in which all the Cards should fit
        let spread = -2.0 * startingAngle
        // By how much the Angle of the next Card should be incremented
        let spreadStep = spread / (cardCount - 1.0)
        
        return Angle(degrees: startingAngle + spreadStep * Double(cardIndex))
    }
    /**
     Calculates the `Offset` by which a `Card` at `cardIndex` should be offset in the Hand when unfocused
     */
    func calculateOffsetUnfocused(cardIndex: Int) -> CGSize {
        let cardCount = cards.count
        // Offset to counteract when we have an even amount of Cards
        let xEvenOffset = cardCount % 2 == 0 ? myCardsWidth / 2 : 0
        // The x coordinate of the leftmost Card
        let startingX = -1 * myCardsWidth * Double(cardCount / 2) + xEvenOffset
        // Introduce some scaling so the the Cards are closer together horizontally
        let xScaling = 0.7
        let xOffset = cardCount > 1 ? ((startingX + myCardsWidth * Double(cardIndex)) * xScaling) : 0
        
        // Introduce some scaling so the the Cards are closer together vertically
        var yScaling = 0.5
        let middleIndex = cardCount / 2
        var yOffset: CGFloat = 0
        // Start at both ends of the card spread and work our way inside
        for i in 0...middleIndex {
            // Check if we found our Card(cardIndex)
            if [i, (cardCount - 1) - i].contains(cardIndex) {
                break
            }
            // Increase the yOffset because the next (more inner) pair of Cards should be higher up
            yOffset += myCardsWidth * yScaling
            // Decrease the yScaling so that the next pair of Cards is closer vertically than the last
            yScaling *= 0.2
        }
        return .init(width: xOffset, height: -1 * yOffset)
    }
    
    func calculateOffsetFocused(cardIndex: Int) -> CGSize {
        let cardCount = cards.count
        // Offset to counteract when we have an even amount of Cards
        let xEvenOffset = cardCount % 2 == 0 ? myCardsWidth / 2 : 0
        // The x coordinate of the leftmost Card
        let startingX = -1 * myCardsWidth * Double(cardCount / 2) + xEvenOffset
        // Introduce some scaling so the the Cards have more spacing horizontally
        let xScaling = 1.05
        let xOffset = cardCount > 1 ? ((startingX + myCardsWidth * Double(cardIndex)) * xScaling) : 0
        
        // Introduce some scaling so the the Cards are more up vertically
        let yScaling = 1.2
        let yOffset = myCardsWidth * yScaling
        return .init(width: xOffset, height: -1 * yOffset)
    }
}
