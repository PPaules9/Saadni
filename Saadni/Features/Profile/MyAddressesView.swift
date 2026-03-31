//
//  MyAddressesView.swift
//  Saadni
//

import SwiftUI

struct MyAddressesView: View {
	@Environment(AuthenticationManager.self) var authManager
	@Environment(UserCache.self) var userCache
	
	var body: some View {
		Group {
			if let currentUser = authManager.currentUser {
				if currentUser.savedAddresses?.isEmpty ?? true {
					VStack(spacing: 16) {
						Image(systemName: "mappin.slash.circle")
							.font(.system(size: 48))
							.foregroundStyle(.gray)
						Text("No saved addresses yet.")
							.font(.headline)
							.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else {
					List {
						ForEach(currentUser.savedAddresses ?? []) { address in
							HStack {
								VStack(alignment: .leading, spacing: 4) {
									Text(address.address)
										.font(.headline)
									Text("\(address.city) • Floor \(address.floor), Unit \(address.unit)")
										.font(.subheadline)
										.foregroundStyle(Colors.swiftUIColor(.textSecondary))
								}
								
								Spacer()
								
								if currentUser.defaultAddressId == address.id {
									Text("Default")
										.font(.caption2)
										.fontWeight(.bold)
										.padding(.horizontal, 8)
										.padding(.vertical, 4)
										.background(Color.accent.opacity(0.1))
										.foregroundStyle(Color.accent)
										.cornerRadius(8)
								}
							}
							.contentShape(Rectangle())
						}
						.onDelete(perform: deleteAddress)
					}
				}
			} else {
				ProgressView()
			}
		}
		.navigationTitle("My Addresses")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu {
					if let currentUser = authManager.currentUser {
						ForEach(currentUser.savedAddresses ?? []) { address in
							Button(action: {
								setDefaultAddress(address.id)
							}) {
								HStack {
									Text(address.address)
									if currentUser.defaultAddressId == address.id {
										Image(systemName: "checkmark")
									}
								}
							}
						}
					}
				} label: {
					Text("Set Default")
						.font(.subheadline)
						.fontWeight(.semibold)
				}
			}
		}
	}
	
	private func deleteAddress(at offsets: IndexSet) {
		guard var currentUser = authManager.currentUser else { return }
		
		var addresses = currentUser.savedAddresses ?? []
		let deletedAddresses = offsets.map { addresses[$0] }
		addresses.remove(atOffsets: offsets)
		currentUser.savedAddresses = addresses
		
		// If the default address was deleted, reset defaultAddressId
		if let defaultId = currentUser.defaultAddressId,
			 deletedAddresses.contains(where: { $0.id == defaultId }) {
			currentUser.defaultAddressId = addresses.last?.id
		}
		
		Task {
			await userCache.updateUser(currentUser)
		}
	}
	
	private func setDefaultAddress(_ id: String) {
		guard var currentUser = authManager.currentUser else { return }
		currentUser.defaultAddressId = id
		Task {
			await userCache.updateUser(currentUser)
		}
	}
}

#Preview {
	NavigationView {
		MyAddressesView()
			.environment(AuthenticationManager(userCache: UserCache()))
			.environment(UserCache())
	}
}
