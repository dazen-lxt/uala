//
//  CityMapView.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 26/03/25.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    
    let city: City
    @State private var position: MapCameraPosition

    init(city: City) {
        self.city = city
        let coordinate = CLLocationCoordinate2D(
            latitude: city.coord.lat,
            longitude: city.coord.lon)
        _position = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            )
        )
    }

    var body: some View {
        Map(position: $position) {
            Marker(
                city.name,
                coordinate: CLLocationCoordinate2D(
                    latitude: city.coord.lat,
                    longitude: city.coord.lon
                )
            )
        }
        .accessibilityIdentifier("cityMap")
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
