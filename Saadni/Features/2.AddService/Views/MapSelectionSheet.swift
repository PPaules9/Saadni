//
//  MapSelectionSheet.swift
//  Saadni
//
//  Created by Pavly Paules on 23/02/2026.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Map Selection Sheet
struct MapSelectionSheet: View {
 @Binding var mapPosition: MapCameraPosition
 @Binding var selectedLocation: CLLocationCoordinate2D?
 @Binding var selectedLocationName: String
 @Binding var position: String
 @Environment(\.dismiss) var dismiss

 @State private var searchText: String = ""
 @State private var selectedCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025)
 @State private var locationName: String = ""
 @State private var searchResults: [MKMapItem] = []
 @State private var showSearchResults: Bool = false
 @State private var isSearching: Bool = false
 @State private var mapCenterCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025)

 var body: some View {
  NavigationStack {
   ZStack {
    VStack(spacing: 12) {
     // Search Field
     VStack(alignment: .leading, spacing: 8) {
      HStack {
       BrandTextField(
        hasTitle: false,
        title: "Location",
        placeholder: "Search location...",
        text: $searchText
       )

       if !searchText.isEmpty {
        Button(action: { searchText = "" }) {
         Image(systemName: "xmark.circle.fill")
          .foregroundStyle(.gray)
        }
       }
      }

      if showSearchResults && !searchResults.isEmpty {
       VStack(alignment: .leading, spacing: 8) {
        ForEach(searchResults, id: \.self) { result in
         Button(action: {
          selectedCoordinate = result.placemark.coordinate
          locationName = result.name ?? "Unknown Location"
          searchText = locationName
          showSearchResults = false
          updateMapPosition()
         }) {
          HStack {
           VStack(alignment: .leading, spacing: 4) {
            Text(result.name ?? "Unknown")
             .font(.subheadline)
             .foregroundStyle(.primary)
            Text(result.placemark.title ?? "")
             .font(.caption)
             .foregroundStyle(.gray)
             .lineLimit(1)
           }
           Spacer()
           Image(systemName: "mappin")
            .foregroundStyle(.accent)
          }
          .padding(8)
          .background(Color(.systemGray6))
          .cornerRadius(8)
         }
        }
       }
       .padding(8)
       .background(Color(.systemGray5).opacity(0.5))
       .cornerRadius(12)
      }
     }
     .padding(.horizontal, 20)
     .padding(.top, 12)

     // Map View with Center Pin
     ZStack(alignment: .center) {
      Map(position: $mapPosition)
       .mapStyle(.standard)
       .onMapCameraChange { context in
        mapCenterCoordinate = context.region.center
        selectedCoordinate = context.region.center
        reverseGeocodeLocation(context.region.center)
       }

      // Center Pin Indicator
      VStack(spacing: 0) {
       Image(systemName: "mappin.circle.fill")
        .font(.system(size: 40))
        .foregroundStyle(.accent)
        .shadow(radius: 4)
      }

      VStack(alignment: .trailing, spacing: 8) {
       Link("Legal", destination: URL(string: "https://www.apple.com")!)
        .font(.caption)
        .foregroundStyle(.blue)
        .padding(12)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
      .padding(12)
     }
     .frame(maxHeight: .infinity)

     // Location Info & Confirm Button
     VStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 4) {
       if !locationName.isEmpty {
        Text("Location: \(locationName)")
         .font(.subheadline)
         .foregroundStyle(.primary)
       }

       Text("Lat: \(selectedCoordinate.latitude, specifier: "%.4f")")
        .font(.caption2)
        .foregroundStyle(Colors.swiftUIColor(.textSecondary))

       Text("Long: \(selectedCoordinate.longitude, specifier: "%.4f")")
        .font(.caption2)
        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Button(action: {
       selectedLocation = selectedCoordinate
       position = locationName.isEmpty ? String(format: "%.4f, %.4f", selectedCoordinate.latitude, selectedCoordinate.longitude) : locationName
       dismiss()
      }) {
       Text("Confirm Location")
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.accent)
        .cornerRadius(12)
        .foregroundStyle(.white)
      }
     }
     .padding(.horizontal, 20)
     .padding(.bottom, 20)
    }
   }
   .navigationTitle("Select Location")
   .navigationBarTitleDisplayMode(.inline)
   .toolbar {
    ToolbarItem(placement: .topBarLeading) {
     Button(action: { dismiss() }) {
      Text("Cancel")
       .foregroundStyle(.accent)
     }
    }
   }
  }
  .onChange(of: searchText) { oldValue, newValue in
   if !newValue.isEmpty {
    searchLocation(newValue)
   } else {
    searchResults = []
    showSearchResults = false
   }
  }
 }

 private func updateMapPosition() {
  mapPosition = .region(
   MKCoordinateRegion(
    center: selectedCoordinate,
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
   )
  )
 }

 private func searchLocation(_ query: String) {
  let searchRequest = MKLocalSearch.Request()
  searchRequest.naturalLanguageQuery = query
  searchRequest.region = MKCoordinateRegion(
   center: selectedCoordinate,
   span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
  )

  let search = MKLocalSearch(request: searchRequest)
  search.start { response, error in
   if let response = response {
    DispatchQueue.main.async {
     searchResults = response.mapItems
     showSearchResults = !response.mapItems.isEmpty
     isSearching = false
    }
   } else {
    DispatchQueue.main.async {
     searchResults = []
     showSearchResults = false
     isSearching = false
    }
   }
  }
 }

 private func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D) {
  let geocoder = CLGeocoder()
  let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

  geocoder.reverseGeocodeLocation(location) { placemarks, error in
   if let placemark = placemarks?.first {
    DispatchQueue.main.async {
     let address = [
      placemark.name,
      placemark.locality,
      placemark.administrativeArea
     ]
     .compactMap { $0 }
     .joined(separator: ", ")

     locationName = address.isEmpty ? "Unknown Location" : address
    }
   }
  }
 }
}


