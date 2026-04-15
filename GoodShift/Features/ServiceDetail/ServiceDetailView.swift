//
//  ServiceDetailView.swift
//  GoodShift
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI
import Kingfisher

struct ServiceDetailView: View {
	let service: JobService
	@Environment(\.dismiss) var dismiss
	@Environment(AuthenticationManager.self) var authManager
	@Environment(ApplicationsStore.self) var applicationsStore
	@Environment(ServicesStore.self) var servicesStore
	@Environment(WalletStore.self) var walletStore
	@Environment(ConversationsStore.self) var conversationsStore
	@Environment(ReviewsStore.self) var reviewsStore
	
	@Environment(AppCoordinator.self) var appCoordinator
	@Environment(UserCache.self) var userCache

	@State private var reviewItem: ApplicantReviewItem?
	@State private var showingApplySheet = false
	@State private var showingApplications = false
	@State private var showingCompletionView = false
	@State private var showingMarkDoneView = false
	@State private var showingReviewSheet = false
	@State private var showingPaySheet = false
	@State private var isConfirmingArrival = false
	@State private var isReportingNoShow = false
	@State private var showNoShowConfirmation = false
	@State private var isCreatingChat = false
	@State private var showDeleteConfirmation = false
	@State private var isBoostingJob = false
	@State private var isBulkUpdating = false
	@State private var showEditBlockAlert = false
	@State private var showDeleteBlockAlert = false
	@State private var showEditSheet = false
	
	var reviews: [Review] {
		reviewsStore.serviceReviews[service.id] ?? []
	}
	
