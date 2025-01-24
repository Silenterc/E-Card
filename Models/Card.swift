//
//  Card.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import Foundation
import CoreTransferable

enum CardType: String, Codable {
    case Citizen = "Card-Citizen"
    case Emperor = "Card-Emperor"
    case Slave = "Card-Slave"
    case Back = "Card-Back"
}
struct Card: Identifiable, Codable {
    var id: UUID = UUID()
    let cardType: CardType
}
