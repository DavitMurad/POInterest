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
    @State private var presentMessage = false
    var body: some View {
        ZStack {
            if let _ = arVM.userLocation {
                ARSceneViewContainer(
                    locationManager: arVM.locationManager,
                    places: arVM.places
                )
                .edgesIgnoringSafeArea(.all)
                
                if arVM.selectedFilterCategoy != nil && arVM.places.isEmpty {
                    OnBoardingMessageView(message: "Nothing has been found within")
                } else if arVM.places.isEmpty {
                    OnBoardingMessageView(message: "Please select a category to start within")
                    
                }
            } else {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Waiting for location...")
                    }
                }
            }
            
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
                    
                    Button(action: {
                        if !arVM.places.isEmpty {
                            withAnimation(.easeInOut) {
                                showingList.toggle()
                            }
                            
                        }
                        
                    }) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding()
                
                .sheet(isPresented: $showingList) {
                    PlacesListView()
                        .environmentObject(arVM)
                    
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            presentMessage = true
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



struct PlacesListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var arVM: ARViewModel
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(
                            Circle()
                                .stroke(lineWidth: 1)
                                .fill(.secondary)
                        )
                        .foregroundStyle(.gray)
                }
                .padding()
                
                
                List {
                    ForEach($arVM.places) { $place in
                        NavigationLink(destination: DetailView(place: $place)) {
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
                            
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        
    }
    
}

struct OnBoardingMessageView: View {
    @State var message: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.black.opacity(0.7))
            
            Text("\(message) \(MetricManager.shared.searchRadius, specifier: "%.0f") m")
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: 300, height: 100)
        
    }
}
//Please select a category to start within

//struct EmptyMessageView: View {
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 15)
//                .fill(.black.opacity(0.7))
//
//            Text("Nothing has been found within \(MetricManager.shared.searchRadius, specifier: "%.0f") m")
//                .multilineTextAlignment(.center)
//                .padding()
//        }
//        .frame(width: 300, height: 100)
//
//    }
//}

//#Preview {
//    ARView()
//}