	var averageRating: Double? {
		guard !reviews.isEmpty else { return nil }
		return reviews.map { Double($0.rating) }.reduce(0, +) / Double(reviews.count)
	}
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 0) {
				// MARK: - Header Image
				ServiceImageSection(service: service)
					.frame(height: 280)
				
				VStack(alignment: .leading, spacing: 24) {
					
					// MARK: - Title, Price & Category
					VStack(alignment: .leading, spacing: 10) {
						Text(service.title)
							.font(.system(size: 26, weight: .bold))
							.fontDesign(.monospaced)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
						
						HStack(spacing: 10) {
							Text(service.formattedPrice)
								.font(.system(size: 22, weight: .bold))
								.fontDesign(.monospaced)
								.foregroundStyle(.green)

							// Payment lock badge
							if isOwnService {
								if service.isPaid {
									Label("Secured", systemImage: "lock.fill")
										.font(.caption.weight(.semibold))
										.foregroundStyle(.green)
										.padding(.horizontal, 8)
										.padding(.vertical, 4)
										.background(Color.green.opacity(0.12))
										.cornerRadius(8)
								} else {
									Label("Payment Required", systemImage: "lock.open.fill")
										.font(.caption.weight(.semibold))
										.foregroundStyle(.orange)
										.padding(.horizontal, 8)
										.padding(.vertical, 4)
										.background(Color.orange.opacity(0.12))
										.cornerRadius(8)
								}
							}

							Divider().frame(height: 20)

							Text(service.categoryDisplayName)
								.font(.caption)
								.fontWeight(.semibold)
								.padding(.horizontal, 10)
								.padding(.vertical, 5)
								.background(Color.accent.opacity(0.15))
								.cornerRadius(8)
								.foregroundStyle(.accent)

							Spacer()
							
							// Application count badge (own service)
							if isOwnService && service.applicationCount > 0 {
								HStack(spacing: 4) {
									Image(systemName: "person.2.fill")
										.font(.caption2)
									Text("\(service.applicationCount)")
										.font(.caption)
										.fontWeight(.semibold)
								}
								.padding(.horizontal, 8)
								.padding(.vertical, 4)
								.background(Color.orange.opacity(0.15))
								.foregroundStyle(.orange)
								.cornerRadius(8)
							}

							// Other applicants count (student view)
							if !isOwnService && otherApplicantCount > 0 {
								HStack(spacing: 4) {
									Image(systemName: "person.2.fill")
										.font(.caption2)
									Text("\(otherApplicantCount) other\(otherApplicantCount == 1 ? "" : "s") applied")
										.font(.caption)
										.fontWeight(.semibold)
								}
								.padding(.horizontal, 8)
								.padding(.vertical, 4)
								.background(Color.blue.opacity(0.12))
								.foregroundStyle(Color.blue)
								.cornerRadius(8)
							}
						}
					}
					
					// MARK: - Core Details Grid
					VStack(spacing: 0) {
						DetailItem(icon: "mappin.and.ellipse", label: "Location", value: service.location.name)
						DetailDivider()
						
						if let date = service.serviceDate {
							DetailItem(icon: "calendar", label: "Service Date", value: formatDate(date))
							DetailDivider()
						}
						
						if let hours = service.estimatedDurationHours {
							DetailItem(icon: "clock.fill", label: "Duration", value: String(format: "%.0f hours", hours))
							DetailDivider()
						}
						
						if let workers = service.numberOfWorkersNeeded, workers > 0 {
							DetailItem(icon: "person.2.fill", label: "Workers Needed", value: "\(workers)")
							DetailDivider()
						}
						
						DetailItem(icon: "checkmark.circle.fill", label: "Status", value: service.status.rawValue.capitalized)
						DetailDivider()
						
						DetailItem(icon: "calendar.badge.clock", label: "Posted", value: formatDate(service.createdAt))
					}
					.padding(16)
					.background()
					.cornerRadius(14)
					
					// MARK: - Address Details
					if !service.address.isEmpty {
						SectionCard(title: "Address Details", icon: "map.fill") {
							VStack(spacing: 0) {
								if !service.address.isEmpty {
									DetailItem(icon: "house.fill", label: "Street", value: service.address)
								}
								if !service.floor.isEmpty {
									DetailDivider()
									DetailItem(icon: "building.2", label: "Floor", value: service.floor)
								}
								if !service.unit.isEmpty {
									DetailDivider()
									DetailItem(icon: "door.left.hand.open", label: "Unit", value: service.unit)
								}
								if let landmark = service.nearestLandmark, !landmark.isEmpty {
									DetailDivider()
									DetailItem(icon: "mappin.circle.fill", label: "Nearest Landmark", value: landmark)
								}
								if let branch = service.branchName, !branch.isEmpty {
									DetailDivider()
									DetailItem(icon: "building.fill", label: "Branch", value: branch)
								}
							}
						}
					}
					
					// MARK: - Description
					if !service.description.isEmpty {
						VStack(alignment: .leading, spacing: 8) {
							Text("About This Job")
								.font(.headline)
								.fontDesign(.monospaced)
								.foregroundStyle(Colors.swiftUIColor(.textMain))

							Text(service.description)
								.font(.body)
								.foregroundStyle(Colors.swiftUIColor(.textSecondary))
								.lineSpacing(4)
						}
					}
					
					// MARK: - Shift Requirements
					let shiftFields: [(String, String, String)] = [
						service.dressCode.map { ("tshirt.fill", "Dress Code", $0) },
						service.minimumAge.map { ("person.fill.checkmark", "Minimum Age", $0) },
						service.genderPreference.map { ("person.2", "Gender Preference", $0) },
						service.languageNeeded.map { ("text.bubble.fill", "Language Required", $0) },
						service.breakDuration.map { ("cup.and.saucer.fill", "Break Duration", $0) },
						service.physicalRequirements.map { ("figure.walk", "Physical Requirements", $0) },
						service.whatToBring.map { ("bag.fill", "What To Bring", $0) },
					].compactMap { $0 }
					
					if !shiftFields.isEmpty {
						SectionCard(title: "Shift Requirements", icon: "list.bullet.clipboard.fill") {
							VStack(spacing: 0) {
								ForEach(Array(shiftFields.enumerated()), id: \.offset) { index, field in
									if index > 0 { DetailDivider() }
									DetailItem(icon: field.0, label: field.1, value: field.2)
								}
							}
						}
					}
					
					// MARK: - Payment Details
					if service.paymentMethod != nil || service.paymentTiming != nil {
						SectionCard(title: "Payment", icon: "creditcard.fill") {
							VStack(spacing: 0) {
								if let method = service.paymentMethod, !method.isEmpty {
									DetailItem(icon: "banknote.fill", label: "Payment Method", value: method)
								}
								if let timing = service.paymentTiming, !timing.isEmpty {
									if service.paymentMethod != nil { DetailDivider() }
									DetailItem(icon: "clock.badge.checkmark.fill", label: "Payment Timing", value: timing)
								}
							}
						}
					}
					
					// MARK: - Special Tools / Equipment
					if let tools = service.specialTools, !tools.isEmpty {
						VStack(alignment: .leading, spacing: 8) {
							Text("Tools & Equipment Needed")
								.font(.headline)
								.fontDesign(.monospaced)
								.foregroundStyle(Colors.swiftUIColor(.textMain))
							
							Text(tools)
								.font(.body)
								.foregroundStyle(Colors.swiftUIColor(.textSecondary))
								.padding(12)
								.frame(maxWidth: .infinity, alignment: .leading)
								.background(Colors.swiftUIColor(.surfaceWhite))
								.cornerRadius(10)
						}
					}
					
					// MARK: - Someone Around
					if service.someoneAround {
						HStack(spacing: 12) {
							Image(systemName: "person.fill.checkmark")
								.foregroundStyle(.accent)
								.font(.title3)
							
							VStack(alignment: .leading, spacing: 2) {
								Text("Someone Will Be Around")
									.font(.headline)
									.foregroundStyle(Colors.swiftUIColor(.textMain))
								Text("The client will be present during the service")
									.font(.caption)
									.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							}
							
							Spacer()
						}
						.padding(12)
						.background(Color.accent.opacity(0.08))
						.cornerRadius(10)
						.overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.accent.opacity(0.3), lineWidth: 1))
					}
					
					// MARK: - Company Info
					if service.companyName != nil || service.contactPersonName != nil {
						SectionCard(title: "Company Info", icon: "building.2.fill") {
							VStack(spacing: 0) {
								if let company = service.companyName, !company.isEmpty {
									DetailItem(icon: "building.2.fill", label: "Company", value: company)
								}
								if let industry = service.industryCategory, !industry.isEmpty {
									DetailDivider()
									DetailItem(icon: "briefcase.fill", label: "Industry", value: industry)
								}
								if let contact = service.contactPersonName, !contact.isEmpty {
									DetailDivider()
									DetailItem(icon: "person.text.rectangle.fill", label: "Contact Person", value: contact)
								}
								if let phone = service.contactPersonPhone, !phone.isEmpty {
									DetailDivider()
									DetailItem(icon: "phone.fill", label: "Phone", value: phone)
								}
							}
						}
					}
					
					// MARK: - Provider Section
					ProviderSection(service: service, startChatAction: startChatWithProvider)
					
					// MARK: - Reviews Section
					if !reviews.isEmpty || true {
						VStack(alignment: .leading, spacing: 12) {
							SectionHeader(title: "Reviews")
								.padding(.horizontal, -16)
							
							ReviewSummaryView(averageRating: averageRating, totalReviews: reviews.count)
							
							if !reviews.isEmpty {
								VStack(spacing: 10) {
									ForEach(reviews.prefix(3)) { review in
										ReviewCard(review: review)
									}
								}
							}
						}
					}
					
					// MARK: - Applicants Section (Provider only)
					if isOwnService {
						providerApplicantsSection
					}

					// MARK: - Action Buttons
					VStack(spacing: 12) {
						if !isOwnService { workerActionsView }
						if isOwnService  { providerActionsView }
						secondaryActionView
					}
					.padding(.top, 8)
					.padding(.bottom, 16)
				}
				.padding(20)
			}
		}
		.background(Colors.swiftUIColor(.appBackground))
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				if isOwnService {
					Menu {
						Button {
							if service.applicationCount > 0 {
								showEditBlockAlert = true
							} else {
								showEditSheet = true
							}
						} label: {
							Label("Edit", systemImage: "pencil")
						}

						Button {
							Task { await boostJob() }
						} label: {
							Label(
								service.isFeatured ? "Already Featured" : "Boost Job",
								systemImage: "bolt.fill"
							)
						}
						.disabled(service.isFeatured || isBoostingJob)

						Button(role: .destructive) {
							if service.status == .active && service.hiredApplicantId != nil {
								showDeleteBlockAlert = true
							} else {
								showDeleteConfirmation = true
							}
						} label: {
							Label("Delete Service", systemImage: "trash.fill")
						}
					} label: {
						Image(systemName: "ellipsis.circle")
							.foregroundStyle(.accent)
					}
					.accessibilityLabel("More Options")
				} else {
					Button(action: {}) {
						Image(systemName: "heart")
							.foregroundStyle(.red)
					}
					.frame(minWidth: 44, minHeight: 44)
					.accessibilityLabel("Save")
				}
			}
		}
		.confirmationDialog(
			"Delete this job?",
			isPresented: $showDeleteConfirmation,
			titleVisibility: .visible
		) {
			Button("Delete", role: .destructive) {
				Task { await deleteJob() }
			}
			Button("Cancel", role: .cancel) {}
		} message: {
			Text("This action cannot be undone.")
		}
		.alert("Cannot Edit This Job", isPresented: $showEditBlockAlert) {
			Button("OK", role: .cancel) {}
		} message: {
			Text("A user has applied to this job. To make changes, delete this service and create a new one.")
		}
		.alert("Cannot Delete This Job", isPresented: $showDeleteBlockAlert) {
			Button("OK", role: .cancel) {}
		} message: {
			Text("A user is currently working this job. You cannot delete it while it is active.")
		}
		.sheet(isPresented: $showEditSheet) {
			if let providerId = authManager.currentUserId {
				CreateJobSheet(editingService: service, editingGroupId: nil, providerId: providerId)
					.environment(servicesStore)
					.environment(authManager)
					.environment(userCache)
					.environment(JobSeekerCoordinator())
			}
		}
		.sheet(isPresented: $showingCompletionView) {
			ServiceCompletionView(service: service)
				.environment(servicesStore)
				.environment(walletStore)
		}
		.sheet(isPresented: $showingApplySheet) {
			ApplyJobSheetContent(service: service)
				.environment(applicationsStore)
		}
		.sheet(isPresented: $showingApplications) {
			ServiceApplicationsSheet(service: service)
				.environment(applicationsStore)
		}
		.sheet(isPresented: $showingMarkDoneView) {
			MarkJobDoneView(service: service)
				.environment(applicationsStore)
		}
		.sheet(isPresented: $showingPaySheet) {
			PayShiftSheet(service: service)
				.environment(applicationsStore)
		}
		.sheet(item: $reviewItem) { item in
			ApplicantReviewSheet(application: item.application, service: item.service)
				.environment(applicationsStore)
		}
		.confirmationDialog(
			"Report Worker No-Show?",
			isPresented: $showNoShowConfirmation,
			titleVisibility: .visible
		) {
			Button("Yes, Report No-Show", role: .destructive) {
				Task { await reportNoShow() }
			}
			Button("Cancel", role: .cancel) {}
		} message: {
			Text("The worker's account will receive a strike. You'll get a full refund plus a free boost credit.")
		}
		.sheet(isPresented: $showingReviewSheet) {
			PostJobReviewSheet(
				service: service,
				revieweeId: service.providerId,
				revieweeName: service.providerName ?? "Provider",
				reviewerRole: .seeker
			)
			.environment(authManager)
			.environment(reviewsStore)
		}
		.onAppear {
			trackJobViewed()
		}
	}
	
	// MARK: - Worker Actions

	@ViewBuilder
	private var workerActionsView: some View {
		if isHiredStudent {
			workerHiredActionsView
		} else {
			workerApplyActionsView
		}
	}

	@ViewBuilder
	private var workerHiredActionsView: some View {
		switch service.status {
		case .active:
			if !service.workerConfirmedArrival {
				BrandButton("I've Arrived", size: .large, isDisabled: isConfirmingArrival, hasIcon: true, icon: "figure.walk.arrival", secondary: false) {
					Task { await confirmArrivalAsWorker() }
				}
			} else if !service.providerConfirmedWorkerArrival {
				workerWaitingForProviderBanner
			} else {
				BrandButton("I'm Done — Mark as Complete", size: .large, isDisabled: false, hasIcon: true, icon: "checkmark.circle.fill", secondary: false) {
					showingMarkDoneView = true
				}
			}
		case .pendingCompletion:
			pendingCompletionBanner
		case .completed:
			BrandButton("Leave a Review", size: .large, isDisabled: false, hasIcon: true, icon: "star.fill", secondary: false) {
				showingReviewSheet = true
			}
		case .disputed:
			disputedBanner
			BrandButton("Resubmit Completion", size: .large, isDisabled: false, hasIcon: true, icon: "arrow.clockwise", secondary: true) {
				showingMarkDoneView = true
			}
		default:
			EmptyView()
		}
	}

	@ViewBuilder
	private var workerApplyActionsView: some View {
		if hasAlreadyApplied {
			HStack(spacing: 8) {
				Image(systemName: "checkmark.circle.fill")
				Text("Already Applied").fontWeight(.semibold)
			}
			.frame(maxWidth: .infinity).frame(height: 56)
			.foregroundStyle(.accent)
			.background(Color.accent.opacity(0.1))
			.cornerRadius(14)
			.overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.accent, lineWidth: 1))
		} else if service.status == .published {
			BrandButton("Apply Now", size: .large, isDisabled: false, hasIcon: true, icon: "hand.raised.fill", secondary: false) {
				showingApplySheet = true
			}
		}
	}

	@ViewBuilder
	private var workerWaitingForProviderBanner: some View {
		HStack(spacing: 10) {
			if isConfirmingArrival { ProgressView().tint(.accent) }
			else { Image(systemName: "clock.badge.checkmark.fill").foregroundStyle(.accent) }
			VStack(alignment: .leading, spacing: 2) {
				Text("Arrival Confirmed — Waiting for Provider")
					.font(.subheadline.weight(.semibold))
					.foregroundStyle(Colors.swiftUIColor(.textMain))
				Text("The provider needs to confirm you're on-site.")
					.font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
			}
			Spacer()
		}
		.padding(14)
		.background(Color.accentColor.opacity(0.08)).cornerRadius(14)
		.overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.accentColor.opacity(0.3), lineWidth: 1))
	}

	@ViewBuilder
	private var pendingCompletionBanner: some View {
		HStack(spacing: 10) {
			Image(systemName: "clock.badge.checkmark.fill").foregroundStyle(.purple)
			VStack(alignment: .leading, spacing: 2) {
				Text("Awaiting Provider Confirmation")
					.font(.subheadline.weight(.semibold)).foregroundStyle(Colors.swiftUIColor(.textMain))
				if let requestedAt = service.completionRequestedAt {
					Text("Submitted \(requestedAt, style: .relative)")
						.font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
			}
			Spacer()
		}
		.padding(14).background(Color.purple.opacity(0.08)).cornerRadius(14)
		.overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.purple.opacity(0.3), lineWidth: 1))
	}

	@ViewBuilder
	private var disputedBanner: some View {
		HStack(spacing: 10) {
			Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.red)
			VStack(alignment: .leading, spacing: 2) {
				Text("Provider Has a Concern")
					.font(.subheadline.weight(.semibold)).foregroundStyle(Colors.swiftUIColor(.textMain))
				if let reason = service.disputeReason, !reason.isEmpty {
					Text(reason).font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
			}
			Spacer()
		}
		.padding(14).background(Color.red.opacity(0.08)).cornerRadius(14)
		.overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.red.opacity(0.3), lineWidth: 1))
	}

	// MARK: - Provider Actions

	@ViewBuilder
	private var providerActionsView: some View {
		if service.status == .published && !service.isPaid {
			BrandButton("Pay \(service.formattedPrice) & Secure Shift", size: .large, isDisabled: false, hasIcon: true, icon: "lock.shield.fill", secondary: false) {
				showingPaySheet = true
			}
		} else if service.status == .active {
			if service.workerConfirmedArrival && !service.providerConfirmedWorkerArrival {
				BrandButton("Confirm Worker Arrived", size: .large, isDisabled: isConfirmingArrival, hasIcon: true, icon: "person.fill.checkmark", secondary: false) {
					Task { await confirmWorkerPresenceAsProvider() }
				}
			}
			if service.bothConfirmedArrival {
				BrandButton("Mark as Completed", size: .large, isDisabled: false, hasIcon: true, icon: "checkmark.circle.fill", secondary: false) {
					showingCompletionView = true
				}
			}
			if !service.workerConfirmedArrival {
				BrandButton("Worker Didn't Show Up", size: .large, isDisabled: isReportingNoShow, hasIcon: true, icon: "person.fill.xmark", secondary: true) {
					showNoShowConfirmation = true
				}
			}
		}
	}

	// MARK: - Secondary Action (View Applications / Contact)

	@ViewBuilder
	private var secondaryActionView: some View {
		if !isHiredStudent || isOwnService {
			BrandButton(
				isOwnService ? "View Applications" : "Contact Provider",
				size: .large,
				isDisabled: isCreatingChat || (isOwnService && !service.isPaid),
				hasIcon: true,
				icon: isOwnService ? "person.3.fill" : "bubble.left.fill",
				secondary: true
			) {
				if isOwnService {
					if service.isPaid { showingApplications = true }
					else { showingPaySheet = true }
				} else {
					startChatWithProvider()
				}
			}
		}
	}

	// MARK: - Arrival Handlers

	private func confirmArrivalAsWorker() async {
		isConfirmingArrival = true
		try? await applicationsStore.confirmWorkerArrival(serviceId: service.id)
		isConfirmingArrival = false
	}

	private func confirmWorkerPresenceAsProvider() async {
		isConfirmingArrival = true
		try? await applicationsStore.confirmWorkerPresence(serviceId: service.id)
		isConfirmingArrival = false
	}

	// MARK: - No-Show Handler

	private func reportNoShow() async {
		guard let workerId = service.hiredApplicantId,
			  let providerId = authManager.currentUserId else { return }
		isReportingNoShow = true
		try? await applicationsStore.reportWorkerNoShow(
			serviceId: service.id,
			workerId: workerId,
			providerId: providerId,
			lockedAmount: service.lockedAmount ?? 0,
			serviceTitle: service.title
		)
		isReportingNoShow = false
	}

	private var isOwnService: Bool {
		guard let currentUserId = authManager.currentUserId else { return false }
		return service.providerId == currentUserId
	}

	private var isHiredStudent: Bool {
		guard let currentUserId = authManager.currentUserId,
			  let hiredId = service.hiredApplicantId else { return false }
		return hiredId == currentUserId && !isOwnService
	}

	private var hasAlreadyApplied: Bool {
		return applicationsStore.hasApplied(to: service.id)
	}

	private var otherApplicantCount: Int {
		let total = service.applicationCount
		return hasAlreadyApplied ? max(0, total - 1) : total
	}

	@ViewBuilder
	private var providerApplicantsSection: some View {
		let applications = applicationsStore.receivedApplications
			.filter { $0.serviceId == service.id && $0.status != .rejected && $0.status != .withdrawn }
			.sorted { $0.appliedAt > $1.appliedAt }

		if !applications.isEmpty {
			VStack(alignment: .leading, spacing: 12) {
				HStack(spacing: 6) {
					Image(systemName: "person.2.fill")
						.font(.subheadline)
						.foregroundStyle(.accent)
					Text("Applicants (\(applications.count))")
						.font(.headline)
						.fontDesign(.monospaced)
						.foregroundStyle(Colors.swiftUIColor(.textMain))
				}

				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 14) {
						ForEach(applications) { application in
							Button {
								reviewItem = ApplicantReviewItem(application: application, service: service)
							} label: {
								ApplicantAvatarBubble(application: application, user: nil)
							}
							.buttonStyle(.plain)
						}
					}
					.padding(.horizontal, 2)
				}
			}
			.padding(16)
			.background(Colors.swiftUIColor(.cardBackground))
			.cornerRadius(14)
		}
	}

	private func startChatWithProvider() {
		guard let currentUserId = authManager.currentUserId else { return }

		isCreatingChat = true

		Task {
			do {
				let conversationId = try await conversationsStore.getOrCreateConversation(
					with: service.providerId,
					currentUserId: currentUserId
				)

				await MainActor.run {
					isCreatingChat = false
					appCoordinator.navigateToChat(conversationId: conversationId)
				}
			} catch {
				await MainActor.run {
					isCreatingChat = false
				}
			}
		}
	}
	
	private func trackJobViewed() {
		AnalyticsService.shared.track(.jobViewed(
			jobId: service.id,
			category: service.category?.rawValue ?? "",
			price: service.price
		))
	}

	private func boostJob() async {
		guard !service.isFeatured else { return }
		isBoostingJob = true
		var boosted = service
		boosted.isFeatured = true
		try? await servicesStore.updateService(boosted)
		isBoostingJob = false
	}

	private func deleteJob() async {
		try? await servicesStore.removeService(id: service.id)
		dismiss()
	}

	private func bulkUpdateAllShifts() async {
		guard let groupId = service.jobGroupId else { return }
		isBulkUpdating = true
		try? await servicesStore.bulkUpdateSharedFields(groupId: groupId, from: service)
		isBulkUpdating = false
	}

	private func formatDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, yyyy"
		return formatter.string(from: date)
	}
}

