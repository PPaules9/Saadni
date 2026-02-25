//
//  JobCategories.swift
//  Saadni
//
//  Created by Pavly Paules on 25/02/2026.
//

import Foundation

enum JobType {
 case flexibleJobs
 case shift
}

enum FlexibleJobCategory: String, CaseIterable {
 // Cleaning
 case helpCleaning = "Help Cleaning"

 // Moving & Logistics
 case helpMoving = "Help Moving"
 case deliveryService = "Delivery Service"
 
 // Food & Beverage
 case makeCoffee = "Make Me Coffee"
 case cookForMe = "Cook for Me"
 case studyWithMe = "Study With Me"
 case mealPrep = "Meal Prep"
 
 // Shopping & Errands
 case groceryShopping = "Grocery Shopping"
 case pharmacyShopping = "Pharmacy Shopping"
 
 // Personal Services
 case personalShopper = "Personal Shopper"
 case petCare = "Pet Care"
 case babysSitting = "Baby Sitting"
 
 var icon: String {
  switch self {
  case .helpCleaning: return "sparkles"
  case .helpMoving: return "shippingbox.and.arrow.backward"
  case .deliveryService: return "truck.box"
  case .makeCoffee: return "cup.and.saucer"
  case .cookForMe: return "frying.pan"
  case .studyWithMe: return "birthday.cake"
  case .mealPrep: return "takeoutbag.and.cup.and.straw"
  case .groceryShopping: return "cart"
  case .pharmacyShopping: return "pills"
  case .personalShopper: return "person.crop.square"
  case .petCare: return "pawprint.fill"
  case .babysSitting: return "figure.2.and.child.holdinghands"
  }
 }
}



enum ShiftCategory: String, CaseIterable {
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

struct Shift: Identifiable, Hashable {
 let id = UUID()
 let name: String
 let requirments: String
 let time: String
}
