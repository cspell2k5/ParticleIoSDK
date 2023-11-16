    //
    //  PCAccessToken.swift
    //  Particle
    //
    //  Created by Craig Spell on 11/8/19.
    //  Copyright © 2019 Spell Software Inc. All rights reserved.
    //


import Foundation
import Combine


/**
 A representation of the json token response from the server. Use the `PCAccessToken` to engage with server requests that require a oAuth token.
 The `PCAccessToken` cannot be created directly instead use a static method such as `generateAccessToken` to secure a token from ther server.
 
 The `PCAccessToken` is the starting point for making most server requests.
 
 
 Example Usage:
 
 ````swift
 
            let token = try await PCAccessToken.generateAccessToken(credentials: PCCredentials(username: "particle_username", passwrod: "particle_password"))
            let device = try await PCDevice.getDevice(deviceID: "Devices id", token: token)
  
            //do something with your device
 
 ````
 
 */
public struct PCAccessToken : Codable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    
    ///OAuth grant type. Usually password.
    public enum GrantType: String, CustomStringConvertible, CustomDebugStringConvertible {
        ///oAuth grant type password
        case password
        
        //Human readable description.
        public var description: String {
            switch self {
                case .password: return "GrantType: password\n"
            }
        }
        
        //Human readable debug description.
        public var debugDescription: String {
            switch self {
                case .password: return "grant_type=password"
            }
        }
    }

        /// A human readable description of the `PCAccessToken`
    public var description: String {
"""
    accessToken: ends with \(accessToken.suffix(4)),
    refreshToken: ends with \(String(describing: refreshToken?.suffix(4))),
    expiresIn = \(String(describing: expiresIn)),
    tokenType = \(String(describing: tokenType))
"""
    }
    
        /// A human readable description of the `PCAccessToken`
    public var debugDescription : String {
"""
PCAccessToken: {
    accessToken: ends with \(accessToken.suffix(4)),
    refreshToken: ends with \(String(describing: refreshToken?.suffix(4))),
    expiresIn = \(String(describing: expiresIn)),
    tokenType = \(String(describing: tokenType))
}
"""
    }
    
        /// A string representation of the actual oAuth token.
        ///  - Warning: This property should not be logged in a shipping app. This is to be considered a secure item when building your app.
    public let accessToken : String
   
        /// A string representation of the  oAuth refresh  token.
        ///  - Warning: This property should not be logged in a shipping app. This is to be considered a secure item when building your app.
    public let refreshToken : String?
   
        ///The number of seconds this token is valid for. Defaults to 7776000 seconds (90 days) if unspecified in the request. 0 means forever.
    public let expiresIn : Int?
    
        /// The type of oAuth token represented ie: bearer
        ///
        /// For more info on token types see [An Introduction to OAuth 2](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2)
    public let tokenType : String?
    
        /// Private enum for decoding.
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token", refreshToken = "refresh_token", expiresIn = "expires_in", tokenType = "token_type", token
    }
    
        /// Private to keep init from being accessed outside of decoder.
    public init(accessToken: String, refreshToken: String? = nil, expiresIn: Int? = nil, tokenType: String? = nil) {
        fatalError("Requires init using decoder.")
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let token = try? container.decode(String.self, forKey: .accessToken) {
            self.accessToken = token
        } else if let token = try? container.decode(String.self, forKey: .token) {
            self.accessToken = token
        } else {
            throw PCError(code: .badData, description: "Could not get the actual token in \(#function) of \(#file)")
        }
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        self.expiresIn = try container.decodeIfPresent(Int.self, forKey: .expiresIn)
        self.tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var contaner = encoder.container(keyedBy: CodingKeys.self)
        try contaner.encode(accessToken, forKey: .accessToken)
        try contaner.encode(refreshToken, forKey: .refreshToken)
        try contaner.encode(expiresIn, forKey: .expiresIn)
        try contaner.encode(tokenType, forKey: .tokenType)

    }
    
    ///Validate that the current token is still valid.
    ///
    ///Used to validate the access token is valid and current
    ///
    ///Example:
    ///
    ///````swift
    ///
    ///         do {
    ///             if try await someToken.isValid() {
    ///
    ///             someDevice.callFunction(.someFunction, token: someToken) { response in
    ///                 //do something with the response.
    ///             }
    ///         } catch {
    ///             // handle pcError
    ///         }
    ///
    ///````
    ///
    /// - note: This is typically used for logging in with an old token or when a token may have otherwise expired.
    /// - Returns: Bool value indicating the validity of the token.
    /// - Throws: PCError
    public func isValid() async throws -> Bool {
        
        let info = try await PCAccessToken.verifyToken(token: self)
        
        let dateInfo = info.expiresAt
        
        let expirationDate = try Date.date(jSonDate: dateInfo)
        
        if expirationDate > Date() {
            return true
        } else {
            return false //TODO: - should try to get refresh token
        }
    }
    
        ///Validate that the current token is still valid.
        ///
        ///Example:
        ///
        ///````swift
        ///
        ///             someToken.isValid() { result in
        ///                  
        ///                   switch result {
        ///
        ///                       case .failure(let pcError):
        ///
        ///                           //handle error
        ///                      
        ///                       case .success(let isValid):
        ///
        ///                       if isValid {
        ///
        ///                            someDevice.callFunction(.someFunction, token: someToken) { response in
        ///                                //do something with the response.
        ///                            }
        ///                       }
        ///                  }
        ///             }
        ///
        ///````
        ///
        /// - note: This is typically used for logging in with an old token or when a token may have otherwise expired.
        /// - Parameter completion: A Result containing a bool of true if the token is valid or false if not. If the operation could not be completed a PCError is passed instead.
    public func isValid(completion: @escaping (Result<Bool, PCError>) -> Void ) {
        
        PCAccessToken.verifyToken(token: self) { result in
            
            switch result {
                    
                case .success(let info):
                    
                    if let expirationDate = try? Date.date(jSonDate: info.expiresAt) {
                        if expirationDate > Date() {
                            completion(.success(true))
                        } else {
                            completion(.success(false))
                        }
                    } else {
                        completion(
                            .failure(
                                PCError(code: .failedToParseJsonDate, 
                                        description: PCErrorCode.failedToParseJsonDate.description)
                            )
                        )
                    }
                    
                case .failure(let error):
                        //TODO: Try to refresh token.
                    completion(.failure(error))
            }
        }
    }
    
    
    /// Deletes the token on which the method is called on.
    /// - Parameter completion: Closure called when the request has been proccessed returning  a `Result<PCAccessTokenServerResponse.DeletionResponse, PCError>`
    internal func delete(completion: ((Result<PCAccessToken.DeletionResponse, PCError>) -> Void)? = nil) {
        PCNetwork.shared.cloudRequest(.deleteCurrentAccessToken(token: self), type: PCAccessToken.DeletionResponse.self, completion: completion)
    }
}

 
extension PCAccessToken {
    /// Representation of a server response indicating the current state of the `PCAccessToken`.
    public struct VerificationResponse: Decodable, CustomStringConvertible, CustomDebugStringConvertible {
        
