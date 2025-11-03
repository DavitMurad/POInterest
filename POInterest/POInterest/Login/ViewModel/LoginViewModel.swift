//
//  LoginViewModel.swift
//  POInterest
//
//  Created by Davit Muradyan on 03.11.25.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var emailErrorMessage: String?
    @Published var passwordErrorMessage: String?
    @Published var formError: String?
    
    @Published var isLoginSuccess = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var isFormValid: Bool {
        isEmailValid(email) && isPasswordSecure(password)
    }
    
    init() {
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
    
    func login() async {
        guard isFormValid else {
            emailErrorMessage = email.isEmpty ? "Email is required." : emailErrorMessage
            passwordErrorMessage = password.isEmpty ? "Password is required." : passwordErrorMessage
            formError = "Please fix the errors above."
            
            return
        }
        formError = nil
        
        do {
            let user = try await AuthManager.shared.loginUser(email: email, password: password)
            print("Logged in \(user.email)")
            isLoginSuccess = true
        } catch (let error) {
            print(error.localizedDescription)
            formError = "Email is not in our system. Please try again."
        }
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
