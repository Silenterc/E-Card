//
//  GameView.swift
//  E-Card
//
//  Created by Lukas Zima on 25.01.2025.
//

import SwiftUI
import UniformTypeIdentifiers
struct GameView: View {
    @State var viewModel: GameViewModel
    var body: some View {
        ZStack {
                table()
            VStack() {
                Spacer()
                cardsHand()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("Table Background")
                .resizable()
                .ignoresSafeArea()
        }
        
    }
    
    @ViewBuilder
    func cardsHand() -> some View {
        ZStack {
            ForEach(Array(viewModel.cards.enumerated()), id: \.element) { index, card in
                CardView(card: card, width: viewModel.myCardsWidth)
                    .rotationEffect(viewModel.isFocusedHand ? .zero : viewModel.calculateAngle(cardIndex: index))
                    .offset(viewModel.isFocusedHand ? viewModel.calculateOffsetFocused(cardIndex: index) : viewModel.calculateOffsetUnfocused(cardIndex: index))
                    .onDrag {
                        viewModel.draggedCard = card
                        return NSItemProvider()
                    } preview: {
                        CardView(card: card, width: viewModel.myCardsWidth)
                    }

            }
        }
        .onTapGesture {
            withAnimation(.snappy) {
                viewModel.isFocusedHand.toggle()
            }
        }
    }
    
    func table() -> some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<11) {i in
                    Rectangle()
                        .foregroundStyle(Color.tableBrown)
                    Rectangle()
                        .foregroundStyle(Color.tableBrown)
                    if i != 10 {
                        Rectangle()
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(width: viewModel.tableWidth, height: viewModel.tableHeight)
            .clipShape(.rect(cornerRadius: 8))
            .onDrop(of: [UTType.card], delegate: CardDropDelegate())
        }
        
    }
}

#Preview {
    let num = 5
    var cards: [Card] = .init()
    for _ in 0..<num {
        cards.append(.init(cardType: .Citizen))
    }
    return GameView(viewModel: .init(cards: cards))
}
