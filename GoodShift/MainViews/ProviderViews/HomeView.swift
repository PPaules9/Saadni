//
//  HomeView.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct HomeView: View {
	@State private var needHelpWith: String = ""
	@FocusState private var isFocused: Bool

	// Animated placeholder state
	private let placeholderPrefix = "I Need to Hire, "
	private let placeholderExamples = ["a Barista", "a Cashier", "an Office Secretary", "WareHouse Worker", "Shop Assistant"]
	@State private var placeholderExampleIndex = 0
	@State private var placeholderTypedCount = 0
	@State private var placeholderTimer: Timer? = nil
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

	private func startPlaceholderAnimation() {
		placeholderTypedCount = 0
		placeholderTimer?.invalidate()

		// Type one character at a time every 0.08s
		var charTimer: Timer?
		charTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
			let currentExample = placeholderExamples[placeholderExampleIndex]
			if placeholderTypedCount < currentExample.count {
				placeholderTypedCount += 1
			} else {
				// Fully typed — wait 3s then move to next example
				charTimer?.invalidate()
				Task { @MainActor in
					try? await Task.sleep(for: .seconds(2))
					placeholderExampleIndex = (placeholderExampleIndex + 1) % placeholderExamples.count
					placeholderTypedCount = 0
					startPlaceholderAnimation()
				}
			}
		}
		placeholderTimer = charTimer
	}

	var body: some View {
		ZStack {
			Color(Colors.swiftUIColor(.appBackground))
				.ignoresSafeArea()

			ScrollView {
				VStack(spacing: 24) {

					//MARK: - Search bar section with accent background
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
								Button(action: { coordinator.presentSheet(.notificationDrawer(role: .provider)) }) {
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

						TextField("", text: $needHelpWith)
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
							.overlay(alignment: .leading) {
								if needHelpWith.isEmpty && !isFocused {
									let currentExample = placeholderExamples[placeholderExampleIndex]
									let typedSuffix = String(currentExample.prefix(placeholderTypedCount))
									Text(placeholderPrefix + typedSuffix)
										.font(Font.caption)
										.fontDesign(.monospaced)
										.fontWeight(.regular)
										.tracking(-1)
										.foregroundColor(.gray)
										.padding(.horizontal, 16)
										.allowsHitTesting(false)
										.animation(nil, value: placeholderTypedCount)
								}
							}
							.onSubmit {
								isFocused = false
							}
							.onAppear {
								startPlaceholderAnimation()
							}
							.onDisappear {
								placeholderTimer?.invalidate()
								placeholderTimer = nil
							}

							.foregroundStyle(.black)
							.background(
								RoundedRectangle(cornerRadius: 100)
									.fill(.white)
							)
							.padding()
							.onSubmit {
								if !needHelpWith.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
									coordinator.navigate(to: .createJob(
										category: needHelpWith,
										initialJobName: needHelpWith,
										initialServiceImageName: nil
									))
									needHelpWith = ""
								}
							}
					}
					.padding(.bottom, 8)
					.background(
						Color.accentColor
							.padding(.top, -400)
							.ignoresSafeArea(edges: .top)
					)


					//MARK: - Circular Categories Sections
					ScrollView(.horizontal, showsIndicators: false) {
						HStack(spacing: 20){
							Button {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Cleaning", initialServiceImageName: nil))
							} label: {
								CircularService(serviceImage: "cleaning", serviceName: "Cleaning")
							}

							Button {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.retailAndMalls.rawValue, initialJobName: "Cashier", initialServiceImageName: nil))
							} label: {
								CircularService(serviceImage: "cashier", serviceName: "Cashier")
							}

							Button {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.movingAndLabour.rawValue, initialJobName: "Moving", initialServiceImageName: nil))
							} label: {
								CircularService(serviceImage: "moving", serviceName: "Moving")
							}

							Button {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.foodAndBeverage.rawValue, initialJobName: "Barista", initialServiceImageName: nil))
							} label: {
								CircularService(serviceImage: "barista", serviceName: "Barista")
							}

							Button {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.logisticsAndWarehousing.rawValue, initialJobName: "Delivery", initialServiceImageName: nil))
							} label: {
								CircularService(serviceImage: "delivery", serviceName: "Delivery")
							}

							Button {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Fixing", initialServiceImageName: nil))
							} label: {
								CircularService(serviceImage: "fixing", serviceName: "Fixing")
							}

							Button {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.movingAndLabour.rawValue, initialJobName: "Furniture", initialServiceImageName: nil))
							} label: {
								CircularService(serviceImage: "furniture", serviceName: "Furniture")
							}
						}
						.buttonStyle(.plain)
						.padding(.horizontal)
					}
					.padding(.bottom)


					if #available(iOS 26.0, *) {
						VStack(alignment: .leading, spacing: 0) {
							VStack(alignment: .leading, spacing: 4){
								Text("Having a Business?")
									.foregroundStyle(.accent)
								Text("Start Hiring Essential Roles")
									.foregroundStyle(Colors.swiftUIColor(.textMain))
									.bold()
							}
							.font(.system(size: 20, weight: .semibold, design: .default))
							.padding()
							.kerning(-0.5)



							HireRoleRow(icon: "sparkles", title: "Cleaning Member Boy") {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Cleaning Boy", initialServiceImageName: nil))
							}

							Divider()
								.padding(.leading, 68)

							HireRoleRow(icon: "doc.text", title: "Office Secretary") {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.retailAndMalls.rawValue, initialJobName: "Secretary", initialServiceImageName: nil))
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
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.cleaningAndMaintenance.rawValue, initialJobName: "Cleaning Boy", initialServiceImageName: nil))
							}

							Divider()
								.padding(.leading, 68)

							HireRoleRow(icon: "doc.text", title: "Office Secretary") {
								coordinator.navigate(to: .createJob(category: ServiceCategoryType.retailAndMalls.rawValue, initialJobName: "Secretary", initialServiceImageName: nil))
							}
						}
						.background(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Colors.swiftUIColor(.textSecondary), lineWidth: 0.15)
						)
						.padding(.horizontal)
					}
					Divider()
						.padding(.vertical)
					//MARK: - Service Categories Sections

					ForEach(HomeView.categories) { category in
						VStack(alignment: .leading, spacing: 12) {
							Text(category.title)
								.font(.system(size: 24, weight: .heavy, design: .default))
								.foregroundStyle(Colors.swiftUIColor(.textMain))
								.padding(.horizontal)
//							.kerning(-0.5)

							ScrollView(.horizontal, showsIndicators: false) {
								HStack(spacing: 16) {
									ForEach(category.services) { service in
										Button(action: {
											coordinator.navigate(to: .createJob(
												category: category.categoryEnum,
												initialJobName: String(localized: service.displayName),
												initialServiceImageName: service.name
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

					Button(action: {
						coordinator.navigate(to: .createJob(
							category: "IKEA Assembly",
							initialJobName: "IKEA Specialist",
							initialServiceImageName: "ikeaAssembly"
						))
					}) {
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
				}

				Spacer()
					.frame(height: 40)

			}

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
					.frame(width: 70, height: 70)

				Image(serviceImage)
					.resizable()
					.clipShape(Circle())
					.frame(width: 60, height: 60)

			}
			Text(serviceName)
				.font(.caption)
				.bold()
				.kerning(0.7)
		}
	}
}




#Preview {
	HomeView()
		.environment(ProviderCoordinator())
		.environment(AuthenticationManager(userCache: UserCache()))
}
