    //
    //  PCAPIUser.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/13/23.
    //

import Foundation


    ///An API user account is a specific type of user account in the Particle platform that is designed to replace using 'human' accounts for programmatic tasks. It allows the creation of tightly scoped users that are unable to do things that machines shouldn't need to do - like log into the console, or administer accounts. This allows you to better enforce the security principle of least privilege.
    ///
    /// Overview API users
    /// - An API user can be scoped to an organization or a product.
    /// - An API user can only have one valid access token associated with it at any one time.
    /// - If an API user's privileges change - the associated access token will change as well, to prevent scope creep.
    ///
    /// Currently, API users are created, updated and deleted via the REST API, and are visible in the console, in either the product team or organization view. API users cannot log into the console, administer users, receive emails - or generally do other things that are reserved for humans.The [API User Tutorial](https://docs.particle.io/getting-started/cloud/cloud-api/#api-users) has interactive controls in the web page that allow you to easily create, list, and delete API users for products and organizations. These controls allow you to both easily perform these operations on your account, and also learn how the APIs work, without needing to use curl or Postman.
    ///
    /// - Creating an API user
    ///   * Use an access token with permission to create users in your organization or product (administrator account). Pass a request to the relevant endpoint with a friendly name, and the desired scope(s) for the user.
    ///
    /// - Create an API user scoped to a product.
    ///   * 'The API will return an access token based on that user, for example:
    ///
    /// - Multiple API user scopes
    ///   * Multiple scopes can be assigned to an API user as follows:
    ///
    /// - Available API user scopes
    ///   *  clients:create
    ///   * clients:list
    ///   * clients:remove
    ///   * clients:update
    ///   * configuration:get
    ///   * configuration:update
    ///   * customers:list
    ///   * customers:remove
    ///   * customers:update
    ///   * devices.diagnostics.metadata:get
    ///   * devices.diagnostics.summary:get
    ///   * devices.diagnostics:get
    ///   * devices.diagnostics:update
    ///   * devices.function:call
    ///   * devices.variable:get
    ///   * devices:get
    ///   * devices:import
    ///   * devices:list
    ///   * devices:ping
    ///   * devices:release
    ///   * devices:remove
    ///   * devices:update
    ///   * events:get
    ///   * events:send
    ///   * firmware.binary:get
    ///   * firmware:create
    ///   * firmware:get
    ///   * firmware:list
    ///   * firmware:release
    ///   * firmware:remove
    ///   * firmware:update
    ///   * groups.impact:get
    ///   * groups:create
    ///   * groups:get
    ///   * groups:list
    ///   * groups:remove
    ///   * groups:update
    ///   * integrations:create
    ///   * integrations:get
    ///   * integrations:list
    ///   * integrations:remove
    ///   * integrations:test
    ///   * integrations:update
    ///   * locations:get
    ///   * organization:get
    ///   * products:get
    ///   * products:list
    ///   * service_agreements.notifications:list
    ///   * service_agreements.usage_reports:create
    ///   * service_agreements.usage_reports:get
    ///   * service_agreements:list
    ///   * sims.status:get
    ///   * sims.usage:get
    ///   * sims:get
    ///   * sims:import
    ///   * sims:list
    ///   * sims:remove
    ///   * sims:update
    ///   * teams.users:invite
    ///   * teams.users:list
    ///   * teams.users:remove
    ///   * teams.users:update
    /// - note: These constants are provided in the UserScope struct and should be accessed from there to prevent accidental entries. 
    ///
    /// - Determining API user scopes
    ///   * The Particle API documentation includes the required scopes needed to call a particular API function. To determine which scope(s) to assign your API user, determine the minimum set of API functions they should be able to call.
    ///
    /// - Updating an API user
    ///   * To modify the permissions associated with an API user, you must update the scopes via the REST API. Remember, when scopes assigned to a user change, the access token is updated and a fresh token is returned, to avoid scope creep. Depending on the scenario, it may be optimal to create a fresh user with updated permissions first, update the access token in use by the script/code/function, and then delete the old user. To update the API user, you pass in the full username.
    ///
    /// - Listing API users
    ///   * Listing API users is done by getting the team member list of the product or for the organization.
    ///   * Both regular and API users are returned, however you can tell API users as they have the `is_programmatic` flag set to true in the user array element:
    ///
    /// - Errors - API users
    ///   * If an API user attempts to perform an action that it is not permitted to, a standard 400 unauthorized error is returned.
    ///   * In the event that an API user tries to hit an endpoint that no API user is authorized to access, then this error is returned.
    ///
    /// - API rate limits
    ///   * The following API rate limits apply. Exceeding the rate limit will result in a 429 HTTP error response.All API functions - API rate limits
    ///   * Maximum of 10,000 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///   * Can be increased for enterprise customers
    ///
    /// - All API Routes
    ///   * Create an access token - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///   * Can be increased for enterprise customers
    ///
    /// - API Route: POST /oauth/token
    ///   * List access tokens - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///
    /// - API Route: GET /v1/access_tokens
    ///   * Delete an access token - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///
    /// - API Route: DELETE /v1/access_tokens/:token
    ///   * Create a user account - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///
    /// - API Route: POST /v1/users
    ///   * Delete user account - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///
    /// - API Route: DELETE /v1/user
    ///   * Generate a password reset token - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///
    /// - API Route: POST /v1/user/password-reset
    ///   * Reset password - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///
    /// - API Route: PUT /v1/user/password-reset
    ///   * Get all events - API rate limits
    ///   * Maximum of 100 requests every 5 minutes
    ///   * Limited by source IP address (public IP address)
    ///   * Can be increased for enterprise customers
    ///
    /// - API Route: GET /v1/events
    ///    * Subscribe to server-sent events - API rate limits
    ///    * Maximum of 100 requests every 5 minutes
    ///    * Limited by source IP address (public IP address)
    ///    * Can be increased for enterprise customers
    ///
    /// - API Routes:
    ///     1. GET /v1/devices/events/
    ///     2. GET /v1/devices/:DeviceID/events/
    ///     3. GET /v1/orgs/:OrgID/events/
    ///     4. GET /v1/orgs/:OrgID/devices/:DeviceID/events/
    ///     5. GET /v1/orgs/products/:ProductID/events/
    ///     6. GET /v1/products/:ProductID/events/
    ///     7. GET /v1/products/:ProductID/devices/:DeviceID/events/
    ///       * Open server-sent event streams - API rate limits
    ///       * A maximum of 100 simultaneous connections
    ///       * Limited by source IP address (public IP address)
    ///
    /// - Get device data via serial number - API rate limits
    ///   * Maximum of of 50 requests every hour
    ///   * Limited per user account that generated the access token
    ///   * Can be increased for enterprise customers
    ///
    /// - API Route: GET /v1/serial_numbers/:SerialNumber
    ///   * Beware of monitoring variables for changeOne situation that can cause problems is continuously monitoring variables for change.
    /// If you're polling every few seconds it's not a problem for a single device and variable.
    ///  But if you are trying to monitor many devices, or have a classroom of students each polling their own device, you can easily exceed the API rate limit.
    ///  Having the device call Particle.publish when the value changes may be more efficient.
    ///  Make sure you handle error conditions properly. If you get a 401 (Unauthorized), your access token has probably expired so retransmitting the request won't help.
    ///  If you get a 429 (Too many requests) you've already hit the limit, so making another request immediately will not help.In response to most error conditions you may want to consider a delay before retrying the request.
    ///
    ///Versioning
    /// - The API endpoints all start with /v1 to represent the first official version of the Particle Device Cloud API.
    ///  - The existing API is stable, and we may add new endpoints with the /v1 prefix.If in the future we make backwards-incompatible changes to the API, the new endpoints will start with something different, probably /v2. If we decide to deprecate any /v1 endpoints, we'll give you lots of notice and a clear upgrade path.
