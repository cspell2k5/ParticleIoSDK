//
//  PCClient.swift
//  Particle2
//
//  Created by Craig Spell on 11/20/19.
//  Copyright © 2019 Spell Software Inc. All rights reserved.
//

import Foundation


///Encapsulation of PCClient specific server responses.
///Servers request response with one or more clients.
public struct PCClientServerResponse: Decodable {
    
    ///Server request success.
    public let ok : Bool
    ///An array of one or more clients affected by the request.
    public let clients : [PCClient]
    
    /// Private to keep init from being accessed outside of decoder.
    private init(ok: Bool, clients: [PCClient]) {
        fatalError("This initializer cannot be accessed directly. You must make a cloud request using a static method.")
    }
    
    /// Private enum for decoding.
    private enum CodingKeys: CodingKey {
        case ok, client, clients
    }
    
    /// Public init created so that the response can be shared on all callls. Some Responses return a single client some return multiples.
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.ok = try container.decode(Bool.self, forKey: .ok)
        var clients = (try? container.decodeIfPresent([PCClient].self, forKey: .clients)) ?? []
        
        if let client = try? container.decodeIfPresent(PCClient.self, forKey: .client) {
            clients.append(client)
        }
        
        self.clients = clients
    }
}

/// Representation of a Particle cloud oAuth client.
///
/// An OAuth client generally represents an app. The Particle CLI is a client, as are the Particle Web IDE, the Particle iOS app, and the Particle Android app. You too can create your own clients. You should create separate clients for each of your web and mobile apps that hit the Particle API.Some requests, like generating an access token, require you to specify an OAuth client ID and secret using HTTP Basic authentication. Normally, when calling the Particle API as a single developer user to access your own account, you can use particle for both the client ID and secret as in the example above for generating an access token. However, especially when you are creating a product on the Particle platform and your web app needs to hit our API on behalf of your customers, you need to create your own client.NEVER expose the client secret to a browser. If, for example, you have a client that controls all your organization's products, and you use the client secret in front-end JavaScript, then a tech-savvy customer using your website can read the secret in her developer console and hack all your customers' devices.
/// - note: You must have administrator credentials to access client information.
public struct PCClient : Decodable, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// Descibes the client type as install or a web client. Use `type=installed` for most web and mobile apps. If you want to have Particle users login to their account on Particle in order to give your app access to their devices, then you can go through the full OAuth authorization code grant flow using `type=web`. The way you authorize it is similar to the way you give any app access to your Facebook or Twitter account.
    public enum ClientType : String, Decodable {
        ///For most web and mobile apps.
        case installed
        ///Full OAuth authorization
        case web
    }
    
    ///Only required for web type. URL that you wish us to redirect to after the OAuth flow.
    ///
    /// Limits the scope of what the access tokens created using the client are allowed to do.
    /// Provide a space separated list of scopes.
    /// The only current valid scopes are customers:create and *:* for full control.
    public enum Scope : String, Decodable {
        ///Create customers scope.
        case createCustomers = "customers:create"
        ///Full accesss control.
        case fullControl = "*:*"
    }
    
    public var description: String {
"""
    id: \(id),
    secret: \(secret.suffix(4)),
    name: \(name),
    type: \(type.rawValue)
"""
    }
    
    public var debugDescription: String {
"""
PCClient: {
    id: \(id),
    secret: \(secret.suffix(4)),
    name: \(name),
    type: \(type.rawValue)
}
"""
    }
    ///Client id.
    public let id : String
    ///Client secret
    public let secret : String
    ///Friendly name for the client.
    public let name : String
    ///Client type.
    public let type : ClientType
    
    /// Create a client
    ///
    /// Used to create a PCClient instance for use with Particle Cloud.
    ///
    ///
    /// - Parameter id: oAuth client id
    /// - Parameter secret: oAuth client secret
    /// - Parameter name: A friendly name for the client or nil to have one created automatically.
    /// - Parameter type: clientType this parameter defaults to `installed` if left nil.
    public init(id: String, secret: String, name: String = "", type: ClientType = .installed) {
        self.id = id; self.secret = secret; self.name = name; self.type = type
    }
}


// MARK: - Async
extension PCClient {
    
