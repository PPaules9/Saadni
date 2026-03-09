//
//  AddService.swift
//  Saadni
//
//  Created by Pavly Paules on 22/02/2026.
//

import SwiftUI

struct AddService: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ServicesStore.self) var servicesStore
    @State private var viewModel = CreateJobViewModel()
    @State private var showConfetti = false

    let tabNames = ["Details", "Pictures", "Tools", "Price", "Review"]

    var body: some View {
        ZStack {
            Color(Colors.swiftUIColor(.appBackground))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress Indicator
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(index <= viewModel.currentTab ? Color.accent : Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                    }
                    .padding(.horizontal)

                    HStack(spacing: 0) {
                        ForEach(0..<5, id: \.self) { index in
                            Text(tabNames[index])
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(index <= viewModel.currentTab ? Color.accent : Color.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                .padding(.vertical, 16)
                .background(Colors.swiftUIColor(.textPrimary))

                // Tab Content
                Group {
                    switch viewModel.currentTab {
                    case 0:
                        CreateJobTab1(viewModel: viewModel, selectedCategory: "My Service")
                    case 1:
                        CreateJobTab2(viewModel: viewModel)
                    case 2:
                        CreateJobTab3(viewModel: viewModel)
                    case 3:
                        CreateJobTab4(viewModel: viewModel)
                    case 4:
                        CreateJobTab5(viewModel: viewModel, onPublish: {
                            publishService()
                        })
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Navigation Buttons
                HStack(spacing: 12) {
                    if viewModel.currentTab > 0 {
                     BrandButton( "Back", hasIcon: false, icon:"", secondary: true ) {
                            viewModel.previousTab()
                        }
                    }

                    if viewModel.currentTab < 4 {
                        BrandButton(
                            "Next",
                            hasIcon: true,
                            icon: "chevron.right",
                            secondary: false
                        ) {
                            if viewModel.isCurrentTabValid {
                                viewModel.nextTab()
                            }
                        }
                        .disabled(!viewModel.isCurrentTabValid)
                    }
                }
                .padding()
                .background(Colors.swiftUIColor(.textPrimary))
            }

            if showConfetti {
                ConfettiView(onAnimationComplete: {
                    dismiss()
                })
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePickerSheet(selectedImage: $viewModel.selectedImage)
                .presentationDetents([.fraction(0.3), .fraction(0.55)])
        }
        .onAppear {
            // Initialize any needed state
        }
    }

    private func publishService() {
        guard viewModel.canPublish() else { return }

        let serviceLocation = ServiceLocation(
            name: viewModel.city,
            coordinate: nil
        )

        let serviceImage = ServiceImage(
            localId: UUID().uuidString,
            remoteURL: nil,
            localImage: viewModel.selectedImage
        )

        let service = FlexibleJobService(
            id: UUID().uuidString,
            title: viewModel.jobName,
            price: Double(viewModel.price) ?? 0,
            location: serviceLocation,
            description: viewModel.otherDetails,
            image: serviceImage,
            createdAt: Date(),
            providerId: authManager.currentUserId ?? "",
            providerName: nil,
            providerImageURL: nil,
            status: .published,
            isFeatured: false,
            category: .homeCleaning
        )

        servicesStore.addFlexibleJob(service, image: viewModel.selectedImage)

        withAnimation {
            showConfetti = true
        }
    }
}

#Preview {
    AddService()
        .environment(AuthenticationManager())
        .environment(ServicesStore())
}
