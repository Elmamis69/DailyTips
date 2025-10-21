//
//  TipViewModel.swift
//  DailyTips
//
//  Created by Adrian Felix on 19/10/25.
//
import Foundation
import Combine
import SwiftData

@MainActor
final class TipViewModel: ObservableObject {
    // Inputs
    @Published var billAmount: String = ""
    @Published var tipPercent: Int = 10
    @Published var partySize: Int = 1
    @Published var roundUp: Bool = false

    // Helpers
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }

    // Parsed numeric
    private var bill: Double {
        Double(billAmount.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    // Outputs
    var tipAmount: Double {
        (bill * Double(tipPercent)) / 100.0
    }

    var total: Double {
        let raw = bill + tipAmount
        return roundUp ? ceil(raw) : raw
    }

    var perPerson: Double {
        guard partySize > 0 else { return total }
        return total / Double(partySize)
    }

    // Formatted strings
    func money(_ value: Double) -> String {
        value.formatted(.currency(code: currencyCode))
    }

    // Actions
    func reset() {
        billAmount = ""
        tipPercent = 10
        partySize = 1
        roundUp = false
    }
    
    // MARK: - Save entry
        func saveEntry(using context: ModelContext) {
            guard bill > 0 else { return }
            let entry = TipEntry(amount: total, tipPercent: tipPercent)
            context.insert(entry)
            try? context.save()
        }
    // Normaliza el input del monto
    func normalizeAmountInput(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber || $0 == "." }
        var result = ""
        var seenDot = false
        for ch in filtered {
            if ch == "." {
                if seenDot { continue }
                seenDot = true
            }
            result.append(ch)
        }
        if result.hasPrefix("0"), !result.hasPrefix("0.") {
            result = String(result.drop(while: { $0 == "0" }))
            if result.isEmpty { result = "0" }
        }
        billAmount = result
    }
}

