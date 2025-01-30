//
//  CardView.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import SwiftUI
/**
 A View of a `Card` used in the Game
 */
struct CardView: View {
    var card: Card
    var width: CGFloat
    // A flipped Card shows the Back of the Card
    var flipped: Bool = false
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Image(flipped ? CardType.Back.rawValue : card.cardType.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding(width / 25)
        .background(.black)
        .clipShape(.rect(cornerRadius: width / 30))
        .frame(width: width)
    }
}

#Preview {
    HStack {
        ForEach(CardType.allCases, id: \.rawValue) { type in
            CardView(card: .init(cardType: .Citizen), width: 60)
        }
    }
}
