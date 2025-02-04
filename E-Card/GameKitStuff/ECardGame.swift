//
//  ECardGame.swift
//  E-Card
//
//  Created by Lukas Zima on 04.02.2025.
//

import Foundation
@preconcurrency import GameKit
import SwiftUI

/*
The main class that implements the logic for the ECard turn-based game.
*/
@Observable
class ECardGame: NSObject, GKMatchDelegate, GKLocalPlayerListener {
    // The game interface state.
    var matchAvailable = false
    var playingGame = false
    var myTurn = false
    
    
    // The persistent game data.
    var localParticipant: Participant? = nil
    var opponent: Participant? = nil
    
    
    /// The root view controller of the window.
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    /// Resets the game interface to the content view.
    func resetGame() {
        // Reset the game data.
        playingGame = false
        myTurn = false
//        currentMatchID = nil
//        localParticipant?.items = 50
//        opponent = nil
//        count = 0
//        youWon = false
//        youLost = false
    }
    
    /// Authenticates the local player and registers for turn-based events.
    func authenticatePlayer() {
        // Set the authentication handler that GameKit invokes.
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // If the view controller is non-nil, present it to the player so they can
                // perform some necessary action to complete authentication.
                self.rootViewController?.present(viewController, animated: true) { }
                return
            }
            if let error {
                // If you can’t authenticate the player, disable Game Center features in your game.
                print("Error: \(error.localizedDescription).")
                return
            }
            
            // A value of nil for viewController indicates successful authentication, and you can access
            // local player properties.
            
            // Load the local player's avatar.
            GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
                if let image {
                    // Create a Participant object to store the local player data.
                    self.localParticipant = Participant(player: GKLocalPlayer.local,
                                                   avatar: Image(uiImage: image))
                }
                if let error {
                    // Handle an error if it occurs.
                    print("Error: \(error.localizedDescription).")
                }
            }
            
            // Register for turn-based invitations and other events.
            GKLocalPlayer.local.register(self)
            
            // Enable the Start Game button.
            self.matchAvailable = true
        }
    }
    
    
}
