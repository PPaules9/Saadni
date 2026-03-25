import Foundation

enum ServiceCategoryGroup: String, CaseIterable {
    case cleaning
    case installation
    case maintenance
    case assembly

    var title: LocalizedStringResource {
        switch self {
        case .cleaning:
            return "Cleaning Services"
        case .installation:
            return "Installation & Mounting"
        case .maintenance:
            return "Repairs & Maintenance"
        case .assembly:
            return "Assembly & Other"
        }
    }

    var services: [ServiceItemCard] {
        switch self {
        case .cleaning:
            return [
                ServiceItemCard(name: "homeCleaning", displayName: "Home Cleaning"),
                ServiceItemCard(name: "carpetCleaning", displayName: "Carpet Cleaning"),
                ServiceItemCard(name: "outdoorCleaning", displayName: "Outdoor Cleaning")
            ]
        case .installation:
            return [
                ServiceItemCard(name: "doorInstallation", displayName: "Door Installation"),
                ServiceItemCard(name: "windowInstallation", displayName: "Window Installation"),
                ServiceItemCard(name: "tvMounting", displayName: "TV Mounting"),
                ServiceItemCard(name: "kitchenInstallation", displayName: "Kitchen Installation"),
                ServiceItemCard(name: "flooringInstallation", displayName: "Flooring Installation"),
                ServiceItemCard(name: "curtainInstallation", displayName: "Curtain Installation"),
                ServiceItemCard(name: "CameraInstallation", displayName: "Camera Installation")
            ]
        case .maintenance:
            return [
                ServiceItemCard(name: "electricWork", displayName: "Electric Work"),
                ServiceItemCard(name: "plumbing", displayName: "Plumbing"),
                ServiceItemCard(name: "painting", displayName: "Painting"),
                ServiceItemCard(name: "AirConditioner", displayName: "Air Conditioner"),
                ServiceItemCard(name: "gardening", displayName: "Gardening")
            ]
        case .assembly:
            return [
                ServiceItemCard(name: "furnitureAssembly", displayName: "Furniture Assembly"),
                ServiceItemCard(name: "IkeaAssemply", displayName: "IKEA Assembly"),
                ServiceItemCard(name: "babySitting", displayName: "Baby Sitting"),
                ServiceItemCard(name: "petSetting", displayName: "Pet Setting"),
                ServiceItemCard(name: "helpMoving", displayName: "Help Moving"),
                ServiceItemCard(name: "beachBabySetting", displayName: "Beach Baby Setting")
            ]
        }
    }
}

struct ServiceItemCard: Identifiable {
    let id = UUID()
    let name: String
    let displayName: LocalizedStringResource
}
