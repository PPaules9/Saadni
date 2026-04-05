//
//  ServiceCategory.swift
//  GoodShift
//
//  Created by Pavly Paules on 03/03/2026.
//

import SwiftUI

struct ServiceCategory: Identifiable {
 let id = UUID()
 let title: String
 let category: ServiceCategoryType
 let isSpecialEvent: Bool
 let imageName: String
 
 init(title: String, category: ServiceCategoryType, isSpecialEvent: Bool = false, imageName: String) {
  self.title = title
  self.category = category
  self.isSpecialEvent = isSpecialEvent
  self.imageName = imageName
 }
}
