//
//  SettingsView.swift
//  POInterest
//
//  Created by Davit Muradyan on 03.11.25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsVM = SettingsViewModel()
    var body: some View {
        Form {
            Section("Account") {
                
                Button("Log out") {
                    do {
                        try settingsVM.signOut()
                    } catch {
                        print("Error signing out: \(error)")
                    }
                }
                .foregroundStyle(.red)
                .navigationDestination(isPresented: $settingsVM.hasSignedOut) {
                    LoginView()
                }
                
                Button("Delete account") {
                    Task {
                        do {
                            try await settingsVM.deleteUser()
                        } catch {
                            print("Error deleting the account out: \(error)")
                        }
                    }
                    
                }
                .foregroundStyle(.red)
                .navigationDestination(isPresented: $settingsVM.hasDeletedAcc) {
                    LoginView()
                }
            }
        }
    }
}

//#Preview {
//    SettingsView()
//}
