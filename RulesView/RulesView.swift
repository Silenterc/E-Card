//
//  RulesView.swift
//  E-Card
//
//  Created by Lukas Zima on 27.01.2025.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        VStack {
            MenuText(text: "Rules", size: 80, symbol: "book")
            List {
                CollapsibleSection(title: "Expand Me") {
                    Text("baddadan")
                    Text("Bladbladda")
                    Text("Bladbladda")
                    Text("Bladbladda")
                    Text("Bladbladda")
                }
                .listRowBackground(Color.gray)
            }
            .scrollContentBackground(.hidden)
        }
        .background(LinearGradient.kaijiGradient())
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
                    }
                    Text(title)
                        .foregroundStyle(.black)
                }
            }

            VStack {
                if expanded {
                    Divider()
                    content
                }
            }
            .animation(.smooth, value: expanded)
        }
    }
}

#Preview {
    RulesView()
}