public struct PCAPIUser: Decodable, Hashable, Identifiable {
   
    public var id: Int {
        self.hashValue
    }
    
        ///Human readable debug description.
    public var debugDescription: String {
        return "username:\(username)\nisProgrammatic:\(isProgrammatic)\ntokens: \(tokens.description)"
    }
    
        ///The "friendly name" of the API user.
    public let username: String
    
        ///Should Always return true for API users. If they are a human user the flag should return false.
    public let isProgrammatic: Bool
    
        ///An array of currently active tokens.
    public let tokens: [PCAccessToken]
    
    
    private enum CodingKeys: String, CodingKey {
        case username
        case isProgrammatic = "is_programmatic"
        case tokens
    }
        ///Provided to keep access limited to the decoder init.
    private init(username: String, isProgrammatic: Bool, tokens: [PCAccessToken]) {
        self.username = username; self.isProgrammatic = isProgrammatic; self.tokens = tokens
    }
}

extension PCAPIUser {
    
    /// Simple enum used to provide a product id or an organization id when submitting a cloud request.
    public enum UserScope {
        ///Represents the organization name.
        case organization(name: OrganizationName)
        ///Represents the product name.
        case product(name: ProductID)
        
        var keyValue: String {
            switch self {
            case .organization: return "orgs"
            case .product: return "products"
            }
        }
        
