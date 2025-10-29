//
//  LoginView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

struct LoginView: View {
    @State var firstname = ""
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
                            TextField("Email", text: $firstname)
                                .customTextFieldStyle()
                            TextField("Password", text: $firstname)
                                .customTextFieldStyle()
                            
                            NavigationLink("Log in", destination: {
                                UnitsView()
                            })
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
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
        
    }
}

#Preview {
    LoginView()
}
