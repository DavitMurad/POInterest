//
//  LoginView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @StateObject var loginVM = LoginViewModel()
    @State private var isLoggedIn = false
    
    @State private var showingForgotPassword = false
    @State private var resetEmail = ""
    @State private var resetStatusMessage: String?
    @State private var showResetStatus = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("StreetView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
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
//                                if let error = loginVM.passwordErrorMessage {
//                                    Text(error)
//                                        .font(.caption)
//                                        .foregroundStyle(.red)
//                                }
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
                                    RootView()
                                }
                                
                                Button("Forgot Password?") {
                                    showingForgotPassword = true
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.top, 4)
                                
                                ORSeperator()
                                    .frame(height: 20)
                                
                                HStack {
                                    GoogleSignInButton() {
                                        Task {
                                            do {
                                                try await loginVM.signInGoogle()
                                                isLoggedIn = true
                                            } catch {
                                                loginVM.formError = "Google sign-in failed. Please try again"
                                            }
                                        }
                                    }
                                    
                                    Button {
                                        loginVM.formError = "Coming Soon!"
                                    } label: {
                                        HStack(spacing: 12) {
                                            Image(systemName: "apple.logo")
                                                .foregroundColor(.black)
                                            
                                            Text("Sign in")
                                                .foregroundColor(.gray)
                                            
                                            
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(height: 16)
                                        .padding(.vertical, 12)
                                        .padding(.leading)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                    
                                    
                                }
                                
                                NavigationLink("Don't have an account?", destination: {
                                    RegisterView()
                                })
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .padding()
                        }
                        .background(
                            //                            LinearGradient(
                            //                                gradient: Gradient(colors: [.black.opacity(0.2), .black.opacity(0.5)]),
                            //                                startPoint: .top,
                            //                                endPoint: .bottom
                            //                            )
                            .bar
                            
                            
                            
                        )
                        
                        
                        
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                }
                .alert("Reset Password", isPresented: $showingForgotPassword) {
                    TextField("Email", text: $resetEmail)
                    Button("Send Reset Link") {
                        Task {
                            do {
                                try await loginVM.sendPasswordReset(email: resetEmail)
                                resetStatusMessage = "Password reset email sent! Check your inbox."
                                showResetStatus = true
                            } catch {
                                resetStatusMessage = "Failed to send reset email. Please check the email address."
                                showResetStatus = true
                            }
                            resetEmail = ""
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        resetEmail = ""
                    }
                } message: {
                    Text("Enter your email address to receive a password reset link.")
                }
                .alert("Password Reset", isPresented: $showResetStatus) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(resetStatusMessage ?? "")
                }
                
            }
        }
        .navigationBarBackButtonHidden()
    }
}


struct ORSeperator: View {
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.white)
            
            Text("or")
                .foregroundColor(.white)
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.white)
        }
    }
}

//#Preview {
//    LoginView()
//}