        //Human readable description.
        public var description: String {
            debugDescription
        }
        ///Human readable description of the instance.
        public var debugDescription: String {
            "organizations:\(organizations ?? [])\nexpiresAt:\(String(describing: expiresAt))\nscopes:\(scopes ?? [])\n"
        }
        
        /// String representing the date the token expires and is no longer valid.
        /// This should be an ISO8601 formatted date string.
        public let expiresAt : String
        
        ///List of orgs this token has access to.
        public let organizations : [String]?
        
        ///List of scopes for this token.
        public let scopes : [String]?
        
        /// Private enum for decoding.
        private enum CodingKeys: String, CodingKey {
            case organizations = "orgs", scopes, expiresAt = "expires_at"
        }
        
        /// Private to keep init from being accessed outside of decoder.
        private init(expiresAt: String, organizations: [String]?, scopes: [String]?) {
            fatalError("Requires init using decoder.")
        }
    }
    
    ///Represents the server response for the current access token information
    public struct ListResponseElement: Decodable, CustomStringConvertible, CustomDebugStringConvertible {
        
        ///Human readable description of the instance.
        public var description: String {
            debugDescription
        }
        ///Human readable description of the instance.
        public var debugDescription: String {
            "client:\(self.client)\nexpiresAt:\(String(describing: self.expiresAt))\ntoken:ends with \(self.accessToken.suffix(4))\n"
        }
        /// A string representation of the actual oAuth token.
        ///  - Warning: This property should not be logged in a shipping app. This is to be considered a secure item when building your app.
        public let accessToken: String
        
        ///Client program used to create the token.
        ///example:  `"__PASSWORD_ONLY__"`
        public let client: String
        
        ///Time in string format iso8601
        public let expiresAt: String?
        
        
        /// Private enum for decoding.
        private enum CodingKeys: String, CodingKey {
            case client, expiresAt = "expires_at", accessToken = "token"
        }
        /// Private to keep init from being accessed outside of decoder.
        private init(client: String?, expiresAt: String?, token: String?) {
            fatalError("Requires init using decoder.")
        }
    }
    
