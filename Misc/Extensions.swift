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
