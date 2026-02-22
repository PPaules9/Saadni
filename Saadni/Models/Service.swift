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
    let location: String
    let date: String
    let description: String
    let imageName: String // System name or asset name
    let isSystemImage: Bool
    
    // Provider info
    let providerName: String
    let providerImageName: String
    
    static let mocks: [Service] = [
        Service(
            title: "Help Cleaning",
            price: "1000Sek",
            location: "Jönköping",
            date: "29 October 2021",
            description: "I need some help cleaning my small flat. Please text me if you are willing to help.",
            imageName: "washer", // SF Symbol for fallback
            isSystemImage: true,
            providerName: "gr8omr",
            providerImageName: "person.circle.fill"
        ),
        Service(
            title: "Help With Moving",
            price: "1000-1500Sek",
            location: "Jönköping",
            date: "30 October 2021",
            description: "Moving from a 2nd floor apartment to a new place. Need help carrying boxes.",
            imageName: "box.truck",
            isSystemImage: true,
            providerName: "flyttgubbe",
            providerImageName: "person.circle.fill"
        ),
        Service(
            title: "Linköping Till Mantorp",
            price: "500 Sek",
            location: "Linköping",
            date: "01 November 2021",
            description: "Moving a bed and some furniture.",
            imageName: "bed.double",
            isSystemImage: true,
            providerName: "transport",
            providerImageName: "person.circle.fill"
        )
    ]
}
