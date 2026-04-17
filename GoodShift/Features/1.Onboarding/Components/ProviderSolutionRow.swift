//
//  ProviderSolutionRow.swift
//  GoodShift
//
//  Created by Pavly Paules on 17/04/2026.
//

import SwiftUI

struct ProviderSolutionRow: View {
	let pain: String
	let solution: String
	let icon: String
	
	var body: some View {
		HStack(alignment: .top, spacing: 14) {
			ZStack {
				RoundedRectangle(cornerRadius: 12)
					.fill(Colors.swiftUIColor(.primaryDark).opacity(0.12))
					.frame(width: 46, height: 46)
				
				Image(systemName: icon)
					.font(.system(size: 20))
					.foregroundStyle(Colors.swiftUIColor(.primaryDark))
			}
			
			VStack(alignment: .leading, spacing: 4) {
				Text(pain)
					.font(.system(size: 12))
					.foregroundStyle(Colors.swiftUIColor(.textSecondary))
					.lineLimit(2)
				
				Text(solution)
					.font(.system(size: 15, weight: .semibold))
					.foregroundStyle(Colors.swiftUIColor(.textMain))
					.lineSpacing(2)
					.fixedSize(horizontal: false, vertical: true)
			}
			
			Spacer()
		}
		.padding(16)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(Colors.swiftUIColor(.cardBackground))
		)
	}
}

#Preview {
	ProviderSolutionRow(pain: "Manag", solution: "here onfdsaoofrne kjj nrwjn das, kj wrnejo", icon: "home")
}