    ///Represents the server response for the deletion of token access.
    public struct DeletionResponse : Decodable, CustomStringConvertible, CustomDebugStringConvertible {
        
        ///Human readable description of the instance.
        public var description: String {
"""
    ok: \(ok),
    error: \(String(describing: error?.debugDescription)),
    errorDescription: \(String(describing: errorDescription))
    mfaToken: \(String(describing: mfaToken?.suffix(4)))
"""
        }
        
        ///Human readable description of the instance.
        public var debugDescription: String {
"""
DeletionResponse: {
    ok: \(ok),
    error: \(String(describing: error?.debugDescription)),
    errorDescription: \(String(describing: errorDescription))
    mfaToken: \(String(describing: mfaToken?.suffix(4)))
}
"""
        }
        ///Returns true if the token was successfuly deleted.
        public let ok: Bool
        
        /// A machine readable code identifying the error associated with the server response if any.
        public let error: String?
        
        /// A human readable reason for the error associated with the server response if any.
        public let errorDescription: String?
        
        ///The two-factor authentication state code that must be sent back with the one-time password.
        ///  - Warning: This property should not be logged in a shipping app. This is to be considered a secure item when building your app.
        public let mfaToken: String?
        
        /// Private enum for decoding.
        private enum CodingKeys: String, CodingKey {
            case ok, error
            case errorDescription = "error_description"
            case mfaToken = "mfa_token"
        }
        
        /// Private to keep init from being accessed outside of decoder.
        private init(ok: Bool, error: String?, errorDescription: String?, mfaToken: String?) {
            fatalError("Requires init using decoder.")
        }
    }
    
    ///Represents the server error response for the creation of token access.
    public struct ErrorResponse : Decodable, CustomStringConvertible, CustomDebugStringConvertible {
        
        ///Human readable description of the instance.
        public var description: String {
"""
    error: \(String(describing: error?.debugDescription)),
    errorDescription: \(String(describing: errorDescription))
"""
        }
        ///Human readable description of the instance.
        public var debugDescription: String {
"""
ErrorResponse: {
    error: \(String(describing: error?.debugDescription)),
    errorDescription: \(String(describing: errorDescription))
}
"""
        }
        /// A machine readable code identifying the error associated with the server response if any.
        public let error: String?
        
        /// A human readable reason for the error associated with the server response if any.
        public let errorDescription: String?
        
        /// Private enum for decoding.
        private enum CodingKeys: String, CodingKey {
            case error, errorDescription = "error_description"
        }
        
        /// Private to keep init from being accessed outside of decoder.
        private init(error: String?, errorDescription: String?) {
            fatalError("Requires init using decoder.")
        }
    }
}



    // MARK: - CurrentValueSubjects
extension PCAccessToken {
    
