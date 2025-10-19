//
//  ContentView.swift
//  DailyTips
//
//  Created by Adrian Felix on 19/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TipViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Bill") {
                    TextField("Amount", text: $vm.billAmount)
                        .keyboardType(.decimalPad)
                }

                Section("Tip") {
                    Picker("Percent", selection: $vm.tipPercent) {
                        ForEach([0,5,10,12,15,18,20,25,30], id: \.self) { p in
                            Text("\(p)%").tag(p)
                        }
                    }
                    .pickerStyle(.segmented)

                    Toggle("Round up total", isOn: $vm.roundUp)
                }

                Section("Split") {
                    Stepper("People: \(vm.partySize)", value: $vm.partySize, in: 1...20)
                }

                Section("Results") {
                    HStack { Text("Tip"); Spacer(); Text(vm.money(vm.tipAmount)) }
                    HStack { Text("Total"); Spacer(); Text(vm.money(vm.total)).bold() }
                    HStack { Text("Per person"); Spacer(); Text(vm.money(vm.perPerson)) }
                }
            }
            .navigationTitle("DailyTips")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") { vm.reset() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
