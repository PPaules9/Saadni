//
//  HomeView.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct HomeView: View {
	@State private var needHelpWith: String = ""
	@FocusState private var isFocused: Bool
	@State private var viewModel: ProfileViewModel?
	@Environment(JobSeekerCoordinator.self) var coordinator
	
	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()
			
			ScrollView {
				VStack(spacing: 24) {
					// Search bar section with accent background
					
					
					VStack(alignment: .leading, spacing: 0) {
						HStack{
							Text("I Need Help Hire")
								.font(.title2)
								.foregroundStyle(.black)
								.fontDesign(.monospaced)
								.bold()
								.tracking(-1.5)
								.padding(.top, 12)
							Spacer()
							
							
							Button(action: {}) {
								Image(systemName: "arrow.left.arrow.right")
									.font(.system(size: 18, weight: .semibold))
									.foregroundStyle(.black)
							}
							
							Button(action: {}) {
								Image(systemName: "bell")
									.font(.system(size: 18, weight: .semibold))
									.foregroundStyle(.black)
							}
						}
						.padding(.horizontal, 20)
						
						TextField("", text: $needHelpWith, prompt: Text("e.g., a barista, a cashier, an event helper...").foregroundColor(.gray))
							.focused($isFocused)
							.font(Font.caption)
							.fontDesign(.monospaced)
							.fontWeight(.regular)
							.padding(16)
							.overlay(
								RoundedRectangle(cornerRadius: 100)
									.stroke(Colors.swiftUIColor(.textSecondary), lineWidth: 1)
							)
							.onSubmit {
								isFocused = false
							}
						
							.foregroundStyle(.black)
							.background(
								RoundedRectangle(cornerRadius: 100)
									.fill(.white)
							)
							.padding()
							.onSubmit {
								if !needHelpWith.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
									coordinator.presentSheet(.createJob(
										category: needHelpWith,
										initialJobName: needHelpWith
									))
									needHelpWith = ""
								}
							}
					}
					.padding(.bottom, 8)
					.background(
						Color.accentColor
						// Extend upward far enough to always cover the safe area + nav bar
							.padding(.top, -500)
							.ignoresSafeArea(edges: .top)
					)
					
					//MARK: - Circular Categories Sections
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 14){
							Button {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.foodAndBeverage.rawValue, initialJobName: "Barista"))
							} label: {
								CircularService(serviceImage: "barista", serviceName: "Barista")
							}
							
							Button {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Cleaning"))
							} label: {
								CircularService(serviceImage: "cleaning", serviceName: "Cleaning")
							}
							
							Button {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.retailAndMalls.rawValue, initialJobName: "Cashier"))
							} label: {
								CircularService(serviceImage: "cashier", serviceName: "Cashier")
							}
							
							Button {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.movingAndLabour.rawValue, initialJobName: "Moving"))
							} label: {
								CircularService(serviceImage: "moving", serviceName: "Moving")
							}
							
							Button {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.logisticsAndWarehousing.rawValue, initialJobName: "Delivery"))
							} label: {
								CircularService(serviceImage: "delivery", serviceName: "Delivery")
							}
							
							Button {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Fixing"))
							} label: {
								CircularService(serviceImage: "fixing", serviceName: "Fixing")
							}
							
							Button {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.movingAndLabour.rawValue, initialJobName: "Furniture"))
							} label: {
								CircularService(serviceImage: "furniture", serviceName: "Furniture")
							}
						}
						.buttonStyle(.plain)
						.padding(.horizontal)
					}

					
					//MARK: - Service Categories Sections
					
					ForEach(HomeView.categories) { category in
						VStack(alignment: .leading, spacing: 12) {
							Text(category.title)
								.font(.system(size: 16, weight: .semibold, design: .default))
								.foregroundStyle(Colors.swiftUIColor(.textMain))
								.padding(.horizontal)
							
							ScrollView(.horizontal, showsIndicators: false) {
								HStack(spacing: 12) {
									ForEach(category.services) { service in
										Button(action: {
											coordinator.presentSheet(.createJob(
												category: category.categoryEnum,
												initialJobName: service.displayName
											))
										}) {
											ZStack {
												Image(service.name)
													.resizable()
													.aspectRatio(contentMode: .fill)
													.frame(width: 240)
													.overlay(
														LinearGradient(
															colors: [.clear, .black.opacity(0.7)],
															startPoint: .center,
															endPoint: .bottom
														)
													)
												
												VStack {
													Spacer()
													HStack {
														Spacer()
														Text(service.displayName)
															.font(.system(size: 14, weight: .semibold, design: .default))
															.foregroundStyle(.white)
															.lineLimit(2)
															.padding(12)
															.fontDesign(.monospaced)
													}
													
												}
											}
											.clipShape(RoundedRectangle(cornerRadius: 12))
											.frame(height: 130)
											.contentShape(Rectangle())
										}
										.buttonStyle(.plain)
									}
								}
								.padding(.horizontal)
							}
						}
					}
				}
			}
			
		}
	}
}

// MARK: - Local Data Models

extension HomeView {
	struct JobCategory: Identifiable {
		let id = UUID()
		let title: String
		let categoryEnum: String
		let services: [JobService]
	}
	
	struct JobService: Identifiable {
		let id = UUID()
		let name: String
		let displayName: String
	}
	
