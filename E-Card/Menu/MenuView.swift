//
//  Menu.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import SwiftUI
/**
 The central Menu View
 */
struct MenuView: View {
    @State var game: ECardGame
    @EnvironmentObject var appCoordinator: AppCoordinator
    var body: some View {
        VStack {
            title("E-Card")
            
            Spacer()
            
            menuOptions()
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 32)
        .background(LinearGradient.kaijiGradient())
        .onAppear {
            if !game.matchAvailable {
                game.authenticatePlayer()
            }
        }
    }
    
    
    func menuOptions() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                game.startMatch()
            } label: {
                MenuText(text: "Start A Game", size: 32, symbol: "play")
            }
            .disabled(!game.matchAvailable)
            Button {
                appCoordinator.push(.rules)
            } label: {
                MenuText(text: "Rules", size: 32, symbol: "book")
            }
            Button {
                // TODO: Show About
            } label: {
                MenuText(text: "About", size: 32, symbol: "info.circle")
            }
        }
    }
    func title(_ text: String) -> some View {
        Text(text)
            .font(.saira(.regular, size: 80))
            .foregroundStyle(.white)
    }
}

struct MenuText : View {
    var text: String
    var size: CGFloat
    var symbol: String
    
    var body : some View {
        HStack {
            Image(systemName: symbol)
                .bold()
                .font(.system(size: size * 4 / 5))
                .foregroundStyle(.white.opacity(0.8))
            Text(text)
                .font(.saira(.regular, size: size))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    MenuView(game: .init(appCoordinator: AppCoordinator()))
}
