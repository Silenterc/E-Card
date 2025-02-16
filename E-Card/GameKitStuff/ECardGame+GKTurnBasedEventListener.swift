//
//  ECardGame+GKTurnBasedEventListener.swift
//  E-Card
//
//  Created by Lukas Zima on 05.02.2025.
//

import Foundation
@preconcurrency import GameKit
import SwiftUI

extension ECardGame: GKTurnBasedEventListener {
    
    /// Creates a match and presents a matchmaker view controller.
    func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
        startMatch(playersToInvite.first)
    }
    
    /// Handles multiple turn-based events during a match.
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        // Handles these turn-based events when:
        // 1. The local player accepts an invitation from another participant.
        // 2. GameKit passes the turn to the local player.
        // 3. The local player opens an existing or completed match.
        // 4. Another player forfeits the match.
        
        if (TBViewController != nil) {
            TBViewController?.dismiss(animated: true)
            TBViewController = nil
        }
        switch match.status {
        case .open:
            do {
                // If the match is open, first check whether game play should continue.
                
                // Remove participants who quit or otherwise aren't in the match.
                let nextParticipants = match.participants.filter {
                    $0.status != .done
                }
                
                // End the match if active participants drop below the minimum.
                if nextParticipants.count < minPlayers {
                    // Set the match outcomes for the active participants.
                    for participant in nextParticipants {
                        participant.matchOutcome = .won
                    }
                    Task {
                        // End the match in turn.
                        try await match.endMatchInTurn(withMatch: match.matchData!)
                    }
                    
                    // Notify the local player when the match ends.
                    youWon = true
                }
                else if (currentMatchID == nil) || (currentMatchID == match.matchID) {
                    // If the local player isn't playing another match or is playing this match,
                    // display and update the game view.
                    
                    // Remove the local player from the participants to find the opponent.
                    let participants = match.participants.filter {
                        self.localParticipant?.player.displayName != $0.player?.displayName
                    }
                    
                    // If the player starts the match, the opponent hasn't accepted the invitation and has no player object.
                    let participant = participants.first
                    if (participant != nil) && (participant?.status != .matching) && (participant?.player != nil) {
                        if opponent == nil {
                            Task {
                                // Load the opponent's avatar and create the opponent object.
                                let image = try await participant?.player?.loadPhoto(for: GKPlayer.PhotoSize.small)
                                opponent = Participant(player: (participant?.player)!,
                                                       avatar: Image(uiImage: image!), isEmperorSide: false)
                            }
                        }
                    }
                    // Restore the current game data from the match object.
                    if let matchData = match.matchData, gameState != nil  {
                        // TODO: ADD ONGOING GAME LOGIC
                        decodeGameData(matchData: matchData)
                        
                    } else {
                        // The game is brand new and this is our first turn, we need to initialize the state
                        initGameState()
                    }
                    
                    // Update the interface depending on whether it's the local player's turn.
                    myTurn = GKLocalPlayer.local == match.currentParticipant?.player ? true : false
                    
                    // Present the Game in case we opened it for the first time
                    if !playingGame {
                        appCoordinator.push(.game(game: self))
                    }
                    // Retain the match ID so action methods can load the current match object later.
                    currentMatchID = match.matchID
                }
                
            }
            
            
        case .ended:
            print("Match ended.")
            
        case .matching:
            // TODO: LET A PLAYER SEE A MATCHING MATCH
            print("Still finding players.")
            
        default:
            print("Status unknown.")
        }
    }
    
    /// Handles when a player forfeits a match when it's their turn using the view controller interface.
    func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
        // Remove the current participant. If the count drops below the minimum, the next participant ends the match.
        let nextParticipants = match.participants.filter {
            $0 != match.currentParticipant
        }
        
        // Quit while it's the local player's turn.
        match.participantQuitInTurn(with: GKTurnBasedMatch.Outcome.quit, nextParticipants: nextParticipants,
                                    turnTimeout: GKTurnTimeoutDefault, match: match.matchData!)
    }
    
    
    
    
    
}


