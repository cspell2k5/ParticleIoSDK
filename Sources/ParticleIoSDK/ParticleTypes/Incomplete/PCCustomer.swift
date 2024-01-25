    //
    //  ParticleCustomer.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/11/23.
    //

import Foundation


///Reprentation of a particleio customer.
///[see particle docs for info on customers](https://docs.particle.io/reference/cloud-apis/api/#customers)
public struct PCCustomer: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
    
    ///Human readable description of the instance.
    public var description: String {
"""
    username: \(username),
    password: *Redacted*,
    productID: \(productID.rawValue),
    token: \(token.description)
"""
    }

    ///Human readable debug description of the instance.
    public var debugDescription: String {
"""
PCCustomer: {
    username: \(username),
    password: *Redacted*,
    productID: \(productID.rawValue),
    \(token.debugDescription)
}
"""
    }
    
    ///The customers username.
    public let username: String
    
    ///The pasword for the customer.
    private let password: String
    
    ///The id of product the customer belongs to.
    public let productID: ProductID
    
    ///The token used to reperesent the customer to the server.
    private let token: PCAccessToken

    ///Made private to shield from public use.
    private init() {
        fatalError("Must use init with decoder.")
    }
    
    private enum CodingKeys: String, CodingKey {
        case username, password, productID, token
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.password = try container.decode(String.self, forKey: .password)
        self.productID = ProductID(try container.decode(String.self, forKey: .productID))
        self.token = try container.decode(PCAccessToken.self, forKey: .token)
    }
}

///Customer information server response representation.
public struct CustomerInfo: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
    
    ///Human readable description of the instance.
    public var description: String {
"""
    id: \(id)
    username: \(username)
"""
    }
    
    ///Human readable debug description of the instance.
    public var debugDescription: String {
"""
CustomerInfo: {
    id: \(id)
    username: \(username)
}
"""
    }
    
    ///The customer id.
    public let id: String
    
    ///The customer username.
    public let username: String
    
    ///Made private to shield from public use.
    private init() {
        fatalError("Must use init with decoder.")
    }
}


extension PCCustomer {
    
    ///Struct used to encapsulate the arguments required to create a customer with a scoped access token.
    public struct AccessTokenArguments: CustomDebugStringConvertible, CustomStringConvertible {
        
        ///Human readable description of the instance.
        public var description: String {
"""
    clientID:\(clientID),
    clientSecret:\(clientSecret.suffix(4)),
    grantType:\(grant_type),
    expiresIn:\(String(describing: expiresIn)),
    expiresAt:\(String(describing: expiresAt)),
    username:\(username)
"""
        }
        
        ///Human readable debug description of the instance.
        public var debugDescription: String {
"""
AccessTokenArguments: {
    clientID:\(clientID),
    clientSecret:\(clientSecret.suffix(4)),
    grant_type:\(grant_type),
    expiresIn:\(String(describing: expiresIn)),
    expiresAt:\(String(describing: expiresAt)),
    username:\(username)
}
"""
        }
            ///OAuth client ID. Required if no Authorization header is present.
        public let clientID: String
        
            /// OAuth client secret. Required if no Authorization header is present.
        public let clientSecret: String
        
            ///OAuth grant type. Must be client_credentials.
        internal let grant_type: String = "client_credentials"
        
            ///How many seconds the token will be valid for. 0 means forever. Short lived tokens are better for security.
        public let expiresIn: Int?
        
            ///When should the token expire? This should be an ISO8601 formatted date string.
        public let expiresAt: String?
        
            ///Username associated with the customer.
        public let username: String

