import Foundation
import SwiftData

@Model
final class TipEntry {
    var id: UUID
    var amount: Double
    var tipPercent: Int
    var date: Date
    
    init(amount: Double, tipPercent: Int, date: Date = .now) {
        self.id = UUID()
        self.amount = amount
        self.tipPercent = tipPercent
        self.date = date
    }
}
