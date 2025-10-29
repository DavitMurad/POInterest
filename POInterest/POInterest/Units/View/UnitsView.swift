//
//  UnitsView.swift
//  POInterest
//
//  Created by Davit Muradyan on 29.10.25.
//

import SwiftUI

struct UnitsView: View {
    @State var notificationsAreEnabled = true
    @State var unitType = "Metrics - m, km,"
    @State var selectedRadius = 50
    let radiusOptions = [50, 100, 150]
    var body: some View {
        VStack {
            Form {
                Section("Pick Units") {
                    
                    Toggle(notificationsAreEnabled ? "Metrics - m, km" : "Units - feet, yard", isOn: $notificationsAreEnabled)
                        
//                    Toggle(unitType, isOn: $notificationsAreEnabled)
//                        .toggleStyle(CustomToggleStyle(
//                            offTrackColor: .green,
//                            offThumbColor: .white
//    
//                        ))
                }
                Section("Pick Radius") {
                    Picker("Radius to explore", selection: $selectedRadius) {
                        ForEach(radiusOptions, id: \.self) { radius in
                            Text("\(radius) m")
                        }
                    }
                }
            }
            NavigationLink("Log in", destination: {
                RootView()
            })
          
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
            
        }
        
    }
}

#Preview {
    UnitsView()
}
