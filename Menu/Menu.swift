//
//  Menu.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        VStack {
            title("E-Card")
            
            Spacer()
            
            menuOptions()
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.kaijiGradient())
    }
    
    func menuOptions() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                // TODO: Start Game
            } label: {
                menuText(text: "Start A Game", size: 32, symbol: "play")
            }
            Button {
                // TODO: Show Rules
            } label: {
                menuText(text: "Rules", size: 32, symbol: "book")
            }
            Button {
                // TODO: Show About
            } label: {
                menuText(text: "About", size: 32, symbol: "info.circle")
            }
        }
    }
    
    func menuText(text: String, size: CGFloat, symbol: String) -> some View {
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
    
    func title(_ text: String) -> some View {
        Text(text)
            .font(.saira(.regular, size: 80))
            .foregroundStyle(.white)
    }
}

#Preview {
    Menu()
}
