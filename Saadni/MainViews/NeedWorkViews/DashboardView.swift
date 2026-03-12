//
//  DashboardView.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//
import SwiftUI

struct DashboardView: View {
 @State private var currentCarouselIndex: Int = 0
 @State private var showWalletSheet: Bool = false
 
 var body: some View {
  ZStack {
   Color(Colors.swiftUIColor(.appBackground))
    .ignoresSafeArea()
   
   NavigationStack {
    ScrollView {
     VStack(spacing: 0) {
      // Dashboard Header (Toolbar)
      DashboardHeaderView()
       .padding(.horizontal, 20)
       .padding(.vertical, 16)
      
      // Carousel Section
      JobStatusCarouselView(currentIndex: $currentCarouselIndex)
       .padding(.bottom, 24)
      
      // Earnings Section
      EarningsView(showWalletSheet: $showWalletSheet)
       .padding(.horizontal, 20)
       .padding(.bottom, 32)
      
      // Recent Activity Section
      RecentActivityView()
       .padding(.horizontal, 20)
       .padding(.vertical, 32)
     }
    }
   }
  }
  .sheet(isPresented: $showWalletSheet) {
   WalletSheet()
  }
 }
}


// MARK: - Dashboard Header View
struct DashboardHeaderView: View {
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   HStack {
    VStack(alignment: .leading, spacing: 4) {
     Text("Hi, Pavly")
      .font(.headline)
      .foregroundStyle(.primary)
      .fontDesign(.monospaced)
      .kerning(-1)
     
     Text("Find your next service")
      .font(.subheadline)
      .foregroundStyle(.secondary)
      .fontDesign(.monospaced)
      .kerning(-1)
     
    }
    
    Spacer()
    
    HStack(spacing: 12) {
     Button(action: {}) {
      Image(systemName: "magnifyingglass")
       .font(.system(size: 18, weight: .semibold))
       .foregroundStyle(.primary)
     }
     
     Button(action: {}) {
      Image(systemName: "bell")
       .font(.system(size: 18, weight: .semibold))
       .foregroundStyle(.primary)
     }
    }
   }
  }
 }
}


// MARK: - Job Status Carousel View
struct JobStatusCarouselView: View {
 @Binding var currentIndex: Int
 @State private var navigateToFeaturedService = false
 @State private var navigateToNewService = false
 let featuredService = JobService.sampleData.first { $0.isFeatured }
 let newService = JobService.sampleData.first { $0.isNew }

 var body: some View {
  VStack(spacing: 16) {
   TabView(selection: $currentIndex) {
    if let featured = featuredService {
     CarouselCard(
      title: "Featured Services",
      subtitle: "Get extra cash",
      provider: "Additionals",
      price: "Up to 10%",
      onTapAction: {
       navigateToFeaturedService = true
      }
     )
     .tag(0)
     .navigationDestination(isPresented: $navigateToFeaturedService) {
      ServiceDetailView(service: featured)
     }
    }

    CarouselCard(
     title: "Top Rated Users",
     subtitle: "5★ rated by customers",
     provider: "well Known",
     price: "Popular",
     onTapAction: {}
    )
     .tag(1)

    if let new = newService {
     CarouselCard(
      title: "New Services",
      subtitle: "Discover what's new",
      provider: "",
      price: "New",
      onTapAction: {
       navigateToNewService = true
      }
     )
     .tag(2)
     .navigationDestination(isPresented: $navigateToNewService) {
      ServiceDetailView(service: new)
     }
    }
   }
   .tabViewStyle(.page(indexDisplayMode: .never))
   .frame(height: 220)

   // Carousel Indicators
   HStack(spacing: 6) {
    ForEach(0..<3, id: \.self) { index in
     Circle()
      .fill(index == currentIndex ? Color.accent : Color.gray.opacity(0.3))
      .frame(width: 8, height: 8)
    }
   }
   .padding(.bottom, 12)
  }
  .padding(.horizontal, 20)
 }
}


// MARK: - Earnings View
struct EarningsView: View {
 @State private var totalEarnings: Double = 250
 @Binding var showWalletSheet: Bool
 
 var body: some View {
  HStack() {
   VStack(alignment: .leading, spacing: 4){
    Text("Your Wallet")
     .font(.subheadline)
     .foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
     .fontDesign(.monospaced)
     .kerning(-1)
    
    Text("Earnings per month")
     .font(.caption)
     .foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
     .fontDesign(.monospaced)
     .kerning(-1)
    
   }
   Spacer()
   HStack(alignment: .center, spacing: 0) {
    Text("EGP ")
     .font(.system(size: 30, weight: .bold))
     .foregroundStyle(.secondary)
     .fontDesign(.monospaced)
     .kerning(-1)
    
    Text(String(format: "%.0f", totalEarnings))
     .font(.system(size: 30, weight: .bold))
     .foregroundStyle(.primary)
     .fontDesign(.monospaced)
     .kerning(-1)
    
   }
  }
  .padding(16)
  .background(Color.accent)
  .cornerRadius(12)
  .onTapGesture {
   showWalletSheet = true
  }
 }
}


// MARK: - Recent Activity View
struct RecentActivityView: View {
 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   HStack {
    Text("Recent Activity")
     .font(.headline)
     .foregroundStyle(.primary)
     .fontDesign(.monospaced)
     .kerning(-1)

    Spacer()

    Button(action: {}) {
     Text("See All")
      .font(.subheadline)
      .foregroundStyle(.accent)
      .fontDesign(.monospaced)
      .kerning(-0.5)
    }
   }

   VStack(spacing: 12) {
    ForEach(JobService.sampleActivities) { activity in
     HomeActivityCard(
      title: activity.activityType.rawValue,
      serviceName: activity.service.title,
      status: activity.status,
      extraDetails: activity.extraDetails,
      isHighlighted: activity.isHighlighted
     )
    }
   }
  }
 }
}


#Preview {
 DashboardView()
}
