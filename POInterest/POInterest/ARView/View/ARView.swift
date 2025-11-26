//
//  ARView.swift
//  POInterest
//
//  Created by Davit Muradyan on 08.11.25.
//

import SwiftUI

//struct ARView: View {
//    @StateObject var arVM = ARViewModel()
//    @StateObject var categoryFilterVM = CategoryFilterViewModel()
//    var body: some View {
//        VStack {
//            CategoryFilterBarView(arVM: arVM)
//                .padding(.vertical)
//            ScrollView {
//                if arVM.isLoading || arVM.places.isEmpty {
//                    ProgressView("Fetching nearby places...")
//                } else {
//                    ForEach(arVM.places) { place in
//                        VStack(spacing: 15) {
//                            Text(place.name ?? "Hello")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            
//                            HStack {
//                                Text(place.location ?? "Loc")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                Spacer()
//                                Text("\(place.distance, specifier: "%.1f") m")
//                            }
//                            .padding(.trailing)
//                            .font(.caption)
//                            
//                        }
//                        .frame(height: 55)
//                    }
//                    .onChange(of: arVM.selectedFilterCategoy) { oldValue, newValue in
//                        print("Filter changed from \(oldValue ?? "None") to \(newValue ?? "None")")
//                        
//                        arVM.manualRefresh()
//                    }
//                }
//                Spacer()
//            }
//        }
//    }
//}

struct ARView: View {
    @StateObject var arVM = ARViewModel()
    @State private var showingList = false
    
    var body: some View {
        ZStack {
            // AR Camera View
            if let _ = arVM.userLocation {
                ARSceneViewContainer(
                    locationManager: arVM.locationManager,
                    places: arVM.places
                )
                .edgesIgnoringSafeArea(.all)
            } else {
                // Loading state
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
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(15)
                    .padding()
                
                Spacer()
                
                // Bottom controls
                HStack {
                    // Place counter
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
                        showingList.toggle()
                    }) {
                        Image(systemName: showingList ? "camera.fill" : "list.bullet")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    // Refresh button
                    Button(action: {
                        arVM.manualRefresh()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding()
            }
            
            // List overlay
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
                    
                    // List content
                    ScrollView {
                        if arVM.isLoading {
                            ProgressView("Loading places...")
                                .padding()
                        } else if arVM.places.isEmpty {
                            Text("No places found nearby")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(arVM.places) { place in
//                                PlaceRowView(place: place)
                            }
                        }
                    }
                    .background(Color.white)
                }
                .frame(maxHeight: 500)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: showingList)
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

//#Preview {
//    ARView()
//}
