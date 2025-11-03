//
//  LoginView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginVM = LoginViewModel()
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Welcome to POInterest")
                        .font(.title2)
                    Text("Please log in below")
                        .font(.title2)
                    
                    ZStack {
                        VStack(spacing: 15) {
                            TextField("Email", text: $loginVM.email)
                                .customTextFieldStyle()
                                .keyboardType(.emailAddress)
                            if let error = loginVM.emailErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                            SecureField("Password", text: $loginVM.password)
                                .customTextFieldStyle()
                            if let error = loginVM.passwordErrorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                            if let error = loginVM.formError {
                                Text(error)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Button("Log in") {
                                Task {
                                    await loginVM.login()
                                    if loginVM.isLoginSuccess {
                                        isLoggedIn = true
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .disabled(!loginVM.isFormValid)
                            .navigationDestination(isPresented: $isLoggedIn) {
                                            UnitsView()
                                        }
                            
                            HStack {
                                Button("Sign in with Google") {
                                    
                                }
                                .frame(maxWidth: 200)
                                .frame(height: 55)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                
                                Button("Sign in with Apple") {
                                    
                                }
                                .frame(maxWidth: 200)
                                .frame(height: 55)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            }
                            
                            NavigationLink("Don't have an account?", destination: {
                                RegisterView()
                            })
                            .frame(maxWidth: .infinity, alignment: .leading)
                          
                        }
                        .padding()
                    }
                    
                    
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
        }
        .navigationBarBackButtonHidden()
        
    }
}

//#Preview {
//    LoginView()
//}