    ///Get a list of all existing OAuth clients, either owned by the authenticated user or clients associated with a product.
    ///
    ///Example Usage
    ///
    ///````swift
    ///
    ///                let response = try await PCClient.listClientsFuture(productId: nil, token: token).value
    ///                let client = response.clients.filter {$0.id == "client_id"}
    ///                //do something with the client
    ///
    ///````
    ///
    ///An OAuth client generally represents an app. The Particle CLI is a client, as are the Particle Web IDE, the Particle iOS app, and the Particle Android app. You too can create your own clients. You should create separate clients for each of your web and mobile apps that hit the Particle API.Some requests, like generating an access token, require you to specify an OAuth client ID and secret using HTTP Basic authentication. Normally, when calling the Particle API as a single developer user to access your own account, you can use particle for both the client ID and secret as in the example above for generating an access token. However, especially when you are creating a product on the Particle platform and your web app needs to hit our API on behalf of your customers, you need to create your own client.NEVER expose the client secret to a browser. If, for example, you have a client that controls all your organization's products, and you use the client secret in front-end JavaScript, then a tech-savvy customer using your website can read the secret in her developer console and hack all your customers' devices.
    /// - note: required scope =  clients:list
    /// - Parameter productIdorSlug: The optional product id or slug for which to filter the list of clients.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Returns: `PCClientSeverResponse.ServerResponse`
    /// - Throws:  `PCError`
    public static func listClients(productId: ProductID?, token: PCAccessToken) async throws -> PCClientServerResponse {
        try await PCNetwork.shared.cloudRequest(.listClients(productIdorSlug: productId, token: token), type: PCClientServerResponse.self)
    }
    /// Create an oAuth client
    ///
    ///Example Usage
    ///
    ///````swift
    ///
    ///        if let response = try await PCClient.createClientFuture(appName: "cool_app_name", productId: nil, type: .installed, token: token).clients.first {
    ///             //Store this clients secret, it wont be given or retrievable again.
    ///             //do something with the client
    ///        }
    ///
    ///````
    ///
    /// Create an OAuth client that represents an app.
    ///
    /// Use type=installed for most web and mobile apps. If you want to have Particle users login to their account on Particle in order to give your app access to their devices, then you can go through the full OAuth authorization code grant flow using type=web. This is the same way you authorize it is similar to the way you give any app access to your Facebook or Twitter account.
    ///
    /// - Important: Your client secret will never be displayed again! Save it in a safe place.
    /// - Warning: NEVER expose the client secret to a browser. If, for example, you have a client that controls all your organization's products, and you use the client secret in front-end JavaScript, then a tech-savvy customer using your website can read the secret in her developer console and hack all your customers' devices.
    ///
    /// If you use type=web then you will also need to pass a redirect_uri parameter in the POST body. This is the URL where users will be redirected after telling Particle they are willing to give your app access to their devices.
    ///
    /// The scopes provided only contain the object and action parts, skipping the domain which is being infered from the context.
    ///
    /// If you are building a web or mobile application for your Particle product, you should use the product-specific endpoint for creating a client (POST /v1/products/:productIdOrSlug/clients). This will grant this client (and access tokens generated by this client) access to product-specific behaviors like [calling functions](https://docs.particle.io/reference/cloud-apis/api/#call-a-function) and [checking variables](https://docs.particle.io/reference/cloud-apis/api/#get-a-variable-value) on product devices, [creating customers](https://docs.particle.io/reference/cloud-apis/api/#create-a-customer---client-credentials), and [generating customer scoped access tokens](https://docs.particle.io/reference/cloud-apis/api/#generate-a-customer-scoped-access-token).
    ///
    /// - Requires: required scope =  clients:create
    /// - Parameter appName: The app name to associate with the new oauth client.
    /// - Parameter productIdorSlug: The optional product id or slug that the new oAuth client is associated with.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Returns: `PCClientSeverResponse.ServerResponse`
    /// - throws: `PCError`
    public static func createClient(appName: String, productId: ProductID?, type: PCClient.ClientType, token: PCAccessToken) async throws -> PCClientServerResponse {
        try await PCNetwork.shared.cloudRequest(.createClient(appName: appName, productIdorSlug: productId, type: type, token: token), type: PCClientServerResponse.self)
    }
    
