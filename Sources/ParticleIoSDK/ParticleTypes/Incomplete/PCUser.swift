//
//  ParticleUser.swift
//  ParticleIO
//
//  Created by Craig Spell on 11/22/19.
//

import Foundation


public struct PCUser: Decodable, CustomStringConvertible {
    
    public var description: String {
        "PCUser:\nusername: \(username)\nsubscriptionIds: [\(subscriptionIds.map({String($0)}).joined(separator: ",\n"))]\naccountInfo: \(accountInfo)\nmfa: \(mfa)\nwifiDeviceCount: \(wifiDeviceCount)\ncellularDeviceCount: \(cellularDeviceCount)\nmemberships: \(String(describing: memberships?.debugDescription))\nrole: \(String(describing: role))\nenabled: \(String(describing: enabled))\naccepted: \(String(describing: accepted))\ndate: \(String(describing: try? Date.date(jSonDate: date)))\nversion: \(String(describing: version))"
    }
    
    ///Email address for current user.
    public let username : String
    
    ///Subscriptions for SIM cards and products/
    public let subscriptionIds : [Int]
    
    ///An object that contains a first_name, last_name, and business_account.
    public let accountInfo : Info
    
    ///Includes whether or not MFA is enabled
    public let mfa : [String : Bool]
    
    ///Number of devices that count against the Wi-Fi device cap.
    public let wifiDeviceCount : Int
    
    ///Number of devices that count against the cellular device cap.
    public let cellularDeviceCount : Int
    
    public let memberships : [Product]?
    public let role: String?
    public let enabled: Bool?
    public let accepted: Bool?
    public let date: String?
    public let version: Int?
    
    private enum CodingKeys: String, CodingKey {
        case username, subscriptionIds = "subscription_ids", accountInfo = "account_info", mfa, wifiDeviceCount = "wifi_device_count", cellularDeviceCount = "cellular_device_count", memberships, role, enabled, accepted, date, version
    }
    
    private init(username: String, subscriptionIds: [Int], accountInfo: Info, mfa: [String : Bool], wifiDeviceCount: Int, cellularDeviceCount: Int, memberships: [Product]?, role: String?, enabled: Bool?, accepted: Bool?, date: String?, version: Int?) {
        self.username = username; self.subscriptionIds = subscriptionIds; self.accountInfo = accountInfo; self.mfa = mfa; self.wifiDeviceCount = wifiDeviceCount; self.cellularDeviceCount = cellularDeviceCount; self.memberships = memberships; self.role = role; self.enabled = enabled; self.accepted = accepted; self.date = date; self.version = version
    }
    
    //MARK: - AccountInfo
    public struct Info : Decodable {
        public let firstName : String?
        public let lastName : String?
        public let businessAccount : Bool
        public let companyName : String?
        
        
        private enum CodingKeys: String, CodingKey {
            case firstName = "first_name", lastName = "last_name", businessAccount = "business_account", companyName = "company_name"
        }
        
        public init(firstName: String?, lastName: String?, businessAccount: Bool, companyName: String?) {
            self.firstName = firstName; self.lastName = lastName; self.businessAccount = businessAccount; self.companyName = companyName
        }
    }
    
    public struct Product: Decodable {
        public let id: Int?
        public let name: String?
        
        private init(id: Int?, name: String?) {
            self.id = id; self.name = name
        }
    }
}

// MARK: - PCUserPassWordResetRequestResponse
extension PCUser {
    public struct RequestResponse: Decodable {
        
        public var debugDescription: String {
            "RequestResponse:\nok:\(ok)\nmessage\(message)\n"
        }
        
        public let ok: Bool
        public let message: String
        
        private init(ok: Bool, message: String) {
            self.ok = ok; self.message = message
        }
    }
}


