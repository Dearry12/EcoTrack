//
//  Item.swift
//  EcoTrack
//
//  Created by Derry Meiraldy on 18/02/26.
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
