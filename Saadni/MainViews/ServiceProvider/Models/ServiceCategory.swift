//
//  ServiceCategory.swift
//  Saadni
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct ServiceCategory: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let backgroundColor: Color
}

struct ServiceSection: Identifiable {
    let id = UUID()
    let title: String
    let categories: [ServiceCategory]
    let isSpecialEvent: Bool

    init(title: String, categories: [ServiceCategory], isSpecialEvent: Bool = false) {
        self.title = title
        self.categories = categories
        self.isSpecialEvent = isSpecialEvent
    }
}