// MARK: - Section Card wrapper
struct SectionCard<Content: View>: View {
	let title: String
	let icon: String
	@ViewBuilder let content: () -> Content
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(spacing: 6) {
				Image(systemName: icon)
					.font(.subheadline)
					.foregroundStyle(.accent)
				Text(title)
					.font(.headline)
					.fontDesign(.monospaced)
					.foregroundStyle(Colors.swiftUIColor(.textMain))
			}
			
			content()
				.padding(14)
				.background()
				.cornerRadius(12)
		}
	}
}

// MARK: - Detail Divider
struct DetailDivider: View {
	var body: some View {
		Divider()
			.padding(.leading, 36)
	}
}

// MARK: - Service Image Section with Remote Loading
struct ServiceImageSection: View {
	let service: JobService
	
	var body: some View {
		ZStack {
			Color(.systemGray6)
			
			if let remoteURL = service.image.remoteURL, !remoteURL.isEmpty {
				KFImage(URL(string: remoteURL))
					.resizable()
					.placeholder {
						ProgressView().tint(.accent)
					}
					.aspectRatio(contentMode: .fill)
					.ignoresSafeArea()
			} else if let localImage = service.image.localImage {
				Image(uiImage: localImage)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.ignoresSafeArea()
			} else {
				VStack(spacing: 12) {
					Image(systemName: "briefcase.fill")
						.font(.system(size: 56))
						.foregroundStyle(.accent.opacity(0.4))
					Text("No Image")
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Colors.swiftUIColor(.appBackground))
			}
			
			// Bottom gradient overlay for readability
			VStack {
				Spacer()
				LinearGradient(
					colors: [Colors.swiftUIColor(.appBackground), .clear],
					startPoint: .bottom,
					endPoint: .center
				)
				.frame(height: 80)
			}
		}
		.clipped()
	}
}