        ///Required initializer.
        public init(clientID: String, clientSecret: String, username: String, expiresIn: Int? = nil, expiresAt: String? = nil) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.expiresIn = expiresIn
            self.expiresAt = expiresAt
            self.username = username
        }
    }
    
        // MARK: CustomerListResponse
    ///Encapsulation of the response returned by the server when calling for customer list.
    public struct CustomerListResponse: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
        
        ///Human readable description of the instance.
        public var description: String {
"""
    customers: \(customerDescription),
    devices: \(devicesDescription)
"""
        }
        
        ///Human readable debug description of the instance.
        public var debugDescription: String {
"""
CustomerListResponse: {
    customers: \(customerDescription),
    devices: \(devicesDescription)
}
"""
        }
        
        ///Used as a helper for description and debug descriptions.
        private var customerDescription: String {
            if customers.isEmpty {
                return "[]"
            }
            return """
[
        \(customers.map({$0.description}).joined(separator: ",\n"))
    ]
"""
        }
        
        ///Used as a helper for description and debug descriptions.
        private var devicesDescription: String {
            if devices.isEmpty {
                return "[]"
            }
            return """
[
        \(devices.map({$0.description}).joined(separator: ",\n"))
    ]
"""
        }
        
        ///Array of customers
        public let customers: [PCCustomer]
        ///Array of Devices that belong to those customers
        public let devices: [PCDevice]
        
        //Left the meta just so I'll remember its there. It just gives some sort of metadata on the number of pages. I can't think of a practical use case.
        private enum CodingKeys: CodingKey {
            case customers, devices, meta
        }

        ///Required initializer.
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.customers = try container.decode([PCCustomer].self, forKey: .customers)
            self.devices = try container.decode([PCDevice].self, forKey: .devices)
            //Explicitely ignore meta data.
        }
        
        ///Shielded from public use.
        private init() {
            fatalError("Must use init with decoder")
        }
    }
    
//    public struct CreationRequestResponse: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
//        
//        ///Human readable description of the instance.
//        public var description: String {
//"""
//    tokenType: \(tokenType),
//    accessToken: ends in \(accessToken.suffix(4)),
//    refreshToken: ends in \(refreshToken.suffix(4)),
//    expiresIn: \(expiresIn)
//"""
//        }
//        
//        ///Human readable debug description of the instance.
//        public var debugDescription: String {
//"""
//CreationRequestResponse: {
//    tokenType: \(tokenType),
//    accessToken: ends in \(accessToken.suffix(4)),
//    refreshToken: ends in \(refreshToken.suffix(4)),
//    expiresIn: \(expiresIn)
//}
//"""
//        }
//        
//        public let tokenType, accessToken, refreshToken: String
//        public let expiresIn: Int
//        
//        private enum CodingKeys: String, CodingKey {
//            case tokenType = "token_type"
//            case accessToken = "access_token"
//            case refreshToken = "refresh_token"
//            case expiresIn = "expires_in"
//        }
//        
//        private init(tokenType: String, accessToken: String, refreshToken: String, expiresIn: Int) {
//            self.tokenType = tokenType; self.accessToken = accessToken; self.refreshToken = refreshToken; self.expiresIn = expiresIn
//        }
//    }
    
//    public struct GenericServerRequestResponse: Decodable {
//        public let ok: Bool
//        private init(ok: Bool) { self.ok = ok }
//    }
}


extension PCCustomer {
    
    //MARK: Creation
    ///Create a customer
    ///
    ///Create a new customer and register it with the particle servers.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/customers
    ///
    ///
    ///````swift
    ///
    ///
    ///         PCCustomer.createCustomer
    ///
    ///
    ///````
    ///
    /// - Requires: Scope of customers:create
    public static func createCustomer(with client: PCClient,
                                      productID: ProductID,
                                                username: String,
                                                password: String) async throws -> PCAccessToken {
        try await PCNetwork.shared.cloudRequest(
            .createCustomerWithClient(
                productIDorSlug: productID,
                client: client,
                username: username,
                password: password
            ),
            type: PCAccessToken.self)
    }
    
    public static func createCustomer(with client: PCClient,
                                      productID: ProductID,
                                                username: String,
                                                password: String,
                                                completion: @escaping (Result<PCAccessToken, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .createCustomerWithClient(
                productIDorSlug: productID,
                client:   client,
                username: username,
                password: password
            ),
            type: PCAccessToken.self,
            completion: completion)
    }
    
        
    public static func createCustomer(with token: PCAccessToken,
                                      productID: ProductID,
                                      clientCredentials: PCClient) async throws -> PCAccessToken {
        try await PCNetwork.shared.cloudRequest(
            .createCustomerWithToken(
                productIDorSlug: productID,
                clientCredentials: clientCredentials,
                token: token
            ),
            type: PCAccessToken.self)
    }
    
    public static func createCustomer(with token: PCAccessToken,
                                      productID: ProductID,
                                      clientCredentials: PCClient,
                                      completion: @escaping (Result<PCAccessToken, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .createCustomerWithToken(
                productIDorSlug: productID,
                clientCredentials: clientCredentials,
                token: token
            ),
            type: PCAccessToken.self,
            completion: completion)
    }
    
        
    public static func createCustomerImplicit(productID: ProductID,
                                              client: PCClient,
                                              customerCredentials: PCCredentials) async throws -> PCAccessToken {
        try await PCNetwork.shared.cloudRequest(
            .createCustomerImplicit(
                productIDorSlug: productID,
                client: client,
                customerCredentials: customerCredentials
            ),
            type: PCAccessToken.self)
    }
    