//MARK: Futures
public extension PCUser {
    
    
    ///Get user.
    ///
    ///Return the user resource for the currently authenticated user.
    ///
    /// - calls: GET /user
    ///
    ///
    /// - throws: PCError indicating the failure.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCUser
    static func getCurrentUser(token: PCAccessToken) async throws -> PCUser {
        try await PCNetwork.shared.cloudRequest(.getUser(token: token), type: PCUser.self)
    }
    
    
    ///Update user.
    ///
    ///Update the logged-in user. Allows changing email, password and other account information.
    ///
    /// - calls: PUT /user
    ///
    ///
    /// - Parameter username: The new account email address to be assigned to the user to be updated.
    /// - Parameter password: The new password to assign to the user to be updated.
    /// - Parameter accountInfo: An PCUser.Info containing the acount info.
    /// - Parameter currentPassword: The current password for the user to be updated.
    /// - Parameter token: A currently active access token.
    /// - Returns: Current value subject containing the optional PCUser.RequestResponse or an PCError indicating the failure.
    static func updateUser(username: String, password: String?, accountInfo: PCUser.Info, currentPassword: String ,token: PCAccessToken) async throws -> PCUser.RequestResponse {
        try await PCNetwork.shared.cloudRequest(.updateUser(username: username, password: password, accountInfo: accountInfo, currentPassword: currentPassword, token: token), type: PCUser.RequestResponse.self)
    }
    
    
    ///Delete user.
    ///
    ///Delete the logged-in user. Allows removing user account and artifacts from Particle system.
    ///
    /// - calls: PUT /user
    ///
    /// - throws: PCError indicating the failure.
    /// - Parameter password: The new password to assign to the user to be updated.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCUser.DeleteUserResponse.
    static func deleteUser(password: String, token: PCAccessToken) async throws -> PCUser.RequestResponse {
        try await PCNetwork.shared.cloudRequest(.deleteUser(password: password, token: token), type: PCUser.RequestResponse.self)
    }
    
    
    ///Forgot password.
    ///
    /// Create a new password reset token and send the user an email with the token. Client doesn't need to be authenticated.
    ///
    /// - calls: POST /user/password-reset
    ///
    
    /// - note: This function will generate an email to the email address passed to username. This call is rate limited to prevent abuse.
    /// - throws: PCError indicating the failure.
    /// - Parameter username: The email address for the users account.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCUser.PassWordResetRequestResponse
    static func forgotPassword(username: String) async throws -> PCUser.RequestResponse {
        try await PCNetwork.shared.cloudRequest(.forgotPassword(username: username), type: PCUser.RequestResponse.self)
    }
}

//MARK: Completion Handlers
public extension PCUser {
    
    
    ///Get user.
    ///
    ///Return the user resource for the currently authenticated user.
    ///
    /// - calls: GET /user
    ///
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: A closure containing a result of PCUser or an PCError indicating the failure.
    /// - Parameter completion: Closure containing a result of an PCUser or an PCError indicating the failure.
    static func getCurrentUser(token: PCAccessToken, completion: @escaping (Result<PCUser, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.getUser(token: token), type: PCUser.self, completion: completion)
    }
    
    
    ///Update user.
    ///
    ///Update the logged-in user. Allows changing email, password and other account information.
    ///
    /// - calls: PUT /user
    ///
    ///
    /// - Parameter username: The new account email address to be assigned to the user to be updated.
    /// - Parameter password: The new password to assign to the user to be updated.
    /// - Parameter accountInfo: An PCUser.Info containing the acount info.
    /// - Parameter currentPassword: The current password for the user to be updated.
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Current value subject containing the optional PCUser.RequestResponse or an PCError indicating the failure.
    static func updateUser(username: String, password: String?, accountInfo: PCUser.Info, currentPassword: String ,token: PCAccessToken, completion: @escaping (Result<PCUser.RequestResponse, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.updateUser(username: username, password: password, accountInfo: accountInfo, currentPassword: currentPassword, token: token), type: PCUser.RequestResponse.self, completion: completion)
    }
    
    
    ///Delete user.
    ///
    ///Delete the logged-in user. Allows removing user account and artifacts from Particle system.
    ///
    /// - calls: PUT /user
    ///
    /// - Parameter password: The new password to assign to the user to be updated.
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure containing the PCUser.DeleteUserResponse or an PCError indicating the failure.
    static func deleteUser(password: String, token: PCAccessToken, completion: @escaping (Result<PCUser.RequestResponse, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.deleteUser(password: password, token: token), type: PCUser.RequestResponse.self, completion: completion)
    }
    
    ///Forgot password.
    ///
    /// Create a new password reset token and send the user an email with the token. Client doesn't need to be authenticated.
    ///
    /// - calls: POST /user/password-reset
    ///
    
    /// - note: This function will generate an email to the email address passed to username. This call is rate limited to prevent abuse.
    /// - Parameter username: The email address for the users account.
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure containing a result of  PCUser.PassWordResetRequestResponse or an PCError indicating the failure.
    static func forgotPassword(username: String, completion: @escaping (Result<PCUser.RequestResponse,PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.forgotPassword(username: username), type: PCUser.RequestResponse.self, completion: completion)
    }
}