        internal var carriedValue: String {
            switch self {
            case .organization(let name): return name.rawValue
            case .product(let name): return String(name.rawValue)
            }
        }
    }
    
    // MARK: Team
    ///The team associated with the API user.
    public struct Team: Decodable, Hashable, Identifiable {
        
        public var id: Int {
            self.hashValue
        }
        
        ///Human readable debug description.
        internal var debugDescription: String {
            return "username:\(username)\nrole:\(String(describing: info?.debugDescription))\nisProgrammatic:\(String(describing: isProgrammatic))"
        }
        
        ///The human readable name of the team.
        public let username: String
        ///The role for the team.
        public let info: Info?
        ///Indicating whether or not the user is of API origin.
        public let isProgrammatic: Bool?
        
        ///Provided to keep access limited to the decoder init.
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        private enum CodingKeys: String, CodingKey {
            case username, info = "role", isProgrammatic //= "is_programmatic"
        }
        
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.username = try container.decode(String.self, forKey: .username)
            self.info = try container.decodeIfPresent(Info.self, forKey: .info)
            self.isProgrammatic = try container.decodeIfPresent(Bool.self, forKey: .isProgrammatic)
        }
        
        ///The Role of the API user.
        public struct Info: Decodable, Hashable, Identifiable {
            
            ///Human readable debug description.
            internal var debugDescription: String {
                return "id: \(id)\nname: \(name)\nowner: \(String(describing: owner))\n"
            }
            
            ///The id for the role.
            public let id: String
            
            ///The human readable name for the role.
            public let name: String
            
            public let owner: Bool?
            
            ///Provided to keep access limited to the decoder init.
            private init(id: String, name: String) {
                fatalError("Must use init with decoder.")
            }
        }
        
        
        public static func == (lhs: PCAPIUser.Team, rhs: PCAPIUser.Team) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }
}

extension PCAPIUser {
        ///Parameter used for creating or updating an API User.
    public struct UserParameters {
        
            ///Human readable debug description.
        public var debugDescription: String {
            return "friendlyName:\(friendlyName)\nscopes:\(permissions.debugDescription)\n"
        }
            ///The "friendlyName" to associate with the API User.
        public let friendlyName: String
            ///An array of scopes or permissions to associate with the API User.
        public let permissions: [UserPermissions]
        
            ///private init to shield against creating without decoder.
        public init(friendlyName: String, permissions: [UserPermissions]) {
            self.friendlyName = friendlyName;  self.permissions = permissions
        }
    }
    
        // MARK: PCUserTeamResponse
    public struct ListResponse: Decodable {
        
            ///Response status.
        public let ok: Bool
        
            ///An array of a team or teams or an empty array.
        public let team: [Team]
        
            ///Provided to keep access limited to the decoder init.
        private init(ok: Bool, team: [Team]) {
            self.ok = ok; self.team = team
        }
    }

        // MARK: ServerResponses
        ///The represented response from the server.
    public struct ServerResponse: Decodable {
        
            ///Human readable debug description.
        internal var debugDescription: String {
            return "ok:\(ok)\ncreated:\(user.debugDescription)\n"
        }
        
            ///Returns false if the request fails. If false error information should be provided in the error and errorDescription fields.
        public let ok: Bool
        
            ///The newly created or updated API User. Or nil if deleting user.
        public let user: PCAPIUser?

        ///Private enum used for decoding.
        private enum CodingKeys: String, CodingKey {
            case ok, user = "created", error, errorDescription = "error_description"
        }
        
            ///private init to shield against creating without decoder.
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.ok = try container.decode(Bool.self, forKey: .ok)
            self.user = try container.decodeIfPresent(PCAPIUser.self, forKey: .user)
            
            //Converts to a server error by throwing the error
            if self.user == nil {
                let error = try container.decodeIfPresent(String.self, forKey: .error)
                let errorDescription = try container.decodeIfPresent(String.self, forKey: .errorDescription)

                
                throw PCError(code: .undelyingError, description: errorDescription, underlyingError: PCError(code: .errorsOnServer, description: error))
            }
        }
    }
    
        // MARK: - PCAPIUserCreationResponse
    struct PCAPIUserCreationResponse: Decodable {
        let ok: Bool
        let team: [Team]
    }
        
        // MARK: - Role
    public struct Role: Decodable {
        let id, name: String
        let owner: Bool
    }

        ///The returned token for the APIUser.
    public struct Token: Decodable {
        
            ///Human readable debug description.
        internal var debugDescription: String {
            return "token:\(token)\n"
        }
        
            ///The token provided.
        public let token: String
        
            ///Provided to keep access limited to the decoder init.
        private init(token: String) { self.token = token }
    }
}


    //MARK: Async