// MARK: - Detail Item Component
struct DetailItem: View {
	let icon: String
	let label: String
	let value: String
	
	var body: some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.foregroundStyle(.accent)
				.font(.subheadline)
				.frame(width: 24)
			
			VStack(alignment: .leading, spacing: 2) {
				Text(label)
					.font(.caption)
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				Text(value)
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(Colors.swiftUIColor(.textMain))
			}
			
			Spacer()
		}
		.padding(.vertical, 6)
	}
}

// MARK: - Provider Section
struct ProviderSection: View {
	let service: JobService
	var startChatAction: () -> Void
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack(spacing: 6) {
				Image(systemName: "person.circle.fill")
					.font(.subheadline)
					.foregroundStyle(.accent)
				Text("Posted By")
					.font(.headline)
					.fontDesign(.monospaced)
					.foregroundStyle(Colors.swiftUIColor(.textMain))
			}
			
			HStack(spacing: 12) {
				if let photoURL = service.providerImageURL, let url = URL(string: photoURL) {
					KFImage(url)
						.resizable()
						.placeholder {
							Image(systemName: "person.circle.fill")
								.resizable()
								.foregroundStyle(.accent.opacity(0.4))
						}
						.scaledToFill()
						.frame(width: 52, height: 52)
						.clipShape(Circle())
				} else {
					Image(systemName: "person.circle.fill")
						.resizable()
						.frame(width: 52, height: 52)
						.foregroundStyle(.accent.opacity(0.4))
				}
				
				VStack(alignment: .leading, spacing: 2) {
					Text(service.providerName ?? "Service Provider")
						.font(.headline)
						.foregroundStyle(Colors.swiftUIColor(.textMain))
					if let company = service.companyName, !company.isEmpty {
						Text(company)
							.font(.caption)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					} else {
						Text("Service Provider")
							.font(.caption)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					}
				}
				
				Spacer()
				
				Button(action: startChatAction) {
					Image(systemName: "message.fill")
						.foregroundStyle(.accent)
						.font(.title3)
						.padding(10)
						.background(Color.accent.opacity(0.12))
						.cornerRadius(10)
				}
			}
			.padding(14)
			.background()
			.cornerRadius(14)
		}
	}
}

