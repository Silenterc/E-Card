//
//  ECardGame+MatchData.swift
//  E-Card
//
//  Created by Lukas Zima on 04.02.2025.
//

import Foundation
import GameKit
import SwiftUI
// A message that one player sends to another.
struct Message: Identifiable {
    var id = UUID()
    var content: String
    var playerName: String
    var isLocalPlayer: Bool = false
}

// A participant object with their items.
struct Participant: Identifiable {
    var id = UUID()
    var player: GKPlayer
    var avatar = Image(systemName: "person")
    var items = 50
}

// Codable game data for sending to players.
struct GameData: Codable {
    var playedCard: Card?
    var cards: [Card]
}
