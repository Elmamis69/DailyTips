//
//  Item.swift
//  DailyTips
//
//  Created by Adrian Felix on 19/10/25.
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
