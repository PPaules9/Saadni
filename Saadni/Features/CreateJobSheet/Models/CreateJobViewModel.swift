//
//  CreateJobViewModel.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI
import MapKit
import FirebaseFirestore

enum UploadState: Equatable {
	case idle
	case compressing
	case uploading(progress: Double)
	case saving
	case completed
}

@Observable
class CreateJobViewModel {
	// MARK: - Tab 1: Basic Shift Info
	var jobName: String = ""
	var selectedDates: Set<DateComponents> = []
	var startTime: Date = {
		var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
		components.hour = 9
		components.minute = 0
		return Calendar.current.date(from: components) ?? Date()
	}()
	
	var endTime: Date = {
		var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
		components.hour = 17
		components.minute = 0
		return Calendar.current.date(from: components) ?? Date()
	}()
	
	var breakDuration: String = ""
	
	// MARK: - Tab 2: Location
	var branchName: String = ""
	var address: String = ""
	var nearestLandmark: String = ""
	var city: String = ""
	var selectedLocation: CLLocationCoordinate2D?
	var selectedLocationName: String = ""
	
	// MARK: - Tab 3: Pay
	var price: String = ""
	var paymentMethod: String = "Cash"
	var paymentTiming: String = "Same Day"
	
	// MARK: - Tab 4: Requirements (Optional)
	var dressCode: String = ""
	var minimumAge: String = ""
	var genderPreference: String = "Any"
	var physicalRequirements: String = ""
	var languageNeeded: String = ""
	
	// MARK: - Tab 5: Description & Details (Optional)
	var otherDetails: String = ""
	var whatToBring: String = ""
	var selectedImage: UIImage?
	
	// MARK: - Metadata
	var currentUserId: String?
	var selectedCategoryTags: Set<String> = []
	
