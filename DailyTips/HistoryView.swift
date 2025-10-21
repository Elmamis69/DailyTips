import SwiftUI
import SwiftData

struct HistoryView: View {
    // Trae todas las entradas ordenadas (más recientes primero)
    @Query(sort: [SortDescriptor(\TipEntry.date, order: .reverse)])
    private var entries: [TipEntry]

    @Environment(\.modelContext) private var modelContext

    private var currencyCode: String { Locale.current.currency?.identifier ?? "USD" }

    var body: some View {
        List {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No saved tips",
                    systemImage: "tray",
                    description: Text("Save a tip from the main screen to see it here.")
                )
            } else {
                ForEach(entries, id: \.id) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.date, format: .dateTime.day().month().year().hour().minute())
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text("Tip: \(entry.tipPercent)%")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(entry.amount, format: .currency(code: currencyCode))
                            .font(.headline)
                            .monospacedDigit()
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("History")
        .toolbar {
            if !entries.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear All", role: .destructive) {
                        clearAll()
                    }
                }
            }
        }
    }

    private func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(entries[index])
        }
        try? modelContext.save()
    }

    private func clearAll() {
        entries.forEach { modelContext.delete($0) }
        try? modelContext.save()
    }
}