        /// Generates a new PCAccessToken. On the server a new oAuth token will be generated and represented by the PCAccessToken.
        ///
        /// You must give a valid OAuth client ID and secret in HTTP Basic Auth or in the client_id and client_secret parameters. For controlling your own developer account, you can use particle:particle. Otherwise use a valid OAuth Client ID and Secret. This endpoint doesn't accept JSON requests, only form encoded requests. See OAuth Clients.Refresh tokens only work for product tokens, and even then they are not particularly useful. In order to generate a new access token from the refresh token you still need the client ID and secret. Because of this, it's simpler to just generate a new token, and then you don't need to remember and keep secure the refresh token. Also refresh tokens have a lifetime of 14 days, much shorter than the default access token lifetime of 90 days.
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           PCAccessToken.generateAccessToken(client: GlobalResources.shared.client,
        ///               credentials: GlobalResources.shared.credentials)
        ///               .sink { completion in
        ///                    switch completion {
        ///                        case .finished:
        ///                            //Do Cleanup
        ///                        case .failure(let error):
        ///                            //do something with the PCError
        ///                    }
        ///               } receiveValue: { token in
        ///                    if token != nil {
        ///                        //do something with the token
        ///                    }
        ///               }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - note: `expiresAt` parameter if provided, must be in ISO8601 format
        /// - Parameter client: OAuth client including clientID and password. Required if no credentials are provided.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter grantType: OAuth grant type. Defaults to 'password'
        /// - Parameter expiresIn: Number of seconds the token remain valid. 0 means forever. Short lived tokens are prefered for better security. Defaults to nil.
        /// - Parameter expireAt: An ISO8601 formatted date string indicatiing when the token will expire. Defaults to nil.
        /// - Returns: An CurrentValueSubject<PCAccessToken?, PCError> representing the servers response of an access token or an error.
    static public func generateAccessToken(client: PCClient? = nil, 
                                           credentials: PCCredentials,
                                           grantType: PCAccessToken.GrantType = .password,
                                           expiresIn: Int? = nil,
                                           expireAt: String? = nil) -> CurrentValueSubject<PCAccessToken?, PCError> {
        
        PCNetwork.shared.cloudRequest(.generateAccessToken(client: client, credentials: credentials, grantType: grantType, expiresIn: expiresIn, expireAt: expireAt), type: PCAccessToken.self)
    }
    
        /// List access tokens issued to your account.
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           PCAccessToken.listAccessToken(credentials: GlobalResources.shared.credentials)
        ///               .replaceNil(with: [] )
        ///               .sink { completion in
        ///                    switch completion {
        ///                        case .finished:
        ///                            //Do Cleanup
        ///                        case .failure(let error):
        ///                            //do something with the PCError
        ///                    }
        ///               } receiveValue: { elementArray in
        ///
        ///               //do something with the array
        ///
        ///               }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter otp: One time password for multifactor authentication.
        /// - Returns: A `CurrentValueSubject<[PCAccessToken.Info]?, PCError>`  representing  an array of PCAccessToken.Info representing all the issued oAuth tokens for your account.  In the case of failure a PCError is the completion result.
    static public func listAccessToken(credentials: PCCredentials, otp: String? = nil) -> CurrentValueSubject<[PCAccessToken.ListResponseElement]?, PCError> {
       
        PCNetwork.shared.cloudRequest(.listAccessTokens(credentials: credentials, otp: otp), type: [PCAccessToken.ListResponseElement].self)
    }
    
        /// Delete an access token from your account.
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           PCAccessToken.deleteAnAccessToken(credentials: GlobalResources.shared.credentials, token: token)
        ///                .sink { completion in
        ///                     switch completion {
        ///                         case .finished:
        ///                             //Do Cleanup
        ///                         case .failure(let error):
        ///                             //do something with the PCError
        ///                     }
        ///                } receiveValue: { response in
        ///
        ///                //do something with the response
        ///
        ///                }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Parameter token: `PCAccessToken` representing the cloud access token to delete
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: `CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError>` representing the server response.
    static public func deleteAnAccessToken(credentials: PCCredentials, token: PCAccessToken) -> CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError> {
        
        PCNetwork.shared.cloudRequest(.deleteAnAccessToken(tokenID: token.accessToken, credentials: credentials), type: PCAccessToken.DeletionResponse.self)
    }
    
        /// Delete all current access tokens from your account.
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           PCAccessToken.deleteAllAccessTokens(token: token)
        ///                .sink { completion in
        ///                     switch completion {
        ///                         case .finished:
        ///                             //Do Cleanup
        ///                         case .failure(let error):
        ///                             //do something with the PCError
        ///                     }
        ///                } receiveValue: { response in
        ///
        ///                //do something with the response
        ///
        ///                }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the server oAuth access token and associated information.
        /// - Returns: `CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError>` representing the server response or an error if unsuccessful.
    static public func deleteAllAccessTokens(token: PCAccessToken) -> CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError> {
        
        PCNetwork.shared.cloudRequest(.deleteAllAccessTokens(token: token), type: PCAccessToken.DeletionResponse.self)
    }
    
        /// Delete all current access tokens from your account.
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           token.deleteAllAccessTokens()
        ///                .sink { completion in
        ///                     switch completion {
        ///                         case .finished:
        ///                             //Do Cleanup
        ///                         case .failure(let error):
        ///                             //do something with the PCError
        ///                     }
        ///                } receiveValue: { response in
        ///
        ///                //do something with the response
        ///
        ///                }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Returns: `CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError>` representing the server response or an error if unsuccessful.
    public func deleteAllAccessTokens() -> CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError> {
       
        PCNetwork.shared.cloudRequest(.deleteAllAccessTokens(token: self), type: PCAccessToken.DeletionResponse.self)
    }

    
        /// Delete current access token from your account.
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           PCAccessToken.deleteCurrentAccessToken(token: token)
        ///                .sink { completion in
        ///                     switch completion {
        ///                         case .finished:
        ///                             //Do Cleanup
        ///                         case .failure(let error):
        ///                             //do something with the PCError
        ///                     }
        ///                } receiveValue: { response in
        ///
        ///                //do something with the response
        ///
        ///                }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the server oAuth access token and associated information.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: `CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError>` representing the server response or an error if unsuccessful.
    static public func deleteCurrentAccessToken(token: PCAccessToken) -> CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError> {
       
        PCNetwork.shared.cloudRequest(.deleteCurrentAccessToken(token: token), type: PCAccessToken.DeletionResponse.self)
    }
    
        /// Deletes the token on which the method is called on.
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           token.delete()
        ///                .sink { completion in
        ///                     switch completion {
        ///                         case .finished:
        ///                             //Do Cleanup
        ///                         case .failure(let error):
        ///                             //do something with the PCError
        ///                     }
        ///                } receiveValue: { response in
        ///
        ///                //do something with the response
        ///
        ///                }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the server oAuth access token and associated information.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: `CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError>` representing the server response or an error if unsuccessful.
    public func delete() -> CurrentValueSubject<PCAccessToken.DeletionResponse?, PCError> {
       
        PCNetwork.shared.cloudRequest(.deleteCurrentAccessToken(token: self), type: PCAccessToken.DeletionResponse.self)
    }

    
        /// Gets current server information for the access token provided..
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           PCAccessToken.verifyToken(token: PCAccessToken)
        ///                .sink { completion in
        ///                     switch completion {
        ///                         case .finished:
        ///                             //Do Cleanup
        ///                         case .failure(let error):
        ///                             //do something with the PCError
        ///                     }
        ///                } receiveValue: { response in
        ///
        ///                //do something with the response
        ///
        ///                }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An `CurrentValueSubject<PCAccessToken.Info?, PCError>` of PCAccessToken.Info representing the oAuth token.  In the case of failure a PCError is provided at completion.
    static public func verifyToken(token: PCAccessToken) -> CurrentValueSubject<PCAccessToken.VerificationResponse?, PCError> {
        
        PCNetwork.shared.cloudRequest(.getCurrentAccessTokenInfo(token: token), type: PCAccessToken.VerificationResponse.self)
    }
    
        /// Gets current server information for the access token.
        ///
        ///
        ///Example Usage:
        ///````swift
        ///
        ///           token.verifyToken()
        ///                .sink { completion in
        ///                     switch completion {
        ///                         case .finished:
        ///                             //Do Cleanup
        ///                         case .failure(let error):
        ///                             //do something with the PCError
        ///                     }
        ///                } receiveValue: { response in
        ///
        ///                //do something with the response
        ///
        ///                }.store(in: &cancellables)
        ///
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An `CurrentValueSubject<PCAccessToken.Info?, PCError>` of PCAccessToken.Info representing the oAuth token.  In the case of failure a PCError is provided at completion.
    public func verifyToken() -> CurrentValueSubject<PCAccessToken.VerificationResponse?, PCError> {
        
        PCNetwork.shared.cloudRequest(.getCurrentAccessTokenInfo(token: self), type: PCAccessToken.VerificationResponse.self)
    }
}

