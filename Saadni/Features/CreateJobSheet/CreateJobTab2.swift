//
//  CreateJobTab2.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI
import MapKit

struct CreateJobTab2: View {
    @Bindable var viewModel: CreateJobViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Address Header
                HStack(spacing: 4) {
                    Text("Location Details")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Branch Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Branch Name (Optional)")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Downtown Branch", text: $viewModel.branchName)
                }
                
                // City
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("City")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("*").foregroundStyle(.red)
                    }
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Cairo", text: $viewModel.city)
                }
                
                // Address
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Full Address")
                            .font(.subheadline)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("*").foregroundStyle(.red)
                    }
                    BrandTextField(hasTitle: false, title: "", placeholder: "Street, Building, Floor", text: $viewModel.address)
                }
                
                // Landmark
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nearest Landmark (Optional)")
                        .font(.subheadline)
                        .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                    BrandTextField(hasTitle: false, title: "", placeholder: "e.g., Next to Starbucks", text: $viewModel.nearestLandmark)
                }
                
                // Map Section
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("Pinpoint on Map")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("*").foregroundStyle(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        viewModel.showMapSheet = true
                    }) {
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

struct MapSelectionView: View {
    @Bindable var viewModel: CreateJobViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Map(position: $viewModel.mapPosition) {
                if let coord = viewModel.selectedLocation {
                    Annotation("Selected", coordinate: coord) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.accent)
                    }
                }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                viewModel.selectedLocation = context.region.center
            }
            .overlay(alignment: .center) {
                if viewModel.selectedLocation == nil {
                    Image(systemName: "mappin")
                        .font(.largeTitle)
                        .foregroundStyle(Color.accent)
                        .offset(y: -15)
                }
            }
            .overlay(alignment: .bottom) {
                Button("Confirm Location") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 30)
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CreateJobTab2(viewModel: CreateJobViewModel())
}
