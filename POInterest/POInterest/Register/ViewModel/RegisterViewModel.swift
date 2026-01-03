//
//  RegisterViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var name = ""
    @Published var password = ""
    
    @Published var emailErrorMessage: String?
    @Published var nameErrorMessage: String?
    @Published var passwordErrorMessage: String?
    @Published var formError: String?

    @Published var isRegisterSuccess = false
    
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    var isFormValid: Bool {
        isNameValid(name) && isEmailValid(email) && isPasswordSecure(password)
    }
    
    init() {
        $name
            .map { [weak self] name in
                guard let self = self else { return nil }
                guard !name.isEmpty else { return nil }
                return self.isNameValid(name) ? nil : "Name must be 2-50 characters and contain only letters, spaces, hyphens, or apostrophes."
            }
            .sink { [weak self] in self?.nameErrorMessage = $0 }
            .store(in: &cancellables)
        
        $email
            .map { [weak self] email in
                guard let self = self else { return nil }
                guard !email.isEmpty else { return nil }
                return self.isEmailValid(email) ? nil : "Please enter a valid email address."
            }
            .sink { [weak self] in self?.emailErrorMessage = $0 }
            .store(in: &cancellables)
        
        $password
            .map { [weak self] password in
                guard let self = self else { return nil }
                guard !password.isEmpty else { return nil }
                return self.isPasswordSecure(password) ? nil : "Password must be 8+ characters with uppercase, lowercase, number, and special character."
            }
            .sink { [weak self] in self?.passwordErrorMessage = $0 }
            .store(in: &cancellables)
    }
    
    func signUp() async {
        guard isFormValid else {
            nameErrorMessage = name.isEmpty ? "Name is required." : nameErrorMessage
            emailErrorMessage = email.isEmpty ? "Email is required." : emailErrorMessage
            passwordErrorMessage = password.isEmpty ? "Password is required." : passwordErrorMessage
            formError = "Please fix the errors above."
            return
            
        }
        
        formError = nil
        isLoading = true
        do {
            let returnedUser = try await AuthManager.shared.createUser(
                email: email,
                password: password,
                name: name
            )
            isRegisterSuccess = true
       
            print("Registration successful for UID: \(returnedUser.uid), Name: \(returnedUser.name ?? "N/A")")
        } catch {
            formError = "This email is already registered."
        }
    }
    
     func isNameValid(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        let nameRegex = /^[A-Za-zÀ-ÿ\s'-]{2,50}$/
        return !trimmed.isEmpty && trimmed.wholeMatch(of: nameRegex) != nil
    }
    
     func isEmailValid(_ email: String) -> Bool {
        let emailRegex = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$/
        return email.wholeMatch(of: emailRegex) != nil
    }
    
     func isPasswordSecure(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecial = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil
        
        return hasUppercase && hasLowercase && hasNumber && hasSpecial
    }
}
