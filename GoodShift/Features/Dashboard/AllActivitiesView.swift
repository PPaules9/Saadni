//
//  AllActivitiesView.swift
//  GoodShift
//

import SwiftUI

struct AllActivitiesView: View {
    @Environment(ServicesStore.self) var servicesStore
    @Environment(ApplicationsStore.self) var applicationsStore

    private var activities: [ServiceActivity] {
        let sorted = applicationsStore.myApplications.sorted { $0.appliedAt > $1.appliedAt }
        return sorted.compactMap { application -> ServiceActivity? in
            guard let service = servicesStore.services.first(where: { $0.id == application.serviceId }) else {
                return nil
            }
            return ServiceActivity(application: application, service: service)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(Colors.swiftUIColor(.appBackground))
                    .ignoresSafeArea()

                if activities.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 44))
                            .foregroundStyle(.secondary)
                        Text("No activity yet")
                            .font(.headline)
                            .fontDesign(.monospaced)
                            .kerning(-0.5)
                            .foregroundStyle(.primary)
                        Text("Apply to a job to see your activity here.")
                            .font(.subheadline)
                            .fontDesign(.monospaced)
                            .kerning(-0.5)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(activities) { activity in
                                HomeActivityCard(
                                    title: activity.activityType.rawValue,
                                    serviceName: activity.service.title,
                                    status: activity.status,
                                    extraDetails: activity.extraDetails,
                                    isHighlighted: activity.isHighlighted
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