// MARK: - Apply Job Sheet
struct ApplyJobSheetContent: View {
	let service: JobService
	
	@Environment(\.dismiss) var dismiss
	@Environment(AuthenticationManager.self) var authManager
	@Environment(ApplicationsStore.self) var applicationsStore
	
	@State private var coverMessage = ""
	@State private var proposedPrice = ""
	@State private var isSubmitting = false
	@State private var showError = false
	@State private var errorMessage = ""
	@State private var showSuccess = false
	
	var isFormValid: Bool {
		!isSubmitting
	}
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 24) {
					// MARK: - Header
					VStack(spacing: 8) {
						Text("Apply for This Job")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
						
						Text(service.title)
							.font(.headline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					}
					.frame(maxWidth: .infinity)
					
					Divider()
					
					// MARK: - Service Summary
					VStack(spacing: 12) {
						HStack(spacing: 16) {
							Image(systemName: "briefcase.fill")
								.font(.title3)
								.foregroundStyle(.accent)
								.frame(width: 24)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("Price")
									.font(.caption)
									.foregroundStyle(Colors.swiftUIColor(.textSecondary))
								Text(service.formattedPrice)
									.font(.headline)
									.foregroundStyle(Colors.swiftUIColor(.textMain))
							}
							
							Spacer()
						}
						
						HStack(spacing: 16) {
							Image(systemName: "location.fill")
								.font(.title3)
								.foregroundStyle(.accent)
								.frame(width: 24)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("Location")
									.font(.caption)
									.foregroundStyle(Colors.swiftUIColor(.textSecondary))
								Text(service.location.name)
									.font(.headline)
									.foregroundStyle(Colors.swiftUIColor(.textMain))
							}
							
							Spacer()
						}
						
						if let hours = service.estimatedDurationHours {
							HStack(spacing: 16) {
								Image(systemName: "clock.fill")
									.font(.title3)
									.foregroundStyle(.accent)
									.frame(width: 24)
								
								VStack(alignment: .leading, spacing: 4) {
									Text("Duration")
										.font(.caption)
										.foregroundStyle(Colors.swiftUIColor(.textSecondary))
									Text(String(format: "%.0f hours", hours))
										.font(.headline)
										.foregroundStyle(Colors.swiftUIColor(.textMain))
								}
								
								Spacer()
							}
						}
					}
					.padding(14)
					.background(Colors.swiftUIColor(.surfaceWhite))
					.cornerRadius(12)
					
					Divider()
					
					// MARK: - Cover Message Section
					VStack(alignment: .leading, spacing: 8) {
						Text("Cover Message (Optional)")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						
						Text("Tell the job poster why you're interested and why you're a good fit")
							.font(.caption)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary).opacity(0.7))
						
						TextEditor(text: $coverMessage)
							.frame(height: 120)
							.padding(8)
							.background(Colors.swiftUIColor(.surfaceWhite))
							.cornerRadius(8)
							.foregroundStyle(Colors.swiftUIColor(.textMain))
							.scrollContentBackground(.hidden)
						
						Text("\(coverMessage.count)/500")
							.font(.caption)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
							.frame(maxWidth: .infinity, alignment: .trailing)
					}
					
					// MARK: - Proposed Price Section
					VStack(alignment: .leading, spacing: 8) {
						Text("Proposed Price (Optional)")
							.font(.subheadline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
						
						Text("Counter-offer a different price if needed")
							.font(.caption)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary).opacity(0.7))
						
						HStack(spacing: 8) {
							Image(systemName: "dollarsign")
								.foregroundStyle(.accent)
							
							TextField("Enter price", text: $proposedPrice)
								.keyboardType(.decimalPad)
								.foregroundStyle(Colors.swiftUIColor(.textMain))
						}
						.padding(12)
						.background(Colors.swiftUIColor(.surfaceWhite))
						.cornerRadius(8)
						
						if !proposedPrice.isEmpty && Double(proposedPrice) == nil {
							Text("Please enter a valid number")
								.font(.caption)
								.foregroundStyle(.red)
						}
					}
					
					Spacer()
					
					// MARK: - Submit Button
					BrandButton(
						isSubmitting ? "Submitting..." : "Submit Application",
						size: .large,
						isDisabled: !isFormValid,
						hasIcon: true,
						icon: isSubmitting ? "clock" : "paperplane.fill",
						secondary: false
					) {
						Task { await submitApplication() }
					}
				}
				.padding()
			}
			.navigationTitle("Apply for Job")
			.navigationBarTitleDisplayMode(.inline)
			.background(Colors.swiftUIColor(.appBackground))
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") { dismiss() }
						.foregroundStyle(.accent)
				}
			}
			.alert("Error", isPresented: $showError) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(errorMessage)
			}
			.alert("Application Sent!", isPresented: $showSuccess) {
				Button("OK", role: .cancel) { dismiss() }
			} message: {
				Text("Your application has been submitted successfully. The job poster will review it soon.")
			}
		}
	}
	
	private func submitApplication() async {
		guard let currentUserId = authManager.currentUserId,
					let currentUser = authManager.currentUser else {
			errorMessage = "You must be logged in to submit an application"
			showError = true
			return
		}
		
		if !proposedPrice.isEmpty, Double(proposedPrice) == nil {
			errorMessage = "Please enter a valid price"
			showError = true
			return
		}
		
		isSubmitting = true
		
		do {
			try await applicationsStore.submitApplication(
				serviceId: service.id,
				providerId: service.providerId,
				applicantId: currentUserId,
				applicantName: currentUser.displayName ?? "User",
				applicantPhotoURL: currentUser.photoURL,
				coverMessage: coverMessage.isEmpty ? nil : coverMessage
			)
			
			showSuccess = true
			isSubmitting = false
		} catch {
			errorMessage = "Failed to submit application: \(error.localizedDescription)"
			showError = true
			isSubmitting = false
		}
	}
}

