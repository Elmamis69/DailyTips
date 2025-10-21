import SwiftUI
import UIKit  // para haptics
import SwiftData

struct ContentView: View {
    @StateObject private var vm = TipViewModel()
    @FocusState private var amountFocused: Bool
    
    @Environment(\.modelContext) private var modelContext 

    // MARK: - Preferencias persistentes
    @AppStorage("prefs.tipPercent") private var tipPref: Int = 10
    @AppStorage("prefs.roundUp") private var roundPref: Bool = false

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
                    
                    Button("💾 Save Tip") {
                        vm.saveEntry(using: modelContext)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("💵 DailyTips")
            .onAppear {
                // Cuando la vista se muestra, cargamos los valores guardados
                vm.tipPercent = tipPref
                vm.roundUp = roundPref
            }
            .onChange(of: vm.tipPercent) { _, new in
                // Cada vez que cambia el porcentaje de propina, lo guardamos
                tipPref = new
            }
            .onChange(of: vm.roundUp) { _, new in
                // Cada vez que cambia el switch de redondeo, lo guardamos
                roundPref = new
            }
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
    
    // Persistencia simple de preferencias
    private enum Prefs {
        static let tip = "prefs.tipPercent"
        static let round = "prefs.roundUp"
    }

}

#Preview { ContentView() }