    /// Update the name or scope of an existing OAuth client.
    ///
    /// Example Usage
    ///
    /// ````swift
    ///
    ///        let response = PCClient.updateClient(client: client, newName: "", newScope: .createCustomers, productIdorSlug: nil, token: token).value
    ///        if response?.ok == true {
    ///            //client is updated
    ///        }
    ///
    ///````
    ///
    /// - Requires: required scope =  clients:update
    /// - Parameter client: The oauth client to update.
    /// - Parameter newName: Give the OAuth client a new name or pass nil to keep the old name.
    /// - Parameter newScope: Update the scope of the OAuth client. to only allow customer creation from the client or pass none to remove all scopes (full permissions)
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Returns: `PCClientSeverResponse.ServerResponse`
    /// - Throws:  `PCError`
    public static func updateClient(client: PCClient, newName: String?, newScope: PCClient.Scope?, productId: ProductID?, token: PCAccessToken) async  throws -> PCClientServerResponse{
        try await PCNetwork.shared.cloudRequest(.updateClient(client: client, newName: newName, newScope: newScope, productIdorSlug: productId, token: token), type: PCClientServerResponse.self)
    }
    
    ///Delete the client from the server database.
    ///
    ///Eample Usage
    ///
    ///````swift
    ///
    ///        let response = try await PCClient.deleteClient(client, productIdorSlug: nil, token: token).value
    ///        if response?.ok == true {
    ///            //bye client
    ///        }
    ///
    ///````
    ///
    /// - Requires: Scope of clients:remove
    /// - Parameter client: The oauth client to update.
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Returns: `ServerResponses.NoResponse`
    /// - Throws: `PCError`
    public static func deleteClient(_ client: PCClient, productId: ProductID?, token: PCAccessToken) async throws -> ServerResponses.NoResponse {
        try await PCNetwork.shared.cloudRequest(.deleteClient(client: client, productIdorSlug: productId, token: token), type: ServerResponses.NoResponse.self)
    }
}



// MARK: - Completion Handlers
extension PCClient {
    
    ///Get a list of all existing OAuth clients, either owned by the authenticated user or clients associated with a product.
    ///
    ///Example Usage
    ///
    ///````swift
    ///
    ///        PCClient.listClients(productIdorSlug: nil, token: token) { result in
    ///            switch result {
    ///                case .success(let response):
    ///                    //check the response
    ///                case .failure(let error):
    ///                    //check the error
    ///             }
    ///        }
    ///
    ///````
    ///
    ///An OAuth client generally represents an app. The Particle CLI is a client, as are the Particle Web IDE, the Particle iOS app, and the Particle Android app. You too can create your own clients. You should create separate clients for each of your web and mobile apps that hit the Particle API.Some requests, like generating an access token, require you to specify an OAuth client ID and secret using HTTP Basic authentication. Normally, when calling the Particle API as a single developer user to access your own account, you can use particle for both the client ID and secret as in the example above for generating an access token. However, especially when you are creating a product on the Particle platform and your web app needs to hit our API on behalf of your customers, you need to create your own client.NEVER expose the client secret to a browser. If, for example, you have a client that controls all your organization's products, and you use the client secret in front-end JavaScript, then a tech-savvy customer using your website can read the secret in her developer console and hack all your customers' devices.
    /// - note: required scope =  clients:list
    /// - Parameter productIdorSlug: The optional product id or slug for which to filter the list of clients.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCClientSeverResponse.ServerResponse or a PCError.
    /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    public static func listClients(productIdorSlug productID: ProductID?, token: PCAccessToken, completion: @escaping (Result<PCClientServerResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.listClients(productIdorSlug: productID, token: token), type: PCClientServerResponse.self, completion: completion)
    }
    
