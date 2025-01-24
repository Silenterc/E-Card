//
//  CardView.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import SwiftUI

struct CardView: View {
    var type: CardType
    @Binding var width: CGFloat
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Image(type.rawValue)
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
    CardView(type: .Citizen, width: .constant(50))
}
