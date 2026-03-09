//
//  JobCategories.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import Foundation
import SwiftUI

enum JobType: String, Codable {
 case flexibleJobs = "flexibleJobs"
 case shift = "shift"
}

enum ServiceCategoryType: String, CaseIterable, Codable, Hashable {
 // Cleaning Services
 case homeCleaning = "Home Cleaning"
 case carpetCleaning = "Carpet Cleaning"
 case outdoorCleaning = "Outdoor Cleaning"

 // Moving & Logistics
 case helpMoving = "Help Moving"
 case deliveryService = "Delivery Service"

 // Furniture & Assembly
 case furnitureAssembly = "Furniture Assembly"
 case ikea = "Ikea Assembly"

 // Electrical & Plumbing
 case electricalWork = "Electrical Work"
 case plumbing = "Plumbing"

 // Installation Services
 case kitchenInstallation = "Kitchen Installation"
 case doorInstallation = "Door Installation"
 case windowInstallation = "Window Installation"
 case curtainInstallation = "Curtain Installation"
 case flooringInstallation = "Flooring Installation"
 case tvMounting = "TV Mounting"
 case cameraInstallation = "Camera Installation"

 // Home Improvement
 case painting = "Painting"
 case airConditioner = "Air Conditioner Setup"
 case gardening = "Gardening & Landscaping"

 // Personal Services
 case petCare = "Pet Setting"
 case babySitting = "Baby Sitting"
 case personalShopper = "Personal Shopper"

 // Food & Beverage
 case makeCoffee = "Make Me Coffee"
 case cookForMe = "Cook for Me"
 case mealPrep = "Meal Prep"

 // Shopping & Errands
 case groceryShopping = "Grocery Shopping"
 case pharmacyShopping = "Pharmacy Shopping"

 // Special Events
 case beachBabySitting = "Beach Baby Setting"
 case studyWithMe = "Study With Me"

 var icon: String {
  switch self {
  case .homeCleaning: return "sparkles"
  case .carpetCleaning: return "sparkles"
  case .outdoorCleaning: return "leaf.fill"
  case .helpMoving: return "shippingbox.and.arrow.backward"
  case .deliveryService: return "truck.box"
  case .furnitureAssembly: return "hammer.fill"
  case .ikea: return "hammer.fill"
  case .electricalWork: return "bolt.fill"
  case .plumbing: return "wrench.fill"
  case .kitchenInstallation: return "kitchen.2"
  case .doorInstallation: return "door.left.hand.open"
  case .windowInstallation: return "square.split.2x1"
  case .curtainInstallation: return "square.split.2x1"
  case .flooringInstallation: return "square.fill"
  case .tvMounting: return "tv.fill"
  case .cameraInstallation: return "camera.fill"
  case .painting: return "paintbrush.fill"
  case .airConditioner: return "snowflake"
  case .gardening: return "leaf.fill"
  case .petCare: return "pawprint.fill"
  case .babySitting: return "figure.2.and.child.holdinghands"
  case .personalShopper: return "person.crop.square"
  case .makeCoffee: return "cup.and.saucer"
  case .cookForMe: return "frying.pan"
  case .mealPrep: return "takeoutbag.and.cup.and.straw"
  case .groceryShopping: return "cart"
  case .pharmacyShopping: return "pills"
  case .beachBabySitting: return "beach.umbrella.fill"
  case .studyWithMe: return "book.fill"
  }
 }
}



enum ShiftCategory: String, CaseIterable, Codable {
 // Food & Beverage
 case barista = "Barista"
 case waiter = "Waiter"
 case chef = "Chef"
 case dishwasher = "Dishwasher"
 
 // Retail & Sales
 case cashier = "Cashier"
 case shopAssistant = "Shop Assistant"
 case salesRepresentative = "Sales Representative"
 
 // Delivery & Logistics
 case deliveryDriver = "Delivery Driver"
 case warehouseWorker = "Warehouse Worker"
 
 // Creative & Services
 case modelling = "Modelling"
 case photographer = "Photographer"
 case videographer = "Videographer"
 
 // Hospitality
 case hotelStaff = "Hotel Staff"
 case receptionist = "Receptionist"
 
 // Tuition & Teaching
 case languageTeacher = "Language Teacher"
 case fitnessTrainer = "Fitness Trainer"
}