extension PCAPIUser {
    
        /// Used to create an API User scoped to an organization or a product.
        ///
        ///Example Usage
        ///
        /// ````swift
        ///             let response = try await PCAPIUser.createAn_API_User(type: .product(name: "super_product"),
        ///                                                                        parameters: .init(friendlyName: "cool_user_name",
        ///                                                                                          scopes: [.devices_diagnostics_get]),
        ///                                                                        token: PCAccessToken)
        ///             if response.ok {
        ///                 let createdUser = response.created
        ///                 //put the user to work
        ///             }
        ///
        ///
        /// ````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: `PCAPIUser.ServerResponse>`
        /// - Throws: `PCError`
    static public func createAn_API_User(type: PCAPIUser.UserScope, parameters: UserParameters, token: PCAccessToken) async throws -> PCAPIUser.ServerResponse {
        try await PCNetwork.shared.cloudRequest(.createAPiUser(type: type, parameters: parameters, token: token), type: PCAPIUser.ServerResponse.self)
    }
    
        ///Used to update an existing API User.
        ///
        ///To modify the permissions associated with an API user, you must update the scopes via the REST API. Remember, when scopes assigned to a user change, the access token is updated and a fresh token is returned, to avoid scope creep. Depending on the scenario, it may be optimal to create a fresh user with updated permissions first, update the access token in use by the script/code/function, and then delete the old user. To update the API user, you pass in the full username, in this case super_product@api.particle.io.
        ///
        ///Example Usage
        ///
        /// ````swift
        ///             let response = try await PCAPIUser.updateAn_API_User(type: .product(name: "super_product"),
        ///                                                                        parameters: .init(friendlyName: "cool_user_name",
        ///                                                                                          scopes: [.devices_diagnostics_get]),
        ///                                                                        token: PCAccessToken)
        ///             if response.ok {
        ///                 let createdUser = response.created
        ///                 //put the user to work
        ///             }
        ///
        ///
        /// ````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: `PCAPIUser.ServerResponse`
        /// - Throws: `PCError`
    static public func updateAn_API_User(type: PCAPIUser.UserScope, parameters: UserParameters, token: PCAccessToken) async throws -> PCAPIUser.ServerResponse {
        try await PCNetwork.shared.cloudRequest(.updateAPiUser(type: type, parameters: parameters, token: token), type: PCAPIUser.ServerResponse.self)
    }

        ///Used to get a list of the api users.
        ///
        ///Listing API users is done by getting the team member list of the product or for the organization. Both regular and API users are returned, however you can tell API users as they have the is_programmatic flag set to true in the user array element:
        ///
        ///Example Usage
        ///
        /// ````swift
        ///             let response = try await PCAPIUser.list_API_Users(type: .product(name: "super_product"),
        ///                                                                     token: PCAccessToken)
        ///             if response.ok {
        ///                 let user = response.team.filter{ $0.username == "funky_fresh"}
        ///                 //put the user to work
        ///             }
        ///
        ///
        /// ````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: `PCAPIUser.ListResponse`
        /// - Throws: `PCError`
    static public func list_API_Users(type: PCAPIUser.UserScope, token: PCAccessToken) async throws -> PCAPIUser.ListResponse {
        try await PCNetwork.shared.cloudRequest(.listAPiUsers(type: type, token: token), type: PCAPIUser.ListResponse.self)
    }

        /// Delete an API User scoped to an organization or a product.
        ///
        /// Also deletes the accociated access token.
        ///
        ///Example Usage
        ///
        /// ````swift
        ///             let response = try await PCAPIUser.deleteAn_API_User(type: .product(name: "super_product"),
        ///                                                                     token: PCAccessToken)
        ///             if response.ok {
        ///                 //bye user
        ///             }
        ///
        ///
        /// ````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter username: The username or "friendly name" of the API user to delete.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: `PCAPIUser.ServerResponse`
        /// - Throws: `PCError`
    static public func deleteAn_API_User(type: PCAPIUser.UserScope, username: String, token: PCAccessToken) async throws -> PCAPIUser.ServerResponse {
        try await PCNetwork.shared.cloudRequest(.deleteAPiUser(type: type, username: username, token: token), type: PCAPIUser.ServerResponse.self)
    }
}

    //MARK: Completion Handlers