// MARK: - Service Applications Sheet

struct ApplicantID: Identifiable {
	let id: String
}

// MARK: - State Holder (keeps FirestoreService out of the View)
@Observable private final class ApplicantUsersLoader {
	var users: [String: User] = [:]

	/// Fetches all missing applicant profiles concurrently using TaskGroup.
	/// Previously this was a sequential for-loop: 10 applicants = 10 round-trips one after another.
	/// Now all fetches start at the same time — total time ≈ slowest single fetch.
	func load(applications: [JobApplication]) async {
		let missingIds = applications.map(\.applicantId).filter { users[$0] == nil }
		guard !missingIds.isEmpty else { return }

		await withTaskGroup(of: (String, User?).self) { group in
			for id in missingIds {
				group.addTask {
					let user = try? await FirestoreService.shared.fetchUser(id: id)
					return (id, user)
				}
			}
			for await (id, user) in group {
				if let user { users[id] = user }
			}
		}
	}
}

struct ServiceApplicationsSheet: View {
	let service: JobService
	@Environment(\.dismiss) var dismiss
	@Environment(ApplicationsStore.self) var applicationsStore

	@State private var applicantLoader = ApplicantUsersLoader()
	private var applicantUsers: [String: User] { applicantLoader.users }
	@State private var isLoading = true
	@State private var selectedApplicantID: ApplicantID?
	@State private var actionError: String?
	@State private var showError = false
	
	var applications: [JobApplication] {
		applicationsStore.getApplications(for: service.id)
			.sorted { $0.appliedAt > $1.appliedAt }
	}
	
	var body: some View {
		NavigationStack {
			Group {
				if isLoading && applications.isEmpty {
					ProgressView()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(Colors.swiftUIColor(.appBackground))
				} else if applications.isEmpty {
					ContentUnavailableView(
						"No Applications Yet",
						systemImage: "person.fill.questionmark",
						description: Text("No one has applied to this job yet")
					)
					.background(Colors.swiftUIColor(.appBackground))
				} else {
					List {
						ForEach(applications) { application in
							applicationRow(application)
								.listRowBackground(Colors.swiftUIColor(.surfaceWhite))
						}
					}
					.listStyle(.insetGrouped)
					.scrollContentBackground(.hidden)
					.background(Colors.swiftUIColor(.appBackground))
				}
			}
			.navigationTitle("Applications (\(applications.count))")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Done") { dismiss() }
				}
			}
			.alert("Error", isPresented: $showError) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(actionError ?? "An error occurred")
			}
		}
		.task {
			await applicantLoader.load(applications: applications)
			isLoading = false
		}
		.sheet(item: $selectedApplicantID) { identifier in
			UserProfileSheet(userId: identifier.id)
		}
	}
	
	@ViewBuilder
	private func applicationRow(_ application: JobApplication) -> some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(spacing: 12) {
				if let photoURL = applicantUsers[application.applicantId]?.photoURL,
					 let url = URL(string: photoURL) {
					AsyncImage(url: url) { img in
						img.resizable().scaledToFill()
					} placeholder: {
						Color(.systemGray5)
					}
					.frame(width: 44, height: 44)
					.clipShape(Circle())
				} else {
					Circle()
						.fill(Color(.systemGray5))
						.frame(width: 44, height: 44)
						.overlay(Text("👤").font(.system(size: 18)))
				}
				
				VStack(alignment: .leading, spacing: 2) {
					Text(applicantUsers[application.applicantId]?.displayName ?? application.applicantName)
						.font(.system(size: 15, weight: .semibold))
						.foregroundStyle(Colors.swiftUIColor(.textMain))
					
					if let rating = applicantUsers[application.applicantId]?.rating {
						HStack(spacing: 2) {
							Image(systemName: "star.fill")
								.font(.system(size: 10))
								.foregroundColor(.orange)
							Text(String(format: "%.1f", rating))
								.font(.system(size: 11))
								.foregroundColor(.secondary)
						}
					}
				}
				
				Spacer()
				
				statusBadge(for: application.status)
			}
			
			if let message = application.coverMessage, !message.isEmpty {
				Text(message)
					.font(.system(size: 13))
					.foregroundColor(.secondary)
					.lineLimit(3)
			}
			
			HStack(spacing: 8) {
				if application.status == .pending {
					Button {
						Task { await accept(application) }
					} label: {
						Label("Accept", systemImage: "checkmark")
							.font(.system(size: 13, weight: .semibold))
							.frame(maxWidth: .infinity)
							.padding(.vertical, 8)
							.background(Color.green)
							.foregroundColor(.white)
							.cornerRadius(8)
					}
					.buttonStyle(.plain)
					
					Button {
						Task { await reject(application) }
					} label: {
						Label("Reject", systemImage: "xmark")
							.font(.system(size: 13, weight: .semibold))
							.frame(maxWidth: .infinity)
							.padding(.vertical, 8)
							.background(Color.red)
							.foregroundColor(.white)
							.cornerRadius(8)
					}
					.buttonStyle(.plain)
				}
				
				Button {
					selectedApplicantID = ApplicantID(id: application.applicantId)
				} label: {
					Text("View Profile")
						.font(.system(size: 13, weight: .medium))
						.frame(maxWidth: .infinity)
						.padding(.vertical, 8)
						.background(Color(.systemGray5))
						.foregroundColor(.primary)
						.cornerRadius(8)
				}
				.buttonStyle(.plain)
			}
		}
		.padding(.vertical, 4)
	}
	
	@ViewBuilder
	private func statusBadge(for status: JobApplicationStatus) -> some View {
		let (text, color): (String, Color) = {
			switch status {
			case .pending: return ("Pending", .orange)
			case .accepted: return ("Accepted", .green)
			case .rejected: return ("Rejected", .red)
			case .withdrawn: return ("Withdrawn", .gray)
			case .completed: return ("Completed", .purple)
			}
		}()
		
		Text(text)
			.font(.system(size: 11, weight: .semibold))
			.foregroundColor(.white)
			.padding(.horizontal, 8)
			.padding(.vertical, 4)
			.background(color)
			.cornerRadius(6)
	}
	
	private func accept(_ application: JobApplication) async {
		do {
			try await applicationsStore.acceptApplication(
				applicationId: application.id,
				serviceId: service.id
			)
		} catch {
			actionError = error.localizedDescription
			showError = true
		}
	}
	
	private func reject(_ application: JobApplication) async {
		do {
			try await applicationsStore.updateApplicationStatus(
				applicationId: application.id,
				newStatus: .rejected
			)
			AnalyticsService.shared.track(.applicationRejected(jobId: application.serviceId))
		} catch {
			actionError = error.localizedDescription
			showError = true
		}
	}
}

