//
//  DetailView.swift
//  POInterest
//
//  Created by Davit Muradyan on 02.12.25.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @Binding var place: PlaceModel
    @State var mapRegion = MapCameraPosition.automatic
    @StateObject var detailVM = DetailViewModel()
    @EnvironmentObject var savedPlacesVM: SavedPlacesViewModel
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Image(place.imageName ?? "Unknown")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                    VStack {
                        Button {
                            openMaps()
                        } label: {
                            Label("View on the map", systemImage: "map")
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.thinMaterial)
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        Spacer()
                        Button {
                            withAnimation {
                                if place.isSaved {
                                    Task {
                                        await savedPlacesVM.removePlace(place: place)
                                    }
                                } else {
                                    Task {
                                        await savedPlacesVM.savePlace(place: place)
                                    }
                                }
                                place.isSaved.toggle()
                            }
                        } label: {
                            Label(
                                place.isSaved ? "Unsave" : "Save",
                                systemImage: place.isSaved ? "bookmark.slash" : "bookmark"
                            )
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.thinMaterial)
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                  

                    }
            
                    .padding()
                }
                .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    HStack {
                        Label(place.name ?? "Unknown", systemImage: place.iconName)
                            .font(.title)
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                        Spacer()
                        Text("\(place.distance, specifier: "%.1f") m")
                            .font(.title2)
                    }
                    Text(place.location ?? "Unknown")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    AdditionalDataView(place: $place)
                    
                }
                .padding()
                
                Map(position: $mapRegion) {
                    Annotation(place.name ?? "Unknown", coordinate: CLLocationCoordinate2D(latitude: place.coordinates.lat, longitude: place.coordinates.long) ) {
                        Image(systemName: "mappin")
                            .font(.title)
                            .foregroundStyle(.primary)
                            .shadow(radius: 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
            }
        }
        .onAppear {
            let coordinate = place.coordinates
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.long) ,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            
            self.mapRegion = MapCameraPosition.region(region)
            
            Task {
                await savedPlacesVM.getSavedPlaces()
                
            }
        }
    }
    
    func openMaps() {
        let searchRequest = MKLocalSearch.Request()
        let coord = CLLocationCoordinate2D(latitude: place.coordinates.lat, longitude: place.coordinates.long)
        searchRequest.naturalLanguageQuery = place.name
        searchRequest.region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response,
                  let mapItem = response.mapItems.first else {
                
                self.openBasicMapItem()
                return
            }
            mapItem.openInMaps(launchOptions: nil)
        }
    }
    
    func openBasicMapItem() {
        let placeMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: place.coordinates.lat, longitude:  place.coordinates.long))
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: nil)
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
                            .minimumScaleFactor(0.8)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}


//#Preview {
//    let cafe = PlaceModel(
//        id: "cafe_001",
//        name: "The London Brew House",
//        description: "A cozy independent coffee shop serving artisan coffee and homemade pastries.",
//        location: "12 Borough High Street, London SE1 1XX, United Kingdom",
//        imageName: "POICafe",
//        iconName: "fork.and.knife", category: "Cafe",
//        phone: "+44 20 7946 1234",
//        url: "https://www.thelondonbrewhouse.co.uk",
//        coordinates: CLLocationCoordinate2D(latitude: 51.5055, longitude: -0.0922),
//        distance: 80
//    )
//
//    DetailView(place: cafe)
//}
