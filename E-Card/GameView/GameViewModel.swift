//
//  GameViewModel.swift
//  E-Card
//
//  Created by Lukas Zima on 25.01.2025.
//
import Foundation
import SwiftUI
/**
 A ViewModel for the Game View
 */
@Observable
class GameViewModel {
    // The Game object
    var game: ECardGame
    // Cards in Hand
    var cards: [Card] {
        get {
            game.localParticipant?.cards ?? []
        }
        set(newCards) {
            game.localParticipant?.cards = newCards
        }
    }
    // My Card on the Table
    var tableCardMine: Card? {
        get {
            game.localParticipant?.playedCard
        }
        set(newCard) {
            game.localParticipant?.playedCard = newCard
        }
    }
    // Enemy Players Card on the Table
    var tableCardEnemy: Card? {
        get {
            game.opponent?.playedCard
        }
        set(newCard) {
            game.opponent?.playedCard = newCard
        }
    }
    // Size of the screen (for UI calculations)
    var screenSize: CGSize

    var isFocusedHand: Bool = false
    var isExpandedSidebar: Bool = false
    var draggedCard: Card?
    
    // The base width a Card should have
    private var myCardsWidthBase: CGFloat {
        screenSize.width / 7
    }
    // The width a Card should have when enlarged (in an expanded hand or on the table)
    var myCardsWidthExpanded: CGFloat {
        myCardsWidthBase * 1.3
    }
    // Calculates the width the Cards should have
    var myCardsWidth: CGFloat {
        isFocusedHand ? myCardsWidthExpanded : myCardsWidthBase
    }
    // By how much to vertically lift up the Cards Hand when tapped on
    var focusedHandOffset: CGSize {
        .init(width: 0, height: -1 * myCardsWidth)
    }
    var tableWidth: CGFloat {
        screenSize.width * 0.7
    }
    var tableHeight: CGFloat {
        screenSize.height * 0.4
    }
    var sidebarWidth: CGFloat {
        isExpandedSidebar ? screenSize.width * 0.4 : screenSize.width * 0.1
    }
    var sidebarHeight: CGFloat {
        isExpandedSidebar ? screenSize.height * 0.4 : screenSize.height * 0.2
    }
    // The maximum angle under which a Card can be spread in an unfocused Hand
    private static let MAX_SPREAD_ANGLE: Double = 45
    // The maximum amount of Cards in a Hand
    private static let MAX_CARDS_AMOUNT: Double = 5
    // By how much to change the angle of the Card spread for each Card
    private static var angleStepAmount: Double {
        GameViewModel.MAX_SPREAD_ANGLE / max(1, (GameViewModel.MAX_CARDS_AMOUNT - 1))
    }
    
    
    init(game: ECardGame, screenSize: CGSize = .init(width: 393, height: 700)) {
        self.game = game
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
    /**
     Calculates the `Offset` by which a `Card` at `cardIndex` should be offset in the Hand when focused
     */
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