// MARK: - Applicant Review Item (sheet identity wrapper)

struct ApplicantReviewItem: Identifiable {
    let application: JobApplication
    let service: JobService
    var id: String { application.id }
}

// MARK: - Applicant Review Sheet

struct ApplicantReviewSheet: View {
    let application: JobApplication
    let service: JobService

    @Environment(\.dismiss) var dismiss
    @Environment(ApplicationsStore.self) var applicationsStore

    @State private var loader = UserProfileLoader()
    @State private var isAccepting = false
    @State private var isRejecting = false
    @State private var actionError: String?
    @State private var showError = false

    private var user: User? { loader.user }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Avatar + Name + Rating
                    VStack(spacing: 10) {
                        if let photoURL = user?.photoURL ?? application.applicantPhotoURL,
                           let url = URL(string: photoURL) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                                    .frame(width: 90, height: 90).clipShape(Circle())
                            } placeholder: {
                                Circle().fill(Color(.systemGray5)).frame(width: 90, height: 90)
                            }
                        } else {
                            ZStack {
                                Circle().fill(Colors.swiftUIColor(.primary)).frame(width: 90, height: 90)
                                Text(initials)
                                    .font(.system(size: 28, weight: .bold)).foregroundStyle(.white)
                            }
                        }

                        Text(user?.displayName ?? application.applicantName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Colors.swiftUIColor(.textMain))

                        if let rating = user?.rating {
                            HStack(spacing: 4) {
                                ForEach(0..<5, id: \.self) { i in
                                    Image(systemName: i < Int(rating) ? "star.fill" : "star")
                                        .font(.system(size: 12)).foregroundColor(.orange)
                                }
                                Text(String(format: "%.1f", rating))
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Colors.swiftUIColor(.textPrimary))
                                if let total = user?.totalReviews, total > 0 {
                                    Text("(\(total) reviews)")
                                        .font(.caption).foregroundStyle(Colors.swiftUIColor(.textSecondary))
                                }
                            }
                        }
                    }
                    .padding(.top, 8)

                    // MARK: - Stats Row
                    HStack(spacing: 0) {
                        statCell(
                            icon: "checkmark.circle.fill",
                            value: "\(user?.totalJobsCompleted ?? 0)",
                            label: "Jobs Done"
                        )
                        Divider().frame(height: 40)
                        statCell(
                            icon: "banknote.fill",
                            value: user?.totalEarnings.map { String(format: "%.0f EGP", $0) } ?? "–",
                            label: "Earned"
                        )
                        Divider().frame(height: 40)
                        statCell(
                            icon: "star.fill",
                            value: user.map { "\($0.totalReviews)" } ?? "–",
                            label: "Reviews"
                        )
                    }
                    .padding(.vertical, 12)
                    .background(Colors.swiftUIColor(.cardBackground))
                    .cornerRadius(14)

                    // MARK: - Bio
                    if let bio = user?.bio, !bio.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("About", systemImage: "person.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            Text(bio)
                                .font(.body)
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Colors.swiftUIColor(.cardBackground))
                        .cornerRadius(14)
                    }

                    // MARK: - Cover Message
                    if let message = application.coverMessage, !message.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Cover Message", systemImage: "text.quote")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                            Text(message)
                                .font(.body)
                                .foregroundStyle(Colors.swiftUIColor(.textMain))
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Colors.swiftUIColor(.cardBackground))
                        .cornerRadius(14)
                    }

                    // MARK: - Applied At
                    HStack(spacing: 8) {
                        Image(systemName: "clock").foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Text("Applied \(application.appliedAt, style: .relative) ago")
                            .font(.caption)
                            .foregroundStyle(Colors.swiftUIColor(.textSecondary))
                        Spacer()
                    }

                    // MARK: - Accept / Decline
                    if application.status == .pending {
                        VStack(spacing: 10) {
                            Button {
                                Task { await accept() }
                            } label: {
                                Label(isAccepting ? "Accepting…" : "Accept Applicant", systemImage: "checkmark.circle.fill")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(isAccepting ? Color.green.opacity(0.5) : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                            }
                            .buttonStyle(.plain)
                            .disabled(isAccepting || isRejecting)

                            Button {
                                Task { await decline() }
                            } label: {
                                Label(isRejecting ? "Declining…" : "Decline", systemImage: "xmark.circle.fill")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(isRejecting ? Color.red.opacity(0.3) : Color.red.opacity(0.12))
                                    .foregroundColor(isRejecting ? .white : .red)
                                    .cornerRadius(14)
                                    .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.red.opacity(0.4), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            .disabled(isAccepting || isRejecting)
                        }
                        .padding(.top, 4)
                    } else {
                        // Status badge for non-pending
                        HStack {
                            Spacer()
                            Text(application.status.rawValue.capitalized)
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 16).padding(.vertical, 8)
                                .background(statusColor.opacity(0.15))
                                .foregroundStyle(statusColor)
                                .clipShape(Capsule())
                            Spacer()
                        }
                    }
                }
                .padding(20)
            }
            .background(Colors.swiftUIColor(.appBackground))
            .navigationTitle("Applicant Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(actionError ?? "An error occurred")
            }
        }
        .task {
            await loader.load(userId: application.applicantId)
        }
    }

    // MARK: - Helpers

    private var initials: String {
        let parts = application.applicantName.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined().uppercased()
    }

    private var statusColor: Color {
        switch application.status {
        case .accepted: return .green
        case .rejected: return .red
        case .withdrawn: return .gray
        case .completed: return .purple
        case .pending: return .orange
        }
    }

    private func accept() async {
        isAccepting = true
        do {
            try await applicationsStore.acceptApplication(
                applicationId: application.id,
                serviceId: service.id
            )
            dismiss()
        } catch {
            actionError = error.localizedDescription
            showError = true
        }
        isAccepting = false
    }

    private func decline() async {
        isRejecting = true
        do {
            try await applicationsStore.updateApplicationStatus(
                applicationId: application.id,
                newStatus: .rejected
            )
            AnalyticsService.shared.track(.applicationRejected(jobId: application.serviceId))
            dismiss()
        } catch {
            actionError = error.localizedDescription
            showError = true
        }
        isRejecting = false
    }

    @ViewBuilder
    private func statCell(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Colors.swiftUIColor(.primary))
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Colors.swiftUIColor(.textMain))
            Text(label)
                .font(.caption)
                .foregroundStyle(Colors.swiftUIColor(.textSecondary))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Group Service Detail View

