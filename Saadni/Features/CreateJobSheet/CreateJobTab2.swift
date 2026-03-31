//
//  CreateJobTab2.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Tab 2 View

struct CreateJobTab2: View {
	@Bindable var viewModel: CreateJobViewModel
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 24) {
				Text("Location Details")
					.font(.headline)
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				// City (auto-filled from map)
				VStack(alignment: .leading, spacing: 8) {
					HStack(spacing: 4) {
						Text("City")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						Text("*").foregroundStyle(.red)
					}
					BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Cairo", text: $viewModel.city)
				}
				
				// Address Type Picker
				VStack(alignment: .leading, spacing: 8) {
					HStack(spacing: 4) {
						Text("Address Type")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						Text("*").foregroundStyle(.red)
					}
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 8) {
							ForEach(["Company", "Home", "Office", "Hotel", "Other"], id: \.self) { option in
								let isSelected = viewModel.addressLabel == option
								Button(action: { viewModel.addressLabel = option }) {
									HStack(spacing: 6) {
										Image(systemName: addressTypeIcon(option))
											.font(.caption)
										Text(option)
											.font(.subheadline)
											.fontWeight(isSelected ? .semibold : .regular)
									}
									.padding(.horizontal, 14)
									.padding(.vertical, 9)
									.background(isSelected ? Color.accent : Colors.swiftUIColor(.textPrimary))
									.foregroundStyle(isSelected ? .white : Colors.swiftUIColor(.textSecondary))
									.clipShape(Capsule())
									.overlay(
										Capsule()
											.stroke(isSelected ? Color.clear : Colors.swiftUIColor(.textSecondary).opacity(0.3), lineWidth: 1)
									)
								}
							}
						}
						.padding(.vertical, 2)
					}
					if viewModel.addressLabel == "Other" {
						BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Gym, Studio, Warehouse", text: $viewModel.addressLabelCustom)
							.transition(.opacity.combined(with: .move(edge: .top)))
					}
				}
				.animation(.easeInOut(duration: 0.2), value: viewModel.addressLabel)
				
				// Address (auto-filled from map)
				VStack(alignment: .leading, spacing: 8) {
					HStack(spacing: 4) {
						Text("Full Address")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						Text("*").foregroundStyle(.red)
					}
					BrandTextField(hasTitle: false, title: "", placeholder: "Street, Building, Floor", text: $viewModel.address)
				}
				
				// Map Section
				VStack(spacing: 12) {
					HStack(spacing: 4) {
						Text("Pinpoint on Map")
							.font(.headline)
							.fontWeight(.semibold)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					
					Button(action: { viewModel.showMapSheet = true }) {
						HStack {
							Image(systemName: "map.fill")
								.foregroundStyle(Color.accent)
							Text(viewModel.selectedLocation != nil ? "Location Selected" : "Tap to open map")
								.font(.subheadline)
								.fontWeight(viewModel.selectedLocation != nil ? .semibold : .regular)
								.foregroundStyle(viewModel.selectedLocation != nil ? Color.accent : Colors.swiftUIColor(.textSecondary))
							Spacer()
							if viewModel.selectedLocation != nil {
								Image(systemName: "checkmark.circle.fill")
									.foregroundStyle(.green)
							} else {
								Image(systemName: "chevron.right")
									.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							}
						}
						.padding()
						.background(viewModel.selectedLocation != nil ? Color.accent.opacity(0.1) : Colors.swiftUIColor(.textPrimary))
						.cornerRadius(12)
					}
				}
				
				Spacer()
			}
			.padding()
		}
		.sheet(isPresented: $viewModel.showMapSheet) {
			MapSelectionView(viewModel: viewModel)
		}
	}
}

private func addressTypeIcon(_ type: String) -> String {
	switch type {
	case "Company": return "building.2.fill"
	case "Home":    return "house.fill"
	case "Office":  return "briefcase.fill"
	case "Hotel":   return "bed.double.fill"
	default:        return "mappin.circle.fill"
	}
}

