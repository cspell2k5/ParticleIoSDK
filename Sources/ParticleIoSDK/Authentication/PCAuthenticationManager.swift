//
//  PCAuthenticationManager.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/5/23.
//

import Foundation


public extension Notification.Name {
    static let pc_token_available   = Notification.Name("particle_token_has_become_available")
    static let pc_token_unavailable = Notification.Name("particle_token_no_longer_valid")
}


public enum PCAuthError: Error {
    case invalidUsername
    case invalidPassword
    case notAuthenticated
    case underlyingError(_ error: Error)
}


final public class PCAuthenticationManager: ObservableObject {
    
    // MARK: Properties
    @Published private(set) public var token: PCAccessToken?
    @Published private(set) public var userIsAuthenticated: Bool = false

    public static let shared = PCAuthenticationManager()
    
    private let cryptoManager = PCCryptoManager.shared
        
    @Published private(set) public var loadingProgress = Progress(totalUnitCount: 1)
    
    @Published private(set) public var isLoading: Bool = true
    
    private init() {
                
        Task {
            
            await self.fetchSavedToken()
            
            self.decrementProgress()
            
        }
    }
    
    
    internal init(token: PCAccessToken) async throws {
        try await setToken(token: token)
        self.decrementProgress()
    }
    
    
    private func fetchSavedToken() async {
        
        do {
            if let token = try cryptoManager.fetchSavedToken() {
                
                try await self.setToken(token: token)
                
            } else {
                
                userIsAuthenticated = false
                NotificationCenter.default.post(name: .pc_token_unavailable, object: nil)
            }
        } catch {
            
            NotificationCenter.default.post(name: .pc_token_unavailable, object: nil)
            
            print("error:\n\(error)\nfunction: \(#function) in \(#file)\nisloading: \(isLoading)\n loading progress: \(loadingProgress)")
            
            self.cancelProgress()
        }
    }
    
    
    public func login(token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void) {

        Task {
            do {
                
                try await login(token: token)
                completion(.success(true))
                
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }
    
    
    @discardableResult public func login(token: PCAccessToken) async throws -> Bool {
        
        do {
            
            try await setToken(token: token)
            return true
            
        } catch {
            throw error
        }
    }
    
    
    public func login(credentials: PCCredentials, client: PCClient? = nil, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        Task {
            do {
                
                let result = try await login(credentials: credentials, client: client)
                completion(.success(result))
                
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }
    
    
    @discardableResult public func login(credentials: PCCredentials, client: PCClient? = nil) async throws -> Bool {
        
        do {
           
            let token = try await PCAccessToken.generateAccessToken(client: client, credentials: credentials)
            return try await self.login(token: token)
            
        } catch {
            throw error
        }
    }
    
    
    public func logout(completion: ((Result<Bool, PCError>) -> Void)?) {
        
        Task {
            
            do {
                let result = try await self.logout()
                completion?(.success(result))
            } catch {
                completion?(.failure( error as! PCError ))
            }
        }
    }

    
    @discardableResult public func logout() async throws -> Bool {
        
        guard let token
        else {
            throw PCAuthError.notAuthenticated
        }
                
        do {
            
            try cryptoManager.deleteStoredToken()
            
            let response = try await token.delete()
            
            DispatchQueue.main.sync {
                
                self.objectWillChange.send()
                self.userIsAuthenticated = false
                NotificationCenter.default.post(name: .pc_token_unavailable, object: nil)
            }
            return response.ok //If there was no token to delete return true
            
        } catch {
            throw error as! PCError
        }
    }
    
    
    private func setToken(token: PCAccessToken) async throws {
                
        
        if try await token.isValid() {
            
            try cryptoManager.storeToken(token)
            
            DispatchQueue.main.sync { [weak self] in
                
                self?.objectWillChange.send()
                
                self?.token = token
                self?.userIsAuthenticated = true
                self?.decrementProgress()
                
                NotificationCenter.default.post(name: .pc_token_available, object: token)
                
            }
        } else {
            
            self.logout(completion: nil)
        }
    }
    
    private func newProgress(_ count: Int64 = 1) {
                  
        DispatchQueue.main.sync { [weak self] in
           
            self?.objectWillChange.send()
            self?.isLoading = true
            self?.loadingProgress = Progress(totalUnitCount: count)
        }
    }
    
    private func incrementProgress(_ by: Int64 = 1) {
       
        DispatchQueue.main.async { [weak self] in
            
            self?.objectWillChange.send()
            self?.loadingProgress.increment(by)
        }
    }
    
    private func decrementProgress(_ by: Int64 = 1) {
       
        DispatchQueue.main.async { [weak self] in
           
            guard let self,
            !self.loadingProgress.isFinished else { return }
            
            self.objectWillChange.send()
            self.loadingProgress.decrement(by)
            print("loading progress: \(String(describing: self.loadingProgress.fractionCompleted))")

            if self.loadingProgress.isFinished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.objectWillChange.send()
                    self.isLoading = false
                }
            }
        }
    }
    
    private func cancelProgress() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.objectWillChange.send()
            self?.loadingProgress.cancel()
            self?.isLoading = false
        }
    }
}