    // MARK: - Completion Handler
extension PCAccessToken {
    
        /// Generates a new PCAccessToken. On the server a new oAuth token will be generated and represented by the PCAccessToken.
        ///
        /// You must give a valid OAuth client ID and secret in HTTP Basic Auth or in the client_id and client_secret parameters. For controlling your own developer account, you can use particle:particle. Otherwise use a valid OAuth Client ID and Secret. This endpoint doesn't accept JSON requests, only form encoded requests. See OAuth Clients.Refresh tokens only work for product tokens, and even then they are not particularly useful. In order to generate a new access token from the refresh token you still need the client ID and secret. Because of this, it's simpler to just generate a new token, and then you don't need to remember and keep secure the refresh token. Also refresh tokens have a lifetime of 14 days, much shorter than the default access token lifetime of 90 days.
        /// - note: `expiresAt` parameter if provided, must be in ISO8601 format
        /// - Parameter client: OAuth client including clientID and password. Required if no credentials are provided.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter grantType: OAuth grant type. Defaults to 'password'
        /// - Parameter expiresIn: Number of seconds the token remain valid. 0 means forever. Short lived tokens are prefered for better security. Defaults to nil.
        /// - Parameter expireAt: An ISO8601 formatted date string indicatiing when the token will expire. Defaults to nil.
        /// - Parameter completion: The block to be called when the server task has completed. This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        /// - Example Usage:
        ///
        ///                 let credentials = PCCredentials(username: "particle user email",
        ///                                                 password: "super super secret password")
        ///
        ///                 let client = PCClient(id: "clients id",
        ///                                       secret: "clients super secret")
        ///
        ///                 let token = try! await PCAccessToken.generateAccessTokenFuture(client: client,
        ///                                                                                credentials: credentials).value
        ///                 { (optionalToken, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the token
        ///                     }
        ///                 }
        ///
    static public func generateAccessToken(client: PCClient? = nil, 
                                           credentials: PCCredentials,
                                           grantType: PCAccessToken.GrantType = .password,
                                           expiresIn: Int? = nil,
                                           expireAt: String? = nil,
                                           completion: @escaping (Result<PCAccessToken,PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.generateAccessToken(client: client, credentials: credentials, expiresIn: expiresIn, expireAt: expireAt), type: PCAccessToken.self, completion: completion)
    }
    
