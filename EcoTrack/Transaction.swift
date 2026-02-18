import Foundation
import SwiftData

@Model
final class Transaction {
    var name: String
    var amount: Double
    var date: Date
    var category: String
    var carbonEstimate: Double // Dalam satuan kg CO2
    
    init(name: String, amount: Double, date: Date = .now, category: String, carbonEstimate: Double) {
        self.name = name
        self.amount = amount
        self.date = date
        self.category = category
        self.carbonEstimate = carbonEstimate
    }
}
