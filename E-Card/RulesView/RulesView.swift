//
//  RulesView.swift
//  E-Card
//
//  Created by Lukas Zima on 27.01.2025.
//

import SwiftUI

struct RulesView: View {
    var screenSize: CGSize
    init(screenSize: CGSize = .init(width: 393, height: 700)) {
        self.screenSize = screenSize
    }
    var body: some View {
        VStack {
            MenuText(text: "Rules", size: 80, symbol: "book")
            List {
                CollapsibleSection(title: "Cards") {
                    ForEach(CardType.allCases, id: \.rawValue) { type in
                        if type != .Back {
                            Text(type.rawValue)
                                .bold()
                                .foregroundStyle(.white)
                            HStack(alignment: .center) {
                                CardView(card: .init(cardType: type), width: screenSize.width / 4)
                                VStack(alignment: .center) {
                                    HStack() {
                                        Image(systemName: "info.circle")
                                            .foregroundStyle(.white)
                                        Text(type.description)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Image(systemName: "trophy")
                                            .foregroundStyle(.white)
                                        Text(type.defeatMechanics)
                                            .foregroundStyle(.white)
                                        Spacer()
                                    }
                                    
                                }
                                Spacer()
                            }
                            if type != .Citizen {
                                Divider()
                            }
                        }
                        
                    }
                }
                CollapsibleSection(title: "Card Distribution") {
                    cardDist(type: .Emperor)
                    Divider()
                    cardDist(type: .Slave)
                }
                CollapsibleSection(title: "Gameplay") {
                    GameFlowView()
                }
            }
            .scrollContentBackground(.hidden)
            Spacer()
        }
        .background(LinearGradient.kaijiGradient())
    }
    
    func cardDist(type: CardType) -> some View {
        var myCards:[Card] = []
        switch type {
        case .Emperor: myCards = Card.emperorSide
        case .Slave: myCards = Card.slaveSide
        default: break
        }
        return VStack {
            Text(type.rawValue + "Side")
                .bold()
                .foregroundStyle(.white)
            HStack {
                ForEach(myCards) { card in
                    CardView(card: card, width: screenSize.width / 8)
                }
            }
            
        }
    }
    
}
struct CollapsibleSection<Content: View>: View {
    @State var expanded: Bool = false
    var title: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            Button {
                expanded.toggle()
            } label: {
                ZStack() {
                    HStack {
                        Spacer()
                        Image(systemName: expanded ? "chevron.up" : "chevron.down")
                            .tint(.white)
                    }
                    Text(title)
                        .font(.title3)
                        .foregroundStyle(.white)
                    
                }
            }
            
            VStack {
                if expanded {
                    Divider()
                    content
                }
            }
        }
        .alignmentGuide(.listRowSeparatorLeading, computeValue: { ViewDimensions in
            0
        })
        .listRowBackground(Color.gray.opacity(0.1))
        .border(.clear)
    }
}

struct GameFlowView: View {
    @State private var showDrawRules = false
    var body: some View {
        Text("Game Flow")
            .bold()
            .foregroundStyle(.white)
        HStack {
            VStack(alignment: .leading) {
                ForEach(1..<5) { index in
                    groupStep(title: "Group \(index)", description: index.isMultiple(of: 2) ? "Slave Side starts" : "Emperor Side starts")
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(1..<4) { round in
                            Rectangle()
                                .frame(width: 2, height: 10)
                                .foregroundColor(.white)
                                .offset(x: 7)
                            HStack {
                                smallCircle
                                    .offset(x: 4)
                                Text("Round \(round)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .offset(x: 8)
                            }
                        }
                    }
                    if index == 4 {
                        groupStep(title: "The End", description: "Player with the most victories wins")
                    }
                }
            }
            Spacer()
        }
        Divider()
        Text("Round Flow")
            .bold()
            .foregroundStyle(.white)
        HStack {
            VStack(alignment: .leading) {
                ForEach(1..<4) { matchup in
                    groupStep(title: "Matchup \(matchup)", description: matchup.isMultiple(of: 2)
                              ? "Slave side places a card down first"
                              : "Emperor side places a card down first")
                    
                    roundStep(title: (matchup.isMultiple(of: 2) ? "Emperor" : "Slave") + " side places a card down")
                    
                    roundStep(title: "Cards are flipped and compared")
                    
                    roundStep(title: matchup == 3
                              ? "If a draw, The Round concludes as a draw"
                              : "If a draw, continue to Matchup \(matchup + 1)")
                    
                }
            }
            Spacer()
        }
        
        
        
        
    }
    func groupStep(title: String, description: String) -> some View {
        HStack {
            Circle()
                .frame(width: 16, height: 16)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .foregroundStyle(.white)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    func roundStep(title: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .frame(width: 2, height: 10)
                .foregroundColor(.white)
                .offset(x: 7)
            HStack {
                smallCircle
                    .offset(x: 4)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .offset(x: 8)
            }
        }
    }
    static func placementText(matchup: Int, isFirst: Bool) -> String {
        matchup.isMultiple(of: 2) == isFirst ? "Emperor" : "Slave" + "side places a card down"
    }
    
    func matchupConclusionText(matchup: Int) -> String {
        return matchup == 3
                    ? "Matchup concludes. If it is a draw, the round concludes without a winner"
                    : "Matchup ends. If a draw, proceed to Matchup \(matchup + 1)"
    }
    let smallCircle: some View = Circle()
        .frame(width: 8, height: 8)
        .foregroundColor(.white)
}



#Preview {
    RulesView()
}
