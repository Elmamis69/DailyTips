import SwiftUI
import UIKit
import SwiftData

struct ContentView: View {
    // VM + teclado
    @StateObject private var vm = TipViewModel()
    @FocusState private var amountFocused: Bool

    // SwiftData
    @Environment(\.modelContext) private var modelContext

    // Preferencias
    @AppStorage("prefs.tipPercent") private var tipPref: Int = 10
    @AppStorage("prefs.roundUp") private var roundPref: Bool = false
    @AppStorage("prefs.useMXN") private var useMXN: Bool = true

    // UI
    @State private var showSavedAlert = false

    // Datos auxiliares
    private let presetPercents: [Int] = [10, 15, 20]

    private var displayCurrency: String {
        useMXN ? "MXN" : (vm.currencyCode)
    }

    var body: some View {
        NavigationStack {
            Form {
                billSection
                tipSection
                resultSection
                settingsSection
            }
            .navigationTitle("💵 DailyTips")
            .toolbar { historyToolbar }
            .onAppear {
                vm.tipPercent = tipPref
                vm.roundUp = roundPref
            }
            .onChange(of: vm.tipPercent) { _, new in tipPref = new }
            .onChange(of: vm.roundUp) { _, new in roundPref = new }
            .alert("Saved!", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Tip stored in History.")
            }
        }
    }

    // MARK: - Sections (partimos el body)

    private var billSection: some View {
        Section("Bill") {
            TextField("Enter amount", text: $vm.billAmount)
                .keyboardType(.decimalPad)
                .focused($amountFocused)
                .onChange(of: vm.billAmount) { _, new in
                    vm.normalizeAmountInput(new)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { amountFocused = false }
                    }
                }
        }
    }

    private var tipSection: some View {
        Section("Tip") {
            HStack {
                ForEach(presetPercents, id: \.self) { (p: Int) in
                    Button("\(p)%") {
                        vm.tipPercent = p
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    .buttonStyle(.bordered)
                    .tint(vm.tipPercent == p ? .accentColor : .secondary)
                }
            }

            Stepper("Tip: \(vm.tipPercent)%",
                    value: $vm.tipPercent,
                    in: 0...50)

            Stepper("People: \(vm.partySize)",
                    value: $vm.partySize,
                    in: 1...20)

            Toggle("Round up total", isOn: $vm.roundUp)
        }
    }

    private var resultSection: some View {
        Section("Result") {
            valueRow(title: "Total:", value: vm.total, currency: displayCurrency)
            valueRow(title: "Per person:", value: vm.perPerson, currency: displayCurrency)

            Button("💾 Save Tip") {
                vm.saveEntry(using: modelContext)
                showSavedAlert = true
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
            .disabled(vm.total == 0)
        }
    }

    private var settingsSection: some View {
        Section("Settings") {
            Toggle("Use MXN currency", isOn: $useMXN)
        }
    }

    // MARK: - Toolbar
    private var historyToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: HistoryView()) {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
    }

    // MARK: - Helpers
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
