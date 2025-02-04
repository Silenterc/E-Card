
import Foundation
import GameKit
import SwiftUI
/*
An extension for turn-based games that handles turn-based matchmaker view controller delegate callbacks.
*/
extension ECardGame: GKTurnBasedMatchmakerViewControllerDelegate {
    
    /// Dismisses the view controller when either player cancels matchmaking.
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true)
        
        // Remove the game view.
        resetGame()
    }
    
    /// Handles an error during the matchmaking process and dismisses the view controller.
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription).")
        viewController.dismiss(animated: true)
        
        // Remove the game view.
        resetGame()
    }
}

