//
//  MyAddressesView.swift
//  Saadni
//

import SwiftUI

// MARK: - Row View

private struct AddressRowView: View {
	let address: SavedAddress
	let isEditing: Bool
	let isSelected: Bool
	let isDefault: Bool
	let onTap: () -> Void

	var body: some View {
		Button(action: onTap) {
			HStack {
				VStack(alignment: .leading, spacing: 4) {
					Text(address.label.isEmpty ? address.address : address.label)
						.font(.headline)
					Text(address.address)
						.font(.subheadline)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					Text("\(address.city) • Floor \(address.floor), Unit \(address.unit)")
						.font(.caption)
						.foregroundStyle(Colors.swiftUIColor(.textSecondary))
				}
				Spacer()
				selectionBadge
			}
			.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
	}

	@ViewBuilder
	private var selectionBadge: some View {
		if isEditing {
			Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
				.foregroundStyle(isSelected ? Color.accent : Colors.swiftUIColor(.textSecondary))
		} else if isDefault {
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
}

// MARK: - Main View

struct MyAddressesView: View {
	@Environment(AuthenticationManager.self) var authManager
	@Environment(UserCache.self) var userCache

	@State private var isEditing: Bool = false
	@State private var pendingDefaultId: String? = nil

	private var savedAddresses: [SavedAddress] {
		authManager.currentUser?.savedAddresses ?? []
	}

	private var currentDefaultId: String? {
		authManager.currentUser?.defaultAddressId
	}

	var body: some View {
		List {
			addressRows
		}
		.navigationTitle("My Addresses")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button("Cancel") {
					isEditing = false
					pendingDefaultId = nil
				}
				.foregroundStyle(.red)
				.opacity(isEditing ? 1.0 : 0.0)
				.disabled(!isEditing)
			}
			ToolbarItem(placement: .topBarTrailing) {
				Button(isEditing ? "Set Default" : "Edit") {
					handlePrimaryAction()
				}
				.fontWeight(.semibold)
				.disabled(isEditing && pendingDefaultId == nil)
			}
		}
	}

	@ViewBuilder
	private var addressRows: some View {
		if savedAddresses.isEmpty {
			VStack(spacing: 16) {
				Image(systemName: "mappin.slash.circle")
					.font(.system(size: 48))
					.foregroundStyle(.gray)
				Text("No saved addresses yet.")
					.font(.headline)
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
			}
			.frame(maxWidth: .infinity)
			.listRowSeparator(.hidden)
		} else {
			ForEach(savedAddresses) { address in
				AddressRowView(
					address: address,
					isEditing: isEditing,
					isSelected: pendingDefaultId == address.id,
					isDefault: currentDefaultId == address.id,
					onTap: { if isEditing { pendingDefaultId = address.id } }
				)
			}
			.onDelete { offsets in
				guard !isEditing else { return }
				deleteAddress(at: offsets)
			}
		}
	}

	private func handlePrimaryAction() {
		if isEditing {
			if let id = pendingDefaultId { setDefaultAddress(id) }
			isEditing = false
			pendingDefaultId = nil
		} else {
			pendingDefaultId = currentDefaultId
			isEditing = true
		}
	}

	private func deleteAddress(at offsets: IndexSet) {
		guard var currentUser = authManager.currentUser else { return }
		var addresses = currentUser.savedAddresses ?? []
		let deletedAddresses = offsets.map { addresses[$0] }
		addresses.remove(atOffsets: offsets)
		currentUser.savedAddresses = addresses
		if let defaultId = currentUser.defaultAddressId,
			 deletedAddresses.contains(where: { $0.id == defaultId }) {
			currentUser.defaultAddressId = addresses.last?.id
		}
		Task { await userCache.updateUser(currentUser) }
	}

	private func setDefaultAddress(_ id: String) {
		guard var currentUser = authManager.currentUser else { return }
		currentUser.defaultAddressId = id
		Task { await userCache.updateUser(currentUser) }
	}
}

#Preview {
	NavigationView {
		MyAddressesView()
			.environment(AuthenticationManager(userCache: UserCache()))
			.environment(UserCache())
	}
}
