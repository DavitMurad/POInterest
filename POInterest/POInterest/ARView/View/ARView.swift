//
//  ARView.swift
//  POInterest
//
//  Created by Davit Muradyan on 08.11.25.
//

import SwiftUI

struct ARView: View {
    @StateObject var arVM = ARViewModel()
    @State private var showingList = false
    
    var body: some View {
        ZStack {
            if let _ = arVM.userLocation {
                ARSceneViewContainer(
                    locationManager: arVM.locationManager,
                    places: arVM.places
                )
                .edgesIgnoringSafeArea(.all)
            } else {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        Text("Waiting for location...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
            }
            
            // Top overlay with category filter
            VStack {
                CategoryFilterBarView(arVM: arVM)
       
                    .padding()
                
                Spacer()
                
                HStack {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("\(arVM.places.count) places")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    
                    Spacer()
                    
                    // Toggle list view button
                    Button(action: {
                        if !arVM.places.isEmpty {
                            showingList.toggle()
                        }
                        
                    }) {
                        Image(systemName: showingList ? "camera.fill" : "list.bullet")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding()
                
                if showingList {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showingList = false
                        }
                    
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Nearby Places")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: { showingList = false }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                    }
                    .sheet(isPresented: $showingList) {
                        List {
                            ForEach(arVM.places) { place in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(place.name ?? "Unknown")
                                            .font(.headline)
                                        Text(place.location ?? "Unknown")
                                            .font(.caption)
                                        
                                    }
                                    Spacer()
                                    Text("\(place.distance, specifier: "%.1f") m")
                                        .font(.caption)
                                }
                                .padding(.horizontal)
                                
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
            }
            .onAppear {
                arVM.startTracking()
            }
            .onDisappear {
                arVM.stopTracking()
            }
            .onChange(of: arVM.selectedFilterCategoy) { oldValue, newValue in
                print("Filter changed, refreshing places")
                arVM.manualRefresh()
            }
        }
    }
}

//#Preview {
//    ARView()
//}
