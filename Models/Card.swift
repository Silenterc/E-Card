//
//  Card.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import Foundation
import CoreTransferable

/**
 All the possible Card types (including the back side of the card)
 */
enum CardType: String, CaseIterable, Codable {
    case Citizen = "Card-Citizen"
    case Emperor = "Card-Emperor"
    case Slave = "Card-Slave"
    case Back = "Card-Back"
}
/**
 Card used in the app
 */
struct Card: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let cardType: CardType
    static var cardsPreview: [Card] = [.init(cardType: .Citizen), .init(cardType: .Citizen),
                        .init(cardType: .Citizen), .init(cardType: .Citizen),
                        .init(cardType: .Slave)]
}
