//
//  PreferenceKeys.swift
//  E-Card
//
//  Created by Lukas Zima on 26.01.2025.
//

import Foundation
import SwiftUI

class ClosureItemProvider: NSItemProvider {
    var didEnd: (() -> Void)?
    
    init(didEnd: ( () -> Void)? = nil) {
        super.init()
        self.didEnd = didEnd
    }
    deinit {
        didEnd?()
    }
}
/**
 Custom PreferenceKey to propagate a Size value
 */
struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
/**
 A View Modifier which adds a background with a given mask
 */
struct MyBackground<BackgroundContent: View>: ViewModifier {
    @ViewBuilder var background: BackgroundContent
    var maskGradient: LinearGradient
    func body(content: Content) -> some View {
        content
            .background {
                background
                    .mask {
                        maskGradient
                    }
                    .ignoresSafeArea()
            }
    }
}
