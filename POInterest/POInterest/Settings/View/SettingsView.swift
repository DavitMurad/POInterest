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
    @State private var signOut = false
    @State private var deleteAccount = false
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
                    signOut.toggle()
                }
                .foregroundStyle(.red)
                
                Button("Delete account") {
                    deleteAccount = true
                }
                .foregroundStyle(.red)
            }
            .disabled(settingsVM.isLoading)
//            .blur(radius: settingsVM.isLoading ? 2 : 0)
            
            if settingsVM.isLoading {
                
                ProgressView("Please wait…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
            
            
        }
        
        .alert("Are you sure you want to Log out?", isPresented: $signOut) {
            Button("Cancel", role: .cancel) {}
            Button("Log out", role: .destructive) {
                settingsVM.signOut()
            }
        }
        .alert("Are you sure you want to Delete your account?", isPresented: $deleteAccount) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    await settingsVM.deleteUser()
                }
            }
        } message: {
            Text("This action cannot be undone.")
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
