//
//  RegisterView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerVM = RegisterViewModel()
    @State var isRegistered = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Light gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGray6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 8) {
                            Text("Create Account")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Join POInterest to discover amazing places")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 60)
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    TextField("Name", text: $registerVM.name)
                                        .textContentType(.name)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    
                                    if let error = registerVM.nameErrorMessage {
                                        Text(error)
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    TextField("Email", text: $registerVM.email)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    
                                    if let error = registerVM.emailErrorMessage {
                                        Text(error)
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    SecureField("Password", text: $registerVM.password)
                                        .textContentType(.newPassword)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    
                                    if let error = registerVM.passwordErrorMessage {
                                        Text(error)
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }
                                }
                                
                                if let error = registerVM.formError {
                                    Text(error)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 4)
                                }
                                
                                Button {
                                    Task {
                                        await registerVM.signUp()
                                        if registerVM.isRegisterSuccess {
                                            isRegistered = true
                                        }
                                    }
                                } label: {
                                    if registerVM.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    } else {
                                        Text("Create Account")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    }
                                }
                                .background(
                                    Color.accentColor
                                        .opacity(registerVM.isFormValid && !registerVM.isLoading ? 1.0 : 0.5)
                                )
                                .cornerRadius(12)
                                .disabled(!registerVM.isFormValid || registerVM.isLoading)
                                .navigationDestination(isPresented: $isRegistered) {
                                    UnitsView()
                                }
                            }
                            
                            
                            .padding(24)
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                            .padding(.horizontal, 24)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    RegisterView()
//}
