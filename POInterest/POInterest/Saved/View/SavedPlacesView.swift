//
//  SavedPlacesView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.11.25.
//

import SwiftUI

struct SavedPlacesView: View {
    @EnvironmentObject var savedPlacesVM: SavedPlacesViewModel
    @State var selectedPlaceIndex: Int?
    var body: some View {
        ScrollView {
            if savedPlacesVM.savedPlaces.isEmpty {
                Group {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Fetching Saved Places...")
                }
                .frame(maxHeight: .infinity, alignment: .center)
               
            }
            VStack(spacing: 15) {
                ForEach(Array(savedPlacesVM.savedPlaces.enumerated()), id: \.element.id) { index, place in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.thickMaterial)
                            .frame(height: 200)
                        
                        Image(place.imageName ?? "Default")
                            .resizable()
                            .scaledToFill()
                            .clipShape(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 5,
                                    bottomLeadingRadius: 5,
                                    bottomTrailingRadius: 5,
                                    topTrailingRadius: 5,
                                    style: .circular
                                )
                            )
                        
                        
                        VStack(spacing: 0) {
                            UnevenRoundedRectangle(
                                topLeadingRadius: 5,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 5,
                                style: .circular
                            )
                            .fill(.black.opacity(0.5))
                            
                            .overlay(alignment: .topLeading) {
                                Text(place.name ?? "Place")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                            
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 5,
                                bottomTrailingRadius: 5,
                                topTrailingRadius: 0,
                                style: .circular
                            )
                            .fill(.background)
                            .frame(height: 60)
                            .overlay {
                                HStack {
                                    Image(systemName: place.iconName)
                                        .font(.headline)
                                    
                                    Text(place.location ?? "Unknown")
                                        .font(.caption)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                    
                                    Button("See More") {}
                                        .font(.caption)
                                }
                                .padding(.horizontal, 15)
                            }
                        }
                        .onTapGesture {
                            selectedPlaceIndex = index
                        }
                    }
                    
                }
                .sheet(item: Binding(
                    get: { selectedPlaceIndex.map { savedPlacesVM.savedPlaces[$0] } },
                    set: { _ in selectedPlaceIndex = nil }
                )) { _ in
                    if let index = selectedPlaceIndex {
                        DetailView(place: $savedPlacesVM.savedPlaces[index])
                    }
                }
//                .refreshable {
//                    await savedPlacesVM.getSavedPlaces()
//                }
                
            }
            .padding()
            .onAppear {
                Task {
                    await savedPlacesVM.getSavedPlaces()
                }
            }
            
        }
    }
}


//#Preview {
//    SavedPlacesView()
//}
