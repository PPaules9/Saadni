//
//  AppContainer.swift
//  Saadni
//
//  Created by Pavly Paules on 13/03/2026.
//

import Foundation

@Observable
class AppContainer {
    let userCache: UserCache
    let authManager: AuthenticationManager
    let servicesStore: ServicesStore
    let applicationsStore: ApplicationsStore
    let appStateManager: AppStateManager
    let messagesStore: MessagesStore
    let conversationsStore: ConversationsStore
    let errorHandler: ErrorHandler

    init() {
        // Initialize in correct order (dependencies first)
        let cache = UserCache()
        let appState = AppStateManager()
        let authManager = AuthenticationManager(userCache: cache, appStateManager: appState)
        let errorHandler = ErrorHandler()

        self.userCache = cache
        self.authManager = authManager
        self.servicesStore = ServicesStore()
        self.applicationsStore = ApplicationsStore()
        self.appStateManager = appState
        self.messagesStore = MessagesStore()
        self.conversationsStore = ConversationsStore()
        self.errorHandler = errorHandler
    }
}
