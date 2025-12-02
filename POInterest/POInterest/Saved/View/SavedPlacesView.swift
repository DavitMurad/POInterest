//
//  SavedPlacesView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.11.25.
//

import SwiftUI

struct SavedPlacesView: View {
    @StateObject var savedPlacesVM = SavedPlacesViewModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(savedPlacesVM.savedPlaces, id: \.self) { place in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.thickMaterial)
                            .frame(height: 200)
                        
                        
                        Image("imagesCafe")
                            .resizable()
                            .scaledToFill()
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 5, bottomTrailingRadius: 5, topTrailingRadius: 5, style: .circular))
                        
                        VStack(spacing: 0) {
                            UnevenRoundedRectangle(topLeadingRadius: 5, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 5, style: .circular)
                                .fill(.black.opacity(0.5))
                                .overlay(alignment: .topLeading) {
                                    Text("Blacksheep")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding()
                                }
                            
                            UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 5, bottomTrailingRadius: 5, topTrailingRadius: 0, style: .circular)
                                .fill(.background)
                                .frame(height: 60)
                                .overlay {
                                    HStack {
                                        Image(systemName: "cup.and.saucer")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                        
                                            .background(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(.background)
                                                    .frame(width: 50, height: 50)
                                                
                                                
                                            )
                                        
                                        VStack {
                                            Text("50 Sauchiehall Street, Glasgow G2 3AH, Scotland")
                                                .font(.caption)
                                                .multilineTextAlignment(.leading)
                                                .minimumScaleFactor(0.8)
                                                .lineLimit(2)
                                                .frame(width: 200)
                                            
                                        }
                                        .padding(.horizontal)
                                        
                                        Spacer()
                                        Button("See More") {
                                            
                                        }
                                        .font(.caption)
                                        .frame(height: 30)
                                      
                                        
                                    }
                                    .padding(.horizontal, 15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .shadow(color: .secondary.opacity(0.3), radius: 5)
                            
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Saved Places")
    }
}

#Preview {
    SavedPlacesView()
}
