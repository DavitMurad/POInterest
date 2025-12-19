//
//  SettingsView.swift
//  POInterest
//
//  Created by Davit Muradyan on 03.11.25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsVM = SettingsViewModel()
    @State private var selectedRadius = MetricManager.shared.defaultMeter

    var body: some View {
        Form {
            
            Section("Pick Radius") {
                Picker("Radius to explore", selection: $selectedRadius) {
                    ForEach(DistanceOptionEnumMeters.allCases, id: \.self) { radius in
                        Text("\(radius.rawValue, specifier: "%.0f") m")
                            .tag(radius.rawValue)
                    }
                }
            }
            
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
        .onChange(of: selectedRadius) { oldValue, newValue in
            if let meterValue = DistanceOptionEnumMeters(rawValue: newValue.rawValue) {
                MetricManager.shared.defaultMeter = meterValue
            }
        }
    }
}

//#Preview {
//    SettingsView()
//}