// MARK: - Map Selection View

struct MapSelectionView: View {
	@Bindable var viewModel: CreateJobViewModel
	@Environment(\.dismiss) var dismiss
	@State private var locationManager = MapLocationManager()
	@State private var searchCompleter = LocationSearchCompleter()
	
	@State private var isSearching = false
	@State private var searchText = ""
	@State private var detectedAddress = ""
	@State private var detectedCity = ""
	@State private var isGeocoding = false
	@FocusState private var isSearchFocused: Bool
	
	var body: some View {
		NavigationStack {
			ZStack {
				// MARK: Map
				mapLayer
				
				// MARK: Search overlay
				if isSearching {
					searchOverlay
						.transition(.opacity)
				}
			}
			.navigationTitle("Select Location")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button { dismiss() } label: {
						Image(systemName: "xmark")
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					}
				}
			}
			.animation(.easeInOut(duration: 0.2), value: isSearching)
			.onAppear {
				locationManager.onLocationUpdate = { coord in
					moveMap(to: coord)
				}
			}
		}
	}
	
	// MARK: - Map Layer
	
	private var mapLayer: some View {
		ZStack(alignment: .bottom) {
			// Map
			Map(position: $viewModel.mapPosition) {}
				.onMapCameraChange(frequency: .onEnd) { context in
					let coord = context.region.center
					viewModel.selectedLocation = coord
					reverseGeocode(coord)
				}
				.ignoresSafeArea(edges: .bottom)
			
			// Fixed center pin
			VStack {
				Spacer()
					.frame(height: UIScreen.main.bounds.height * 0.35)
				ZStack(alignment: .bottom) {
					// Tooltip
					VStack(spacing: 4) {
						Text("Your job location will be here")
							.font(.caption)
							.fontWeight(.semibold)
							.foregroundStyle(.white)
						Text("Drag the map to adjust the pin")
							.font(.caption2)
							.foregroundStyle(.white.opacity(0.85))
					}
					.padding(.horizontal, 14)
					.padding(.vertical, 8)
					.background(Color.black.opacity(0.75))
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.offset(y: -48)
					
					// Pin
					Image(systemName: "mappin.circle.fill")
						.font(.system(size: 36))
						.foregroundStyle(Color.accent)
						.shadow(radius: 4)
				}
				Spacer()
			}
			.allowsHitTesting(false)
			
			// Tappable search bar on map (opens overlay)
			VStack {
				mapSearchButton
					.padding(.horizontal)
					.padding(.top, 8)
				Spacer()
			}
			
			// Bottom panel
			VStack(spacing: 0) {
				Divider()
				bottomPanel
					.background(Colors.swiftUIColor(.surfaceWhite))
			}
			
			// Locate me button
			HStack {
				Spacer()
				locateMeButton
					.padding(.trailing, 16)
					.padding(.bottom, 130)
			}
		}
	}
	
	// MARK: - Map Search Button (tap target, opens overlay)
	
	private var mapSearchButton: some View {
		Button { isSearching = true } label: {
			HStack(spacing: 10) {
				Image(systemName: "magnifyingglass")
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				Text("Search Location")
					.font(.subheadline)
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				Spacer()
			}
			.padding(12)
			.background(Color(.systemGray6))
			.clipShape(RoundedRectangle(cornerRadius: 12))
		}
	}
	
	// MARK: - Overlay Search Bar (real TextField with focus)
	
	private var overlaySearchBar: some View {
		HStack(spacing: 10) {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(Colors.swiftUIColor(.textSecondary))
			TextField("Search Location", text: $searchText)
				.font(.subheadline)
				.focused($isSearchFocused)
				.onChange(of: searchText) { _, newValue in
					searchCompleter.search(query: newValue)
				}
			if !searchText.isEmpty {
				Button { searchText = "" } label: {
					Image(systemName: "xmark.circle.fill")
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
			}
			Button("Cancel") {
				searchText = ""
				isSearching = false
				isSearchFocused = false
			}
			.font(.subheadline)
			.foregroundStyle(Color.accent)
		}
		.padding(12)
		.background(Color(.systemGray6))
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}
	
	// MARK: - Search Overlay
	
	private var searchOverlay: some View {
		ZStack {
			Colors.swiftUIColor(.surfaceWhite)
				.ignoresSafeArea()
			
			VStack(spacing: 0) {
				overlaySearchBar
					.padding(.horizontal)
					.padding(.top, 8)
					.padding(.bottom, 8)
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
							isSearchFocused = true
						}
					}
				
				Divider()
				
				ScrollView {
					VStack(spacing: 0) {
						// Results
						ForEach(searchCompleter.results, id: \.self) { result in
							Button {
								selectSearchResult(result)
							} label: {
								HStack(spacing: 14) {
									Image(systemName: "mappin")
										.foregroundStyle(Colors.swiftUIColor(.textSecondary))
										.frame(width: 24)
									VStack(alignment: .leading, spacing: 2) {
										Text(result.title)
											.font(.subheadline)
											.foregroundStyle(Colors.swiftUIColor(.textMain))
										if !result.subtitle.isEmpty {
											Text(result.subtitle)
												.font(.caption)
												.foregroundStyle(Colors.swiftUIColor(.textSecondary))
										}
									}
									Spacer()
								}
								.padding(.horizontal, 20)
								.padding(.vertical, 14)
							}
							Divider().padding(.leading, 58)
						}
						
						// Use current location
						Button {
							isSearching = false
							searchText = ""
							locationManager.requestLocation()
						} label: {
							HStack(spacing: 14) {
								Image(systemName: "location.fill")
									.foregroundStyle(Color.accent)
									.frame(width: 24)
								Text("Use my current location")
									.font(.subheadline)
									.foregroundStyle(Color.accent)
								Spacer()
							}
							.padding(.horizontal, 20)
							.padding(.vertical, 14)
						}
						Divider().padding(.leading, 58)
						
						// Select from map
						Button {
							isSearching = false
							searchText = ""
							UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
						} label: {
							HStack(spacing: 14) {
								Image(systemName: "map.fill")
									.foregroundStyle(Color.accent)
									.frame(width: 24)
								Text("Select location from map")
									.font(.subheadline)
									.foregroundStyle(Color.accent)
								Spacer()
							}
							.padding(.horizontal, 20)
							.padding(.vertical, 14)
						}
					}
				}
			}
		}
	}
	
	// MARK: - Bottom Panel
	
	private var bottomPanel: some View {
		VStack(spacing: 12) {
			HStack(spacing: 12) {
				Image(systemName: "mappin.circle.fill")
					.font(.title2)
					.foregroundStyle(Color.accent)
				
				VStack(alignment: .leading, spacing: 2) {
					Text("Location Zone")
						.font(.caption)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					if isGeocoding {
						Text("Detecting...")
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					} else {
						Text(detectedCity.isEmpty ? "Move pin to detect location" : detectedCity)
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
					}
				}
				Spacer()
			}
			
			Button {
				viewModel.city = detectedCity
				viewModel.address = detectedAddress
				dismiss()
			} label: {
				Text("Confirm Location")
					.font(.headline)
					.fontWeight(.semibold)
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 16)
					.background(detectedCity.isEmpty ? Color.gray : Color.accent)
					.clipShape(RoundedRectangle(cornerRadius: 14))
			}
			.disabled(detectedCity.isEmpty)
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 16)
		.padding(.bottom, 8)
	}
	
	// MARK: - Locate Me Button
	
	private var locateMeButton: some View {
		Button {
			locationManager.requestLocation()
		} label: {
			HStack(spacing: 6) {
				Image(systemName: "location.fill")
					.font(.subheadline)
				Text("Locate me")
					.font(.subheadline)
					.fontWeight(.medium)
			}
			.foregroundStyle(Colors.swiftUIColor(.textMain))
			.padding(.horizontal, 14)
			.padding(.vertical, 10)
			.background(Colors.swiftUIColor(.surfaceWhite))
			.clipShape(Capsule())
			.shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 2)
		}
	}
	
	// MARK: - Helpers
	
	private func moveMap(to coord: CLLocationCoordinate2D) {
		viewModel.mapPosition = .region(
			MKCoordinateRegion(
				center: coord,
				span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
			)
		)
		viewModel.selectedLocation = coord
		reverseGeocode(coord)
	}
	
	private func reverseGeocode(_ coord: CLLocationCoordinate2D) {
		isGeocoding = true
		let geocoder = CLGeocoder()
		let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
		geocoder.reverseGeocodeLocation(location) { placemarks, _ in
			DispatchQueue.main.async {
				isGeocoding = false
				if let placemark = placemarks?.first {
					detectedCity = [placemark.locality, placemark.administrativeArea]
						.compactMap { $0 }
						.joined(separator: ", ")
					detectedAddress = [
						placemark.thoroughfare,
						placemark.subThoroughfare,
						placemark.subLocality,
						placemark.locality
					]
						.compactMap { $0 }
						.joined(separator: ", ")
				}
			}
		}
	}
	
	private func selectSearchResult(_ result: MKLocalSearchCompletion) {
		let request = MKLocalSearch.Request(completion: result)
		let search = MKLocalSearch(request: request)
		search.start { response, _ in
			guard let item = response?.mapItems.first else { return }
			let coord = item.placemark.coordinate
			DispatchQueue.main.async {
				isSearching = false
				searchText = ""
				UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
				moveMap(to: coord)
			}
		}
	}
}

