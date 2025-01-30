//
//  Item.swift
//  E-Card
//
//  Created by Lukas Zima on 24.01.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
