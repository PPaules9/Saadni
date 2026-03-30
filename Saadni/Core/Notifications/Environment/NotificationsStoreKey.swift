import SwiftUI

struct NotificationsStoreKey: EnvironmentKey {
    static let defaultValue: NotificationsStore = NotificationsStore()
}

extension EnvironmentValues {
    var notificationsStore: NotificationsStore {
        get { self[NotificationsStoreKey.self] }
        set { self[NotificationsStoreKey.self] = newValue }
    }
}
