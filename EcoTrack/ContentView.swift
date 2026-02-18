import SwiftUI
import SwiftData
import Charts

struct ContentView: View {
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddSheet = false
    
    // Inisialisasi Security Manager
    @StateObject private var securityManager = SecurityManager()

    var body: some View {
        Group {
            if securityManager.isUnlocked {
                // TAMPILAN UTAMA (Terbuka)
                NavigationStack {
                    List {
                        // MARK: - Header Grafik
                        if !transactions.isEmpty {
                            Section {
                                Chart {
                                    ForEach(transactions) { item in
                                        BarMark(
                                            x: .value("Nama", item.name),
                                            y: .value("Karbon", item.carbonEstimate)
                                        )
                                        .foregroundStyle(by: .value("Kategori", item.category))
                                    }
                                }
                                .frame(height: 200)
                                .padding(.vertical)
                            } header: {
                                Text("Ringkasan Jejak Karbon (kg CO2)")
                            }
                        }

                        // MARK: - Daftar Transaksi
                        Section("Riwayat Transaksi") {
                            if transactions.isEmpty {
                                ContentUnavailableView("Belum Ada Data", systemImage: "leaf", description: Text("Mulai catat transaksi untuk melihat dampak karbonmu."))
                            } else {
                                ForEach(transactions) { item in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name).font(.headline)
                                            Text(item.category).font(.caption).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            Text("Rp\(item.amount, specifier: "%.0f")")
                                            Text("\(item.carbonEstimate, specifier: "%.2f") kg CO2")
                                                .font(.caption2)
                                                .foregroundStyle(.green)
                                        }
                                    }
                                }
                                .onDelete(perform: deleteItems)
                            }
                        }
                    }
                    .navigationTitle("EcoTrack")
                    .toolbar {
                        Button(action: { isShowingAddSheet = true }) {
                            Image(systemName: "plus.circle.fill").font(.title3)
                        }
                    }
                    .sheet(isPresented: $isShowingAddSheet) {
                        AddTransactionView()
                    }
                }
            } else {
                // TAMPILAN LOCK SCREEN (Terkunci)
                VStack(spacing: 20) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    Text("EcoTrack Terkunci")
                        .font(.title).bold()
                    Button("Buka dengan Face ID") {
                        securityManager.authenticate()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .onAppear {
            securityManager.authenticate()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(transactions[index])
        }
    }
}