extension PCAPIUser {
    
        /// Used to create an API User scoped to an organization or a product.
        ///
        ///Example Usage
        ///
        ///````swift
        ///
        ///            PCAPIUser.createAn_API_User(type: .organization(name: "super_cool_organization_id"), parameters: .init(friendlyName: "super_nice", scopes: [.clients_create, .clients_list]), token: token) { result in
        ///                switch result {
        ///                    case .success(let response):
        ///                        let user = response.created
        ///                            //put the user to work
        ///                    case .failure(let error):
        ///                        print(error)
        ///                }
        ///            }
        ///
        ///````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCAPIUser.ServerResponse or a PCError.
    static public func createAn_API_User(type: PCAPIUser.UserScope, parameters: UserParameters, token: PCAccessToken, completion: @escaping (Result<PCAPIUser.ServerResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.createAPiUser(type: type, parameters: parameters, token: token), type: PCAPIUser.ServerResponse.self, completion: completion)
    }
    
    #warning("This needs review.")
    static func createUser(type: PCAPIUser.UserScope, parameters: PCAPIUser.UserParameters, username: String, password: String?, accountInfo: PCUser.Info, currentPassword: String, token: PCAccessToken, completion: @escaping (Result<PCAPIUser.ServerResponse, PCError>) -> Void ) {
        
        PCNetwork.shared.cloudRequest(.createAPiUser(type: type, parameters: parameters, token: token), type: PCAPIUser.ServerResponse.self, completion: completion)
    }

    
        /// Used to update an existing API User.
        ///
        /// To modify the permissions associated with an API user, you must update the scopes via the REST API. Remember, when scopes assigned to a user change, the access token is updated and a fresh token is returned, to avoid scope creep. Depending on the scenario, it may be optimal to create a fresh user with updated permissions first, update the access token in use by the script/code/function, and then delete the old user. To update the API user, you pass in the full username, in this case super_cool_organization_id@api.particle.io.
        ///
        ///Example Usage
        ///
        ///````swift
        ///
        ///            PCAPIUser.updateAn_API_User(type: .organization(name: "super_cool_organization_id@api.particle.io"), parameters: .init(friendlyName: "super_nice", scopes: [.clients_create, .clients_list]), token: token) { result in
        ///                switch result {
        ///                    case .success(let response):
        ///                        let user = response.created
        ///                            //put the user to work
        ///                    case .failure(let error):
        ///                        print(error)
        ///                }
        ///            }
        ///
        ///````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCAPIUser.ServerResponse or a PCError.
    static public func updateAn_API_User(type: PCAPIUser.UserScope, parameters: UserParameters, token: PCAccessToken, completion: @escaping (Result<PCAPIUser.ServerResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.updateAPiUser(type: type, parameters: parameters, token: token), type: PCAPIUser.ServerResponse.self, completion: completion)
    }

        ///Used to get a list of the api users.
        ///
        ///Listing API users is done by getting the team member list of the product or for the organization. Both regular and API users are returned, however you can tell API users as they have the is_programmatic flag set to true in the user array element:
        ///
        ///Example Usage
        ///
        ///````swift
        ///
        ///            PCAPIUser.list_API_Users(type: .organization(name: "super_cool_organization_id"), token: token) { result in
        ///                switch result {
        ///                    case .success(let response):
        ///                        let user = response.team.filter {$0.username = "amp_champ"}
        ///                            //put the user to work
        ///                    case .failure(let error):
        ///                        print(error)
        ///                }
        ///            }
        ///
        ///````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCAPIUser.ListResponse or a PCError.
    static public func list_API_Users(type: PCAPIUser.UserScope, token: PCAccessToken, completion: @escaping (Result<PCAPIUser.ListResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.listAPiUsers(type: type, token: token), type: PCAPIUser.ListResponse.self, completion: completion)
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
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Parameter completion: A completion handler for the request The completion will contain a result of either an PCAPIUser.ServerResponse or a PCError.
    static public func deleteAn_API_User(type: PCAPIUser.UserScope, username: String, token: PCAccessToken, completion: @escaping (Result<PCAPIUser.ServerResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.deleteAPiUser(type: type, username: username, token: token), type: PCAPIUser.ServerResponse.self, completion: completion)
    }
}
