    //
    //  PCKeychainStore.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/12/23.
    //

import Foundation

    /// An error we can throw when something goes wrong.
internal struct PCKeychainStoreError: Error, CustomStringConvertible {
    var message: String
    
    internal init(_ message: String) {
        self.message = message
    }
    
    internal var description: String {
        return message
    }
}

internal extension OSStatus {
    
        /// A human readable message for the status.
    var message: String {
        return (SecCopyErrorMessageString(self, nil) as String?) ?? String(self)
    }
}


internal final class PCKeychainStore {
    
    private let keychainID = "com.spellsoftware.particleiosdk.keychainID.ParticleSDK.\(String(describing: Bundle.main.bundleIdentifier))"
        /// Stores a keys data in the keychain as a generic password.
        ///
        /// - Parameter data: The token data to store to the keychain.
        /// - throws: PCKeychainStoreError
    internal func storeTokenData(_ data: Data) throws {
        
            // Treat the key data as a generic password.
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: keychainID,
                 kSecAttrLabel: "ParticleCloudSDK",
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
 kSecUseDataProtectionKeychain: true,
                 kSecValueData: data] as [String: Any]
        
            // Add the key data.
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw PCKeychainStoreError("Unable to store item: \(status.message)")
        }
    }
    
        /// Reads a CryptoKit key from the keychain as a generic password.
        ///
        /// - Returns: Token Data that was stored in the keychain or nil if not found.
        /// - Throws: PCKeychainStoreError
    internal func readStoredTokenData() throws -> Data? {
        
            // Seek a generic password with the given account.
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: keychainID,
 kSecUseDataProtectionKeychain: true,
                kSecReturnData: true] as [String: Any]
        
            // Find and cast the result as data.
        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
            case errSecSuccess:
                guard let data = item as? Data else { return nil }
                return data  // Convert back to a key.
            case errSecItemNotFound: return nil
            case let status: throw PCKeychainStoreError("Keychain read failed: \(status.message)")
        }
    }

        /// Stores a key in the keychain and then reads it back.
        ///
        /// - Parameter data: The token data to store to the keychain.
        /// - Returns: Token Data that was stored in the keychain or nil if not found.
        /// - Throws: PCKeychainStoreError
    internal func roundTrip(_ data: Data) throws -> Data {

            // Start fresh.
        try deleteStoredTokenData()

            // Store and read it back.
        try storeTokenData(data)
        guard let data = try readStoredTokenData() else {
            throw PCKeychainStoreError("Failed to locate stored key.")
        }
        return data
    }
    
        /// Removes any existing key with the given account.
        /// - Throws: PCKeychainStoreError
    internal func deleteStoredTokenData() throws {
        let query = [kSecClass: kSecClassGenericPassword,
 kSecUseDataProtectionKeychain: true,
               kSecAttrAccount: keychainID] as [String: Any]
        switch SecItemDelete(query as CFDictionary) {
            case errSecItemNotFound, errSecSuccess: break // Okay to ignore
            case let status:
                throw PCKeychainStoreError("Unexpected deletion error: \(status.message)")
        }
    }
}

