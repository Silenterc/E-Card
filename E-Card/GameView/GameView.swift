//
//  GameView.swift
//  E-Card
//
//  Created by Lukas Zima on 25.01.2025.
//

import SwiftUI
import UniformTypeIdentifiers
import GameKit
/**
 The UI for the E-Card Game
 */
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
                SideBar(isExpanded: $viewModel.isExpandedSidebar, width: viewModel.sidebarWidth, height: viewModel.sidebarHeight) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Group: \(viewModel.gameState?.group ?? 0)")
                            .foregroundStyle(.black)
                        StepIndicator(steps: 4, currentStep: viewModel.gameState?.group ?? 0, spacing: viewModel.sidebarWidth * 0.08)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Round: \(viewModel.gameState?.round ?? 0)")
                            .foregroundStyle(.black)
                        StepIndicator(steps: 3, currentStep: viewModel.gameState?.round ?? 0, spacing: viewModel.sidebarWidth * 0.08)
                    }
                    Spacer()
                    HStack {
                        Button {
                            // TODO: FORFEIT MATCH
                        } label: {
                            Text("Forfeit Match")
                                .font(.system(size: 10))
                                .lineLimit(2)
                        }
                        .tint(.red)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        Button() {
                            // TODO: TAKE TURN
                            viewModel.takeTurn()
                        } label: {
                            Text("End Turn")
                                .font(.system(size: 10))
                                .lineLimit(2)
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        .disabled(viewModel.tableCardMine == nil || !viewModel.myTurn)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.tableCardMine)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.myTurn)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .maskedBackground(mask: LinearGradient.gameBackgroundMask(), background: {
            Image("Wooden Light")
                .resizable()
                .scaledToFill()
        })
    }
    /**
     The Card Hand
     It can be unfocused (where the Cards are spread out)
     or focused (where the Cards are enlarged and next to each other)
     */
    func cardsHand() -> some View {
        ZStack {
            ForEach(Array(viewModel.cards.enumerated()), id: \.element) { index, card in
                CardView(card: card, width: viewModel.myCardsWidth)
                    .rotationEffect(viewModel.isFocusedHand ? .zero : viewModel.calculateAngle(cardIndex: index))
                    .offset(viewModel.isFocusedHand ? viewModel.calculateOffsetFocused(cardIndex: index) : viewModel.calculateOffsetUnfocused(cardIndex: index))
                    .shadow(color: viewModel.isFocusedHand ? .black : .clear, radius: 4, x: 12, y: 16)
                    .opacity(card.id == viewModel.draggedCard?.id ? 0 : 100)
                    .onDrag {
                        guard viewModel.myTurn else {
                            return NSItemProvider()
                        }
                        viewModel.draggedCard = card
                        let prov = ClosureItemProvider {
                            viewModel.draggedCard = nil
                        }
                        return prov
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
    /**
     The table on which the played Cards lay
     */
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
            
            VStack {
                if let enemyCard = viewModel.tableCardEnemy {
                    CardView(card: enemyCard, width: viewModel.myCardsWidthExpanded)
                }
                Spacer()
                if let myCard = viewModel.tableCardMine {
                    CardView(card: myCard, width: viewModel.myCardsWidthExpanded, flipped: true)
                }
            }
        }
        .frame(width: viewModel.tableWidth, height: viewModel.tableHeight)
        .onDrop(of: [UTType.card], delegate: CardDropDelegate(draggedCard: $viewModel.draggedCard, tableCard: $viewModel.tableCardMine, cards: $viewModel.cards))
        
    }
    
}

struct StepIndicator: View {
    var steps: Int
    var currentStep: Int
    var spacing: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<steps + 1, id: \.self) { i in
                Image(systemName: "\(i).circle\(i < currentStep ? ".fill" : "")")
                    .foregroundStyle(.black)
                    .bold(i == currentStep)
                if i < steps {
                    Rectangle()
                        .foregroundStyle(withAnimation {
                            i < currentStep ? .black : .white
                        })
                        .frame(width: spacing, height: 4)
                }
            }
        }
    }
    
    
}
/**
 A sidebar which can be expanded by a `Tap Gesture` to show `Content`
 */
struct SideBar<Content: View> : View {
    @Binding var isExpanded: Bool
    var width: CGFloat
    var height: CGFloat
    @ViewBuilder var content: Content
    var body: some View {
        ZStack() {
            Rectangle()
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadii: .init(topLeading: 60, bottomLeading: 60, bottomTrailing: 0, topTrailing: 0)))
                .opacity(isExpanded ? 0.8 : 0.4)
                .overlay {
                    HStack {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black)
                            .font(.title)
                            .rotationEffect(isExpanded ? .degrees(0) : .degrees(180))
                            .animation(.easeInOut(duration: 0.2), value: isExpanded)
                        
                        if isExpanded {
                            VStack(alignment: .leading) {
                                content
                            }
                            .transition(
                                .scale(scale: 0.1)
                                .combined(with: .move(edge: .trailing))
                            )
                            .padding(.vertical, 12)
                            Spacer()
                        }
                    }
                    .padding(.leading, isExpanded ? 8 : 0)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                    }
                }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
//    let num = 5
//    var cards: [Card] = .init()
//    for _ in 0..<num {
//        cards.append(.init(cardType: .Citizen))
//    }
    var game = ECardGame(appCoordinator: AppCoordinator())
    var participant = Participant(player: .anonymousGuestPlayer(withIdentifier: "id"), isEmperorSide: true)
    participant.cards = Card.emperorSide
    game.localParticipant = participant
    game.initGameState()
    return GameView(viewModel: .init(game: game))
}