struct GroupServiceDetailView: View {
    let groupId: String
    let shifts: [JobService]

    @Environment(\.dismiss) var dismiss
    @Environment(AuthenticationManager.self) var authManager
    @Environment(ServicesStore.self) var servicesStore
    @Environment(ApplicationsStore.self) var applicationsStore
    @Environment(AppCoordinator.self) var appCoordinator
    @Environment(UserCache.self) var userCache

    @State private var isExpanded: Bool = false
    @State private var showDeleteConfirmation = false
    @State private var showEditBlockAlert = false
    @State private var showDeleteBlockAlert = false
    @State private var isDeleting = false
    @State private var showEditSheet = false

    private var representative: JobService { shifts[0] }

    // Any shift in the group has an active hired worker
    private var hasActiveWorker: Bool {
        shifts.contains { $0.status == .active && $0.hiredApplicantId != nil }
    }

    // Any shift in the group has at least one application
    private var hasApplicants: Bool {
        shifts.contains { $0.applicationCount > 0 }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header image from first shift
                ServiceImageSection(service: representative)
                    .frame(height: 280)

                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text(representative.title)
                        .font(.system(size: 26, weight: .bold))
                        .fontDesign(.monospaced)
                        .foregroundStyle(Colors.swiftUIColor(.textMain))

                    // Price & Category
                    HStack(spacing: 10) {
                        Text(representative.formattedPrice)
                            .font(.system(size: 22, weight: .bold))
                            .fontDesign(.monospaced)
                            .foregroundStyle(.green)

                        Divider().frame(height: 20)

                        Text(representative.categoryDisplayName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.accent.opacity(0.15))
                            .cornerRadius(8)
                            .foregroundStyle(.accent)

                        Spacer()

                        // Total shift count badge
                        HStack(spacing: 4) {
                            Image(systemName: "rectangle.stack.fill")
                                .font(.caption2)
                            Text("\(shifts.count) shifts")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accent.opacity(0.15))
                        .foregroundStyle(.accent)
                        .cornerRadius(8)
                    }

                    // Shifts toggle card
                    JobGroupCard(
                        groupId: groupId,
                        shifts: shifts,
                        isExpanded: isExpanded,
                        onToggle: { withAnimation { isExpanded.toggle() } },
                        onSelectShift: { shift in
                            appCoordinator.serviceProviderCoordinator?.navigate(
                                to: ServiceProviderDestination.serviceDetail(shift)
                            )
                        }
                    )
                }
                .padding(20)
            }
        }
        .background(Colors.swiftUIColor(.appBackground))
        .navigationTitle("Shift Group")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        if hasApplicants {
                            showEditBlockAlert = true
                        } else {
                            showEditSheet = true
                        }
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button {
                        // Boost — placeholder, same as single service boost
                    } label: {
                        Label("Boost Job", systemImage: "bolt.fill")
                    }

                    Button(role: .destructive) {
                        if hasActiveWorker {
                            showDeleteBlockAlert = true
                        } else {
                            showDeleteConfirmation = true
                        }
                    } label: {
                        Label("Delete Service", systemImage: "trash.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.accent)
                }
                .accessibilityLabel("More Options")
            }
        }
        .confirmationDialog(
            "Delete all \(shifts.count) shifts?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete All Shifts", role: .destructive) {
                Task { await deleteGroup() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all shifts in this group. This cannot be undone.")
        }
        .alert("Cannot Edit This Job", isPresented: $showEditBlockAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("A user has applied to one or more shifts. To make changes, delete this service and create a new one.")
        }
        .alert("Cannot Delete This Job", isPresented: $showDeleteBlockAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("A user is currently working one of these shifts. You cannot delete it while it is active.")
        }
        .sheet(isPresented: $showEditSheet) {
            if let providerId = authManager.currentUserId {
                CreateJobSheet(editingService: representative, editingGroupId: groupId, providerId: providerId)
                    .environment(servicesStore)
                    .environment(authManager)
                    .environment(userCache)
                    .environment(JobSeekerCoordinator())
            }
        }
    }

    private func deleteGroup() async {
        guard let providerId = authManager.currentUserId else { return }
        isDeleting = true
        try? await servicesStore.bulkDeleteGroup(groupId: groupId, providerId: providerId)
        isDeleting = false
        dismiss()
    }
}

#Preview {
	NavigationStack {
		ServiceDetailView(service: JobService.sampleData[0])
			.environment(AuthenticationManager(userCache: UserCache()))
			.environment(ApplicationsStore())
			.environment(ServicesStore())
			.environment(WalletStore())
			.environment(ConversationsStore())
			.environment(ReviewsStore())
	}
}
