//
//  Extensions.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
/**
 Extensions for LinearGradient
 */
extension LinearGradient {
    /**
     The Gradient used for the menu background
     */
    static func kaijiGradient() -> Self {
        return LinearGradient(stops: [
            Gradient.Stop(color: Color(red: 0.9, green: 0.19, blue: 0.19), location: 0.05),
            Gradient.Stop(color: .black, location: 0.6)
        ], startPoint: .topTrailing, endPoint: .leading)
    }
    /**
     The Gradient used as a mask for the game background
     */
    static func gameBackgroundMask() -> Self {
        LinearGradient(stops: [.init(color: .clear, location: 0),
                               .init(color: .black, location: 0.25),
                               .init(color: .black, location: 1)],
                               startPoint: .top, endPoint: .bottom)
    }
}
/**
 Font extensions used in the app
 */
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
/**
 Color extensions used in the app
 */
extension Color {
    public static let tableBrown: Color = Color(red: 139 / 255, green: 69 / 255, blue: 19 / 255)
    
}
/**
 View extensions used in the app
 */
extension View {
    /**
     Reads the size of the View it is used on
     */
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func maskedBackground<BackgroundContent: View>(mask: LinearGradient, @ViewBuilder background: () -> BackgroundContent) -> some View {
        modifier(MyBackground(background: background, maskGradient: mask))
    }
}
/**
 UTType extensions
 */
extension UTType {
    static let card = UTType(exportedAs: "cz.lukas.zima.E-Card.card")
}


