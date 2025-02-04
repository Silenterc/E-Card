//
//  ContentView.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appCoordinator: AppCoordinator = AppCoordinator()
    var game: ECardGame = ECardGame()
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            appCoordinator.build(.menu(game: game))
                .navigationDestination(for: Screen.self) { screen in
                    appCoordinator.build(screen)
                }
                .sheet(item: $appCoordinator.sheet) { sheet in
                    appCoordinator.build(sheet)
                }
            
            //        GameView(viewModel: .init(game: ECardGame(), cards: Card.cardsPreview))
            //RulesView()
            //MenuView(game: ECardGame())
        }
        .environmentObject(appCoordinator)
    }
}

#Preview {
    ContentView()
}
