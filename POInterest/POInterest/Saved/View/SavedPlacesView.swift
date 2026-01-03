//
//  SavedPlacesView.swift
//  POInterest
//
//  Created by Davit Muradyan on 27.11.25.
//

import SwiftUI

struct SavedPlacesView: View {
    @EnvironmentObject var savedPlacesVM: SavedPlacesViewModel
    @State var selectedPlace: PlaceModel?
    
    var body: some View {
        ScrollView {
            if !savedPlacesVM.hasFetchedPlaces {
                ProgressView("Fetching Saved Places...")
                    .font(.headline)
                    .frame(maxHeight: .infinity, alignment: .center)
            } else if savedPlacesVM.savedPlaces.isEmpty {
                ContentUnavailableView("Nothing has been saved yet", systemImage: "bookmark.slash").font(.headline)
            } else {
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
                                    HStack {
                                        Text(place.name ?? "Place")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding()
                                        
                                        Spacer()
                                        
                                        Circle()
                                            .fill(place.distance <= MetricManager.shared.searchRadius ? .green : .red)
                                            .frame(width: 12, height: 12)
                                            .padding(.horizontal)
                                        
                                    }
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
                                            .font(.title)
                                        
                                        Text(place.location ?? "Unknown")
                                            .font(.caption)
                                            .lineLimit(2)
                                        
                                        Spacer()
                                        
                                        Button("See More") {
                                            selectedPlace = place
                                        }
                                        .font(.caption)
                                    }
                                    .padding(.horizontal, 15)
                                }
                                .shadow(color: .secondary.opacity(0.3), radius: 10)
                                
                            }
                            .onTapGesture {
                                selectedPlace = place
                            }
                        }
                    }
                    .sheet(item: $selectedPlace) { place in
                        if let index = savedPlacesVM.savedPlaces.firstIndex(where: { $0.id == place.id }) {
                            DetailView(place: $savedPlacesVM.savedPlaces[index])
                                .presentationDragIndicator(.visible)
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
        }
        .onAppear {
            Task {
                await savedPlacesVM.getSavedPlaces()
            }
        }
        .onChange(of: savedPlacesVM.savedPlaces) { oldValue, newValue in
            Task {
                await savedPlacesVM.getSavedPlaces()
            }
            
        }
    }
}
