//
//  DashboardView.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//
import SwiftUI

struct DashboardView: View {
 @State private var currentCarouselIndex: Int = 0

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
      EarningsView()
       .padding(.horizontal, 20)
       .padding(.bottom, 32)

      // Recent Activity Section
      RecentActivityView()
       .padding(.horizontal, 20)
       .padding(.bottom, 32)
     }
    }
   }
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

     Text("Find your next service")
      .font(.subheadline)
      .foregroundStyle(.secondary)
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
 @State private var carouselItems: [CarouselItem] = []

 var body: some View {
  VStack(spacing: 16) {
   TabView(selection: $currentIndex) {
    ForEach(0..<carouselItems.count, id: \.self) { index in
     CarouselCard(item: carouselItems[index])
      .tag(index)
    }
   }
   .tabViewStyle(.page(indexDisplayMode: .never))
   .frame(height: 220)

   // Carousel Indicators
   HStack(spacing: 6) {
    ForEach(0..<carouselItems.count, id: \.self) { index in
     Circle()
      .fill(index == currentIndex ? Color.accent : Color.gray.opacity(0.3))
      .frame(width: 8, height: 8)
    }
   }
   .padding(.bottom, 12)
  }
  .padding(.horizontal, 20)
  .onAppear {
   loadCarouselItems()
  }
 }

 private func loadCarouselItems() {
  // This will be populated with actual data from your data source
  // For now, showing placeholder logic
  var items: [CarouselItem] = []

  // Check for active/upcoming jobs
  let hasActiveJob = false // Replace with actual logic
  let hasRecentlyCompletedJob = false // Replace with actual logic

  if hasActiveJob {
   items.append(CarouselItem(
    type: .activeJob,
    title: "House Cleaning",
    subtitle: "Upcoming in 2 hours",
    provider: "John Doe",
    price: "$45"
   ))
  } else if hasRecentlyCompletedJob {
   items.append(CarouselItem(
    type: .completedJob,
    title: "House Cleaning",
    subtitle: "Completed today!",
    provider: "John Doe",
    price: "$45"
   ))
  }

  // Add featured services
  items.append(contentsOf: [
   CarouselItem(
    type: .featured,
    title: "Premium Services",
    subtitle: "Get 20% off this week",
    provider: "Saadni",
    price: "20% OFF"
   ),
   CarouselItem(
    type: .featured,
    title: "Top Rated Services",
    subtitle: "5★ rated by customers",
    provider: "Saadni",
    price: "Popular"
   ),
   CarouselItem(
    type: .featured,
    title: "New Services",
    subtitle: "Discover what's new",
    provider: "Saadni",
    price: "New"
   )
  ])

  carouselItems = items
 }
}


// MARK: - Carousel Item Model
struct CarouselItem: Identifiable {
 let id = UUID()
 enum ItemType {
  case activeJob
  case completedJob
  case featured
 }

 let type: ItemType
 let title: String
 let subtitle: String
 let provider: String
 let price: String
}


// MARK: - Carousel Card View
struct CarouselCard: View {
 let item: CarouselItem

 var backgroundColor: Color {
  switch item.type {
  case .activeJob:
   return Color.green.opacity(0.1)
  case .completedJob:
   return Color.blue.opacity(0.1)
  case .featured:
   return Color.accent.opacity(0.1)
  }
 }

 var iconName: String {
  switch item.type {
  case .activeJob:
   return "clock.fill"
  case .completedJob:
   return "checkmark.circle.fill"
  case .featured:
   return "star.fill"
  }
 }

 var body: some View {
  RoundedRectangle(cornerRadius: 16)
   .fill(backgroundColor)
   .overlay(
    VStack(alignment: .leading, spacing: 12) {
     HStack {
      VStack(alignment: .leading, spacing: 8) {
       HStack(spacing: 8) {
        Image(systemName: iconName)
         .font(.system(size: 16, weight: .semibold))
         .foregroundStyle(item.type == .activeJob ? .green : item.type == .completedJob ? .blue : .accent)

        Text(item.title)
         .font(.headline)
         .foregroundStyle(.primary)
       }

       Text(item.subtitle)
        .font(.subheadline)
        .foregroundStyle(.secondary)
      }

      Spacer()

      VStack(alignment: .trailing, spacing: 4) {
       Text(item.price)
        .font(.headline)
        .foregroundStyle(.accent)

       Text(item.provider)
        .font(.caption)
        .foregroundStyle(.secondary)
      }
     }

     Spacer()

     HStack {
      Text("Learn more")
       .font(.subheadline)
       .foregroundStyle(.accent)

      Spacer()

      Image(systemName: "arrow.right")
       .font(.system(size: 14, weight: .semibold))
       .foregroundStyle(.accent)
     }
    }
    .padding(16)
   )
 }
}


// MARK: - Earnings View
struct EarningsView: View {
 @State private var totalEarnings: Double = 245.50

 var body: some View {
  HStack() {
   VStack(alignment: .leading, spacing: 4){
    Text("Your Earnings")
     .font(.subheadline)
     .fontDesign(.rounded)
     .foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
    
    Text("This month")
     .font(.caption)
     .fontDesign(.rounded)
     .foregroundStyle(Colors.swiftUIColor(.textMain).opacity(0.7))
   }
   Spacer()
   HStack(alignment: .center, spacing: 0) {
    Text("EGP ")
     .font(.system(size: 30, weight: .bold))
     .foregroundStyle(.secondary)
    
    Text(String(format: "%.2f", totalEarnings))
     .font(.system(size: 30, weight: .bold))
     .foregroundStyle(.primary)
   }
  }
  .padding(16)
  .background(Color.accent)
  .cornerRadius(12)
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

    Spacer()

    Button(action: {}) {
     Text("See All")
      .font(.subheadline)
      .foregroundStyle(.accent)
    }
   }

   
  }
 }
}




#Preview {
 DashboardView()
}
