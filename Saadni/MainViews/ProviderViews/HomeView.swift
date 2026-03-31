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
	@State private var showNotificationDrawer = false
	@Environment(ProviderCoordinator.self) var coordinator
	@Environment(\.notificationsStore) var notificationsStore
	@Environment(AuthenticationManager.self) var authManager
	
	private var locationLabel: String {
		guard
			let user = authManager.currentUser,
			let defaultId = user.defaultAddressId,
			let address = user.savedAddresses?.first(where: { $0.id == defaultId })
		else { return "Current location" }
		let words = address.label.split(separator: " ").map(String.init)
		if words.count <= 2 {
			return address.label
		}
		return words.prefix(2).joined(separator: " ") + "..."
	}
	
	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()
			
			ScrollView {
				VStack(spacing: 24) {
					// Search bar section with accent background
					
					
					VStack(alignment: .center, spacing: 0) {
						HStack{
							Button {
								coordinator.presentSheet(.myAddresses)
							} label: {
								HStack(spacing: 8){
									Text(locationLabel)
										.font(.headline)
										.foregroundStyle(.white)
										.fontDesign(.monospaced)
										.tracking(-1)
										.padding(.top, 12)
									Image(systemName: "chevron.down")
										.padding(.top, 12)
										.foregroundStyle(.white)
								}
							}
							Spacer()
							
							ZStack(alignment: .topTrailing) {
								Button(action: { showNotificationDrawer = true }) {
									Image(systemName: "bell")
										.font(.system(size: 18, weight: .semibold))
										.foregroundStyle(.white)
								}
								
								if notificationsStore.unreadCount(for: .provider) > 0 {
									ZStack {
										Circle()
											.fill(Colors.swiftUIColor(.borderWarning))
										
										Text(notificationsStore.unreadCount(for: .provider) > 99 ? "99+" : "\(notificationsStore.unreadCount(for: .provider))")
											.font(.system(size: 10, weight: .bold))
											.foregroundColor(.white)
									}
									.frame(width: 20, height: 20)
									.offset(x: 8, y: -8)
								}
							}
						}
						.padding(.horizontal, 20)
						
						TextField("", text: $needHelpWith, prompt: Text("I Need to Hire, e.g., a barista, a cashier,...").foregroundColor(.gray))
							.focused($isFocused)
							.font(Font.caption)
							.fontDesign(.monospaced)
							.fontWeight(.regular)
							.tracking(-1)
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
					
					
					if #available(iOS 26.0, *) {
						VStack(alignment: .leading, spacing: 0) {
							VStack(alignment: .leading, spacing: 4){
								Text("Have a Business?")
									.foregroundStyle(.accent)
								Text("Start Hiring Essential Roles")
									.foregroundStyle(Colors.swiftUIColor(.textMain))
							}
							.font(.system(size: 20, weight: .semibold, design: .default))
							.padding()
							.kerning(-0.5)
							
							
							
							HireRoleRow(icon: "sparkles", title: "Cleaning Member Boy") {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Cleaning Boy"))
							}
							
							Divider()
								.padding(.leading, 68)
							
							HireRoleRow(icon: "doc.text", title: "Office Secretary") {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.retailAndMalls.rawValue, initialJobName: "Secretary"))
							}
						}
					
						.glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 16))
						.padding(.horizontal)
					} else {
						VStack(alignment: .leading, spacing: 0) {
							VStack(alignment: .leading, spacing: 4){
								Text("Have a Business?")
									.foregroundStyle(.accent)
								Text("Start Hiring Essential Roles")
									.foregroundStyle(Colors.swiftUIColor(.textMain))
							}
							.font(.system(size: 20, weight: .semibold, design: .default))
							.padding()
							.kerning(-0.5)
							
							
							
							HireRoleRow(icon: "sparkles", title: "Cleaning Member Boy") {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Cleaning Boy"))
							}
							
							Divider()
								.padding(.leading, 68)
							
							HireRoleRow(icon: "doc.text", title: "Office Secretary") {
								coordinator.presentSheet(.createJob(category: ServiceCategoryType.retailAndMalls.rawValue, initialJobName: "Secretary"))
							}
						}
						.background(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Colors.swiftUIColor(.textSecondary), lineWidth: 0.15)
						)
						.padding(.horizontal)
					}
					
					Divider()
					//MARK: - Service Categories Sections
					
					ForEach(HomeView.categories) { category in
						VStack(alignment: .leading, spacing: 12) {
							Text(category.title)
								.font(.system(size: 20, weight: .regular, design: .default))
								.foregroundStyle(Colors.swiftUIColor(.textMain))
								.padding(.horizontal)
								.kerning(-0.5)
							
							ScrollView(.horizontal, showsIndicators: false) {
								HStack(spacing: 16) {
									ForEach(category.services) { service in
										Button(action: {
											coordinator.presentSheet(.createJob(
												category: category.categoryEnum,
												initialJobName: String(localized: service.displayName)
											))
										}) {
											ZStack {
												Image(service.name)
													.resizable()
													.aspectRatio(contentMode: .fill)
													.frame(width: 230)
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
				.padding(.bottom, 20)
				
				VStack(alignment: .center) {
					Text("IKEA Assembly, Hire a Specialist for easy Installment")
						.font(.system(size: 20, weight: .semibold, design: .monospaced))
						.foregroundStyle(Colors.swiftUIColor(.textMain))
						.kerning(-0.5)
						.multilineTextAlignment(.center)
					
					Image("ikeaAssembly")
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(maxWidth: .infinity)
						.overlay(
							LinearGradient(
								colors: [.clear, .black.opacity(0.7)],
								startPoint: .center,
								endPoint: .bottom
							)
						)
						.clipShape(RoundedRectangle(cornerRadius: 16))
						.padding()
						.padding(.horizontal)
				}
				
				Spacer()
					.frame(height: 40)
				
			}
			
		}
		.sheet(isPresented: $showNotificationDrawer) {
			NotificationDrawerView(userRole: .provider)
		}
	}
}

// MARK: - Local Data Models

extension HomeView {
	struct JobCategory: Identifiable {
		let id = UUID()
		let title: LocalizedStringResource
		let categoryEnum: String
		let services: [JobService]
	}
	
	struct JobService: Identifiable {
		let id = UUID()
		let name: String
		let displayName: LocalizedStringResource
	}
	
	static let categories: [JobCategory] = [
		JobCategory(title: "Restaurants", categoryEnum: ServiceCategoryType.foodAndBeverage.rawValue, services: [
			JobService(name: "cashierMan", displayName: "Cashier"),
			JobService(name: "waiter", displayName: "Waiter"),
			JobService(name: "foodTruck", displayName: "Food Truck Helper"),
			JobService(name: "foodDelivery", displayName: "Delivery Hero"),
			JobService(name: "eventCatering", displayName: "Event Catering"),
		]),
		JobCategory(title: "Malls", categoryEnum: ServiceCategoryType.retailAndMalls.rawValue, services: [
			JobService(name: "shopAssistant", displayName: "shop assistant"),
			JobService(name: "baristaMan", displayName: "Barista"),
			JobService(name: "eventSecurity", displayName: "Security"),
		]),
		JobCategory(title: "Warehouse", categoryEnum: ServiceCategoryType.logisticsAndWarehousing.rawValue, services: [
			JobService(name: "warehouse", displayName: "Warehouse Work"),
			JobService(name: "helpMoving", displayName: "Heavy Moving"),
			JobService(name: "outdoorCleaning", displayName: "Last-Mile Delivery")
		]),
		JobCategory(title: "Home", categoryEnum: ServiceCategoryType.cleaningAndMaintenance.rawValue, services: [
			JobService(name: "furnitureAssembly", displayName: "Order Sorter"),
			JobService(name: "electricWork", displayName: "Inventory Counter"),
			JobService(name: "homeCleaning", displayName: "Home Cleaning"),
			JobService(name: "carpetCleaning", displayName: "Office Cleaning Shift"),
			JobService(name: "doorInstallation", displayName: "Retail Sales Associate"),
			JobService(name: "furnitureAssembly", displayName: "Stock Replenisher"),
			JobService(name: "outdoorCleaning", displayName: "Fitting Room Attendant"),
			JobService(name: "outdoorCleaning", displayName: "Post-Event Cleaning"),
			JobService(name: "doorInstallation", displayName: "Car Wash Attendant"),
			JobService(name: "homeCleaning", displayName: "Common Area Cleaning")
		]),
		JobCategory(title: "Community", categoryEnum: ServiceCategoryType.hospitalityAndEvents.rawValue, services: [
			JobService(name: "outdoorCleaning", displayName: "Car Wash Assistant"),
			JobService(name: "petrolStation", displayName: "Petrol Station Attendant"),
			JobService(name: "homeCleaning", displayName: "Hotel Housekeeping"),
			JobService(name: "GymAssistant", displayName: "Gym Floor Assistant"),
			JobService(name: "furnitureAssembly", displayName: "Event Setup Crew"),
			
		]),
	]
}





struct CircularService : View {
	@Environment(\.colorScheme) var colorScheme
	let serviceImage: String
	let serviceName : LocalizedStringResource
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
		.environment(ProviderCoordinator())
		.environment(AuthenticationManager(userCache: UserCache()))
}
