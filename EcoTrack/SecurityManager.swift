import Foundation
import LocalAuthentication
import SwiftUI
import Combine // Tambahkan ini untuk memperbaiki error 'missing import'

class SecurityManager: ObservableObject {
    @Published var isUnlocked = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Buka kunci untuk mengakses data EcoTrack"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    }
                }
            }
        }
    }
}