        /// List access tokens issued to your account.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter otp: One time password for multifactor authentication.
        /// - Parameter completion: The block to be called when the server task has completed. This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        /// - Example Usage:
        ///
        ///                 PCAccessToken.listAccessToken(credentials: PCCredentials(username: "particle user email",
        ///                                                                            password: "super super secret password"))
        ///                 { (optionalPCAccessTokenInfos, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the token infos
        ///                     }
        ///                 }
        ///
    static public func listAccessToken(credentials: PCCredentials, otp: String? = nil, completion: @escaping (Result<[PCAccessToken.ListResponseElement], PCError>) -> Void) {
       
        PCNetwork.shared.cloudRequest(.listAccessTokens(credentials: credentials, otp: otp), type: [PCAccessToken.ListResponseElement].self, completion: completion)
    }
    
        /// Delete an access token from your account.
        /// - Parameter token: `PCAccessToken` representing the cloud access token to delete
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter completion: The block to be called when the server task has completed.
        /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        /// - Example Usage:
        ///
        ///                 let credentials = PCCredentials(username: "particle user email",
        ///                                                 password: "super super secret password")
        ///
        ///                 let client = PCClient(id: "clients id",
        ///                                       secret: "clients super secret")
        ///
        ///                 let token = try! await PCAccessToken.generateAccessTokenFuture(client: client,
        ///                                                                                credentials: credentials).value
        ///
        ///                 PCAccessToken.deleteAnAccessToken(credentials: credentials), token: token)
        ///                 { (optionalPCAccessTokenDeletionResponse, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the response
        ///                     }
        ///                 }
        ///
    static public func deleteAnAccessToken(credentials: PCCredentials, token: PCAccessToken, completion: @escaping (Result<PCAccessToken.DeletionResponse, PCError>) -> Void) {
       
        PCNetwork.shared.cloudRequest(.deleteAnAccessToken(tokenID: token.accessToken, credentials: credentials), type: PCAccessToken.DeletionResponse.self, completion: completion)
    }
    
        /// Delete all current access tokens from your account.
        ///
        /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        /// Example Usage:
        ///
        ///````swift
        ///                 let credentials = PCCredentials(username: "particle user email",
        ///                                                 password: "super super secret password")
        ///
        ///                 let client = PCClient(id: "clients id",
        ///                                       secret: "clients super secret")
        ///
        ///                 let token = try! await PCAccessToken.generateAccessTokenFuture(client: client,
        ///                                                                                credentials: credentials).value
        ///
        ///                 PCAccessToken.deleteAllAccessTokens(credentials: credentials, token: token)
        ///                 { (optionalPCAccessTokenDeletionResponse, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the response
        ///                     }
        ///                 }
        ///
        ///````
        ///
        /// - Parameter token: `PCAccessToken` representing the cloud access token to delete
        /// - Parameter completion: The block to be called when the server task has completed.
    static public func deleteAllAccessTokens(token: PCAccessToken, completion: @escaping (Result<PCAccessToken.DeletionResponse, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.deleteAllAccessTokens(token: token), type: PCAccessToken.DeletionResponse.self, completion: completion)
    }
    
        /// Delete all current access tokens from your account.
        ///
        /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        /// Example Usage:
        ///
        ///````swift
        ///                 let credentials = PCCredentials(username: "particle user email",
        ///                                                 password: "super super secret password")
        ///
        ///                 let client = PCClient(id: "clients id",
        ///                                       secret: "clients super secret")
        ///
        ///                 let token = try! await PCAccessToken.generateAccessTokenFuture(client: client,
        ///                                                                                credentials: credentials).value
        ///
        ///                 token.deleteAllAccessTokens()
        ///                 { (optionalPCAccessTokenDeletionResponse, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the response
        ///                     }
        ///                 }
        ///
        ///````
        ///
        /// - Parameter completion: The block to be called when the server task has completed.
    public func deleteAllAccessTokens(completion: @escaping (Result<PCAccessToken.DeletionResponse, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.deleteAllAccessTokens(token: self), type: PCAccessToken.DeletionResponse.self, completion: completion)
    }

    
        /// Delete the current token from your account.
        /// - Parameter token: `PCAccessToken` representing the cloud access token to delete
        /// - Parameter completion: The block to be called when the server task has completed.
        /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        /// - Example Usage:
        ///
        ///````swift
        ///                 let credentials = PCCredentials(username: "particle user email",
        ///                                                 password: "super super secret password")
        ///
        ///                 let client = PCClient(id: "clients id",
        ///                                       secret: "clients super secret")
        ///
        ///                 let token = try! await PCAccessToken.generateAccessTokenFuture(client: client,
        ///                                                                                credentials: credentials).value
        ///
        ///                 PCAccessToken.deleteCurrentAccessToken(token: token)
        ///                 { (optionalPCAccessTokenDeletionResponse, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the response
        ///                     }
        ///                 }
        ///````
        ///
    static public func deleteCurrentAccessToken(token: PCAccessToken, completion: @escaping (Result<PCAccessToken.DeletionResponse, PCError>) -> Void) {
       
        PCNetwork.shared.cloudRequest(.deleteCurrentAccessToken(token: token), type: PCAccessToken.DeletionResponse.self, completion: completion)
    }
    
