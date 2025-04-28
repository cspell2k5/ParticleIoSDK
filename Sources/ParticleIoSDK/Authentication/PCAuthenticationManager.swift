//
//  PCAuthenticationManager.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/5/23.
//

import Foundation

/// Extension to define custom notification names for token availability.
public extension Notification.Name {
    /// Notification sent when a particle access token becomes available.
    static let pc_token_available = Notification.Name("particle_token_has_become_available")

    /// Notification sent when a particle access token is no longer valid.
    static let pc_token_unavailable = Notification.Name("particle_token_no_longer_valid")
}

/// Enum defining possible authentication errors.
public enum PCAuthError: Error {
    /// Indicates an invalid username was provided.
    case invalidUsername

    /// Indicates an invalid password was provided.
    case invalidPassword

    /// Indicates the user is not authenticated.
    case notAuthenticated

    /// Wraps an underlying error for additional context.
    case underlyingError(_ error: Error)
}

/// Manages user authentication and access token handling for the Particle SDK.
final public class PCAuthenticationManager: ObservableObject {

    // MARK: Properties

    /// The current access token, if available.
    @Published private(set) public var token: PCAccessToken?

    /// Indicates whether the user is currently authenticated.
    @Published private(set) public var userIsAuthenticated: Bool = false

    /// Singleton instance of the authentication manager.
    public static let shared = PCAuthenticationManager()

    /// Instance of the crypto manager for secure token storage.
    private let cryptoManager = PCCryptoManager.shared

    /// Tracks the progress of authentication-related tasks.
    @Published private(set) public var loadingProgress = Progress(totalUnitCount: 1)

    /// Indicates whether an authentication operation is in progress.
    @Published private(set) public var isLoading: Bool = true

    // MARK: Initialization

    /// Private initializer to enforce singleton pattern and fetch saved token.
    private init() {
        Task {
            await self.fetchSavedToken()
            self.decrementProgress()
        }
    }

    /// Internal initializer for testing with a specific token.
    /// - Parameter token: The access token to initialize with.
    internal init(token: PCAccessToken) async throws {
        try await setToken(token: token)
        self.decrementProgress()
    }

    // MARK: Private Methods

    /// Fetches a saved token from secure storage and updates authentication state.
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
            print("Error fetching saved token: \(error)\nFunction: \(#function)\nFile: \(#file)\nIs Loading: \(isLoading)\nLoading Progress: \(loadingProgress)")
            self.cancelProgress()
        }
    }

    /// Sets and validates a new access token, updating authentication state.
    /// - Parameter token: The access token to set.
    /// - Throws: An error if the token is invalid or cannot be stored.
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

    /// Initializes a new progress tracker for authentication tasks.
    /// - Parameter count: The total number of units for the progress.
    private func newProgress(_ count: Int64 = 1) {
        DispatchQueue.main.sync { [weak self] in
            self?.objectWillChange.send()
            self?.isLoading = true
            self?.loadingProgress = Progress(totalUnitCount: count)
        }
    }

    /// Increments the current progress by a specified amount.
    /// - Parameter by: The number of units to increment the progress.
    private func incrementProgress(_ by: Int64 = 1) {
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
            self?.loadingProgress.increment(by)
        }
    }

    /// Decrements the current progress by a specified amount and updates loading state.
    /// - Parameter by: The number of units to decrement the progress.
    private func decrementProgress(_ by: Int64 = 1) {
        DispatchQueue.main.async { [weak self] in
            guard let self, !self.loadingProgress.isFinished else { return }
            self.objectWillChange.send()
            self.loadingProgress.decrement(by)
            print("Loading progress: \(String(describing: self.loadingProgress.fractionCompleted))")
            if self.loadingProgress.isFinished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.objectWillChange.send()
                    self.isLoading = false
                }
            }
        }
    }

    /// Cancels the current progress and resets loading state.
    private func cancelProgress() {
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
            self?.loadingProgress.cancel()
            self?.isLoading = false
        }
    }

    // MARK: Public Methods

    /// Logs in with a provided access token (callback-based).
    /// - Parameters:
    ///   - token: The access token to use for authentication.
    ///   - completion: A closure called with the result of the login attempt.
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

    /// Logs in with a provided access token (async).
    /// - Parameter token: The access token to use for authentication.
    /// - Returns: A boolean indicating successful login.
    /// - Throws: An error if the login fails.
    @discardableResult
    public func login(token: PCAccessToken) async throws -> Bool {
        do {
            try await setToken(token: token)
            return true
        } catch {
            throw error
        }
    }

    /// Logs in with provided credentials (callback-based).
    /// - Parameters:
    ///   - credentials: The user credentials for authentication.
    ///   - completion: A closure called with the result of the login attempt.
    public func login(credentials: PCCredentials, scopedTo client: PCClient, completion: @escaping (Result<Bool, PCError>) -> Void) {
        Task {
            do {
                let result = try await login(credentials: credentials, scopedTo: client)
                completion(.success(result))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }

    /// Logs in with provided credentials (async).
    /// - Parameters:
    ///  - client: The  client to use for token generation.
    ///  - Returns: A boolean indicating successful login.
    ///  - Throws: An error if the login fails.
    @discardableResult
    public func login(credentials: PCCredentials) async throws -> Bool {
        do {
            let token = try await PCAccessToken.generateAccessToken(credentials: credentials)
            return try await self.login(token: token)
        } catch {
            throw error
        }
    }

    public func login(credentials: PCCredentials, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task {
            do {
                let result = try await login(credentials: credentials)
                completion(.success(result))
            } catch let error as PCError {
                completion(.failure(error))
            } catch {
                completion(.failure(error))
            }
        }
    }



    public func login(credentials: PCCredentials, scopedTo client: PCClient) async throws -> Bool {
        do {
            let token = try await PCAccessToken.generateAccessToken(credentials: credentials, scopedTo: client)
            return try await self.login(token: token)
        } catch {
            throw error
        }
    }

    /// Logs in with a client and generates a new access token (async).
    /// - Parameter client: The client to use for token generation.
    /// - Returns: The generated access token.
    /// - Throws: An error if the login or token generation fails.
    public func login(client: PCClient) async throws -> PCAccessToken {
        let token = try await PCAccessToken.generateAccessToken(client: client)
        try await self.login(token: token)
        return token
    }

    /// Logs in with a client and generates a new access token (callback-based).
    /// - Parameters:
    ///   - client: The client to use for token generation.
    ///   - completion: A closure called with the result of the login attempt.
    public func login(client: PCClient, completion: @escaping (Result<PCAccessToken, Error>) -> Void) {
        Task {
            do {
                let result = try await login(client: client)
                completion(.success(result))
            } catch let error as PCError {
                completion(.failure(error))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Logs out the current user (callback-based).
    /// - Parameter completion: An optional closure called with the result of the logout attempt.
    public func logout(completion: ((Result<Bool, PCError>) -> Void)?) {
        Task {
            do {
                let result = try await self.logout()
                completion?(.success(result))
            } catch {
                completion?(.failure(error as! PCError))
            }
        }
    }

    /// Logs out the current user (async).
    /// - Returns: A boolean indicating successful logout.
    /// - Throws: An error if the logout fails or the user is not authenticated.
    @discardableResult
    public func logout() async throws -> Bool {
        guard let token else {
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
            return response.ok
        } catch {
            throw error as! PCError
        }
    }
}

