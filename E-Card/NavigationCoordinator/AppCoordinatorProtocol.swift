//
//  AppCoordinatorProtocol.swift
//  E-Card
//
//  Created by Lukas Zima on 04.02.2025.
//

import Foundation
import SwiftUI
/**
 Enum for the screens in my app
 */
enum Screen: Identifiable, Hashable {
    case menu(game: ECardGame)
    case rules
    case game(game: ECardGame)
    
    var id: Self { return self }
}

/**
 Enum for the sheets in my app
 */
enum Sheet: Identifiable, Hashable {
    case about
    
    var id: Self { return self }
}
/**
 Protocol for the Coordinator navigation pattern
 */
protocol AppCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    
    func push(_ screen: Screen)
    func presentSheet(_ sheet: Sheet)
    func pop()
    func popToRoot()
    func dismissSheet()
}
