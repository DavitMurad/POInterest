//
//  RegisterView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var registerVM = RegisterViewModel()
    @State var isRegistered = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("StreetView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Welcome to POInterest")
                            .font(.title2)
                        Text("Please register with you Email & Password")
                            .font(.title2)
                        
                        VStack(spacing: 15) {
                            TextField("Name", text: $registerVM.name)
                                .customTextFieldStyle()
                            
                            if let error = registerVM.nameErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            TextField("Email", text: $registerVM.email)
                                .customTextFieldStyle()
                                .keyboardType(.emailAddress)
                            
                            if let error = registerVM.emailErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            SecureField("Password", text: $registerVM.password)
                                .customTextFieldStyle()
                            
                            if let error = registerVM.passwordErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            if let error = registerVM.formError {
                                Text(error)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Button("Register") {
                                Task {
                                    await registerVM.signUp()
                                    if registerVM.isRegisterSuccess {
                                        isRegistered = true
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .disabled(!registerVM.isFormValid || registerVM.isLoading)
                            .navigationDestination(isPresented: $isRegistered) {
                                UnitsView()
                            }
                            
                            .padding(20)
                            .disabled(registerVM.isLoading)
                            
                            if registerVM.isLoading {
                                ProgressView("Please wait…")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                
                            }
                            
                        }
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0.2), .black.opacity(0.5)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(20)
                    }
                    .padding(.top, 20)
                    
                }
            }
        }
    }
}


//#Preview {
//    RegisterView()
//}
