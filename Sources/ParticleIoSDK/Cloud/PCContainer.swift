//
//  PCContainer.swift
//  ParticleSDK
//
//  Created by Craig Spell on 10/28/23.
//

import Foundation
//import Combine

@available(*, deprecated, message: "Failed Class: -> Couldn't work out authentication timing.")
///Encapsulation of all available cloud exposed particlio APIs
public class PCContainer: ObservableObject {
    
//    ///The shared global singleton for the PCContainer class.
//    static public let shared = PCContainer()
    
    @Published public var isAuthenticated = PCAuthenticationManager.shared.userIsAuthenticated
    
    ///An encapsulation of all authentication needs of the framework. Your application should use this to determine the authenticated state of the application. If you want to handle login yourself, you must still provide a valid token to the authentication manager. This can be done through the method on PCAuthenticationManager directly or simply call login(token:) on the PCContainer.
    @Published private(set) public var authenticationManager: PCAuthenticationManager
    
//    //private tracking of cancellables to unwrap return types on Combine overloads.
//    private var cancellables = Set<AnyCancellable>()
    
    ///Returns the current authentication state of the access token.
    ///
    ///If a token expires this property may still return true until the authmanager catches the token is invalidated. This can happen for many reason, such as deleting a token from a separate webhook or app, or an expiration of the token. Even when loggied in the token is not valid until the server accepts it. You can validate a token, but generally wouldn't since doing so would require a separate network call anyway.
    public var userIsAuthenticated: Bool {
        self.authenticationManager.userIsAuthenticated
    }
    
