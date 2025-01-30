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
    case Emperor = "Emperor"
    case Slave = "Slave"
    case Citizen = "Citizen"
    case Back = "Back"
    
    var description: String {
        switch self {
        case .Emperor: "Represents ultimate power and wealth."
        case .Slave: "Represents those with nothing to lose and no desire for wealth."
        case .Citizen: "Represents the common people who are subservient to the Emperor."
        default: "Card Back"
        }
    }
    
    var defeatMechanics: String {
        switch self {
        case .Emperor: "The Emperor card defeats Citizen cards."
        case .Slave: "The Slave card defeats the Emperor but loses to Citizen cards."
        case .Citizen: "Citizen cards lose to the Emperor but defeat the Slave."
        default: "Card Back"
        }
    }
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
    static var slaveSide: [Card] = [.init(cardType: .Slave), .init(cardType: .Citizen),
                                   .init(cardType: .Citizen), .init(cardType: .Citizen),
                                   .init(cardType: .Citizen)]
    static var emperorSide: [Card] = [.init(cardType: .Emperor), .init(cardType: .Citizen),
                                   .init(cardType: .Citizen), .init(cardType: .Citizen),
                                   .init(cardType: .Citizen)]
}
