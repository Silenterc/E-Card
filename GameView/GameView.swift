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
            HStack {
                Spacer()
                sideBar()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("Wooden Light")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        
    }
    
    func cardsHand() -> some View {
        ZStack {
            ForEach(Array(viewModel.cards.enumerated()), id: \.element) { index, card in
                CardView(card: card, width: viewModel.myCardsWidth)
                    .rotationEffect(viewModel.isFocusedHand ? .zero : viewModel.calculateAngle(cardIndex: index))
                    .offset(viewModel.isFocusedHand ? viewModel.calculateOffsetFocused(cardIndex: index) : viewModel.calculateOffsetUnfocused(cardIndex: index))
                    .shadow(color: viewModel.isFocusedHand ? .black : .clear, radius: 4, x: 12, y: 16)
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
            .clipShape(.rect(cornerRadii: .init(topLeading: 90, bottomLeading: 90, bottomTrailing: 90, topTrailing: 90)))
            .shadow(color: .black, radius: 24, x: 20, y: 30)
            .onDrop(of: [UTType.card], delegate: CardDropDelegate())
        }
        
    }
    
    func sideBar() -> some View {
        return ZStack() {
            Rectangle()
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadii: .init(topLeading: 60, bottomLeading: 60, bottomTrailing: 0, topTrailing: 0)))
                .opacity(viewModel.isExpandedSidebar ? 0.8 : 0.4)
                .overlay {
                    HStack {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black)
                            .font(.title)
                            .rotationEffect(viewModel.isExpandedSidebar ? .degrees(0) : .degrees(180))
                            .animation(.easeInOut(duration: 0.2), value: viewModel.isExpandedSidebar)
                        
                        if viewModel.isExpandedSidebar {
                            VStack(alignment: .leading) {
                                Text("Rounds: 0")
                                Text("Games:")
                                Spacer()
                            }
                            .transition(
                                .scale(scale: 0.1)
                                .combined(with: .move(edge: .trailing))
                            )
                            Spacer()
                        }
                    }
                    .padding(.leading, viewModel.isExpandedSidebar ? 8 : 0)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.isExpandedSidebar.toggle()
                    }
                }
        }
        .frame(width: viewModel.sidebarWidth, height: viewModel.sidebarHeight)
        
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