	static let categories: [JobCategory] = [
		JobCategory(title: "Food & Beverage", categoryEnum: ServiceCategoryType.foodAndBeverage.rawValue, services: [
			JobService(name: "Cashier", displayName: "Cashier at Restaurant"),
			JobService(name: "Barista", displayName: "Barista / Staff"),
			JobService(name: "Waiter", displayName: "Waiter / Runner"),
			JobService(name: "FoodDelivery", displayName: "Food Delivery Support"),
			JobService(name: "EventCatering", displayName: "Event Catering Server"),
			JobService(name: "foodTruck", displayName: "Food Truck Helper")
		]),
		JobCategory(title: "Retail & Malls", categoryEnum: ServiceCategoryType.retailAndMalls.rawValue, services: [
			JobService(name: "doorInstallation", displayName: "Retail Sales Associate"),
			JobService(name: "Cashier", displayName: "Mall Cashier"),
			JobService(name: "furnitureAssembly", displayName: "Stock Replenisher"),
			JobService(name: "outdoorCleaning", displayName: "Fitting Room Attendant"),
			JobService(name: "beachBabySetting", displayName: "Holiday Gift Wrapper"),
			JobService(name: "carpetCleaning", displayName: "Promo Stand Attendant")
		]),
		JobCategory(title: "Logistics & Warehousing", categoryEnum: ServiceCategoryType.logisticsAndWarehousing.rawValue, services: [
			JobService(name: "helpMoving", displayName: "Warehouse Picker"),
			JobService(name: "furnitureAssembly", displayName: "Order Sorter"),
			JobService(name: "electricWork", displayName: "Inventory Counter"),
			JobService(name: "helpMoving", displayName: "Loading Helper"),
			JobService(name: "outdoorCleaning", displayName: "Last-Mile Delivery")
		]),
		JobCategory(title: "Cleaning & Maintenance", categoryEnum: ServiceCategoryType.cleaningAndMaintenance.rawValue, services: [
			JobService(name: "homeCleaning", displayName: "Home Cleaning Shift"),
			JobService(name: "carpetCleaning", displayName: "Office Cleaning Shift"),
			JobService(name: "outdoorCleaning", displayName: "Post-Event Cleaning"),
			JobService(name: "doorInstallation", displayName: "Car Wash Attendant"),
			JobService(name: "homeCleaning", displayName: "Common Area Cleaning")
		]),
		JobCategory(title: "Petrol & Automotive", categoryEnum: ServiceCategoryType.petrolAndAutomotive.rawValue, services: [
			JobService(name: "tvMounting", displayName: "Petrol Station Attendant"),
			JobService(name: "outdoorCleaning", displayName: "Car Wash Assistant"),
			JobService(name: "doorInstallation", displayName: "Parking Lot Attendant")
		]),
		JobCategory(title: "Security & Crowd Management", categoryEnum: ServiceCategoryType.securityAndCrowdManagement.rawValue, services: [
			JobService(name: "doorInstallation", displayName: "Event Security Helper"),
			JobService(name: "beachBabySetting", displayName: "Parking Enforcement Helper"),
			JobService(name: "tvMounting", displayName: "Mall Entrance Checker")
		]),
		JobCategory(title: "Hospitality & Events", categoryEnum: ServiceCategoryType.hospitalityAndEvents.rawValue, services: [
			JobService(name: "furnitureAssembly", displayName: "Event Setup Crew"),
			JobService(name: "beachBabySetting", displayName: "Exhibition Helper"),
			JobService(name: "homeCleaning", displayName: "Hotel Housekeeping"),
			JobService(name: "carpetCleaning", displayName: "Breakfast Service Assistant"),
			JobService(name: "tvMounting", displayName: "Venue Usher")
		]),
		JobCategory(title: "Moving & Labour", categoryEnum: ServiceCategoryType.movingAndLabour.rawValue, services: [
			JobService(name: "helpMoving", displayName: "Moving Crew Helper"),
			JobService(name: "furnitureAssembly", displayName: "Furniture Assembly Helper"),
			JobService(name: "electricWork", displayName: "Construction Site Laborer")
		]),
		JobCategory(title: "Community & Outdoor", categoryEnum: ServiceCategoryType.communityAndOutdoor.rawValue, services: [
			JobService(name: "beachBabySetting", displayName: "Flyer Distributor"),
			JobService(name: "GymAssistant", displayName: "Gym Floor Assistant"),
			JobService(name: "outdoorCleaning", displayName: "Street Promoter"),
			JobService(name: "doorInstallation", displayName: "Queue Management Helper")
		])
	]
}





struct CircularService : View {
	@Environment(\.colorScheme) var colorScheme
	let serviceImage: String
	let serviceName : String
	var body: some View {
		VStack{
			ZStack{
				Circle()
					.fill(.accent.opacity(0.3))
					.background(Circle().fill(colorScheme == .dark ? .gray : .clear))
					.frame(width: 62, height: 62)
				
				Image(serviceImage)
					.resizable()
					.clipShape(Circle())
					.frame(width: 50, height: 50)

			}
			Text(serviceName)
				.font(.caption)
				.kerning(0.7)
				.fontDesign(.monospaced)
		}
	}
}




#Preview {
	HomeView()
		.environment(JobSeekerCoordinator())
}
