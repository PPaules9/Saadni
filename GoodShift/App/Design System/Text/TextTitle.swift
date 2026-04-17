//
//  BrandTextEditor.swift
//  GoodShift
//
//  Created by Pavly Paules on 13/03/2026.
//

import SwiftUI


struct TextTitle: View {
    let title: String

    var body: some View {
        Text(title)
				.font(.largeTitle)
				.fontWeight(.bold)
				.fontDesign(.rounded)
			
		}
}

#Preview {

	TextTitle(title: "Main Title")
}
