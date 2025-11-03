//
//  RegisterView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var registerVM = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Welcome to POInterest")
                        .font(.title2)
                    Text("Please register bellow")
                        .font(.title2)
                    
                    ZStack {
                        VStack(spacing: 15) {
                            TextField("Name", text: $registerVM.name)
                                .customTextFieldStyle()
                            if let error = registerVM.nameErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                            TextField("Email", text: $registerVM.email)
                                .customTextFieldStyle()
                                .keyboardType(.emailAddress)
                            
                            if let error = registerVM.emailErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                            TextField("Password", text: $registerVM.password)
                                .customTextFieldStyle()
                            if let error = registerVM.passwordErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
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
                                }
                                
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .disabled(!registerVM.isFormValid)
                            
                            HStack {
                                Button("Sign up with Google") {
                                    
                                }
                                .frame(maxWidth: 200)
                                .frame(height: 55)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                
                                Button("Sign up with Apple") {
                                    
                                }
                                .frame(maxWidth: 200)
                                .frame(height: 55)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            }
                        }
                        
                        
                        .padding()
                    }
                    
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        
    }
}

#Preview {
    RegisterView()
}