// MARK: - Location Manager

@Observable
final class MapLocationManager {
	var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
	private let adapter = LocationManagerAdapter()
	
	init() {
		adapter.onLocationUpdate = { [weak self] coord in
			self?.onLocationUpdate?(coord)
		}
	}
	
	func requestLocation() {
		adapter.requestLocation()
	}
}

private final class LocationManagerAdapter: NSObject, CLLocationManagerDelegate {
	private let manager = CLLocationManager()
	var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
	
	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
	}
	
	func requestLocation() {
		let status = manager.authorizationStatus
		if status == .notDetermined {
			manager.requestWhenInUseAuthorization()
		} else if status == .authorizedWhenInUse || status == .authorizedAlways {
			manager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let coord = locations.first?.coordinate else { return }
		DispatchQueue.main.async { self.onLocationUpdate?(coord) }
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if manager.authorizationStatus == .authorizedWhenInUse ||
				manager.authorizationStatus == .authorizedAlways {
			manager.requestLocation()
		}
	}
}

// MARK: - Search Completer

@Observable
final class LocationSearchCompleter {
	var results: [MKLocalSearchCompletion] = []
	private let adapter = SearchCompleterAdapter()
	
	init() {
		adapter.onResults = { [weak self] results in
			self?.results = results
		}
	}
	
	func search(query: String) {
		adapter.search(query: query)
	}
}

private final class SearchCompleterAdapter: NSObject, MKLocalSearchCompleterDelegate {
	private let completer = MKLocalSearchCompleter()
	var onResults: (([MKLocalSearchCompletion]) -> Void)?
	
	override init() {
		super.init()
		completer.delegate = self
		completer.resultTypes = [.address, .pointOfInterest]
		completer.region = MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025),
			span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
		)
	}
	
	func search(query: String) {
		if query.isEmpty {
			onResults?([])
		} else {
			completer.queryFragment = query
		}
	}
	
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		DispatchQueue.main.async { self.onResults?(completer.results) }
	}
	
	func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {}
}

#Preview {
	CreateJobTab2(viewModel: CreateJobViewModel())
}
