//
//  Item.swift
//  Riddle-Room-Team-4
//
//  Created by Abdullah Zahid on 20/7/2026.
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
