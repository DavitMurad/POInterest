//
//  ARView.swift
//  POInterest
//
//  Created by Davit Muradyan on 08.11.25.
//

import SwiftUI

struct ARView: View {
    @StateObject var arVM = ARViewModel()
    @StateObject var categoryFilterVM = CategoryFilterViewModel()
    var body: some View {
        VStack {
            CategoryFilterBarView(arVM: arVM)
                .padding(.vertical)
            ScrollView {
                if arVM.isLoading || arVM.places.isEmpty {
                    ProgressView("Fetching nearby places...")
                } else {
                    ForEach(arVM.places) { place in
                        VStack(spacing: 15) {
                            Text(place.name ?? "Hello")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text(place.location ?? "Loc")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Text("\(place.distance, specifier: "%.1f") m")
                            }
                            .padding(.trailing)
                            .font(.caption)
                            
                        }
                        .frame(height: 55)
                    }
                    .onChange(of: arVM.selectedFilterCategoy) { oldValue, newValue in
                        print("Filter changed from \(oldValue ?? "None") to \(newValue ?? "None")")
                        
                        arVM.manualRefresh()
                    }
                }
                Spacer()
            }
        }
    }
}

//#Preview {
//    ARView()
//}