    ///Initializes the container for immediate use.
    public init(credentials: PCCredentials, client: PCClient? = nil) {
        
        self.authenticationManager = PCAuthenticationManager.shared
        self.authenticationManager.login(credentials: credentials, client: client) { result in
            #warning("not finished")
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenAvailable(_:)),
                                               name: .pc_token_available,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenRevoked(_:)),
                                               name: .pc_token_unavailable,
                                               object: nil)
    }
    
    
    @objc private func tokenAvailable(_ note: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.isAuthenticated = true
        }
    }
    
    
    @objc private func tokenRevoked(_ note: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.isAuthenticated = false
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    //MARK: - Login
    //MARK: Token
    ///Short cut to PCAuthenticationManager to login with an access token.
    func login(token: PCAccessToken) async throws {
        try await self.authenticationManager.login(token: token)
    }
//    
//    
//    ///Short cut to PCAuthenticationManager to login with an access token.
//    func login(token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void) {
//        Task {
//            do {
//                try await self.authenticationManager.login(token: token)
//                completion(.success(true))
//            } catch {
//                completion(.failure(error as! PCError))
//            }
//        }
//    }
    
    //MARK: Credentials
    ///Short cut to PCAuthenticationManager to login with an PCCredentials and optionally scope to a client.
    func login(credentials: PCCredentials, client: PCClient? = nil) async throws {
        try await self.authenticationManager.login(credentials: credentials, client: client)
    }
    
//    
//    ///Short cut to PCAuthenticationManager to login with an PCCredentials and optionally scope to a client.
//    func login(credentials: PCCredentials, client: PCClient? = nil, completion: @escaping (Result<Bool, PCError>) -> Void) {
//        Task {
//            do {
//                try await self.authenticationManager.login(credentials: credentials, client: client)
//                completion(.success(true))
//            } catch {
//                completion(.failure(error as! PCError))
//            }
//        }
//    }


//MARK: - Logout
    
    ///Short cut to PCAuthenticationManager to logout.
    func logout() async throws -> Bool {
        try await self.authenticationManager.logout()
    }
    
//    ///Short cut to PCAuthenticationManager to logout.
//    func logout(completion: @escaping (Result<Bool, PCError>) -> Void) {
//        Task {
//            do {
//                let success = try await self.authenticationManager.logout()
//                completion(.success(success))
//            } catch {
//                completion(.failure(error as! PCError))
//            }
//        }
//    }

    
    //MARK: List Client
    
    ///Get a list of all existing OAuth clients, either owned by the authenticated user or clients associated with a product.
    ///
    ///
    ///
    ///An OAuth client generally represents an app. The Particle CLI is a client, as are the Particle Web IDE, the Particle iOS app, and the Particle Android app. You too can create your own clients. You should create separate clients for each of your web and mobile apps that hit the Particle API.Some requests, like generating an access token, require you to specify an OAuth client ID and secret using HTTP Basic authentication. Normally, when calling the Particle API as a single developer user to access your own account, you can use particle for both the client ID and secret as in the example above for generating an access token. However, especially when you are creating a product on the Particle platform and your web app needs to hit our API on behalf of your customers, you need to create your own client.NEVER expose the client secret to a browser. If, for example, you have a client that controls all your organization's products, and you use the client secret in front-end JavaScript, then a tech-savvy customer using your website can read the secret in her developer console and hack all your customers' devices.
    /// - note: required scope =  clients:list
    /// - Parameter productIdorSlug: The optional product id or slug for which to filter the list of clients.
    /// - Returns: `array of PCClient`
    /// - Throws:  `PCError`
    func listClients(productIdorSlug: ProductID?) async throws -> [PCClient] {
        
        guard let token = authenticationManager.token else { throw PCError.unauthenticated}
        return try await PCClient.listClients(productId: productIdorSlug, token: token).clients
    }
    
    
    ///Get a list of all existing OAuth clients, either owned by the authenticated user or clients associated with a product.
    ///
    ///
    ///
    ///An OAuth client generally represents an app. The Particle CLI is a client, as are the Particle Web IDE, the Particle iOS app, and the Particle Android app. You too can create your own clients. You should create separate clients for each of your web and mobile apps that hit the Particle API.Some requests, like generating an access token, require you to specify an OAuth client ID and secret using HTTP Basic authentication. Normally, when calling the Particle API as a single developer user to access your own account, you can use particle for both the client ID and secret as in the example above for generating an access token. However, especially when you are creating a product on the Particle platform and your web app needs to hit our API on behalf of your customers, you need to create your own client.NEVER expose the client secret to a browser. If, for example, you have a client that controls all your organization's products, and you use the client secret in front-end JavaScript, then a tech-savvy customer using your website can read the secret in her developer console and hack all your customers' devices.
    /// - note: required scope =  clients:list
    /// - Parameter productIdorSlug: The optional product id or slug for which to filter the list of clients.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an array of PCClient or a PCError.
    /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    func listClients(productIdorSlug: ProductID?, completion: @escaping (Result<[PCClient], PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else { completion(.failure(PCError.unauthenticated)); return}
        PCClient.listClients(productIdorSlug: productIdorSlug, token: token) { result in
            switch result {
            case .success(let response):
                completion(.success(response.clients))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    //MARK: Create Client
    
    /// Create an oAuth client
    ///
    ///
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
    /// - Returns: An `PCClient`.
    /// - throws: `PCError`
    func createClient(appName: String, productIdorSlug: ProductID?, type: PCClient.ClientType) async throws -> PCClient? {
        
        guard let token = authenticationManager.token else { throw PCError.unauthenticated}
        return try await PCClient.createClient(appName: appName, productId: productIdorSlug, type: type, token: token).clients.first
    }
    
    
    /// Create an oAuth client
    ///
    ///
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
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCClient or a PCError.
    /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    func createClient(appName: String, productIdorSlug: ProductID?, type: PCClient.ClientType, completion: @escaping (Result<PCClient?, PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else { completion(.failure(PCError.unauthenticated)); return}
        
        PCClient.createClient(appName: appName, productIdorSlug: productIdorSlug, type: type, token: token, completion: { result in
            
            switch result {
            case .success(let response):
                completion(.success(response.clients.first))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    
    //MARK: Update Client
    
    /// Update the name or scope of an existing OAuth client.
    ///
    ///
    ///
    /// - Requires: required scope =  clients:update
    /// - Parameter client: The oauth client to update.
    /// - Parameter newName: Give the OAuth client a new name or pass nil to keep the old name.
    /// - Parameter newScope: Update the scope of the OAuth client. to only allow customer creation from the client or pass none to remove all scopes (full permissions)
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Returns: `PCClient`
    /// - Throws:  `PCError`
    func updateClient(client: PCClient, newName: String?, newScope: PCClient.Scope?, productIdorSlug: ProductID?) async throws -> PCClient? {
        
        guard let token = authenticationManager.token else { throw PCError.unauthenticated}
        return try await PCClient.updateClient(client: client, newName: newName, newScope: newScope, productId: productIdorSlug, token: token).clients.first
    }
    
    
    /// Update the name or scope of an existing OAuth client.
    ///
    ///
    ///
    /// - Requires: required scope =  clients:update
    /// - Parameter client: The oauth client to update.
    /// - Parameter newName: Give the OAuth client a new name or pass nil to keep the old name.
    /// - Parameter newScope: Update the scope of the OAuth client. to only allow customer creation from the client or pass none to remove all scopes (full permissions)
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an optional PCClient or a PCError.
    /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    func updateClient(client: PCClient, newName: String?, newScope: PCClient.Scope?, productIdorSlug: ProductID?, completion: @escaping (Result<PCClient?, PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else { completion(.failure(PCError.unauthenticated)); return}
        
        PCClient.updateClient(client: client, productIdorSlug: productIdorSlug, token: token, completion:  { result in
            
            switch result {
            case .success(let response):
                completion(.success(response.clients.first))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    
    //MARK: Clients Delete
    
    ///Delete the client from the server database.
    ///
    ///
    ///
    /// - Requires: Scope of clients:remove
    /// - Parameter client: The oauth client to update.
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Returns: `Bool` indicating success.
    /// - Throws: `PCError`
    func deleteClient(_ client: PCClient, productIdorSlug: ProductID?) async throws -> Bool {
        
        guard let token = authenticationManager.token else { throw PCError.unauthenticated}
        return try await PCClient.deleteClient(client, productId: productIdorSlug, token: token).ok
    }
    
    
    ///Delete the client from the server database.
    ///
    ///
    ///
    /// - Requires: Scope of clients:remove
    /// - Parameter client: The oauth client to update.
    /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an Bool indicating success or an PCError indicating the failure.
    /// This task may be called from any thread and the result should be dispatched to the main queue if User Interface interactions or handling occurs within the closure.
    func deleteClient(_ client: PCClient, productIdorSlug: ProductID?, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else { completion(.failure(PCError.unauthenticated)); return}
        
        PCClient.deleteClient(client, productIdorSlug: productIdorSlug, token: token, completion: { result in
            
            switch result {
            case .success(let response):
                completion(.success(response.ok))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    
    //Create API User
        
    /// Used to create an API User scoped to an organization or a product.
    ///
    ///
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
    /// - Returns: `PCAPIUser.ServerResponse>`
    /// - Throws: `PCError`
    func createApiUser(scopedTo: PCAPIUser.UserScope, friendlyName: String, permissions: [UserPermissions]) async throws -> PCAPIUser? {
        
        guard let token = authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCAPIUser.createAn_API_User(type: scopedTo, parameters: .init(friendlyName: friendlyName, permissions: permissions), token: token).user
    }
    
    
    /// Used to create an API User scoped to an organization or a product.
    ///
    ///
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
    /// - Parameter completion: A completion handler for the request The completion closure will provide an result of either an optional PCAPIUser or a PCError.
    func createApiUser(scopedTo: PCAPIUser.UserScope, friendlyName: String, permissions: [UserPermissions], completion: @escaping (Result<PCAPIUser?, PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else {
            completion( .failure(PCError.unauthenticated) )
            return
        }
        
        PCAPIUser.createAn_API_User(type: scopedTo, parameters: .init(friendlyName: friendlyName, permissions: permissions), token: token) { result in
            
            switch result {
            case .success(let response):
                completion(.success(response.user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    //MARK: Update API User
    
    ///Used to update an existing API User.
    ///
    ///To modify the permissions associated with an API user, you must update the scopes via the REST API. Remember, when scopes assigned to a user change, the access token is updated and a fresh token is returned, to avoid scope creep. Depending on the scenario, it may be optimal to create a fresh user with updated permissions first, update the access token in use by the script/code/function, and then delete the old user. To update the API user, you pass in the full username, in this case super_product@api.particle.io.
    ///
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
    /// - Returns: `PCAPIUser`
    /// - Throws: `PCError`
    func updateApiUser(scopedTo: PCAPIUser.UserScope, parameters: PCAPIUser.UserParameters) async throws -> PCAPIUser? {
        
        guard let token = authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCAPIUser.updateAn_API_User(type: scopedTo, parameters: parameters, token: token).user
    }
    
    
    /// Used to update an existing API User.
    ///
    /// To modify the permissions associated with an API user, you must update the scopes via the REST API. Remember, when scopes assigned to a user change, the access token is updated and a fresh token is returned, to avoid scope creep. Depending on the scenario, it may be optimal to create a fresh user with updated permissions first, update the access token in use by the script/code/function, and then delete the old user. To update the API user, you pass in the full username, in this case super_cool_organization_id@api.particle.io.
    ///
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
    /// - Parameter completion: A completion handler for the request The completion closure will provide a result of an optional PCAPIUser or a PCError indicating the failure.
    func updateApiUser(scopedTo: PCAPIUser.UserScope, parameters: PCAPIUser.UserParameters, completion: @escaping (Result<PCAPIUser?, PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated))
            return
        }
        
        PCAPIUser.updateAn_API_User(type: scopedTo, parameters: parameters, token: token) { result in
            do{
                let response = try result.get()
                completion(.success(response.user))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }

    
    //MARK: List API Users
    
    ///Used to get a list of the api users.
    ///
    ///Listing API users is done by getting the team member list of the product or for the organization. Both regular and API users are returned, however you can tell API users as they have the is_programmatic flag set to true in the user array element:
    ///
    ///
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Returns: `PCAPIUser.Team`
    /// - Throws: `PCError`
    func listApiUsers(scopedTo: PCAPIUser.UserScope) async throws -> [PCAPIUser.Team] {
        
        guard let token = authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCAPIUser.list_API_Users(type: scopedTo, token: token).team
    }
    
    
    ///Used to get a list of the api users.
    ///
    ///Listing API users is done by getting the team member list of the product or for the organization. Both regular and API users are returned, however you can tell API users as they have the is_programmatic flag set to true in the user array element:
    ///
    ///
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCAPIUser.ListResponse or a PCError.
    func listApiUsers(scopedTo: PCAPIUser.UserScope, completion: @escaping (Result<[PCAPIUser.Team], PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated))
            return
        }
        
        PCAPIUser.list_API_Users(type: scopedTo, token: token) { result in
            do{
                let response = try result.get()
                completion(.success(response.team))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }

    
    //MARK: Delete API User
    
    
    /// Delete an API User scoped to an organization or a product.
    ///
    /// Also deletes the accociated access token.
    ///
    ///
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Parameter username: The username or "friendly name" of the API user to delete.
    /// - Returns: A `Bool` indicating success.
    /// - Throws: `PCError`
    func deleteApiUser(scopedTo: PCAPIUser.UserScope, username: String) async throws -> Bool {
        
        guard let token = authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCAPIUser.deleteAn_API_User(type: scopedTo, username: username, token: token).ok
    }
    
    
    /// Delete an API User scoped to an organization or a product.
    ///
    /// Also deletes the accociated access token.
    ///
    ///Example Usage
    ///
    ///````swift
    ///
    ///            PCAPIUser.deleteAn_API_User(type: .organization(name: "super_cool_organization_id"), username: "bad_apple", token: token) { result in
    ///                switch result {
    ///                    case .success(let response):
    ///                        if let response.ok {
    ///                             //bye user
    ///                        }
    ///                    case .failure(let error):
    ///                        print(error)
    ///                }
    ///            }
    ///
    ///````
    ///
    /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
    /// - Parameter username: The username or "friendly name" of the API user to delete.
    /// - Parameter completion: A completion handler for the request The completion will contain a result of either an Bool indicating success or an PCError indicating the failure.
    func deleteApiUser(scopedTo: PCAPIUser.UserScope, username: String, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated))
            return
        }
        
        PCAPIUser.deleteAn_API_User(type: scopedTo, username: username, token: token) { result in
            do{
                let response = try result.get()
                completion(.success(response.ok))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }

    
    //MARK: - Devices
    //MARK: List Devices
    
    /// List Particle devices linked to the current access token.
    ///
    ///
    ///
    /// - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    /// - Returns: An array of PCDevice.
    /// - Throws: PCError
    func listDevices(arguments: PCDevice.ListArguments? = nil) async throws -> [PCDevice] {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        return try await PCDevice.listDevices(arguments: arguments, token: token)
    }
    
    
    
    /// List Particle devices linked to the current access token.
    ///
    ///
    ///
    ///  - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    ///  - Parameter token: The current Particle Cloud Access Token.
    ///  - Parameter completion: Completion closure delivering either an [PCDevice] or a PCError.
    func listDevices(arguments: PCDevice.ListArguments? = nil, completion: @escaping (Result<[PCDevice], PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion(.failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        return PCDevice.listDevices(arguments: arguments, token: token, completion: completion)
    }

    
    //MARK: List Product Devices

    
    /// List Particle devices linked to the current access token.
    ///
    ///
    ///
    /// - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    /// - Returns: An array of PCDevice.
    /// - Throws: PCError
    public func listProductDevices(productIdOrSlug: ProductID, arguments: PCDevice.ListArguments?)
    async throws -> [PCDevice] {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        
        return try await PCDevice.listProductDevices(productIdOrSlug: productIdOrSlug, arguments: arguments, token: token)
    }
    
    
    
    /// List Particle devices linked to the current access token.
    ///
    ///
    ///
    ///  - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    ///  - Parameter completion: Completion closure delivering either an [PCDevice] or a PCError.
    public func listProductDevices(productIdOrSlug: ProductID, arguments: PCDevice.ListArguments?, completion: @escaping (Result<[PCDevice], PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion(.failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        
        PCDevice.listProductDevices(productIdOrSlug: productIdOrSlug, arguments: arguments, token: token, completion: completion)
    }

    
    //MARK: Import Devices
    
    
    ///Import devices into product
    ///
    ///Import devices into a product. Devices must be of the same platform type as the product in order to be successfully imported. Imported devices may receive an immediate OTA firmware update to the product's released firmware.Importing a device with a Particle SIM card will also import the SIM card into the product and activate the SIM card.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/devices
    ///
    ///
    ///
    /// - Requires: Scope of devices:import
    /// - throws: PCError indicating the failure.
    /// - Parameter arguments: Optional arguments to be included in the request.
    /// - Returns: An `PCDevice.ImportResponse`
    public func importDevices(_ devices: DeviceID..., into productId: ProductID, arguments: PCDevice.ImportArguments? = nil) async throws -> PCDevice.ImportResponse {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        
        return try await PCDevice.importDevices(devices, into: productId, arguments: arguments, token: token)
    }
    
    
    ///Import devices into product
    ///
    ///Import devices into a product. Devices must be of the same platform type as the product in order to be successfully imported. Imported devices may receive an immediate OTA firmware update to the product's released firmware.Importing a device with a Particle SIM card will also import the SIM card into the product and activate the SIM card.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/devices
    ///
    ///
    ///
    /// - Requires: Scope of devices:import
    /// - Parameter arguments: Optional arguments to be included in the request.
    /// - Parameter completion: Closure containing a result of PCDevice.ImportResponse of an PCError indicating the failure.
    public func importDevices(_ devices: DeviceID..., into productId: ProductID, arguments: PCDevice.ImportArguments? = nil, completion: @escaping (Result<PCDevice.ImportResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion(.failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        
        PCDevice.importDevices(devices, into: productId, arguments: arguments, token: token, completion: completion)
    }

    
    //MARK: Get Device
    
    
    ///Get a particlie io device
    ///
    ///Used to get the representation of the physical device. Once you have a device you interact with it directly. Look at the PCDevice dowumentation for more information.
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The ID of the device you are trying to represent.
    /// - Returns: PCDevice representing the actual particle device.
    func getDevice(deviceID: DeviceID) async throws -> PCDevice {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        return try await PCDevice.getDevice(deviceID: deviceID, token: token)
    }

    
    
    ///Get a particlie io device
    ///
    ///Used to get the representation of the physical device. Once you have a device you interact with it directly. Look at the PCDevice dowumentation for more information.
    /// - Parameter deviceID: The ID of the device you are trying to represent.
    /// - Parameter completion: Closure containing with an PCDevice or an PCError indicating the failure.
    func getDevice(deviceID: DeviceID, completion: @escaping (Result<PCDevice, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion(.failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        return PCDevice.getDevice(deviceID: deviceID, token: token, completion: completion)
    }

    
    //MARK: Get Product Device
    
    
    ///Get a particlie io device
    ///
    ///Used to get the representation of the physical device. Once you have a device you interact with it directly. Look at the PCDevice dowumentation for more information.
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The ID of the device you are trying to represent.
    /// - Parameter productIdOrSlug: The id of the product that the device is associated with.
    /// - Returns: PCDevice representing the actual particle device.
    func getProductDevice(deviceID: DeviceID?, productIdOrSlug: ProductID, completion: @escaping (Result<PCDevice, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion(.failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        return PCDevice.getProductDevice(deviceID: deviceID, productIdOrSlug: productIdOrSlug, token: token, completion: completion)
    }
    
    
    ///Get a particlie io device
    ///
    ///Used to get the representation of the physical device. Once you have a device you interact with it directly. Look at the PCDevice dowumentation for more information.
    /// - Parameter deviceID: The ID of the device you are trying to represent.
    /// - Parameter productIdOrSlug: The id of the product that the device is associated with.
    /// - Parameter completion: Closure containing with an PCDevice or an PCError indicating the failure.
    func getProductDevice(deviceID: DeviceID?, productIdOrSlug: ProductID) async throws -> PCDevice {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        return try await PCDevice.getProductDevice(deviceID: deviceID, productIdOrSlug: productIdOrSlug, token: token)
    }

    
    //MARK: Claim Codes
    
    ///Create a claim code
    ///
    ///Generate a device claim code that allows the device to be successfully claimed to a Particle account during the setup process. You can use the product endpoint for creating a claim code to allow customers to successfully claim a product device. Use an access token that was generated by the Particle account you'd like to claim ownership of the device.
    ///
    ///When creating claim codes for Wi-Fi devices like Photons, allow the cloud to generate the claim code for you. This is done by not passing anything to the request body (with the exception of products in private beta, which require an activation code to generate a claim code). Then, this claim code must be sent to the Photon via SoftAP. For more information on how to send claim codes to Particle devices via SoftAP, please check out [Particle SoftAP setup for JavaScript](https://github.com/particle-iot/softap-setup-js).
    ///
    ///Conversely, for cellular devices like Electrons, you must create a claim code equal to the iccid or imei of the device. This is because Electrons are not directly connected to by the client during setup. This is done by passing an iccid or imei in the body of the request when creating a claim code.
    ///
    ///When an device connects to the cloud, it will immediately publish its claim code (or in the case of Electrons, it will publish its ICCID and IMEI). The cloud will check this code against all valid claim codes, and if there is a match, successfully claim the device to the account used to create the claim code.
    ///
    /// - calls: POST /v1/device_claims
    ///
    /// - throws: PCError
    /// - Parameter arguments: An encapsulation of the arguments for the request.
    /// - Returns: An PCDevice.ClaimCodeResponse.
    func createClaimCode(arguments: PCDevice.ClaimRequestArguments?) async throws  -> PCDevice.ClaimCodeResponse {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        return try await PCDevice.createClaimCode(arguments: arguments, token: token)
    }
    
    
    
    ///Create a claim code
    ///
    ///Generate a device claim code that allows the device to be successfully claimed to a Particle account during the setup process. You can use the product endpoint for creating a claim code to allow customers to successfully claim a product device. Use an access token that was generated by the Particle account you'd like to claim ownership of the device.
    ///
    ///When creating claim codes for Wi-Fi devices like Photons, allow the cloud to generate the claim code for you. This is done by not passing anything to the request body (with the exception of products in private beta, which require an activation code to generate a claim code). Then, this claim code must be sent to the Photon via SoftAP. For more information on how to send claim codes to Particle devices via SoftAP, please check out [Particle SoftAP setup for JavaScript](https://github.com/particle-iot/softap-setup-js).
    ///
    ///Conversely, for cellular devices like Electrons, you must create a claim code equal to the iccid or imei of the device. This is because Electrons are not directly connected to by the client during setup. This is done by passing an iccid or imei in the body of the request when creating a claim code.
    ///
    ///When an device connects to the cloud, it will immediately publish its claim code (or in the case of Electrons, it will publish its ICCID and IMEI). The cloud will check this code against all valid claim codes, and if there is a match, successfully claim the device to the account used to create the claim code.
    ///
    /// - calls: POST /v1/device_claims
    ///
    /// - Parameter arguments: An encapsulation of the arguments for the request.
    /// - Parameter completion: Closure with a result containing the ClaimCodeResponse or an PCError indicating the failure.
    func createClaimCode(arguments: PCDevice.ClaimRequestArguments?, completion: @escaping (Result<PCDevice.ClaimCodeResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion( .failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        return PCDevice.createClaimCode(arguments: arguments, token: token, completion: completion)
    }

    
    //MARK: Device Claim


    ///Claim a device
    ///
    ///Claim a new or unclaimed device to your account or request a transfer from another user.
    ///
    /// - calls: POST /v1/devices
    ///
    ///
    /// - Throws: PCError
    /// - Parameter deviceID: The ID of the device to claim.
    /// - Parameter isTransfer: Indicates if this is a transfer from another user.
    /// - Returns: An PCDevice.TransferID
    func claimDevice(_ deviceID: DeviceID, isTransfer: Bool = false) async throws -> PCDevice.TransferID {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        
        return try await PCDevice.claimDevice(deviceID, isTransfer: isTransfer, token: token)
    }
    
    
    ///Claim a device
    ///
    ///Claim a new or unclaimed device to your account or request a transfer from another user.
    ///
    /// - calls: POST /v1/devices
    ///
    ///
    ///
    /// - Parameter deviceID: The ID of the device to claim.
    /// - Parameter isTransfer: Indicates if this is a transfer from another user.
    /// - Parameter completion: Closure with a result containing the  PCDevice.ClaimResponse or an PCError indicating the failure.
    func claimDevice(_ deviceID: DeviceID, isTransfer: Bool = false, completion: @escaping (Result<PCDevice.TransferID, PCError>) -> Void)  {
        
        guard let token = self.authenticationManager.token else {
            completion( .failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        
        PCDevice.claimDevice(deviceID, isTransfer: isTransfer, token: token, completion: completion)
    }

    
    //MARK: Remove Device from Product
    
    
    ///Remove device from product
    ///
    ///Remove a device from a product and re-assign to a generic Particle product.
    ///
    /// - calls: DELETE /v1/products/:productIdOrSlug/devices/:deviceID
    ///
    ///
    /// - Requires: Scope of devices:remove
    /// - Important: This endpoint will unclaim the device if it is owned by a customer.
    /// - Parameter deviceID: The device identifier of the device to be removed.
    /// - Parameter productIdorSlug: The product identifier of the product the device is assigned to.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - throws: PCError indicating the failure reason.
    /// - Returns: Bool indicating the success of the API call.
    func remove(_ device: DeviceID, from product: ProductID) async throws -> Bool {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        
        return try await PCDevice.removeDeviceFromProduct(deviceID: device, productIdorSlug: product, token: token)
    }
    
    
    ///Remove device from product
    ///
    ///Remove a device from a product and re-assign to a generic Particle product.
    ///
    /// - calls: DELETE /v1/products/:productIdOrSlug/devices/:deviceID
    ///
    ///
    /// - Requires: Scope of devices:remove
    /// - Important: This endpoint will unclaim the device if it is owned by a customer.
    /// - Parameter deviceID: The device identifier of the device to be removed.
    /// - Parameter productIdorSlug: The product identifier of the product the device is assigned to.
    /// - Parameter completion: Closure containing either a Bool indicating success or an PCError indicating the failure.
    func remove(_ device: DeviceID, from product: ProductID, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion( .failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        
        PCDevice.removeDeviceFromProduct(deviceID: device, productIdorSlug: product, token: token, completion: completion)
    }

    
    //MARK: Unclaim Device
    
    
    ///Unclaim device.
    ///
    ///Remove ownership of a device. This will unclaim regardless if the device is owned by a user or a customer, in the case of a product.When using this endpoint to unclaim a product device, the route looks slightly different:DELETE /v1/products/:productIdOrSlug/devices/:deviceID/owner Note the /owner at the end of the route.
    ///
    /// - calls: DELETE /v1/devices/:deviceID
    ///
    ///
    /// - Requires: Scope of devices:release
    /// - note: If the device is assigned to a product the productID argument must correspond to the product it is assigned to.
    /// - Parameter deviceID: The device identifier of the device to be unclaimed.
    /// - Parameter productID: The product identifier of the product the device is assigned to or nil if not assigned to a product.
    /// - throws: PCError indicating the failure.
    /// - Returns: A bool representing the succes of the call.
    func unclaim(_ deviceID: DeviceID, in product: ProductID?) async throws -> Bool {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        
        return try await PCDevice.unclaimDevice(deviceID, productIdorSlug: product, token: token).ok
    }
    
    
    ///Unclaim device.
    ///
    ///Remove ownership of a device. This will unclaim regardless if the device is owned by a user or a customer, in the case of a product.When using this endpoint to unclaim a product device, the route looks slightly different: DELETE /v1/products/:productIdOrSlug/devices/:deviceID/owner Note the /owner at the end of the route.
    ///
    /// - calls: DELETE /v1/devices/:deviceID
    ///
    ///
    /// - Requires: Scope of devices:release
    /// - note: If the device is assigned to a product the productID argument must correspond to the product it is assigned to.
    /// - Parameter deviceID: The device identifier of the device to be unclaimed.
    /// - Parameter productID: The product identifier of the product the device is assigned to or nil if not assigned to a product.
    /// - Returns: CurrrentValueSubject containing a bool representing the succes of the call. Or a PCError indicating the failure.
    func unclaim(_ deviceID: DeviceID, in product: ProductID?, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion( .failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        
        PCDevice.unclaimDevice(deviceID, productIdorSlug: product, token: token) { result in
            switch result {
            case .success(let response): completion(.success(response.ok))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    
    //MARK: Signale a device
    
    
    ///Signal a device.
    ///
    ///Make the device conspicuous by causing its LED to flash in rainbow patterns.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///            let response = try await PCContainer.shared.signalDevice(deviceID, rainbowState: .on)
    ///            let deviceId = response.deviceID
    ///            let connected = response.connected
    ///            let state = response.signalState
    ///
    ///            print("device with id \(deviceID) is \(connected ? "online" : "offline") and \(state ? "is signaling" : "is not signaling")")
    ///
    ///
    ///````
    ///
    /// - Parameter deviceID: The device identifier of the device to be affected.
    /// - Parameter rainbowState: An enum determining whether to turn the signal on or off.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - throws: PCError indicating the reason for failure.
    /// - Returns: `DeviceID.SignalResponse`
    func signalDevice(_ deviceID: DeviceID, rainbowState: RainbowState) async throws -> PCDevice.SignalResponse {
        
        guard let token = self.authenticationManager.token else {
            throw PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")
        }
        return try await PCDevice.signalDevice(deviceID, rainbowState: rainbowState, token: token)
    }
    
    
    ///Signal a device.
    ///
    ///Make the device conspicuous by causing its LED to flash in rainbow patterns.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///            let response = PCContainer.shared.signalDevice(deviceID, rainbowState: .on) { result in
    ///            switch result {
    ///                 case .success(let response):
    ///                       let deviceId = response.deviceID
    ///                       let connected = response.connected
    ///                       let state = response.signalState
    ///
    ///                       print("device with id \(deviceID) is \(connected ? "online" : "offline") and \(state ? "is signaling" : "is not signaling")")
    ///
    ///                 case .failure(let error):
    ///                       print(error)
    ///            }
    ///
    ///
    ///````
    ///
    /// - Parameter deviceID: The device identifier of the device to be affected.
    /// - Parameter rainbowState: An enum determining whether to turn the signal on or off.
    /// - Parameter completion: Closure with a Result containing the signal reponse or an PCError indicating the failure.
    /// - Returns: `DeviceID.SignalResponse`
    func signalDevice(_ deviceID: DeviceID, rainbowState: RainbowState, completion: @escaping (Result<PCDevice.SignalResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token else {
            completion( .failure(PCError(code: .unauthenticated, description: "You are not currently authenticated. You must be authenticated to access this resource.")))
            return
        }
        
        PCDevice.signalDevice(deviceID, rainbowState: rainbowState, token: token, completion: completion)
    }

    
    //MARK: Force OTA Updates
    
    
    ///Force enable OTA updates
    ///
    ///[Force enable](https://docs.particle.io/getting-started/cloud/ota-updates/) OTA updates on this device.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///             let response = try await PCContainer.shared.forceEnable_OTA_Updates(on: deviceID, enabled: true)
    ///             print(response?.id, response?.firmwareUpdatesForced)
    ///
    ///````
    ///
    /// - throws: PCError indicating the failure.
    /// - Requires: Scope of devices:update
    /// - Parameter deviceID: The device identifier of the device to be affected.
    /// - Parameter enabled: Boolean to indicate whether ota updates will be fored or not.
    /// - Returns: `PCDevice.ForceOTAUpdateResponse` indicating the servers response.
    func forceEnable_OTA_Updates(on deviceID: DeviceID, enabled: Bool, token: PCAccessToken) async throws -> PCDevice.ForceOTAUpdateResponse {
        try await PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: deviceID, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self)
    }
    
    
    ///Force enable OTA updates
    ///
    ///[Force enable](https://docs.particle.io/getting-started/cloud/ota-updates/) OTA updates on this device.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///             PCContainer.shared.forceEnable_OTA_Updates(on: deviceID, enabled: true) { result in
    ///
    ///                  do {
    ///                      let response = try result.get()
    ///                      print(response?.id, response?.firmwareUpdatesForced)
    ///                  } catch {
    ///                        print(error)
    ///                  }
    ///             }
    ///
    ///
    ///````
    ///
    /// - Requires: Scope of devices:update
    /// - Parameter deviceID: The device identifier of the device to be affected.
    /// - Parameter enabled: Boolean to indicate whether ota updates will be fored or not.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Parameter completion: Result indicating the servers response. Or an PCError indicating the failure.
    func forceEnable_OTA_Updates(on deviceID: DeviceID, enabled: Bool, token: PCAccessToken, completion: @escaping (Result<PCDevice.ForceOTAUpdateResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: deviceID, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self, completion: completion)
    }

    
    //MARK: Lookup Device Info
    
    
    ///Look up device identification from a serial number.
    ///
    ///Return the device ID and SIM card ICCD (if applicable) for a device by serial number. This API can look up devices that you have not yet added to your product and is rate limited to 50 requests per hour. Once you've imported your devices to your product you should instead use the list devices in a product API and filter on serial number. No special rate limits apply to that API.
    ///
    /// - calls: GET /v1/serial_numbers/:serial_number
    ///
    ///
    ///````swift
    ///
    ///              do {
    ///                 let response = try PCContainer.shared.lookUpDeviceInformation(from: serialNumber, token: token)
    ///                 print(response.deviceID, response.iccid)
    ///              } catch {
    ///                 print(error)
    ///              }
    ///
    ///````
    /// - throws: PCError indicating the failure.
    /// - Parameter serialNumber: The serial number printed on the barcode of the device packaging.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: SerialNumberLookupResponse indicating the servers response.
    func lookUpDeviceInformation(from serialNumber: String, token: PCAccessToken) async throws-> PCDevice.SerialNumberLookupResponse {
        try await PCNetwork.shared.cloudRequest(.lookUpDeviceInformation(serialNumber: serialNumber, token: token), type: PCDevice.SerialNumberLookupResponse.self)
    }
    
    
    ///Look up device identification from a serial number.
    ///
    ///Return the device ID and SIM card ICCD (if applicable) for a device by serial number. This API can look up devices that you have not yet added to your product and is rate limited to 50 requests per hour. Once you've imported your devices to your product you should instead use the list devices in a product API and filter on serial number. No special rate limits apply to that API.
    ///
    /// - calls: GET /v1/serial_numbers/:serial_number
    ///
    ///
    ///````swift
    ///
    ///         PCContainer.shared.lookUpDeviceInformation(from: serialNumber, token: token) { result in
    ///              do {
    ///                 let response = try result.get
    ///                 print(response.deviceID, response.iccid)
    ///              } catch {
    ///                 print(error)
    ///              }
    ///
    ///````
    ///
    /// - Parameter serialNumber: The serial number printed on the barcode of the device packaging.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Parameter completion: Result indicating the servers response. Or an PCError indicating the failure.
    func lookUpDeviceInformation(from serialNumber: String, token: PCAccessToken, completion: @escaping (Result<PCDevice.SerialNumberLookupResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.lookUpDeviceInformation(serialNumber: serialNumber, token: token), type: PCDevice.SerialNumberLookupResponse.self, completion: completion)
    }

    
    //MARK: Refresh Device Vitals
    
    ///Refresh device vitals.
    ///
    ///Refresh diagnostic vitals for a single device. This will instruct the device to publish a new event to the Device Cloud containing a device vitals payload. This is an asynchronous request: the HTTP request returns immediately after the request to the device is sent. In order for the device to respond with a vitals payload, it must be online and connected to the Device Cloud.The device will respond by publishing an event named spark/device/diagnostics/update. See the description of the [device vitals event](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event).
    ///
    /// - calls: PUBLISH spark/device/diagnostics/update
    ///
    ///
    ///````swift
    ///
    ///             PCEvent.subscribe(EventName("spark/device/diagnostics/update", onEvent: {
    ///                 print($0.description)
    ///             })
    ///
    ///             if PCContainer.shared.refreshVitals(for: deviceID) {
    ///                 //expect an diagnostic event
    ///                 //event delivery is not guaranteed consider using another diagnostic call if you need guarantee of delivery.
    ///             }
    ///
    ///````
    ///
    /// - Requires: Scope of devices.diagnostics:update
    /// - throws: PCError
    /// - Parameter deviceID: String representing the device id.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Returns A discardable bool response indicating success on the server.
    @discardableResult func refreshVitals(for device: DeviceID, in product: ProductID? = nil) async throws -> Bool {
        
        guard let token = authenticationManager.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.refreshDeviceVitals(deviceID: device, productIDorSlug: product, token: token), type: ServerResponses.BoolResponse.self).ok
    }
    
    
    ///Refresh device vitals.
    ///
    ///Refresh diagnostic vitals for a single device. This will instruct the device to publish a new event to the Device Cloud containing a device vitals payload. This is an asynchronous request: the HTTP request returns immediately after the request to the device is sent. In order for the device to respond with a vitals payload, it must be online and connected to the Device Cloud.The device will respond by publishing an event named spark/device/diagnostics/update. See the description of the [device vitals event](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event).
    ///
    /// - calls: PUBLISH spark/device/diagnostics/update
    ///
    ///
    ///````swift
    ///
    ///             PCEvent.subscribe(EventName("spark/device/diagnostics/update", onEvent: {
    ///                 print($0.description)
    ///             })
    ///
    ///             PCContainer.shared.refreshVitals(for: device.id) { result in
    ///                 //check for server success
    ///             }
    ///
    ///````
    ///
    /// - Requires: Scope of devices.diagnostics:update
    /// - Parameter deviceID: String representing the device id.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter completion: Closure containing a bool response indicating success on the server or an PCError indicating the failure.
    func refreshVitals(for device: DeviceID, in product: ProductID? = nil, completion: @escaping (Result<Bool, PCError>) -> Void){
        
        guard let token = authenticationManager.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.refreshDeviceVitals(deviceID: device, productIDorSlug: product, token: token), type: ServerResponses.BoolResponse.self) { result in
            
            do {
                let success = try result.get().ok
                completion(.success(success))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }

    
    //MARK: Last Known Vitals
    
    
    ///Get last known device vitals.
    ///
    ///Returns the last device vitals payload sent by the device to the Device Cloud. See [device vitals event payload](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event) for more info.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId/last
    ///
    ///
    /// - Requires: Scope of devices.diagnostics:get
    /// - throws: PCError
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productID: The product idthe device is associated with.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics:get
    /// - Returns: LastKnownDiagnosticsResponse
    func getLastKnownVitals(for deviceID: DeviceID, in product: ProductID) async throws -> LastKnownDiagnosticsResponse {
        
        guard let token = authenticationManager.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCDevice.getLastKnownVitals(for: deviceID, in: product, token: token)
    }
    
    
    ///Get last known device vitals.
    ///
    ///Returns the last device vitals payload sent by the device to the Device Cloud. See [device vitals event payload](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event) for more info.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId/last
    ///
    ///
    /// - Requires: Scope of devices.diagnostics:get
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productID: The product idthe device is associated with.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics:get
    /// - Returns: Closure containg a result of the  LastKnownDiagnosticsResponse or a PCError indicating failure.
    func getLastKnownVitals(for deviceID: DeviceID, in product: ProductID, completion: @escaping (Result<LastKnownDiagnosticsResponse, PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else {
            completion(.failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        return PCDevice.getLastKnownVitals(for: deviceID, in: product, token: token, completion: completion)
    }

    
    //MARK: Historical Vitals
    
    
    ///Get all historical device vitals.
    ///
    ///Returns all stored device vital records sent by the device to the Device Cloud. Device vitals records will expire after 1 month.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId
    ///
    ///
    ///
    /// - Requires: Scope of devices.diagnostics:get
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productIDorSlug: The productID the device is associated with.
    /// - Parameter startDate: Starting  date for query.
    /// - Parameter endDate: Ending date for query.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics:get
    /// - Returns: Current value subject containing the optional HistoricalDiagnosticsResponse or a PCError indicating the failure.
    func getHistoricalVitals(for deviceID: DeviceID, in product: ProductID, startDate: Date? = nil, endDate: Date? = nil) async throws -> HistoricalDiagnosticsResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCDevice.getHistoricalVitals(for: deviceID, in: product, startDate: startDate, endDate: endDate, token: token)
    }
    
    
    ///Get all historical device vitals.
    ///
    ///Returns all stored device vital records sent by the device to the Device Cloud. Device vitals records will expire after 1 month.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId
    ///
    ///
    ///
    /// - Requires: Scope of devices.diagnostics:get
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productIDorSlug: The productID the device is associated with.
    /// - Parameter startDate: Starting  date for query.
    /// - Parameter endDate: Ending date for query.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics:get
    /// - Parameter completion: Closure containing a result of HistoricalDiagnosticsResponse or a PCError indicating the failure.
    func getHistoricalVitals(for device: DeviceID, in product: ProductID, startDate: Date? = nil, endDate: Date? = nil, completion: @escaping (Result<HistoricalDiagnosticsResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        return PCDevice.getHistoricalVitals(for: device, in: product, startDate: startDate, endDate: endDate, token: token, completion: completion)
    }

    
    //MARK: Vital Metadata
    
    
    ///Get device vitals metadata.
    ///
    ///Contextualizes and allows for interpretation of [device vitals](https://docs.particle.io/reference/cloud-apis/api/#refresh-device-vitals). The objects in the device vitals payload map to the metadata objects returned by this endpoint. Metadata will vary depending on the device type, and is subject to change as more is learned about device health.Each metadata object mapping to a device vital can include:
    /// - title: A friendly name.
    /// - type: The data type of the vital returned by the device. Can be set to number or string.
    /// - units: Information on the specific unit of measurement, including how to convert the raw vital into the preferred unit of measurement.
    /// - ranges: Establishes healthy vital ranges. If outside the healthy range, the vital will be marked in the "warning" state in the Console. Ranges help assert whether a reported vital is above/below a specified value, or use a ratio between two related vitals as an indicator of health.
    /// - values: Similar to ranges, but maps reported vitals with a type of string to determine a healthy or warning state.
    /// - messages: Helpful messages to provide analysis and interpretation of diagnostics test results. Also includes a description of the vital.
    /// - priority: Used for visual ordering of device vitals on the Console.
    /// - describes: Creates a relationship between two vitals used for visual arrangement on the Console.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId/metadata
    ///
    ///
    /// - Requires: Scope of devices.diagnostics.metadata:get
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productIDorSlug: The id of the product that the device is associated with.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics.metadata:get
    /// - Returns: An PCRemoteDiagnosticsMetaDataResponse.
    func getVitalMetadata(for device: DeviceID, in product: ProductID) async throws -> PCRemoteDiagnosticsMetaDataResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCNetwork.shared.cloudRequest(.getDeviceVitalsMetadata(deviceID: device, productIDorSlug: product, token: token), type: PCRemoteDiagnosticsMetaDataResponse.self)
    }
    
    
    
    ///Get device vitals metadata.
    ///
    ///Contextualizes and allows for interpretation of [device vitals](https://docs.particle.io/reference/cloud-apis/api/#refresh-device-vitals). The objects in the device vitals payload map to the metadata objects returned by this endpoint. Metadata will vary depending on the device type, and is subject to change as more is learned about device health.Each metadata object mapping to a device vital can include:
    /// - title: A friendly name.
    /// - type: The data type of the vital returned by the device. Can be set to number or string.
    /// - units: Information on the specific unit of measurement, including how to convert the raw vital into the preferred unit of measurement.
    /// - ranges: Establishes healthy vital ranges. If outside the healthy range, the vital will be marked in the "warning" state in the Console. Ranges help assert whether a reported vital is above/below a specified value, or use a ratio between two related vitals as an indicator of health.
    /// - values: Similar to ranges, but maps reported vitals with a type of string to determine a healthy or warning state.
    /// - messages: Helpful messages to provide analysis and interpretation of diagnostics test results. Also includes a description of the vital.
    /// - priority: Used for visual ordering of device vitals on the Console.
    /// - describes: Creates a relationship between two vitals used for visual arrangement on the Console.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId/metadata
    ///
    ///
    /// - Requires: Scope of devices.diagnostics.metadata:get
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productIDorSlug: The id of the product that the device is associated with.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics.metadata:get
    /// - Parameter completion: Closure containg the PCRemoteDiagnosticsMetaDataResponse or an PCError indicating the failure.
    func getVitalMetadata(for device: DeviceID, in product: ProductID, token: PCAccessToken, completion: @escaping (Result<PCRemoteDiagnosticsMetaDataResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion( .failure(PCError.unauthenticated))
            return
        }
        
        
        return PCDevice.getVitalMetadata(for: device, in: product, token: token, completion: completion)
    }

    
    
    //MARK: Cellular Network Status
    
    
    ///Get cellular network status.
    ///
    ///Get cellular network status for a given device. Kicks off a long running task that checks if the device/SIM has an active data session with a cell tower. Values for keys in the sim_status object will be null until the task has finished. Poll the endpoint until meta.state is complete. At this point, the sim_status object will be populated.Note that responses are cached by the cellular network providers. This means that on occasion, the real-time status of the device/SIM may not align with the results of this test.
    ///
    /// - calls: GET /v1/sims/:iccid/status
    ///
    ///
    /// - Requires: Scope of sims.status:get
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The id of the cellular device to query.
    /// - Parameter iccid: The iccid number of the device to query.
    /// - Parameter productIDorSlug: The id of the product the device is associated with.
    /// - Parameter token: A currently active access token with appropriate scopes..
    /// - Returns: An PCRemoteDiagnosticsCellularNetworkStatusResponse.
    func getCellularNetworkStatus(for device: DeviceID, iccid: ICCIDNumber, in product: ProductID) async throws -> PCRemoteDiagnosticsCellularNetworkStatusResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        return try await PCDevice.getCellularNetworkStatus(for: device, iccid: iccid, in: product, token: token)
    }
    
    
    ///Get cellular network status.
    ///
    ///Get cellular network status for a given device. Kicks off a long running task that checks if the device/SIM has an active data session with a cell tower. Values for keys in the sim_status object will be null until the task has finished. Poll the endpoint until meta.state is complete. At this point, the sim_status object will be populated.Note that responses are cached by the cellular network providers. This means that on occasion, the real-time status of the device/SIM may not align with the results of this test.
    ///
    /// - calls: GET /v1/sims/:iccid/status
    ///
    ///
    /// - Requires: Scope of sims.status:get
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The id of the cellular device to query.
    /// - Parameter iccid: The iccid number of the device to query.
    /// - Parameter productIDorSlug: The id of the product the device is associated with.
    /// - Parameter token: A currently active access token with appropriate scopes..
    /// - Returns: An PCRemoteDiagnosticsCellularNetworkStatusResponse.
    func getCellularNetworkStatus(for device: DeviceID, iccid: ICCIDNumber, in product: ProductID, completion: @escaping (Result<PCRemoteDiagnosticsCellularNetworkStatusResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        return PCDevice.getCellularNetworkStatus(for: device, iccid: iccid, in: product, token: token, completion: completion)
    }

    

//MARK: - User


    //MARK: Get User
    
    
    ///Get user.
    ///
    ///Return the user resource for the currently authenticated user.
    ///
    /// - calls: GET /user
    ///
    ///
    /// - throws: PCError indicating the failure.
    /// - Returns: PCUser
    func getCurrentUser() async throws -> PCUser {
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        return try await PCUser.getCurrentUser(token: token)
    }
    
    
    ///Get user.
    ///
    ///Return the user resource for the currently authenticated user.
    ///
    /// - calls: GET /user
    ///
    ///
    /// - Parameter completion: A closure containing a result of PCUser or an PCError indicating the failure.
    /// - Returns: PCUser
    func getCurrentUser(completion: @escaping (Result<PCUser, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCUser.getCurrentUser(token: token, completion: completion)
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
    /// - Returns: Current value subject containing the optional PCUser.RequestResponse or an PCError indicating the failure.
    func updateCurrentUser(username: String, password: String?, accountInfo: PCUser.Info, currentPassword: String) async throws -> PCUser.RequestResponse {
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCUser.updateUser(username: username, password: password, accountInfo: accountInfo, currentPassword: currentPassword, token: token)
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
    /// - Returns: Current value subject containing the optional PCUser.RequestResponse or an PCError indicating the failure.
    func updateCurrentUser(username: String, password: String?, accountInfo: PCUser.Info, currentPassword: String, completion: @escaping (Result<PCUser.RequestResponse,PCError>) -> Void) {
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCUser.updateUser(username: username, password: password, accountInfo: accountInfo, currentPassword: currentPassword, token: token, completion: completion)
    }


    //MARK: Delete User
    
    ///Delete user.
    ///
    ///Delete the logged-in user. Allows removing user account and artifacts from Particle system.
    ///
    /// - calls: PUT /user
    ///
    /// - throws: PCError indicating the failure.
    /// - Parameter password: The new password to assign to the user to be updated.
    /// - Returns: PCUser.DeleteUserResponse.
    func deleteUser(password: String) async throws -> PCUser.RequestResponse {
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        return try await PCUser.deleteUser(password: password, token: token)
    }
    
    
    ///Delete user.
    ///
    ///Delete the logged-in user. Allows removing user account and artifacts from Particle system.
    ///
    /// - calls: PUT /user
    ///
    /// - Parameter password: The new password to assign to the user to be updated.
    /// - Parameter completion: Closure containing the PCUser.DeleteUserResponse or an PCError indicating the failure.
    func deleteUser(password: String, completion: @escaping (Result<PCUser.RequestResponse, PCError>) -> Void) {
        guard let token = self.authenticationManager.token
        else {
            completion( .failure(PCError.unauthenticated)); return
        }
        
        PCUser.deleteUser(password: password, token: token, completion: completion)
    }

    
    //MARK: Forgot Password

    ///Forgot password.
    ///
    /// Create a new password reset token and send the user an email with the token. Client doesn't need to be authenticated.
    ///
    /// - calls: POST /user/password-reset
    ///
    
    /// - note: This function will generate an email to the email address passed to username. This call is rate limited to prevent abuse.
    /// - throws: PCError indicating the failure.
    /// - Parameter username: The email address for the users account.
    /// - Returns: PCUser.PassWordResetRequestResponse
    func forgotPassword(username: String) async throws -> PCUser.RequestResponse {
                
        try await PCUser.forgotPassword(username: username)
    }
    
    
    ///Forgot password.
    ///
    /// Create a new password reset token and send the user an email with the token. Client doesn't need to be authenticated.
    ///
    /// - calls: POST /user/password-reset
    ///
    
    /// - note: This function will generate an email to the email address passed to username. This call is rate limited to prevent abuse.
    /// - Parameter username: The email address for the users account.
    /// - Parameter completion: Closure containing a result of  PCUser.PassWordResetRequestResponse or an PCError indicating the failure.
    func forgotPassword(username: String, completion: @escaping (Result<PCUser.RequestResponse,PCError>) -> Void) {
            
        PCUser.forgotPassword(username: username, completion: completion)
    }

    
    //MARK: - Quarantine
   ///Approve or deny a quarantined device.
    ///
    ///Approval will immediately release the device from quarantine and allow it to publish events, receive firmware updates, etc.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/devices
    ///
    ///
    /// - Requires: Scope of devices:import for approval and devices:remove for denial.
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The id of the quarantined device.
    /// - Parameter productIDorSlug: The id of the product associated with the device.
    /// - Parameter action: The action to take on the quarantined device.
    /// - Returns: PCQuarantine.QuarantineActionResponse
    func handleQuarantine(for device: DeviceID, in product: ProductID, action: PCQuarantine.QuarantineAction) async throws -> PCQuarantine.QuarantineActionResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCDevice.handleQuarantine(for: device, in: product, action: action, token: token)
    }
    
    
    ///Approve or deny a quarantined device.
    ///
    ///Approval will immediately release the device from quarantine and allow it to publish events, receive firmware updates, etc.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/devices
    ///
    ///
    /// - Requires: Scope of devices:import for approval and devices:remove for denial.
    /// - Parameter deviceID: The id of the quarantined device.
    /// - Parameter productIDorSlug: The id of the product associated with the device.
    /// - Parameter action: The action to take on the quarantined device.
    /// - Parameter completion: Closure containing the QuarantineActionResponse or an PCError indicating the failure.
    func handleQuarantine(for device: DeviceID, in product: ProductID, action: PCQuarantine.QuarantineAction, completion: @escaping (Result<PCQuarantine.QuarantineActionResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCDevice.handleQuarantine(for: device, in: product, action: action, token: token, completion: completion)
    }

    
    //MARK: - Sim Cards
    //MARK: List SIM cards
    
    
    ///List SIM cards.
    ///
    ///Get a list of the SIM cards owned by an individual or a product. The product endpoint is paginated, by default returns 25 SIM card records per page.
    ///
    /// - calls: GET /v1/sims
    ///
    ///
    ///
    /// - Requires: Scope of sims:list
    /// - Throws: PCError
    /// - Parameter arguments: An PCSimCard.ListRequestArgument struct containing the desired properties of the request.
    /// - Returns: PCSimCard.ListRequestArgument
    func listSimCards(arguments: PCSimCard.ListRequestArgument) async throws -> PCSimCard.ListResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCSimCard.listSimCards(arguments: arguments, token: token)
    }
    
    
    
    ///List SIM cards.
    ///
    ///Get a list of the SIM cards owned by an individual or a product. The product endpoint is paginated, by default returns 25 SIM card records per page.
    ///
    /// - calls: GET /v1/sims
    ///
    ///
    ///
    /// - Requires: Scope of sims:list
    /// - Parameter arguments: An PCSimCard.ListRequestArgument struct containing the desired properties of the request.
    /// - Parameter completion: Closure containing `Result<ListResponse?, PCError>`
    func listSimCards(arguments: PCSimCard.ListRequestArgument, completion: @escaping (Result<PCSimCard.ListResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        return PCSimCard.listSimCards(arguments: arguments, token: token, completion: completion)
    }

    
    //MARK: Get Sim Info
    
    
    ///Get SIM information.
    ///
    ///Retrieve a SIM card owned by an individual or a product.
    ///
    /// - calls: GET /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:get
    /// - Throws: PCError
    /// - Parameter iccid: Filter results to SIMs with this ICCID (partial matching) Product endpoint only
    /// - Parameter productIDorSlug: The id of the product the sim belongs to.
    /// - Returns: `PCSimCard.GetSimInfoResponse`
    func getSimInformation(iccid: ICCIDNumber, productIDorSlug: ProductID) async throws -> PCSimCard.GetSimInfoResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await  PCSimCard.getSimInformation(iccid: iccid, productIDorSlug: productIDorSlug, token: token)
    }

    
    
    ///Get SIM information.
    ///
    ///Retrieve a SIM card owned by an individual or a product.
    ///
    /// - calls: GET /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:get
    /// - Parameter iccid: Filter results to SIMs with this ICCID (partial matching) Product endpoint only
    /// - Parameter productIDorSlug: The id of the product the sim belongs to.
    /// - Returns: Closure containing `Result<PCSimCard.GetSimInfoResponse?, PCError>`
    func getSimInformation(iccid: ICCIDNumber, productIDorSlug: ProductID, completion: @escaping (Result<PCSimCard.GetSimInfoResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCSimCard.getSimInformation(iccid: iccid, productIDorSlug: productIDorSlug, token: token, completion: completion)
    }


    //MARK: Get Sim Data Usage
    
    
    ///Get data usage.
    ///
    ///Get SIM card data usage for the current billing period, broken out by day. Note that date usage reports can be delayed by up to 1 hour.
    ///
    /// - calls: GET /v1/sims/:iccid/data_usage
    ///
    ///
    /// - Throws: PCError
    /// - Parameter iccid: Filter results to SIMs with this ICCID (partial matching) Product endpoint only
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Returns: `PCSimCard.IccidDataUsageResponse`
    func getSimDataUsage(iccid: ICCIDNumber, productIDorSlug: ProductID, token: PCAccessToken) async throws -> PCSimCard.IccidDataUsageResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCSimCard.getDataUsage(iccid: iccid, productIDorSlug: productIDorSlug, token: token)
    }

    
    
    ///Get data usage.
    ///
    ///Get SIM card data usage for the current billing period, broken out by day. Note that date usage reports can be delayed by up to 1 hour.
    ///
    /// - calls: GET /v1/sims/:iccid/data_usage
    ///
    ///
    ///
    /// - Parameter iccid: Filter results to SIMs with this ICCID (partial matching) Product endpoint only
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter completion: Closure containing `Result<PCSimCard.IccidDataUsageResponse?, PCError>`
    func getSimDataUsage(iccid: ICCIDNumber, productIDorSlug: ProductID, completion: @escaping (Result<PCSimCard.IccidDataUsageResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCSimCard.getDataUsage(iccid: iccid, productIDorSlug: productIDorSlug, token: token, completion: completion)
    }


    //MARK: Fleet Data Usage
    
    
    ///Get data usage for product fleet.
    ///
    ///Get fleet-wide SIM card data usage for a product in the current billing period, broken out by day. Daily usage totals represent an aggregate of all SIM cards that make up the product. Data usage reports can be delayed until the next day, and occasionally by several days.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/sims/data_usage
    ///
    ///
    ///
    /// - Requires: Scope of sims.usage:get
    /// - Throws: PCError
    /// - Parameter productIDorSlug: String representing the product id or slug of the fleet.
    /// - Returns: `PCSimCard.FleetDataUsageResponse`
    func getFleetDataUsage(productIDorSlug: ProductID) async throws -> PCSimCard.FleetDataUsageResponse {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        return try await PCSimCard.getFleetDataUsage(productIDorSlug: productIDorSlug, token: token)
    }

    
    
    ///Get data usage for product fleet.
    ///
    ///Get fleet-wide SIM card data usage for a product in the current billing period, broken out by day. Daily usage totals represent an aggregate of all SIM cards that make up the product. Data usage reports can be delayed until the next day, and occasionally by several days.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/sims/data_usage
    ///
    ///
    ///
    /// - Requires: Scope of sims.usage:get
    /// - Parameter productIDorSlug: String representing the product id or slug of the fleet.
    /// - Parameter completion: Closure containing `Result<PCSimCard.FleetDataUsageResponse, PCError>`
    func getFleetDataUsage(productIDorSlug: ProductID, completion: @escaping (Result<PCSimCard.FleetDataUsageResponse, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        PCSimCard.getFleetDataUsage(productIDorSlug: productIDorSlug, token: token, completion: completion)
    }


    //MARK: Activate Sim
    
       
    ///Activate SIM.
    ///
    ///Activates a SIM card for the first time.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/sims
    ///
    ///
    ///
    /// - Requires: Scope of sims:import
    /// - note: Can not be used to activate Product SIM cards. Use the importAndActivateProductSim instead.
    /// - Parameter iccid: The ICCID of the SIM to update
    /// - Parameter completion: Closure containing `Result<Bool, PCError>` indicating the success.
    func activateSim(iccid: ICCIDNumber, completion: @escaping (Result<Bool, PCError>) -> Void) {
        guard let token = self.authenticationManager.token
        else {
            completion( .failure(PCError.unauthenticated)); return
        }
        
        PCSimCard.activateSim(iccid: iccid, token: token) { result in
            do {
                completion(.success(try result.get().ok))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }

    
    //MARK: Import and Activate Sims
    
    
    ///Import and activate product SIMs.
    ///
    ///Import a group of SIM cards into a product. SIM cards will be activated upon import. Activated SIM cards will receive a prorated charge for the 1MB data plan for the remainder of the month on your next invoice. Either pass an array of ICCIDs or include a file containing a list of SIM cards.Import and activation will be queued for processing. You will receive an email with the import results when all SIM cards have been processed.Importing a SIM card associated with a device will also import the device into the product.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/sims
    ///
    ///
    ///
    /// - Requires: Scope of sims:import
    /// - Throws: PCError
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter filePath: A path to a .txt file containing a single-column list of ICCIDs.
    /// - Parameter sims: An array of SIM ICCIDs to import.
    /// - Returns:Bool indicating success.
    func importAndActivateProductSim(productIdOrSlug: ProductID, iccids: [ICCIDNumber]?, filePath: String?) async throws -> Bool {
                
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
       return try await PCSimCard.importAndActivateProductSim(productIdOrSlug: productIdOrSlug, iccids: iccids, filePath: filePath, token: token)
    }

    
    
    ///Import and activate product SIMs.
    ///
    ///Import a group of SIM cards into a product. SIM cards will be activated upon import. Activated SIM cards will receive a prorated charge for the 1MB data plan for the remainder of the month on your next invoice. Either pass an array of ICCIDs or include a file containing a list of SIM cards.Import and activation will be queued for processing. You will receive an email with the import results when all SIM cards have been processed.Importing a SIM card associated with a device will also import the device into the product.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/sims
    ///
    ///
    ///
    /// - Requires: Scope of sims:import
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter filePath: A path to a .txt file containing a single-column list of ICCIDs.
    /// - Parameter sims: An array of SIM ICCIDs to import.
    /// - Parameter completion: Closure containing `Result<Bool, PCError>`
    func importAndActivateProductSim(productIdOrSlug: ProductID, iccids: [ICCIDNumber]?, filePath: String?, completion: @escaping (Result<Bool, PCError>) -> Void) {
                
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCSimCard.importAndActivateProductSim(productIdOrSlug: productIdOrSlug, iccids: iccids, filePath: filePath, token: token) { response in
            switch response {
            case .success(let result):
                completion(.success(result.ok))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    //MARK: Deactivate Sim
    
    
    ///Deactivate SIM.
    ///
    ///Deactivates a SIM card, disabling its ability to connect to a cell tower. Devices with deactivated SIM cards are not billable.
    ///
    /// - calls: PUT /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:update
    /// - Throws: PCError
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Returns: Bool indicating success.
    func deActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber) async throws -> Bool {
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCSimCard.deActivateSIM(productIdOrSlug: productIdOrSlug, iccid: iccid, token: token)
    }

    
    
    ///Deactivate SIM.
    ///
    ///Deactivates a SIM card, disabling its ability to connect to a cell tower. Devices with deactivated SIM cards are not billable.
    ///
    /// - calls: PUT /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:update
    /// - Throws: PCError
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter completion: Closure containing ` Result<Bool?, PCError>`.
    func deActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCSimCard.deActivateSIM(productIdOrSlug: productIdOrSlug, iccid: iccid, token: token, completion: completion)
    }

    
    //MARK: Reactivate Sim
        
    
    ///Reactivate SIM.
    ///
    ///Re-enables a SIM card to connect to a cell tower. Do this if you'd like to reactivate a SIM that you have deactivated.
    ///
    /// - calls: PUT /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:update
    /// - Throws: PCError
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Returns: Bool
    func reActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber) async throws -> Bool {
        
        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCSimCard.reActivateSIM(productIdOrSlug: productIdOrSlug, iccid: iccid, token: token)
    }

    
    
    ///Reactivate SIM.
    ///
    ///Re-enables a SIM card to connect to a cell tower. Do this if you'd like to reactivate a SIM that you have deactivated.
    ///
    /// - calls: PUT /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:update
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter completion:Closure containing `Result<Bool, PCError>`
    func reActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCSimCard.reActivateSIM(productIdOrSlug: productIdOrSlug, iccid: iccid, token: token, completion: completion)
    }

    
    //MARK: Release Sim
    ///Release SIM from account.
    ///
    ///Remove a SIM card from an account, disassociating the SIM card from a user or a product. The SIM will also be deactivated.
    ///
    ///Once the SIM card has been released, it can be claimed by a different user, or imported into a different product.
    ///
    /// - calls: DELETE /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:remove
    /// - Throws: PCError
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Returns: Bool indicating success.
    func releaseSimFromAccount(productIdOrSlug: ProductID?, iccid: ICCIDNumber) async throws -> Bool {
        

        guard let token = self.authenticationManager.token
        else {
            throw PCError.unauthenticated
        }
        
        return try await PCSimCard.releaseSimFromAccount(productIdOrSlug: productIdOrSlug, iccid: iccid, token: token)
    }

    
    
    ///Release SIM from account.
    ///
    ///Remove a SIM card from an account, disassociating the SIM card from a user or a product. The SIM will also be deactivated.
    ///
    ///Once the SIM card has been released, it can be claimed by a different user, or imported into a different product.
    ///
    /// - calls: DELETE /v1/sims/:iccid
    ///
    ///
    ///
    /// - Requires: Scope of sims:remove
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter completion: Closure containing `Result<Bool?, PCError>`
    func releaseSimFromAccount(productIdOrSlug: ProductID?, iccid: ICCIDNumber, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCSimCard.releaseSimFromAccount(productIdOrSlug: productIdOrSlug, iccid: iccid, token: token, completion: completion) 
    }


//MARK: - Events
    
    ///Subscribe to Events
    ///
    ///Subscribes to server sent events. [See publishing events from a device](https://docs.particle.io/reference/device-os/firmware/#particle-publish-) [and also](https://docs.particle.io/reference/cloud-apis/api/#events) for information on particle events.
    /// - note: There is no guarantee on recieving an event. Even when a connection is open events may not make it through.
    /// - Requires: Scope of events:get
    /// - Parameter eventName: The name of the event to subscribe to.
    /// - Parameter onEvent: Closure that is called when an event by that name is recieved.
    /// - Parameter completion: Closure that is called when the connection is closed. This will contain an PCError indicating the subscription failure.
    func subscribe(to event: EventName, onEvent: @escaping (PCEvent) -> Void, completion: ((PCError?) -> Void)?) {
        guard let token = self.authenticationManager.token
        else {
            completion?(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource."))
            return
        }
        
        PCEvent.subscribeToEvents(eventName: event, token: token, onEvent: onEvent, completion: completion)
    }
    
    ///Publish an event
    ///
    ///Used to publish an event from the API.
    ///
    /// - Requires: Scope of events:send
    /// - Parameter productIdOrSlug: The id of the product to limit the publish to.
    /// - Parameter eventName: The name of the event published.
    /// - Parameter data: The content of the publish.
    /// - Parameter private: If you wish this event to be publicly visible.
    /// - Parameter ttl: How long the event should persist in seconds.
    /// - Parameter completion: Closure that is called when the operation completes.
    func publishEvent(productIdOrSlug: ProductID? = nil, eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, completion: @escaping (Result<Bool, PCError>) -> Void)  {
        
        guard let token = self.authenticationManager.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        PCEvent.publishEvent(eventName: eventName, data: data, isPrivate: isPrivate, ttl: ttl, token: token, completion: completion)
    }

    

//MARK: - Libraries
    
    ///List Libraries
    ///
    ///List firmware libraries. This includes private libraries visibile only to the user.
    ///
    ///
    ///
    /// - Throws: PCError
    /// - Parameter arguments: The arguments used to filter the libraries.
    /// - Returns: A `PCLibrary.ListResponse` The list response contains an array of libraries filtered by the arguments or an empty array if a suitable match could not be found.
    public func listLibraries(arguments: PCLibrary.LibraryListArguments) async throws -> [PCLibrary] {
        
        guard let token = authenticationManager.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        return try await PCLibrary.listLibraries(arguments: arguments, token: token).libraries
    }
    
    
    
    ///List Libraries
    ///
    ///List firmware libraries. This includes private libraries visibile only to the user.
    ///
    ///
    ///
    /// - Parameter arguments: The arguments used to filter the libraries.
    /// - Parameter completion: A completion closure supplying an Result with containing a list response or a PCError
    public func listLibraries(arguments: PCLibrary.LibraryListArguments, completion: @escaping (Result<[PCLibrary], PCError>) -> Void) {
        
        guard let token = authenticationManager.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCLibrary.listLibraries(arguments: arguments, token: token) { result in
            
            do {
                let libraries = try result.get().libraries
                completion(.success(libraries))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }
}
