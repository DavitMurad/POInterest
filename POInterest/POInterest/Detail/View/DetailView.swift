//
//  DetailView.swift
//  POInterest
//
//  Created by Davit Muradyan on 02.12.25.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @State var place: PlaceModel
    
    @State var mapRegion = MapCameraPosition.automatic
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Image(place.imageName ?? "Unknown")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                    
                    
                    Button("View on the map") {
                        
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    
                    .padding()
                    
                }
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Image(systemName: "cup.and.saucer")
                            .font(.title)
                        Text(place.name ?? "Unknown")
                            .font(.title2)
                        
                        Spacer()
                        Text("\(place.distance, specifier: "%.1f") m")
                            .font(.title2)
                    }
            
                    Text(place.location ?? "Unknown")
                        .font(.caption)
                    
                    AdditionalDataView(place: $place)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Map(position: $mapRegion) {
                    Annotation(place.name ?? "Unknown", coordinate: place.coordinates) {
                        Image(systemName: "mappin")
                            .font(.title)
                            .foregroundStyle(.primary)
                            .shadow(radius: 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .padding()
            }
            
        }
        .onAppear {
            let coordinate = place.coordinates
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                
                self.mapRegion = MapCameraPosition.region(region)
        }
    }
}

struct AdditionalDataView: View {
    @Binding var place: PlaceModel

    var additionalData: [String: String] {
        var data: [String: String] = [:]
        if let phone = place.phone { data["Phone"] =  phone }
        if let url = place.url { data["URL"] = url }
        return data
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(additionalData.sorted(by: >), id: \.key) { key, value in
                Section(header: Text(key)) {
                    Rectangle()
                        .fill(.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 0.5)
                    if key == "Phone" {
                        Link(value, destination: URL(string: "tel::" + value)!)
                            .font(.caption)
                    } else {
                        Link(value, destination: URL(string: value)!)
                            .font(.caption)
                    }
                  
                }
//                .padding(.vertical, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}

//
//#Preview {
//    let cafe = PlaceModel(
//        id: "cafe_001",
//        name: "The London Brew House",
//        description: "A cozy independent coffee shop serving artisan coffee and homemade pastries.",
//        location: "12 Borough High Street, London SE1 1XX, United Kingdom",
//        imageName: "london_brew_house",
//        category: "Cafe",
//        rating: 4.6,
//        status: true,
//        reviews: [
//            "Great atmosphere and amazing flat white!",
//            "Lovely staff and delicious pastries.",
//            "Perfect place to work or relax."
//        ],
//        phone: "+44 20 7946 1234",
//        url: "https://www.thelondonbrewhouse.co.uk",
//        coordinates: CLLocationCoordinate2D(latitude: 51.5055, longitude: -0.0922),
//        distance: 80
//    )
//    
//    DetailView(place: cafe)
//}
