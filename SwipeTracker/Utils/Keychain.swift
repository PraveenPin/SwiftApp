//
//  Keychain.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/14/23.
//

import Security

class AuthTokenService {
    static let shared = AuthTokenService()
}

func saveAuthTokenToKeychain(_ token: String) {
    let service = "com.pin.SwipeTracker" // Unique service identifier for your app

    if let data = token.data(using: .utf8) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        // Delete any existing token before saving the new one
        SecItemDelete(query as CFDictionary)

        // Add the new token to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save auth token to Keychain")
        }
    }
}

func removeAuthTokenFromKeychain() {
    let service = "com.example.app" // Unique service identifier for your app

    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service
    ]

    // Delete the auth token from the Keychain
    let status = SecItemDelete(query as CFDictionary)
    if status != errSecSuccess {
        print("Failed to remove auth token from Keychain")
    }
}

func getAuthTokenFromKeychain() -> String? {
    let service = "com.example.app" // Unique service identifier for your app

    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnData as String: true
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    if status == errSecSuccess, let data = result as? Data {
        return String(data: data, encoding: .utf8)
    } else {
        print("Failed to retrieve auth token from Keychain")
        return nil
    }
}

// Login function
func login(withAuthToken authToken: String) {
    saveAuthTokenToKeychain(authToken)
    // Perform other login-related tasks
}

// Logout function
func logout() {
    removeAuthTokenFromKeychain()
    // Perform other logout-related tasks
}
