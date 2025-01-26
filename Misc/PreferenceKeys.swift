//
//  PreferenceKeys.swift
//  E-Card
//
//  Created by Lukas Zima on 26.01.2025.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
