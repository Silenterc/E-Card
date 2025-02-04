//
//  ContentView.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
//        GameView(viewModel: .init(game: ECardGame(), cards: Card.cardsPreview))
        //RulesView()
        MenuView(game: ECardGame())
    }
}

#Preview {
    ContentView()
}