    /// Create an oAuth client
    ///
    ///Example Usage
    ///
    ///````swift
    ///
    ///        PCClient.(appName: String, productIdorSlug productID: String?, type: PCClientEnum.ClientType, token: token) { result in
    ///            switch result {
    ///                case .success(let response):
    ///
    ///                    //check the response
    ///
    ///                    if let client = response.clients.first {
    ///                        //Store this secret it wont be given or retrievable again.
    ///                    }
    ///                case .failure(let error):
    ///                    //check the error
    ///             }
    ///        }
    ///
    ///````
    ///
    /// Create an OAuth client that represents an app.
    ///
    /// Use type=installed for most web and mobile apps. If you want to have Particle users login to their account on Particle in order to give your app access to their devices, then you can go through the full OAuth authorization code grant flow using type=web. This is the same way you authorize it similar to the way you give any app access to your Facebook or Twitter account.
    ///
    /// - Important: Your client secret will never be displayed again! Save it in a safe place.
    /// - Important: If you use type=web then you will also need to pass a redirect_uri parameter.
    /// - Warning: NEVER expose the client secret to a browser. If, for example, you have a client that controls all your organization's products, and you use the client secret in front-end JavaScript, then a tech-savvy customer using your website can read the secret in her developer console and hack all your customers' devices.
    ///
    /// The scopes provided only contain the object and action parts, skipping the domain which is being infered from the context.
    ///
    /// If you are building a web or mobile application for your Particle product, you should use the product-specific endpoint for creating a client (POST /v1/products/:productIdOrSlug/clients). This will grant this client (and access tokens generated by this client) access to product-specific behaviors like [calling functions](https://docs.particle.io/reference/cloud-apis/api/#call-a-function) and [checking variables](https://docs.particle.io/reference/cloud-apis/api/#get-a-variable-value) on product devices, [creating customers](https://docs.particle.io/reference/cloud-apis/api/#create-a-customer---client-credentials), and [generating customer scoped access tokens](https://docs.particle.io/reference/cloud-apis/api/#generate-a-customer-scoped-access-token).
    ///
    /// - Requires: required scope =  clients:create
    /// - Parameter appName: The app name to associate with the new oauth client.
    /// - Parameter productIdorSlug: The optional product id or slug that the new oAuth client is associated with.
    /// - Parameter redirectURL: This is the URL where users will be redirected after telling Particle they are willing to give your app access to their devices.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCClientSeverResponse.ServerResponse or a PCError.
    /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    public static func createClient(appName: String, productIdorSlug productID: ProductID?, redirectURL: URL?, type: PCClient.ClientType, token: PCAccessToken, completion: @escaping (Result<PCClientServerResponse, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.createClient(appName: appName, productIdorSlug: productID, redirect_uri: redirectURL, type: type, token: token), type: PCClientServerResponse.self, completion: completion)
    }
    
    /// Update the name or scope of an existing OAuth client.
    ///
    ///Example Usage
    ///
    ///````swift
    ///
    ///        PCClient.updateClient(client: PCClient, newName: String? = nil, newScope: PCClientEnum.Scope? = nil, productIdorSlug productID: String?, token: token) { result in
    ///            switch result {
    ///                case .success(let response):
    ///                    //check the response
    ///                case .failure(let error):
    ///                    //check the error
    ///             }
    ///        }
    ///
    ///````
    ///
    /// - Requires: required scope =  clients:update
    /// - Parameter client: The oauth client to update.
    /// - Parameter newName: Give the OAuth client a new name or pass nil to keep the old name.
    /// - Parameter newScope: Update the scope of the OAuth client. to only allow customer creation from the client or pass none to remove all scopes (full permissions)
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCClientSeverResponse.ServerResponse or a PCError.
    /// - Note: This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    public static func updateClient(client: PCClient, newName: String? = nil, newScope: PCClient.Scope? = nil, productIdorSlug productID: ProductID?, token: PCAccessToken, completion: @escaping (Result<PCClientServerResponse, PCError>) -> Void ){
        PCNetwork.shared.cloudRequest(.updateClient(client: client, newName: newName, newScope: newScope, productIdorSlug: productID, token: token), type: PCClientServerResponse.self, completion: completion)
    }
    
    ///Delete the client from the server database.
    ///
    ///Example Usage
    ///
    ///````swift
    ///
    ///        PCClient.deleteClient(_ client: PCClient, productIdorSlug productID: String?,
    ///            switch result {
    ///                case .success(let response):
    ///                    //check the response
    ///                case .failure(let error):
    ///                    //check the error
    ///             }
    ///        }
    ///
    ///````
    ///
    /// - Requires: Scope of clients:remove
    /// - Parameter client: The oauth client to update.
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Parameter token: An PCAccessToken carrying the access token and associated information.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an ServerResponses.NoResponse or a PCError.
    /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    public static func deleteClient(_ client: PCClient, productIdorSlug productID: ProductID?, token: PCAccessToken, completion: @escaping (Result<ServerResponses.NoResponse, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.deleteClient(client: client, productIdorSlug: productID, token: token), type: ServerResponses.NoResponse.self, completion: completion)
    }
}

