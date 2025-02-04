//
//  AppCoordinator.swift
//  E-Card
//
//  Created by Lukas Zima on 04.02.2025.
//

import Foundation
import SwiftUI

class AppCoordinator: AppCoordinatorProtocol {
    
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Sheet?
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .menu(game: let game):
            MenuView(game: game)
        case .rules:
            RulesView()
        case .game(game: let game):
            GameView(viewModel: GameViewModel(game: game))
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .about:
            // TODO: ABOUT
            VStack {}
        }
    }
}
