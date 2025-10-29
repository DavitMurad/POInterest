//
//  RegisterView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

struct RegisterView: View {
    @State var firstname = ""
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
                            TextField("Name", text: $firstname)
                                .customTextFieldStyle()
                            TextField("Email", text: $firstname)
                                .customTextFieldStyle()
                            TextField("Password", text: $firstname)
                                .customTextFieldStyle()
                            
                            Button("Register") {
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
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
                            
//                            NavigationLink("Already have an account?", destination: {
//                                
//                            })
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                          
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
