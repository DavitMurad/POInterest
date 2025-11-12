//
//  ARView.swift
//  POInterest
//
//  Created by Davit Muradyan on 08.11.25.
//

import SwiftUI

struct ARView: View {
    @StateObject var arVM = ARViewModel()
    var body: some View {
        VStack {
            CategoryFilterBarView()
                .padding(.vertical)
            ScrollView {
                if arVM.places.isEmpty {
                    ProgressView("Fetching nearby places...")
                }
                else {
                    ForEach(arVM.places) { place in
                        VStack(spacing: 15) {
                            Text(place.name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text(place.address)
                                Spacer()
                                Text("\(place.distance, specifier: "%.2f") m")
                                
                            }
                            .padding(.trailing)
                            .font(.caption)
                        }
                        .frame(height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
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
