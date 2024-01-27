    //
    //  CryptoManager.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 8/21/23.
    //

import Foundation
import CryptoKit


public class PCCryptoManager {
    
    public static let shared = PCCryptoManager()
    private let keyName = "com.spellsoftware.particleiosdk.CryptoStore.ParticleSDK.\(String(describing: Bundle.main.bundleIdentifier))"
    
    private var key: SymmetricKey
    
    public init() {
        
        if let key: SymmetricKey = try? PrivateKeyStore(keyName: keyName).readKey() {
            self.key = key
        } else {
            self.key = try! PrivateKeyStore(keyName: keyName).roundTrip(SymmetricKey(size: .bits256))
        }
    }
    
    private func encryptData(_ data: Data) throws -> Data {
        let encryptedContent = try ChaChaPoly.seal(data, using: key).combined
        let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedContent)
        
        let nonce = sealedBox.nonce
        let ciphertext = sealedBox.ciphertext
        let tag = sealedBox.tag
        
        assert(sealedBox.combined == nonce + ciphertext + tag)
        return sealedBox.combined
    }
    
    private func decrypt(_ data: Data) throws -> Data {
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        return try ChaChaPoly.open(sealedBox, using: key)
    }

    public func deleteStoredToken() throws {
        try PCKeychainStore().deleteStoredTokenData()
    }
    
    @discardableResult public func storeToken(_ token: PCAccessToken) throws -> PCAccessToken {
                
            let data = try JSONEncoder().encode(token)
            let encryptedData = try encryptData(data)
            let returnedData = try PCKeychainStore().roundTrip(encryptedData)
            let decryptedData = try decrypt(returnedData)
            return try JSONDecoder().decode(PCAccessToken.self, from: decryptedData)
    }
    
    public func fetchSavedToken() throws -> PCAccessToken? {
        guard let encryptedData = try PCKeychainStore().readStoredTokenData() else {
            print("no stored token available.")
            return nil
        }
        let decryptedData = try decrypt(encryptedData)
        return try JSONDecoder().decode(PCAccessToken.self, from: decryptedData)
    }
}



fileprivate extension SymmetricKey {
    
    init<D>(rawRepresentation data: D) throws where D: ContiguousBytes {
        self.init(data: data)
    }
    
    var rawRepresentation: Data {
        return dataRepresentation  // Contiguous bytes repackaged as a Data instance.
    }
}

fileprivate extension ContiguousBytes {
        /// A Data instance created safely from the contiguous bytes without making any copies.
     var dataRepresentation: Data {
        return self.withUnsafeBytes { bytes in
            let cfdata = CFDataCreateWithBytesNoCopy(nil, bytes.baseAddress?.assumingMemoryBound(to: UInt8.self), bytes.count, kCFAllocatorNull)
            return ((cfdata as NSData?) as Data?) ?? Data()
        }
    }
}


fileprivate struct PrivateKeyStore {
    
    fileprivate let keyName: String
    
        /// Stores a CryptoKit key in the keychain as a generic password.
    fileprivate func storeKey(_ key: SymmetricKey) throws {
        
            // Treat the key data as a generic password.
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: keyName,
                 kSecAttrLabel: keyName,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
 kSecUseDataProtectionKeychain: true,
                 kSecValueData: key.rawRepresentation] as [String: Any]
        
            // Add the key data.
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeyStoreError("Unable to store item: \(status.message)")
        }
    }
    
        /// Reads a CryptoKit key from the keychain as a generic password.
    fileprivate func readKey() throws -> SymmetricKey? {
        
            // Seek a generic password with the given account.
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: keyName,
 kSecUseDataProtectionKeychain: true,
                kSecReturnData: true] as [String: Any]
        
            // Find and cast the result as data.
        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
            case errSecSuccess:
                guard let data = item as? Data else { return nil }
                return try SymmetricKey(rawRepresentation: data)  // Convert back to a key.
            case errSecItemNotFound: return nil
            case let status: throw KeyStoreError("Keychain read failed: \(status.message)")
        }
    }
    
        /// Stores a key in the keychain and then reads it back.
    fileprivate func roundTrip(_ key: SymmetricKey) throws -> SymmetricKey {
        
            // An account name for the key in the keychain.
        
            // Start fresh.
        try deleteKey()
        
            // Store and read it back.
        try storeKey(key)
        guard let key = try readKey() else {
            throw KeyStoreError("Failed to locate stored key.")
        }
        return key
    }
    
        /// Removes any existing key with the given account.
    fileprivate func deleteKey() throws {
        let query = [kSecClass: kSecClassGenericPassword,
 kSecUseDataProtectionKeychain: true,
               kSecAttrAccount: keyName] as [String: Any]
        switch SecItemDelete(query as CFDictionary) {
            case errSecItemNotFound, errSecSuccess: break // Okay to ignore
            case let status:
                throw KeyStoreError("Unexpected deletion error: \(status.message)")
        }
    }
}


    /// An error we can throw when something goes wrong.
fileprivate struct KeyStoreError: Error, CustomStringConvertible {
    fileprivate var message: String
    
    fileprivate init(_ message: String) {
        self.message = message
    }
    
    fileprivate var description: String {
        return message
    }
}