	// MARK: - UI State
	var currentTab: Int = 0
	var showValidationError: Bool = false
	var showSuccessModal: Bool = false
	var showImagePicker: Bool = false
	var showMapSheet: Bool = false
	var isPublishing: Bool = false
	var publishError: String?
	var showSummary: Bool = false
	var uploadState: UploadState = .idle
	var showAddressSavedAlert: Bool = false
	var mapPosition: MapCameraPosition = .region(
		MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 26.8206, longitude: 30.8025),
			span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
		)
	)
	
	// MARK: - Validation
	@ObservationIgnored
	var isTab1Valid: Bool {
		!jobName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
		!selectedDates.isEmpty
	}
	
	@ObservationIgnored
	var tab1ValidationError: String? {
		if jobName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Job Title is required" }
		if selectedDates.isEmpty { return "Please select at least one date" }
		return nil
	}
	
	@ObservationIgnored
	var isTab2Valid: Bool {
		!address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}

	@ObservationIgnored
	var tab2ValidationError: String? {
		if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Address is required" }
		return nil
	}
	
	@ObservationIgnored
	var isTab3Valid: Bool {
		guard let p = Double(price), p > 0 else { return false }
		return !paymentMethod.isEmpty && !paymentTiming.isEmpty
	}
	
	@ObservationIgnored
	var tab3ValidationError: String? {
		guard let p = Double(price), p > 0 else { return "Please enter a valid pay amount" }
		if paymentMethod.isEmpty { return "Payment Method is required" }
		if paymentTiming.isEmpty { return "Payment Timing is required" }
		return nil
	}
	
	@ObservationIgnored
	var isTab4Valid: Bool { true } // All optional
	
	@ObservationIgnored
	var isTab5Valid: Bool { true } // All optional
	
	@ObservationIgnored
	var isCurrentTabValid: Bool {
		switch currentTab {
		case 0: return isTab1Valid
		case 1: return isTab2Valid
		case 2: return isTab3Valid
		case 3: return isTab4Valid
		case 4: return isTab5Valid
		default: return false
		}
	}

	@ObservationIgnored
	var currentTabValidationError: String? {
		switch currentTab {
		case 0: return tab1ValidationError
		case 1: return tab2ValidationError
		case 2: return tab3ValidationError
		default: return nil
		}
	}

	@ObservationIgnored
	var isFormValid: Bool {
		return isTab1Valid && isTab2Valid && isTab3Valid && isTab4Valid && isTab5Valid
	}
	
	func nextTab() {
		showValidationError = false
		if currentTab < 4 {
			currentTab += 1
		}
	}
	
	func previousTab() {
		showValidationError = false
		if currentTab > 0 {
			currentTab -= 1
		}
	}
	
	// MARK: - Image Compression
	func compressImage(_ image: UIImage, quality: CGFloat = 0.7) -> UIImage? {
		guard let data = image.jpegData(compressionQuality: quality) else { return nil }
		return UIImage(data: data)
	}
	
	// MARK: - Service Creation
	
	/// Generates multiple shifts if multiple dates are selected
	func createServices(category: ServiceCategoryType, user: User) -> [JobService] {
		guard let priceValue = Double(price) else { return [] }
		guard let providerId = currentUserId else { return [] }
		
		let serviceLocation = ServiceLocation(
			name: city.isEmpty ? "Location" : city,
			coordinate: selectedLocation
		)
		
		let serviceImage = ServiceImage(
			localId: UUID().uuidString,
			remoteURL: nil,
			localImage: selectedImage
		)
		
		var generatedServices: [JobService] = []
		let calendar = Calendar.current
		
		var estDuration = endTime.timeIntervalSince(startTime) / 3600.0
		if estDuration < 0 {
			estDuration += 24.0 // Handle over-midnight shifts
		}
		
		for dateComp in selectedDates {
			guard let date = calendar.date(from: dateComp) else { continue }
			
			// Combine selected date with start time
			let hour = calendar.component(.hour, from: startTime)
			let minute = calendar.component(.minute, from: startTime)
			var finalDateComp = calendar.dateComponents([.year, .month, .day], from: date)
			finalDateComp.hour = hour
			finalDateComp.minute = minute
			
			let finalServiceDate = calendar.date(from: finalDateComp) ?? date
			
			let job = JobService(
				title: jobName,
				price: priceValue,
				location: serviceLocation,
				description: otherDetails,
				image: serviceImage,
				category: category,
				providerId: providerId,
				address: address,
				floor: "",
				unit: "",
				breakDuration: breakDuration.isEmpty ? nil : breakDuration,
				numberOfWorkersNeeded: nil,
				branchName: branchName.isEmpty ? nil : branchName,
				nearestLandmark: nearestLandmark.isEmpty ? nil : nearestLandmark,
				paymentMethod: paymentMethod,
				paymentTiming: paymentTiming,
				dressCode: dressCode.isEmpty ? nil : dressCode,
				minimumAge: minimumAge.isEmpty ? nil : minimumAge,
				genderPreference: genderPreference,
				physicalRequirements: physicalRequirements.isEmpty ? nil : physicalRequirements,
				languageNeeded: languageNeeded.isEmpty ? nil : languageNeeded,
				whatToBring: whatToBring.isEmpty ? nil : whatToBring,
				companyName: user.companyName ?? user.displayName ?? "",
				industryCategory: user.industryCategory,
				contactPersonName: user.contactPersonName ?? user.displayName ?? "",
				contactPersonPhone: user.contactPersonPhone ?? user.phoneNumber ?? "",
				someoneAround: false,
				specialTools: nil,
				serviceDate: finalServiceDate,
				estimatedDurationHours: estDuration > 0 ? estDuration : 1.0,
				status: .published
			)
			generatedServices.append(job)
		}
		
		return generatedServices
	}
	
	// MARK: - Address Auto-fill
	func applyDefaultAddress(_ addressData: SavedAddress?) {
		guard let addressData = addressData else { return }
		self.address = addressData.address
		self.city = addressData.city
	}
}
