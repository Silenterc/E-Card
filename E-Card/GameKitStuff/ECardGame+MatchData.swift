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
    var cards: [Card] = []
    var playedCard: Card? = nil
    var isEmperorSide: Bool
}

// Codable game data for sending to players.
struct GameData: Codable {
    var group: Int
    var round: Int
    var cards: [String: [Card]]
    var table: [String: Card?]
    var emperorSide: String
}

struct GameState {
    var group: Int
    var round: Int
    var emperorSide: Participant?
    var slaveSide: Participant?
    
    init(group: Int = 1, round: Int = 1, emperorSide: Participant? = nil, slaveSide: Participant? = nil) {
        self.group = group
        self.round = round
        self.emperorSide = emperorSide
        self.slaveSide = slaveSide
    }
    
    mutating func updateFromData(matchData: GameData) {
        group = matchData.group
        round = matchData.round
        guard var emperor = emperorSide, var slave = slaveSide else {
            return
        }
        // If the sides swapped, we swap
        if matchData.emperorSide != emperor.player.displayName {
            swap(&emperor, &slave)
        }
    }
}

extension ECardGame {
    
    // MARK: Codable Game Data
    
    /// Creates a data representation of the game count and items for each player.
    ///
    /// - Returns: A representation of game data that contains only the game scores.
    func encodeGameData() -> Data? {
        // Create a dictionary of cards for each player.
        var cards = [String: [Card]]()
        var table = [String: Card?]()
        // Add the local player's card.
        if let localPlayerName = localParticipant?.player.displayName {
            cards[localPlayerName] = localParticipant?.cards
            table[localPlayerName] = localParticipant?.playedCard
        }
        
        // Add the opponent's card.
        if let opponentPlayerName = opponent?.player.displayName {
            cards[opponentPlayerName] = opponent?.cards
            table[opponentPlayerName] = opponent?.playedCard
        }
        
        let gameData = GameData(group: gameState!.group, round: gameState!.round, cards: cards, table: table, emperorSide: gameState!.emperorSide?.player.displayName ?? "")
        return encode(gameData: gameData)
    }
    
    /// Creates a data representation from the game data for sending to other players.
    ///
    /// - Returns: A representation of the game data.
    func encode(gameData: GameData) -> Data? {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        do {
            let data = try encoder.encode(gameData)
            return data
        } catch {
            print("Error: \(error.localizedDescription).")
            return nil
        }
    }
    
    /// Decodes a data representation of game data and updates the scores.
    ///
    /// - Parameter matchData: A data representation of the game data.
    func decodeGameData(matchData: Data) {
        let gameData = try? PropertyListDecoder().decode(GameData.self, from: matchData)
        guard let gameData = gameData else { return }
        // Update the game state
        gameState?.updateFromData(matchData: gameData)
        
        // Set the local player's items and last played Card.
        if let localPlayerName = localParticipant?.player.displayName {
            if let cards = gameData.cards[localPlayerName] {
                localParticipant?.cards = cards
            }
            if let card = gameData.table[localPlayerName] {
                localParticipant?.playedCard = card
            }
        }

        // Set the opponent's items and last played Card.
        if let opponentPlayerName = opponent?.player.displayName {
            if let cards = gameData.cards[opponentPlayerName] {
                opponent?.cards = cards
            }
            if let card = gameData.table[opponentPlayerName] {
                opponent?.playedCard = card
            }
        }
    }
}
