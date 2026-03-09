//
//  PersistenceProvider.swift
//  Saadni
//
//  Created by Pavly Paules on 09/03/2026.
//

import Foundation


protocol PersistenceProvider {
    func load<T>(_ key: StateKey<T>) -> T
    func save<T>(_ value: T, for key: StateKey<T>) async throws
}

// UserDefaults implementation
class UserDefaultsProvider: PersistenceProvider {
    func load<T>(_ key: StateKey<T>) -> T {
        return UserDefaults.standard.object(forKey: key.key) as? T 
               ?? key.defaultValue
    }
    
    func save<T>(_ value: T, for key: StateKey<T>) async throws {
        UserDefaults.standard.set(value, forKey: key.key)
        // Could add error handling here
    }
}











/*
 Developer Notes:
  This is created for future implementation option to coreData or CloudKitProvider
 */
