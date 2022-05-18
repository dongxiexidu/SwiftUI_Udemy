//
//  MapView.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/17.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region: MKCoordinateRegion = {
        var mapCoordinates = CLLocationCoordinate2D(latitude: 6.600286, longitude: 16.4377599)
        var mapZoomLevel = MKCoordinateSpan(latitudeDelta: 70.0, longitudeDelta: 70.0)
        var mapRegion = MKCoordinateRegion(center: mapCoordinates, span: mapZoomLevel)
        return mapRegion
    }()
    
    let locations:[NationalParkLocation] = Bundle.main.decode("locations.json")
    var body: some View {
        // MARK: No1 BASIC MAP
        Map(coordinateRegion: $region, annotationItems: locations, annotationContent: {
            item in
            // Map PIN: OLD STYLE
            // MapPin(coordinate: item.location, tint: .accentColor)
            
            // MAP MARKER: NEW STYLE
            // MapMarker(coordinate: item.location, tint: .accentColor)
            
            // Custom Map Marker done
            MapAnnotation(coordinate: item.location) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32, alignment: .center)
            }
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
