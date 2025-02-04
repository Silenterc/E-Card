//
//  CardDropDelegate.swift
//  E-Card
//
//  Created by Lukas Zima on 26.01.2025.
//

import Foundation
import SwiftUI
/**
 A Delegate for handling the Drag & Drop operation of a Card onto a Table
 */
struct CardDropDelegate: DropDelegate {
    // The currently dragged Card
    @Binding var draggedCard: Card?
    // The Card? currently on the table
    @Binding var tableCard: Card?
    // The Cards in the players hand
    @Binding var cards: [Card]
    /**
     Performs the Card drop onto the Table, if it is valid
     */
    func performDrop(info: DropInfo) -> Bool {
        // There cannot be a Card already on the table
        if tableCard != nil {
            draggedCard = nil
            return false
        }
        guard let card = draggedCard else {
            return false
        }
        // Perform the actual drop
        tableCard = card
        if let index = cards.firstIndex(of: card) {
            cards.remove(at: index)
        }
        draggedCard = nil
        return true
    }
    /**
     Specifies that this is a move operation and therefore does not show the green +.
     */
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    /**
     Invalidates the drop if there is a card on the Table already.
     */
    func validateDrop(info: DropInfo) -> Bool {
        return tableCard == nil
    }
    
}