        /// Get the curren access token info from your account.
        ///
        /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        ///Example Usage:
        ///
        ///````swift
        ///                 let credentials = PCCredentials(username: "particle user email",
        ///                                                 password: "super super secret password")
        ///
        ///                 let client = PCClient(id: "clients id",
        ///                                       secret: "clients super secret")
        ///
        ///                 let token = try! await PCAccessToken.generateAccessTokenFuture(client: client,
        ///                                                                                credentials: credentials).value
        ///                 
        ///                 //Verify that token is valid
        ///                 //Note this is illustrating usage and should not be called on a new token.
        ///                 PCAccessToken.verifyToken(token: token)
        ///                 { (optionalPCAccessTokenInfoResponse, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the response
        ///                     }
        ///                 }
        ///
        ///````
        ///
        /// - Parameter token: `PCAccessToken` representing the cloud access token to delete
        /// - Parameter completion: The block to be called when the server task has completed.
    static public func verifyToken(token: PCAccessToken, completion: @escaping (Result<PCAccessToken.VerificationResponse, PCError>) -> Void) {
       
        PCNetwork.shared.cloudRequest(.getCurrentAccessTokenInfo(token: token), type: PCAccessToken.VerificationResponse.self, completion: completion)
    }
    
        /// Get the current access token info from your account.
        ///
        /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
        ///
        ///Example Usage:
        ///
        ///````swift
        ///                 someToken.isValid()
        ///                 { (optionalPCAccessTokenInfoResponse, optionalError) in
        ///                     DispatchQueue.main.async {
        ///                         //check for errors and do something with the response
        ///                     }
        ///                 }
        ///
        ///````
        ///
        /// - Parameter completion: The block to be called when the server task has completed.
    public func verifyToken(completion: @escaping (Result<PCAccessToken.VerificationResponse, PCError>) -> Void) {
       
        PCNetwork.shared.cloudRequest(.getCurrentAccessTokenInfo(token: self), type: PCAccessToken.VerificationResponse.self, completion: completion)
    }
}

//MARK: - Async
extension PCAccessToken {
    
        /// Generates a new PCAccessToken. On the server a new oAuth token will be generated and represented by the PCAccessToken.
        ///
        /// You must give a valid OAuth client ID and secret in HTTP Basic Auth or in the client_id and client_secret parameters. For controlling your own developer account, you can use particle:particle. Otherwise use a valid OAuth Client ID and Secret. This endpoint doesn't accept JSON requests, only form encoded requests. See OAuth Clients.Refresh tokens only work for product tokens, and even then they are not particularly useful. In order to generate a new access token from the refresh token you still need the client ID and secret. Because of this, it's simpler to just generate a new token, and then you don't need to remember and keep secure the refresh token. Also refresh tokens have a lifetime of 14 days, much shorter than the default access token lifetime of 90 days.
        ///
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let token = try await PCAccessToken.generateAccessToken(credentials: GlobalResources.shared.credentials)
        ///                    //do something with your new token.
        ///
        /// ````
        ///
        /// - note: `expiresAt` parameter if provided, must be in ISO8601 format
        /// - Parameter client: OAuth client including clientID and password. Required if no credentials are provided.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter grantType: OAuth grant type. Defaults to 'password'
        /// - Parameter expiresIn: Number of seconds the token remain valid. 0 means forever. Short lived tokens are prefered for better security. Defaults to nil.
        /// - Parameter expireAt: An ISO8601 formatted date string indicatiing when the token will expire. Defaults to nil.
        /// - Returns: A `PCAccessToken`  representing the servers response of an access token.
        /// - Throws: PCError
    static public func generateAccessToken(client: PCClient? = nil, 
                                           credentials: PCCredentials,
                                           grantType: PCAccessToken.GrantType = .password,
                                           expiresIn: Int? = nil,
                                           expireAt: String? = nil) async throws -> PCAccessToken {
       
        try await PCNetwork.shared.cloudRequest(.generateAccessToken(client: client, credentials: credentials, grantType: grantType, expiresIn: expiresIn, expireAt: expireAt), type: PCAccessToken.self)
    }
    
