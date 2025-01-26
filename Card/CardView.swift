//
//  CardView.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var width: CGFloat
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Image(card.cardType.rawValue)
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
