import SwiftUI
import SwiftData

@main
struct DailyTipsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedContainer) // usamos el contenedor seguro de abajo
    }
}

private let sharedContainer: ModelContainer = {
    let isRunningTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    let schema = Schema([TipEntry.self])

    // Intenta crear contenedor (en memoria si estamos en tests)
    do {
        let config = ModelConfiguration(schema: schema,
                                        isStoredInMemoryOnly: isRunningTests)
        return try ModelContainer(for: schema, configurations: [config])
    } catch {
        // Fallback ultra-seguro si algo falla: fuerza memoria
        assertionFailure("SwiftData container failed: \(error.localizedDescription)")
        return try! ModelContainer(
            for: schema,
            configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)]
        )
    }
}()