    public static func createCustomerImplicit(productID: ProductID,
                                              client: PCClient,
                                              customerCredentials: PCCredentials,
                                              completion: @escaping (Result<PCAccessToken, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .createCustomerImplicit(
                productIDorSlug: productID,
                client: client,
                customerCredentials: customerCredentials
            ),
            type: PCAccessToken.self,
            completion: completion)
    }
}

extension PCCustomer {
    //MARK: List
    public static func listCustomers(for productID: ProductID,
                                     token: PCAccessToken) async throws -> PCCustomer.CustomerListResponse {
        try await PCNetwork.shared.cloudRequest(
            .listCustomersForProduct(
                productIdOrSlug: productID,
                token: token
            ),
            type: PCCustomer.CustomerListResponse.self)
    }
    
    public static func listCustomers(for productID: ProductID,
                                     token: PCAccessToken,
                                     completion: @escaping (Result<PCCustomer.CustomerListResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .listCustomersForProduct(
                productIdOrSlug: productID,
                token: token
            ),
            type: PCCustomer.CustomerListResponse.self,
            completion: completion)
    }
}

extension PCCustomer {
    //MARK: Generation
    public static func createCustomerWithScopedAccessToken(arguments: PCCustomer.AccessTokenArguments) async throws -> PCAccessToken {
        try await PCNetwork.shared.cloudRequest(
            .generateCustomerWithScopedAccessToken(arguments: arguments)
            , type: PCAccessToken.self)
    }
    
    public static func createCustomerWithScopedAccessToken(arguments: PCCustomer.AccessTokenArguments, completion: @escaping (Result<PCAccessToken, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .generateCustomerWithScopedAccessToken(arguments: arguments),
            type: PCAccessToken.self,
            completion: completion)
    }
}

extension PCCustomer {
    //MARK: Update Password
    public static func updateCustomerPassword(productID: ProductID,
                                              customerCredentials: PCCredentials,
                                              token: PCAccessToken) async throws -> ServerResponses.BoolResponse {
        try await PCNetwork.shared.cloudRequest(
            .updateCustomerPassword(
                productIDorSlug: productID,
                customerCredentials: customerCredentials,
                token: token
            ),
            type: ServerResponses.BoolResponse.self)
    }
    
    public static func updateCustomerPassword(productID: ProductID,
                                              customerCredentials: PCCredentials,
                                              token: PCAccessToken,
                                              completion: @escaping (Result<ServerResponses.BoolResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .updateCustomerPassword(
                productIDorSlug: productID,
                customerCredentials: customerCredentials,
                token: token
            ),
            type: ServerResponses.BoolResponse.self,
            completion: completion)
    }
}

extension PCCustomer {
    //MARK: Deletion
    public static func deleteCustomer(productIDorSlug: ProductID, username: String, token: PCAccessToken) async throws -> ServerResponses.BoolResponse {
        try await PCNetwork.shared.cloudRequest(
            .deleteA_Customer(
                productIDorSlug: productIDorSlug,
                username: username,
                token: token
            ),
            type: ServerResponses.BoolResponse.self
        )
    }
    
    public static func deleteCustomer(_ customer: PCCustomer, token: PCAccessToken, completion: @escaping (Result<ServerResponses.BoolResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .deleteA_Customer(
                productIDorSlug: customer.productID,
                username: customer.username,
                token: token
            ),
            type: ServerResponses.BoolResponse.self,
            completion: completion)
    }
}

extension PCCustomer {
    //MARK: Password Reset    
    public static func resetPassword(productID: ProductID,
                                           customerEmail: String,
                                           token: PCAccessToken) async throws -> ServerResponses.BoolResponse {
        try await PCNetwork.shared.cloudRequest(
            .resetPassword(
                productIDorSlug: productID,
                customerEmail: customerEmail,
                token: token
            ),
            type: ServerResponses.BoolResponse.self
        )
    }
    
    public static func resetPassword(productID: ProductID,
                                     customerEmail: String,
                                     token: PCAccessToken,
                                     completion: @escaping (Result<ServerResponses.BoolResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(
            .resetPassword(
                productIDorSlug: productID,
                customerEmail: customerEmail,
                token: token
            ),
            type: ServerResponses.BoolResponse.self,
            completion: completion)
    }
}

