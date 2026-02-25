//
//  Service.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import Foundation

struct Service: Identifiable, Hashable {
 let id = UUID()
 let title: String
 let price: String
 let type: JobType
 let location: String
 let date: String
 let description: String
 let imageName: String // System name or asset name
 let isSystemImage: Bool

 // Provider info
 let providerName: String
 let providerImageName: String

 // Dashboard properties
 let isFeatured: Bool
 let applicationStatus: ApplicationStatus
 let completionDate: Date?
 let earnings: Double?

 static let mocks: [Service] = [

 ]
}

enum ApplicationStatus: Hashable {
 case none
 case applied
 case upcoming
 case active
 case completed
}
