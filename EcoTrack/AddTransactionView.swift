import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // State untuk menyimpan input user
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var category: String = "Makanan"
    
    let categories = ["Makanan", "Transportasi", "Elektronik", "Belanja"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Detail Transaksi") {
                    TextField("Nama Barang", text: $name)
                    TextField("Harga (Rp)", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section("Kategori") {
                    Picker("Pilih Kategori", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Tambah Catatan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        saveTransaction()
                    }
                    .disabled(name.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    
    private func saveTransaction() {
        if let price = Double(amount) {
            // Logika sederhana: 1000 Rupiah dianggap 0.01 kg CO2 (ini bisa dikembangkan nanti)
            let carbon = price * 0.00001
            
            let newTransaction = Transaction(
                name: name,
                amount: price,
                category: category,
                carbonEstimate: carbon
            )
            
            modelContext.insert(newTransaction)
            dismiss()
        }
    }
}
