//
//  UnitsView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

struct UnitsView: View {
    @State private var selectedRadius = MetricManager.shared.defaultMeter
    
    var body: some View {
        VStack {
            Form {
                Section("Pick Radius") {
                    Picker("Radius to explore", selection: $selectedRadius) {
                        ForEach(DistanceOptionEnumMeters.allCases, id: \.self) { radius in
                            Text("\(radius.rawValue, specifier: "%.0f") m")
                                .tag(radius.rawValue)
                        }
                    }
                }
            }
            
            NavigationLink {
                RootView()
            } label: {
                Text("Proceed")
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onChange(of: selectedRadius) { oldValue, newValue in
            if let meterValue = DistanceOptionEnumMeters(rawValue: newValue.rawValue) {
                MetricManager.shared.defaultMeter = meterValue
            }
        }
    }
}
//
//#Preview {
//    UnitsView()
//}
