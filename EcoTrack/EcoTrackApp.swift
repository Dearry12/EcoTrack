import SwiftUI
import SwiftData

@main
struct EcoTrackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // BARIS PENTING: Menyiapkan storage untuk model Transaction
        .modelContainer(for: Transaction.self)
    }
}
