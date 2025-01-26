//
//  Extensions.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import Foundation
import SwiftUI

extension LinearGradient {
    static func kaijiGradient() -> Self {
        return LinearGradient(stops: [
            Gradient.Stop(color: Color(red: 0.9, green: 0.19, blue: 0.19), location: 0.05),
            Gradient.Stop(color: .black, location: 0.6)
        ], startPoint: .topTrailing, endPoint: .leading)
    }
}

extension Font {
    enum SairaFont {
        case regular
        var value: String {
            switch self {
            case .regular:
                return "SairaStencilOne-Regular"
            }
        }
    }
    
    static func saira(_ type: SairaFont, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
}

extension Color {
    public static let tableBrown: Color = Color(red: 139 / 255, green: 69 / 255, blue: 19 / 255)
    
}

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

import UniformTypeIdentifiers

extension UTType {
    static let card = UTType(exportedAs: "cz.lukas.zima.E-Card.card")
}