        /// List access tokens issued to your account.
        ///
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let token = try await PCAccessToken.listAccessToken(credentials: GlobalResources.shared.credentials)
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter otp: One time password for multifactor authentication.
        /// - Returns: An  array of PCAccessToken.Info representing all the issued oAuth tokens for your account.
        /// - Throws: PCError
    static public func listAccessToken(credentials: PCCredentials, otp: String? = nil) async throws-> [PCAccessToken.ListResponseElement] {
        
        try await PCNetwork.shared.cloudRequest(.listAccessTokens(credentials: credentials, otp: otp), type: [PCAccessToken.ListResponseElement].self)
    }
    
        /// Delete an access token from your account.
        ///
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let token = try await PCAccessToken.deleteAnAccessToken(credentials: GlobalResources.shared.credentials, token: token)
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Parameter token: `PCAccessToken` representing the cloud access token to delete
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: `PCAccessToken.DeletionResponse` representing the server response.
        /// - Throws: PCError
    static public func deleteAnAccessToken(credentials: PCCredentials, token: PCAccessToken) async throws -> PCAccessToken.DeletionResponse {
       
        try await PCNetwork.shared.cloudRequest(.deleteAnAccessToken(tokenID: token.accessToken, credentials: credentials), type: PCAccessToken.DeletionResponse.self)
    }
    
        /// Delete all access tokens from your account.
        ///
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let response = try await PCAccessToken.deleteAllAccessTokens(token: token)
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Parameter token: An PCAccessToken carrying the server oAuth access token and associated information.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: `PCAccessToken.DeletionResponse` representing the server response.
        /// - Throws: PCError
    static public func deleteAllAccessTokens(token: PCAccessToken) async throws -> PCAccessToken.DeletionResponse {

        try await PCNetwork.shared.cloudRequest(.deleteAllAccessTokens(token: token), type: PCAccessToken.DeletionResponse.self)
    }
    
        /// Delete all access tokens from your account.
        ///
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let response = try await token.deleteAllAccessTokens(token: token)
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: `PCAccessToken.DeletionResponse` representing the server response.
        /// - Throws: PCError
    public func deleteAllAccessTokens() async throws -> PCAccessToken.DeletionResponse {
        
        try await PCNetwork.shared.cloudRequest(.deleteAllAccessTokens(token: self), type: PCAccessToken.DeletionResponse.self)
    }

        /// Delete current access token from your account.
        ///
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let response = try await PCAccessToken.deleteCurrentAccessToken(token: token)
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Parameter token: An PCAccessToken carrying the server oAuth access token and associated information.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns:`PCAccessToken.DeletionResponse` representing the server response.
        /// - Throws: PCError
    static public func deleteCurrentAccessToken(token: PCAccessToken) async throws -> PCAccessToken.DeletionResponse {
       
        try await PCNetwork.shared.cloudRequest(.deleteCurrentAccessToken(token: token), type: PCAccessToken.DeletionResponse.self)
    }
    
        /// Delete current access token from your account.
        ///
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let response = try await token.delete()
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Returns:`PCAccessToken.DeletionResponse` representing the server response.
        /// - Throws: PCError
    public func delete() async throws -> PCAccessToken.DeletionResponse {
        
        try await PCNetwork.shared.cloudRequest(.deleteCurrentAccessToken(token: self), type: PCAccessToken.DeletionResponse.self)
    }

    
        /// Gets current server information for the access token provided..
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let response = try await PCAccessToken.verifyToken(token: PCAccessToken)
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An array of PCAccessToken.Info representing the oAuth token.
        /// - Throws: PCError
    static public func verifyToken(token: PCAccessToken) async throws -> PCAccessToken.VerificationResponse {
            
        try await PCNetwork.shared.cloudRequest(.getCurrentAccessTokenInfo(token: token), type: PCAccessToken.VerificationResponse.self)
    }
    
        /// Gets current server information for the access token.
        ///
        ///Example Usage:
        /// ````swift
        ///
        ///        let response = try await token.verifyToken()
        ///                    //do something with the response
        ///
        /// ````
        ///
        /// - Returns: An array of PCAccessToken.Info representing the oAuth token.
        /// - Throws: PCError
    public func verifyToken() async throws -> PCAccessToken.VerificationResponse {
        
        try await PCNetwork.shared.cloudRequest(.getCurrentAccessTokenInfo(token: self), type: PCAccessToken.VerificationResponse.self)
    }
}
