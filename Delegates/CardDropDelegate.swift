//
//  CardDropDelegate.swift
//  E-Card
//
//  Created by Lukas Zima on 26.01.2025.
//

import Foundation
import SwiftUI

struct CardDropDelegate: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        true
    }
    /**
     Specifies that this is a move operation and therefore does not show the green +.
     */
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    
}
