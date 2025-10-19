import SwiftUI
import UIKit  // para haptics

struct ContentView: View {
    @StateObject private var vm = TipViewModel()
    @FocusState private var amountFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                // BILL
                Section("Bill") {
                    TextField("Enter amount", text: $vm.billAmount)
                        .keyboardType(.decimalPad)
                        .focused($amountFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") { amountFocused = false }
                            }
                        }
                }

                // TIP
                Section("Tip") {
                    // presets
                    HStack {
                        ForEach([10, 15, 20], id: \.self) { p in
                            Button("\(p)%") {
                                vm.tipPercent = p
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                            .buttonStyle(.bordered)
                            .tint(vm.tipPercent == p ? .accentColor : .secondary)
                        }
                    }

                    Stepper("Tip: \(vm.tipPercent)%", value: $vm.tipPercent, in: 0...50)
                    Stepper("People: \(vm.partySize)", value: $vm.partySize, in: 1...20)
                    Toggle("Round up total", isOn: $vm.roundUp)
                }

                // RESULT
                Section("Result") {
                    valueRow(title: "Total:", value: vm.total, currency: vm.currencyCode)
                    valueRow(title: "Per person:", value: vm.perPerson, currency: vm.currencyCode)
                }
            }
            .navigationTitle("💵 DailyTips")
        }
    }

    @ViewBuilder
    private func valueRow(title: String, value: Double, currency: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value, format: .currency(code: currency))
                .monospacedDigit()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) \(value, format: .currency(code: currency))")
    }
}

#Preview { ContentView() }
