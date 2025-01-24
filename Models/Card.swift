//
//  Card.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import Foundation
import CoreTransferable

enum CardType: Codable {
    case Citizen
    case Emperor
    case Slave
}
struct Card: Identifiable, Codable {
    var id: UUID = UUID()
    let cardType: CardType
}
