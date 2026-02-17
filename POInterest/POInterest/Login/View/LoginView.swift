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
                        // Header
                        VStack(spacing: 8) {
                            Text("Welcome to POInterest")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Discover nearby places")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 60)
                        
                    
                        VStack(spacing: 20) {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    TextField("Email", text: $loginVM.email)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    
                                    if let error = loginVM.emailErrorMessage {
                                        Text(error)
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    SecureField("Password", text: $loginVM.password)
                                        .textContentType(.password)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                }
                                
                                if let error = loginVM.formError {
                                    Text(error)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 4)
                                }
                                
                                Button {
                                    Task {
                                        await loginVM.login()
                                        if loginVM.isLoginSuccess {
                                            isLoggedIn = true
                                        }
                                    }
                                } label: {
                                    Text("Log in")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            Color.accentColor
                                                .opacity(loginVM.isFormValid ? 1.0 : 0.5)
                                        )
                                        .cornerRadius(12)
                                }
                                .disabled(!loginVM.isFormValid)
                                .navigationDestination(isPresented: $isLoggedIn) {
                                    RootView()
                                }
                                
                                Button("Forgot Password?") {
                                    showingForgotPassword = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            
                            HStack(spacing: 16) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.3))
                                
                                Text("or")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            .padding(.vertical, 8)
                            
                        
                            VStack(spacing: 12) {
                                GoogleSignInButton {
                                    Task {
                                        do {
                                            try await loginVM.signInGoogle()
                                            isLoggedIn = true
                                        } catch {
                                            loginVM.formError = "Google sign-in failed. Please try again"
                                        }
                                    }
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                
                                Button {
                                    loginVM.formError = "Coming Soon!"
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "apple.logo")
                                            .font(.title3)
                                        
                                        Text("Sign in with Apple")
                                            .font(.headline)
                                    }
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(.secondary)
                                
                                NavigationLink("Sign up") {
                                    RegisterView()
                                }
                                .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                            .padding(.top, 8)
                        }
                        .padding(24)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 24)
                    }
                }
                
                .alert("Reset Password", isPresented: $showingForgotPassword) {
                    TextField("Email", text: $resetEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
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
