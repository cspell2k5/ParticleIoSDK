    //
    //  CloudResources.swift
    //  ParticleIO
    //
    //  Created by Craig Spell on 11/22/19.
    //

import Foundation


enum ResourceType {
    case accessToken, client, apiUser, device, remoteDiagnostics, user, event, webhooks, quranatine, simCard, assetTrackingEvent, firmware, productFirmware, libraries, products, deviceGroups, assetTracking, customers, serviceAgreements
}



    //MARK: - Programmed Resources
internal enum CloudResource {
    
        //MARK: - ResourceType
    var type: ResourceType {
        
        switch self {
                
                    //MARK: Tokens
            case .generateAccessToken, .listAccessTokens, .deleteAnAccessToken, .deleteAllAccessTokens, .deleteCurrentAccessToken, .getCurrentAccessTokenInfo:
                return .accessToken
                
                    //MARK: Clients
            case .listClients, .createClient, .updateClient, .deleteClient:
                return .client
                
                    //MARK: API Users
            case .createAPiUser, .updateAPiUser, .listAPiUsers, .deleteAPiUser:
                return .apiUser
                
                    //MARK: Devices
            case .listDevices, .listProductDevices, .importDevices, .getDeviceInfo, .getProductDeviceInfo, .getVariableValue, .callFunction, .pingDevice, .renameDevice, .addDeviceNotes, .createClaimCode, .claimDevice, .removeDeviceFromProduct, .unclaimDevice, .signalDevice, .forceOverTheAirUpdates, .lookUpDeviceInformation:
                return .device
                
                    //MARK: Remote Diagnostics
            case .refreshDeviceVitals, .getLastKnownDeviceVitals, .getAllHistoricalDeviceVitals, .getDeviceVitalsMetadata, .getCellularNetworkStatus:
                return .remoteDiagnostics
                
                    //MARK: Users
            case .getUser, .updateUser, .deleteUser, .forgotPassword:
                return .user
                
                    //MARK: Events
            case .getEventStream, .getDeviceEventStream, .getProductEventStream, .publishEvent:
                return .event
                
                    //MARK: Quarantine
            case .approveQuarantinedDevice, .denyQuarantinedDevice:
                return .quranatine
                
                    //MARK: SimCard
            case .listSimCards, .getSimInformation, .getDataUsage, .getDataUsageForProductFleet, .activateSIM, .importAndActivateProductSIMs, .deactivateSIM, .reactivateSIM, .releaseSimFromAccount:
                return .simCard
                
                    //MARK: Integrations / WebHooks
            case .createWebhook, .enableAzureIoTHubintegration, .enableGoogleCloudPlatformIntegration, .enableGoogleMapsintegration, .editWebhook, .editAzureIoTHubIntegration, .editGoogleCloudPlatformIntegration, .editGoogleMapsIntegration, .getIntegration, .listIntegrations, .testAnIntegration, .deleteAnIntegration:
                return .webhooks
                
                    //MARK: Asset Tracking Events
            case .trackerLocationEvents, .enhancedLocationEvents, .locationPointSchema:
                return .assetTrackingEvent
                
                    //MARK: Firmware
            case .updateDeviceFirmware, .flashDeviceWithSourceCode, .flashDeviceWithPreCompiledBinary, .compileSourceCode, .listFirmwareBuildTargets, .lockProductDevice, .unlockProductDevice, .markProductDevelopmentDevice, .unmarkProductDevelopmentDevice:
                return .firmware
                
                    //MARK: Product Firmware
            case .getProductFirmware, .listAllProductFirmwares, .uploadProductFirmware, .editProductFirmware, .downloadFirmwareBinary, .releaseProductFirmware, .deleteUnreleasedFirmwareBinary:
                return .productFirmware
                
                    //MARK: Libraries
            case .listLibraries, .getLibraryDetails, .getLibraryVersions, .uploadLibraryVersion, .makeLibraryVersionPublic:
                return .libraries
                
                    //MARK: Products
            case .listProducts, .retrieveProduct, .listTeamMembers, .inviteTeamMember, .createAnAPIuser, .updateTeamMember, .removeTeamMember:
                return .products
                
                    //MARK: Device Groups
            case .getDeviceGroup, .listDeviceGroups, .createDeviceGroup, .editDeviceGroup, .deleteDeviceGroup, .assignGroupsToDevice, .batchAssignGroupsToDevices, .impactOfTakingAction:
                return .deviceGroups
                
                    //MARK: Asset Tracking
            case .queryLocationForDevicesWithinProduct, .queryLocationForOneDeviceWithinProduct, .getProductConfiguration, .deleteOrResetConfigurationSchema, .getDeviceConfiguration, .getSchema, .setConfiguration, .setConfigurationSchema:
                return .assetTracking
                
                    //MARK: Customers
            case .createCustomerWithToken, .createCustomerWithClient, .createCustomerImplicit, .listCustomersForProduct, .generateCustomerWithScopedAccessToken, .updateCustomerPassword, .deleteA_Customer, .resetPassword:
                return .customers
                
                    //MARK: Service Agreements and Usage
            case .getServiceAgreements, .getUserServiceAgreements, .getOrganizationServiceAgreements, .getUserUsageReport, .getOrgUsageReport, .createUserUsageReport, .createOrgUsageReport, .getUserNotificationsForCurrentUsagePeriod, .getOrganizationNotificationsForCurrentUsagePeriod:
                return .serviceAgreements
        }
    }

    
        //MARK: - Tokens - Done

        /// Delivers an PCAccessToken
        ///
        /// You must give a valid OAuth client ID and secret in HTTP Basic Auth or in the client_id and client_secret parameters. For controlling your own developer account, you can use particle:particle. Otherwise use a valid OAuth Client ID and Secret. This endpoint doesn't accept JSON requests, only form encoded requests. See OAuth Clients.Refresh tokens only work for product tokens, and even then they are not particularly useful. In order to generate a new access token from the refresh token you still need the client ID and secret. Because of this, it's simpler to just generate a new token, and then you don't need to remember and keep secure the refresh token. Also refresh tokens have a lifetime of 14 days, much shorter than the default access token lifetime of 90 days.
        ///
        /// - calls: POST /oauth/token
        ///
        /// Example:
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl https://api.particle.io/oauth/token \
        ///        -u particle:particle \
        ///        -d grant_type=password \
        ///        -d "username=joe@example.com" \
        ///        -d "password=SuperSecret"
        ///
        ///         //Particle example response
        ///     POST /oauth/token
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "access_token": "254406f79c1999af65a7df4388971354f85cfee9",
        ///        "token_type": "bearer",
        ///        "expires_in": 7776000,
        ///        "refresh_token": "b5b901e8760164e134199bc2c3dd1d228acf2d90"
        ///     }
        ///
        ///         //Particle example error
        ///     POST /oauth/token
        ///     HTTP/1.1 400 Bad Request
        ///     
        ///     {
        ///        "error": "invalid_grant",
        ///        "error_description": "User credentials are invalid"
        ///     }
        ///
        ///         //Particle example error with two-factor auth enabled.
        ///     POST /oauth/token
        ///     HTTP/1.1 403 Forbidden
        ///     
        ///     {
        ///        "error": "mfa_required",
        ///        "error_description": "Multifactor authentication required",
        ///        "mfa_token": "eyJ0eXAiOiJKV1QiLCJhbGci....D3QCiQ"
        ///     }
        ///
        ///````
        ///
        /// - note: `expiresAt` parameter if provided, must be in ISO8601 format
        /// - Parameter client: OAuth client including clientID and password. Required if no credentials are provided.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter grantType: OAuth grant type. Defaults to 'password'
        /// - Parameter expiresIn: Number of seconds the token remain valid. 0 means forever. Short lived tokens are prefered for better security.
        /// - Parameter expireAt: An ISO8601 formatted date string indicatiing when the token will expire.
        /// - Returns: An PCAccessToken json carrying the new token information.
    case generateAccessToken(client: PCClient?, credentials: PCCredentials, grantType: PCAccessToken.GrantType = .password, expiresIn: Int?, expireAt: String?)

#warning("otp parameter missing from call. Documentation is unclear of how to use it. Call Particle.")
        /// List access tokens issued to your account.
        ///
        /// Retrieve a list of all the issued access tokens for your account
        ///
        /// - calls: GET /v1/access_tokens
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl https://api.particle.io/v1/access_tokens \
        ///        -u "joe@example.com:SuperSecret"
        ///
        ///         //Particle example response
        ///     GET /v1/access_tokens
        ///     HTTP/1.1 200 OK
        ///
        ///     [
        ///         {
        ///            "token": "b5b901e8760164e134199bc2c3dd1d228acf2d98",
        ///            "expires_at": "2014-04-27T02:20:36.177Z",
        ///            "client": "particle"
        ///         },
        ///         {
        ///            "token": "ba54b6bb71a43b7612bdc7c972914604a078892b",
        ///            "expires_at": "2014-04-27T06:31:08.991Z",
        ///            "client": "particle"
        ///         }
        ///     ]
        ///
        ///````
        ///
        /// - Parameter credentials: Your Particle account username and password.
        /// - Parameter otp: Token given from your MFA device. Usually 6 digits long.
        /// - Returns: An array of PCAccessToken(json) representing all the issued oAuth tokens for your account.
    case listAccessTokens(credentials: PCCredentials, otp: String?)
    
        /// Delete an access token from your account.
        ///
        /// Delete your unused or lost tokens.
        ///
        /// - calls: DELETE /v1/access_tokens/:token
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl -X DELETE https://api.particle.io/v1/access_tokens/123abc \
        ///        -u "joe@example.com:SuperSecret"
        ///
        ///         //Particle example response
        ///      DELETE /v1/access_tokens/123abc
        ///      HTTP/1.1 200 OK
        ///
        ///      {
        ///         "ok": true
        ///      }
        ///
        ///````
        ///
        /// - Parameter token: `String` representing the cloud access token id to delete
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: an PCToken.DeleteResponse json
    case deleteAnAccessToken(tokenID: String, credentials: PCCredentials)
    
        /// Delete all access tokens.
        ///
        /// Delete all your active access tokens from your account.
        ///
        /// - calls: DELETE /v1/access_tokens
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl -X DELETE "https://api.particle.io/v1/access_tokens?access_token=123abc"
        ///
        ///         //Particle example response
        ///     DELETE /v1/access_tokens
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "ok": true
        ///     }
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Parameter credentials: Your Particle account username and password.
        /// - Returns: An PCToken.DeleteResponse json
    case deleteAllAccessTokens(token: PCAccessToken)
        
        /// Get the current access token information
        ///
        /// Get your currently used token.
        ///
        /// - calls: GET /v1/access_tokens/current
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl "https://api.particle.io/v1/access_tokens/current?access_token=123abc"
        ///
        ///         //Particle example response
        ///     GET /v1/access_tokens/current
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "expires_at": "2014-04-27T06:31:08.991Z",
        ///        "client": "particle",
        ///        "scopes": [],
        ///        "orgs": []
        ///     }
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An PCAccess.TokenInfo json
    case getCurrentAccessTokenInfo(token: PCAccessToken)

        /// Delete the current access token for your account.
        ///
        /// Delete your currently used token.
        ///
        /// - calls: DELETE /v1/access_tokens/current
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl -X DELETE "https://api.particle.io/v1/access_tokens/current?access_token=123abc"
        ///
        ///         //Particle example response
        ///     DELETE /v1/access_tokens/current
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "ok": true
        ///     }
        ///
        ///````
        ///
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An PCToken.DeleteResponse json
    case deleteCurrentAccessToken(token: PCAccessToken)
                
        ///List clients
        ///
        ///Get a list of all existing OAuth clients, either owned by the authenticated user or clients associated with a product.
        ///
        /// - calls: GET /v1/clients
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/clients?access_token=1234"
        ///        
        ///         //List Product Clients
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/clients?access_token=1234"
        ///
        ///
        ///         //Particle example response
        ///     GET /v1/clients
        ///     HTTP/1.1 200 OK
        ///     {
        ///        "ok":true,
        ///        "clients": [
        ///            {
        ///               "name":"server",
        ///               "type":"installed",
        ///               "id":"server-999"
        ///            },
        ///            {
        ///               "name":"Mobile App",
        ///               "type":"installed",
        ///               "id":"mobile-app-1234"
        ///            }
        ///        ]
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: scope of clients:list
        /// - Parameter productIdorSlug: The optional product id or slug for which to filter the list of clients.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An array of PCClient(json) representing OAuth clients on your account.
    case listClients(productIdorSlug: ProductID?, token: PCAccessToken)
    
        /// Create an oAuth client
        ///
        /// Create an OAuth client that represents an app. Use type=installed for most web and mobile apps. If you want to have Particle users login to their account on Particle in order to give your app access to their devices, then you can go through the full OAuth authorization code grant flow using type=web. This is the same way you authorize it is similar to the way you give any app access to your Facebook or Twitter account.Your client secret will never be displayed again! Save it in a safe place.If you use type=web then you will also need to pass a redirect_uri parameter in the POST body. This is the URL where users will be redirected after telling Particle they are willing to give your app access to their devices.The scopes provided only contain the object and action parts, skipping the domain which is being infered from the context.If you are building a web or mobile application for your Particle product, you should use the product-specific endpoint for creating a client (POST /v1/products/:productIdOrSlug/clients). This will grant this client (and access tokens generated by this client) access to product-specific behaviors like [calling functions](https://docs.particle.io/reference/cloud-apis/api/#call-a-function) and [checking variables](https://docs.particle.io/reference/cloud-apis/api/#get-a-variable-value) on product devices, [creating customers](https://docs.particle.io/reference/cloud-apis/api/#create-a-customer---client-credentials), and [generating customer scoped access tokens](https://docs.particle.io/reference/cloud-apis/api/#generate-a-customer-scoped-access-token).
        /// - calls: POST /v1/clients
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl https://api.particle.io/v1/clients \
        ///        -d name=MyApp \
        ///        -d type=installed \
        ///        -d access_token=1234
        ///
        ///         //create an oAuthclient for a product
        ///     curl https://api.particle.io/v1/products/:productIdOrSlug/clients \
        ///        -d name=MyApp \
        ///        -d type=installed \
        ///        -d access_token=1234
        ///
        ///         //Particle example response
        ///     POST /v1/clients
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "ok": true,
        ///        "client": {
        ///            "name": "MyApp",
        ///            "type": "installed",
        ///            "id": "myapp-2146",
        ///            "secret": "615c620d647b6e1dab13bef1695c120b0293c342"
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: scope of clients:create
        /// - Parameter appName: The app name to associate with the new oauth client.
        /// - Parameter productIdorSlug: The optional product id or slug that the new oAuth client is associated with.
        /// - Parameter redirect_uri: Only required for web type. URL that you wish us to redirect to after the OAuth flow.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An array of PCClients (json) representing OAuth clients on your account.
    case createClient(appName: String, productIdorSlug: ProductID?, redirect_uri: String? = nil, type: PCClient.ClientType, token: PCAccessToken)
    
        ///Update a client
        ///
        ///Update the name or scope of an existing OAuth client.
        ///
        /// - calls: PUT /v1/clients/:clientId
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT https://api.particle.io/v1/clients/client-123 \
        ///        -d name="My App 2" \
        ///        -d access_token=1234
        ///
        ///         //Update product Client
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/clients/client-123 \
        ///        -d name="My App 2" \
        ///        -d access_token=1234
        ///
        ///         //Particle example response
        ///     PUT /v1/clients/client-123
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "ok": true,
        ///        "client": {
        ///            "name": "My App 2",
        ///            "type": "installed",
        ///            "id": "myapp-2146",
        ///            "secret": "615c620d647b6e1dab13bef1695c120b0293c342"
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: scope of devices_clients_update
        /// - Parameter client: The oauth client to update.
        /// - Parameter newScope: Update the scope of the OAuth client. Can allow customer creation only or give full permissions.
        /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is or will be associated with.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An updated PCClient.ServerResponse json.
    case updateClient(client: PCClient, newName: String?, newScope: PCClient.Scope?, productIdorSlug: ProductID?, token: PCAccessToken)
    
    
        ///Delete a client
        ///
        ///Delete the client from the server.
        ///
        /// - calls: DELETE /v1/clients/:clientId
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X DELETE https://api.particle.io/v1/clients/client-123 \
        ///        -d access_token=1234
        ///
        ///         //Delete a product client
        ///     curl -X DELETE https://api.particle.io/v1/products/:productIdOrSlug/clients/client-123 \
        ///        -d access_token=1234
        ///
        ///
        ///         //Particle example response
        ///     DELETE /v1/clients/:clientId
        ///     HTTP/1.1 204 No Content
        ///
        ///
        ///````
        ///
        /// - Requires: scope of clients:remove
        /// - Parameter client: The oauth client to delete.
        /// - Parameter productIdorSlug: The optional product id or slug that the oAuth client is associated with.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: URLRequestResponse only.
    case deleteClient(client: PCClient, productIdorSlug: ProductID?, token: PCAccessToken)
    
    
        //MARK: - API Users - Done
    
        ///Creating an API user
        ///
        /// - Use an access token with permission to create users in your organization or product (administrator account). Pass a request to the relevant endpoint with a friendly name, and the desired scope(s) for the user.
        ///
        ///Create an API user scoped to an organization
        ///
        /// - The resulting access token can then be used by programmatic processes. As always, access tokens are sensitive and should be treated as secrets.
        ///
        /// - calls:  POST /v1/orgs/:orgIDorSlug/team or POST /v1/products/:productIDorSlug/team
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/orgs/:orgIDorSlug/team?access_token=xxxx" \\
        ///        -H "Content-Type: application/json" \
        ///        -d '{ \
        ///            "friendly_name": "org api user", \
        ///            "scopes": [ "devices:list","sims:list"  ] \
        ///        }'
        ///
        ///        //Create an API user scoped to a product
        ///     curl "https://api.particle.io/v1/products/:productIDorSlug/team?access_token=xxxx" \\
        ///        -H "Content-Type: application/json" \
        ///        -d '{ \
        ///            "friendly_name": "product api user", \
        ///            "scopes": [ "devices:list","sims:list" ] \
        ///        }'
        ///
        ///
        ///
        ///````
        ///
        /// - Important: The resulting access token can then be used by programmatic processes. As always, access tokens are sensitive and should be treated as secrets.
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An PCAPIUser.ServerResponse json.
    case createAPiUser(type: PCAPIUser.UserType, parameters: PCAPIUser.UserParameters, token: PCAccessToken)
    
        ///Updating an API user
        ///
        ///To modify the permissions associated with an API user, you must update the scopes via the REST API. Remember, when scopes assigned to a user change, the access token is updated and a fresh token is returned, to avoid scope creep. Depending on the scenario, it may be optimal to create a fresh user with updated permissions first, update the access token in use by the script/code/function, and then delete the old user. To update the API user, you pass in the full username, in this case example-api-user+6fbl2q577b@api.particle.io.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/team/:user or /v1orgs/:organizationID/team/:friendlyName
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT "https://api.particle.io/v1/products/12857/team/example-api-user+6fbl2q577b@api.particle.io?access_token=xxxxxx" \\
        ///        -H "Content-Type: application/json" \\
        ///        -d '{  \\
        ///            "friendly_name": "Updated API user",  \\
        ///            "scopes": [ "devices:list", "sims:list", "customers:list" ]  \\
        ///        }'
        ///
        ///````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: An PCAPIUser.ServerResponse json.
    case updateAPiUser(type: PCAPIUser.UserType, parameters: PCAPIUser.UserParameters, token: PCAccessToken)
    
        ///Listing API users
        ///
        ///Listing API users is done by getting the team member list of the product or for the organization. Both regular and API users are returned, however you can tell API users as they have the is_programmatic flag set to true in the user array element:
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/team/
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X GET "https://api.particle.io/v1/products/12857/team/?access_token=xxxxxx" \\
        ///        -H "Content-Type: application/json"
        ///
        ///         //Particle example response
        ///     {
        ///        "ok": true,
        ///        "team": [
        ///            {
        ///               "username": "user@example.com",
        ///               "role": {
        ///                   "id": "000000000000000000000002",
        ///                   "name": "Administrator"
        ///               }
        ///            },
        ///            {
        ///               "username": "example-api-user+6fbl2q577b@api.particle.io",
        ///               "is_programmatic": true
        ///            }
        ///        ]
        ///     }
        ///
        ///
        ///````
        ///
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter parameters: an PCAPIUser.UserParameters to be used for the request parameter.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: Likely an array of PCAPIUser.ListResponse json.
    case listAPiUsers(type: PCAPIUser.UserType, token: PCAccessToken)

        ///Deleting an API user
        ///
        ///Delete an API user and it's access tokens.
        ///
        /// - calls: DELETE /v1/products/:productIdOrSlug/team/:username
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X DELETE "https://api.particle.io/v1/products/12857/team/example-api-user+6fbl2q577b@api.particle.io?access_token=xxxxx"
        ///
        ///         //Particle example response
        ///     {
        ///        "error":"unauthorized",
        ///        "error_description":"API users are not allowed to call this endpoint"
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter type: PCAPIUser.UserType supplied with the correct name of the org or product.
        /// - Parameter username: The "friendly name" of the API user to delete.
        /// - Parameter token: An PCAccessToken carrying the access token and associated information.
        /// - Returns: Likely an array of PCAPIUser.ListResponse json.
    case deleteAPiUser(type: PCAPIUser.UserType, username: String, token: PCAccessToken)
        
        //MARK: - Devices - Done
    
        ///List devices
        ///
        ///List devices the currently authenticated user has access to. By default, devices will be sorted by last_handshake_at in descending order.
        ///
        /// - calls: GET /v1/devices
        ///
        ///
        ///````BASH
        ///
        ///
        ///         //Particle example response
        ///     GET /v1/devices
        ///     HTTP/1.1 200 OK
        ///     [
        ///         {
        ///            "id": "53ff6f0650723",
        ///            "name": "plumber_laser",
        ///            "last_ip_address": "10.0.0.1",
        ///            "last_heard": "2020-05-28T14:46:07.586Z",
        ///            "last_handshake_at": "2020-05-27T18:13:01.059Z",
        ///            "product_id": 6,
        ///            "online": true,
        ///            "platform_id": 6,
        ///            "cellular": false,
        ///            "notes": "laser!",
        ///            "functions": [
        ///                "fire"
        ///            ],
        ///            "variables": {
        ///                "power": "int32"
        ///            },
        ///            "status": "normal",
        ///            "serial_number": "PH1234",
        ///            "mac_wifi": "00:00:00:AA:BB:00",
        ///            "system_firmware_version": "1.5.0"
        ///         },
        ///         {
        ///            "id": "53ff291839887",
        ///            "name": "particle_love",
        ///            "last_ip_address": "10.0.0.1",
        ///            "last_heard": "2020-05-28T14:46:07.586Z",
        ///            "last_handshake_at": "2020-05-27T18:13:01.059Z",
        ///            "product_id": 10,
        ///            "online": false,
        ///            "platform_id": 10,
        ///            "notes": null,
        ///            "functions": [],
        ///            "variables": {},
        ///            "cellular": true,
        ///            "status": "normal",
        ///            "serial_number": "E261234",
        ///            "iccid": "1111111111111111111",
        ///            "imei": "333333333333333",
        ///            "system_firmware_version": "1.5.0"
        ///         }
        ///     ]
        ///
        ///
        ///````
        ///
        /// - Note: Devices are encapsulated in PCDevice type.

        /// Return type is an array of PCDevice
        ///  - Parameter arguments: All arguments are optional and are provided using a PCDevice.ListArguments struct.
        ///  - Parameter token: The current Particle Cloud Access Token.
        ///  - Returns: Array of PCdevice  json. See [Get device information](https://docs.particle.io/reference/cloud-apis/api/#get-device-information) for the response attributes of each device.
    case listDevices(arguments: PCDevice.ListArguments?, token: PCAccessToken)
    
        ///List devices in a product
        ///
        ///List all devices that are part of a product. Results are paginated, by default returns 25 device records per page.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/devices
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/devices?access_token=1234"
        ///
        ///         //List product group devices
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/devices?groups=beta&access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/products/:productIdOrSlug/devices
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        devices": [
        ///           {
        ///              "id":"1d002a000547343232363230",
        ///              "name":"jeff_test_device",
        ///              "last_ip_address":"199.230.10.194",
        ///              "last_heard":"2016-06-10T15:00:07.100Z",
        ///              "last_handshake_at":"2016-06-10T14:56:27.100Z",
        ///              "product_id":295,
        ///              "online":false,
        ///              "platform_id": 13,
        ///              "cellular": true,
        ///              "functions": [
        ///                  "cmd"
        ///                ], "variables": {
        ///                    "temperature": "double"
        ///                },
        ///              "status": "normal",
        ///              "serial_number": "E40KAB111111111",
        ///              "iccid": "89014111111111111111",
        ///              "imei": "352753090000000",
        ///              "mac_wifi": "00:00:00:AA:BB:00",
        ///              "mobile_secret": "WBPYG6CPLRCFK4S",
        ///              "system_firmware_version": "3.0.0",
        ///              "firmware_product_id": 295,
        ///              "groups":["asia","europe"],
        ///              "firmware_version":3,
        ///              "desired_firmware_version": null,
        ///              "targeted_firmware_release_version": 3,
        ///              "development":false,
        ///              "quarantined":false,
        ///              "denied":false,
        ///              "owner":"jeff@particle.io"
        ///           },
        ///           {
        ///              "id":"32001e000747343337373738",
        ///              "last_ip_address":"199.21.86.18",
        ///              "last_heard":"2016-06-10T15:00:07.100Z",
        ///              "last_handshake_at":"2016-06-10T14:56:27.100Z",
        ///              "product_id":13,
        ///              "online":false,
        ///              "platform_id": 13,
        ///              "cellular": true,
        ///              "status": "normal",
        ///              "serial_number": "E40KAB111111112",
        ///              "iccid": "89014111111111111112",
        ///              "imei": "352753090000001",
        ///              "mac_wifi": "00:00:00:AA:BB:01",
        ///              "mobile_secret": "VNH9JNXMXW5YY9X",
        ///              "system_firmware_version": "2.0.0",
        ///              "firmware_product_id": 295,
        ///              "development": false,
        ///              "quarantined": true,
        ///              "denied": false
        ///           },
        ///           ...
        ///        ],
        ///     "customers": [
        ///         {
        ///            id:"123abc3456",
        ///            username: "customer@gmail.com",
        ///         }
        ///     ],
        ///        "meta": {
        ///            "total_pages":1
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:list

        /// - Parameter productIdorSlug: The  product id or slug that the device is associated with.
        /// - Parameter arguments: All arguments are optional and are provided using a PCDevice.ListArguments struct.
        /// - Parameter token: The current Particle Cloud Access Token.
        /// - Returns: PCDevice.ListResponse json
    case listProductDevices(productIdOrSlug: ProductID, arguments: PCDevice.ListArguments?, token: PCAccessToken)
    
        ///Import devices into product
        ///
        ///Import devices into a product. Devices must be of the same platform type as the product in order to be successfully imported. Imported devices may receive an immediate OTA firmware update to the product's released firmware.Importing a device with a Particle SIM card will also import the SIM card into the product and activate the SIM card.
        ///
        /// - calls: POST /v1/products/:productIdOrSlug/devices
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/devices?claim_user=user@domain.com" \
        ///        -H "Authorization: Bearer 12345" \
        ///        -F file=@devices.txt
        ///
        ///          //providing devices in body
        ///     curl https://api.particle.io/v1/products/:productIdOrSlug/devices
        ///        -H "Authorization: Bearer 12345" \
        ///        -H "Content-Type: application/json" \
        ///        -d '{ "ids":["abc123"], "claim_user": "user@domain.com" }'
        ///
        ///         //Particle example response
        ///     POST /v1/products/:productIdOrSlug/devices
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "updated":1,
        ///        "updatedDeviceIds":["abc1234"],
        ///        "existingDeviceIds":[],
        ///        "nonmemberDeviceIds":[],
        ///        "invalidDeviceIds":[]
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:import
        ///  This resource is meant to be used to create a URLRequest that requests a device import for the particle REST api. The server should respond with either an error or a PCDevice.ImportResponse.
        /// - note: Device id or ids are required in the arguments device ids array.
        /// - Parameter optionalArguments: All arguments are optional and are provided using a DeviceImportOptionalArguments struct.
        /// - Parameter token: The current Particle Cloud Access Token.
        /// - Returns: PCDevice.ImportResponse json
    case importDevices(_ devices: [DeviceID], into: ProductID, arguments: PCDevice.ImportArguments?, token: PCAccessToken)
    
        ///Get device information.
        ///
        ///Get basic information about the given device, including the custom variables and functions it has exposed. This can be called for sandbox devices claimed to your account  you have access to, regardless of claiming.
        ///
        /// - calls: GET /v1/devices/:deviceId
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/devices/0123456789abcdef01234567?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/devices/0123456789abcdef01234567
        ///     HTTP/1.1 200 OK
        ///    
        ///     {
        ///        "id": "0123456789abcdef01234567",
        ///        "name": "gongbot",
        ///        "owner": "someone@particle.io",
        ///        "last_ip_address": "176.83.211.237",
        ///        "last_heard": "2015-07-17T22:28:40.907Z",
        ///        "last_handshake_at": "2015-07-15T20:08:00.456Z",
        ///        "product_id": 13,
        ///        "online": true,
        ///        "platform_id": 13,
        ///        "cellular": true,
        ///        "notes": null,
        ///        "functions": [
        ///            "gong",
        ///            "goto"
        ///        ],
        ///        "variables": {
        ///            "Gongs": "int32"
        ///        },
        ///        "status": "normal",
        ///        "serial_number": "AAAAAA111111111",
        ///        "iccid": "89314404000111111111",
        ///        "imei": "357520000000000",
        ///        "mac_wifi": "00:00:00:AA:BB:00",
        ///        "mobile_secret": "NVYM5RK6AHCBELA",
        ///        "system_firmware_version": "1.5.0",
        ///        "firmware_updates_enabled": true,
        ///        "firmware_updates_forced": false
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of  devices:get
        /// - Parameter deviceID: The id of the device to get.
        /// - Parameter token: The current Particle Cloud Access Token.
        /// - Returns: PCDevice json
    case getDeviceInfo(deviceID: DeviceID, token: PCAccessToken)
    
        ///Get device information.
        ///
        ///Get basic information about a given device that is part of a product, including the custom variables and functions it has exposed. This can be called for sandbox devices claimed to your account and for product devices you have access to, regardless of claiming.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/devices/:deviceId
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/devices/0123456789abcdef01234567?access_token=1234"

        ///
        ///         //Particle example response
        ///     GET /v1/devices/0123456789abcdef01234567
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "id": "0123456789abcdef01234567",
        ///        "name": "gongbot",
        ///        "owner": "someone@particle.io",
        ///        "last_ip_address": "176.83.211.237",
        ///        "last_heard": "2015-07-17T22:28:40.907Z",
        ///        "last_handshake_at": "2015-07-15T20:08:00.456Z",
        ///        "product_id": 13,
        ///        "online": true,
        ///        "platform_id": 13,
        ///        "cellular": true,
        ///        "notes": null,
        ///        "functions": [
        ///            "gong",
        ///            "goto"
        ///        ],
        ///        "variables": {
        ///            "Gongs": "int32"
        ///        },
        ///        "status": "normal",
        ///        "serial_number": "AAAAAA111111111",
        ///        "iccid": "89314404000111111111",
        ///        "imei": "357520000000000",
        ///        "mac_wifi": "00:00:00:AA:BB:00",
        ///        "mobile_secret": "NVYM5RK6AHCBELA",
        ///        "system_firmware_version": "1.5.0",
        ///        "firmware_updates_enabled": true,
        ///        "firmware_updates_forced": false
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:get
        /// - Parameter productIdorSlug: The id of the product device to get.
        /// - Parameter deviceID: The id of the device to get.
        /// - Parameter token: The current Particle Cloud Access Token.
        /// - Returns: PCDevice.ListResponse json
    case getProductDeviceInfo(deviceID: DeviceID?, productIdorSlug: ProductID, token: PCAccessToken)
    
        ///Get a variable value
        ///
        ///Request the current value of a variable exposed by the device. Variables can be read on a device you own, or for any device that is part of a product you are a team member of.
        ///
        /// - calls: GET /v1/devices/:deviceId/:varName
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/devices/0123456789abcdef01234567/temperature?access_token=1234"
        ///      
        ///         //Get Variable on product device.
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/devices/0123456789abcdef01234567/temperature?access_token=1234"
        ///
        ///
        ///````
        ///
        ///````json
        ///
        ///         //Particle example response
        ///     GET /v1/devices/0123456789abcdef01234567/temperature
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "name": "temperature",
        ///        "result": 46,
        ///        "coreInfo": {
        ///            "name": "weatherman",
        ///            "deviceID": "0123456789abcdef01234567",
        ///            "connected": true,
        ///            "last_handshake_at": "2015-07-17T22:28:40.907Z",
        ///        }
        ///     }
        /// ````
        ///
        /// ````BASH
        ///          //Raw value response
        ///     GET /v1/devices/0123456789abcdef01234567/temperature?format=raw
        ///     HTTP/1.1 200 OK
        ///    
        ///     46
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices.variable:get
        ///Response type for the final urlrequest is any PCVariableAllowableType
        ///
        /// - note: The return value of PCVariable can be one of three types (Bool | Double | String) and must match the request.
        /// - Parameter name: The name of ther exposed variable. See particle documentation on [publishing](https://docs.particle.io/reference/device-os/api/cloud-functions/particle-publish/).
        /// - Parameter deviceID: The id of the device to get.
        /// - Parameter optionalArguments: The arguments of the requst.
        /// - Parameter token: The current Particle Cloud Access Token.
        /// - Returns: PCVariable json or a string if raw is set to yes.
    case getVariableValue(name: VariableName, deviceID: DeviceID, productIdOrSlug: ProductID?, token: PCAccessToken)
    
        ///Call a function
        ///
        ///Call a function exposed by the device, with arguments passed in the request body. Functions can be called on a device you own, or for any device that is part of a product you are a team member of. See [functions documentation](https://docs.particle.io/reference/device-os/api/cloud-functions/particle-function/) for more info on exposing functions.
        ///
        /// - calls: POST /v1/devices/:deviceId/:functionName or  /v1/products/:productIdOrSlug/devices/deviceId/gong
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///      curl https://api.particle.io/v1/devices/0123456789abcdef01234567/gong \
        ///      -d arg="ZEN PLEASE" \
        ///      -d access_token=1234
        ///
        ///         //Product function request.
        ///      $ curl https://api.particle.io/v1/products/:productIdOrSlug/devices/0123456789abcdef01234567/gong \
        ///      -d arg="ZEN PLEASE" \
        ///      -d access_token=1234
        ///
        ///         //Particle example response
        ///
        ///     HTTP/1.1 200 OK
        ///     {
        ///        "id": "0123456789abcdef01234567",
        ///        "name": "gongbot",
        ///        "connected": true,
        ///        "return_value": 1
        ///     }
        ///
        ///     //example with `raw` argument set to true
        ///     POST /v1/devices/0123456789abcdef01234567/gong
        ///     { "format": "raw", "arg": "ZEN PLEASE" }
        ///
        ///     HTTP/1.1 200 OK
        ///
        ///     1
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices.function:call
        /// - Parameter deviceID: The id of the device to call function on.
        /// - Parameter arguments: The arguments for the function to call.
        /// - Parameter token: The current Particle Cloud Access Token.
        /// - Returns PCDevice.PCFunctionResponse json
    case callFunction(deviceID: DeviceID, arguments: PCDevice.FunctionArguments, token: PCAccessToken)
        
        ///Ping a device
        ///
        ///This will ping a device, enabling you to see if your device is online or offline
        ///
        /// - calls: PUT /v1/devices/:deviceId/ping
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl https://api.particle.io/v1/devices/0123456789abcdef01234567/ping \
        ///        -X PUT \
        ///        -d access_token=1234
        ///     
        ///         //Product device request
        ///     curl https://api.particle.io/v1/products/:productIdOrSlug/devices/0123456789abcdef01234567/ping \
        ///        -X PUT \
        ///        -d access_token=1234
        ///
        ///         //Particle example response
        ///     PUT /v1/devices/0123456789abcdef01234567/ping
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "online": true,
        ///        "ok": true
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:ping
        /// - Parameter deviceId: The id of the device to ping.
        /// - Parameter productIdorSlug: The id of the product if the device is associated witha product.
        /// - Parameter token: The current Particle Cloud Access Token.
        /// - Returns: PCDevice.PingResponse json
    case pingDevice(deviceID: DeviceID, productIdorSlug: ProductID?, token: PCAccessToken)
    
        ///Rename a device.
        ///
        ///Rename a device, either owned by a user or a product.
        ///
        /// - calls: PUT /v1/devices/:deviceId
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT https://api.particle.io/v1/devices/0123456789abcdef01234567 \
        ///        -d name=phancy_photon \
        ///        -d access_token=1234
        ///
        ///         //Product device request
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/devices/0123456789abcdef01234567 \
        ///        -d name=phancy_photon \
        ///        -d access_token=1234
        ///
        ///         //Particle example response
        ///
        ///     PUT /v1/devices/0123456789abcdef01234567
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "id": "0123456789abcdef01234567",
        ///        "name": "phancy_photon"
        ///        "updated_at": "2017-03-10T20:21:49.059Z"
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:update
        /// - Parameter deviceID: The device identifier of the device to be renamed. This parameter is required by the server.
        /// - Parameter productIdorSlug: The product identifier or nil if the device is not associated with a product.
        /// - Parameter newName: The new name to assign to the device.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: PCDevice.NameUpdateResponse json
    case renameDevice(deviceID: DeviceID, productIdorSlug: ProductID?, newName: String, token: PCAccessToken)
    
        ///Add a note to the device.
        ///
        /// - Example Response:
        ///
        ///  ````json
        ///        HTTP/1.1 200 OK
        ///         {
        ///             "id": "some id number",
        ///             "notes": "the note added",
        ///             "updated_at": "date stamp in ISO8601 format"
        ///         }
        ///
        ///````
        ///
        ///- Example usage:
        ///
        ///  ````curl
        ///
        ///        curl -X PUT https://api.particle.io/v1/devices/0123456789abcdef01234567 \
        ///           -d name=phancy_photon \
        ///           -d access_token=1234
        ///
        ///````
        ///
        /// - Requires: scopes: devices:update
        /// - Parameter deviceID: The device identifier of the device to be renamed. This parameter is required by the server.
        /// - Parameter productIdorSlug: The product identifier or nil if the device is not associated with a product.
        /// - Parameter newName: The new name to assign to the device.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: PCDevice.AddNoteResponse json
    case addDeviceNotes(deviceID: DeviceID, productIdorSlug: ProductID?, note: String, token: PCAccessToken)
    
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
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///    curl https://api.particle.io/v1/device_claims \
        ///       -d access_token=1234
        ///
        ///         //Product device request
        ///    curl https://api.particle.io/v1/products/:productIdOrSlug/device_claims \
        ///         -d access_token=1234
        ///
        ///         //Particle example response
        ///    POST /v1/device_claims
        ///    HTTP/1.1 200 OK
        ///    
        ///    {
        ///       claim_code: 'rCFr2KAJNgzJ2rR3Jm1ZoUd7G4Sr3ak7MRHdWrM274eYzInP1+psZ0fP2qNehlj',
        ///       device_ids: ['33ff210644893f533e242597']
        ///    }
        ///
        ///
        ///````
        ///
        /// - note: Requires an Authorization Header
        /// - Parameter arguments: An encapsulation of the arguments for the request.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: PCDevice.ClaimResponse json
    case createClaimCode(arguments: PCDevice.ClaimRequestArguments?, token: PCAccessToken)

        ///Claim a device
        ///
        ///Claim a new or unclaimed device to your account.
        ///
        /// - calls: POST /v1/devices
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl https://api.particle.io/v1/devices \
        ///        -d id=0123456789abcdef01234567 \
        ///        -d access_token=1234
        ///
        ///````
        ///
        ///
        /// - Parameter deviceID: The ID of the device to claim.
        /// - Parameter isTransfer: Indicates if this is a transfer from another user.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
    case claimDevice(deviceID: DeviceID, isTransfer: Bool, token: PCAccessToken)
    
        ///Request device transfer from another user
        ///
        /// - calls: POST /v1/devices
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl https://api.particle.io/v1/devices \
        ///        -d id=0123456789abcdef01234567 \
        ///        -d request_transfer=true \
        ///        -d access_token=1234
        ///
        ///
        ///````
        ///
        /// - note: request_transfer automatically set to true
        /// - Parameter deviceID: The ID of the device to claim.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
//    case requestDeviceTransferFromAnotherUser(deviceID: DeviceID, token: PCAccessToken)
    
        ///Remove device from product
        ///
        ///Remove a device from a product and re-assign to a generic Particle product.
        ///
        /// - calls: DELETE /v1/products/:productIdOrSlug/devices/:deviceID
        ///
        ///
        ///````BASH
        ///
        ///
        ///         //Particle example response
        ///    
        ///     DELETE /v1/products/photon/devices/123abc
        ///     HTTP/1.1 204 NO CONTENT
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:remove
        /// - Important: This endpoint will unclaim the device if it is owned by a customer.
        /// - Parameter deviceID: The device identifier of the device to be removed.
        /// - Parameter productIdorSlug: The product identifier of the product the device is assigned to.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: URLRequestRsponse only
    case removeDeviceFromProduct(deviceID: DeviceID, productIdorSlug: ProductID, token: PCAccessToken)
    
        ///Unclaim device.
        ///
        ///Remove ownership of a device. This will unclaim regardless if the device is owned by a user or a customer, in the case of a product.When using this endpoint to unclaim a product device, the route looks slightly different:DELETE /v1/products/:productIdOrSlug/devices/:deviceID/owner Note the /owner at the end of the route.
        ///
        /// - calls: DELETE /v1/devices/:deviceID
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X DELETE https://api.particle.io/v1/devices/12345 \
        ///        -d access_token=123abc
        ///
        ///         //Product device request
        ///     curl -X DELETE https://api.particle.io/v1/products/:productIdOrSlug/devices/12345/owner \
        ///        -d access_token=123abc
        ///
        ///         //Particle example response
        ///     DELETE /v1/devices/12345
        ///     HTTP/1.1 200 OK
        ///    
        ///     {
        ///        "ok": true
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:release
        /// - note: If the device is assigned to a product the productID argument must correspond to the product it is assigned to.
        /// - Parameter deviceID: The device identifier of the device to be unclaimed.
        /// - Parameter productIdorSlug: The product identifier of the product the device is assigned to or nil if not assigned to a product.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: ServerResponses.BoolResponse json
    case unclaimDevice(deviceID: DeviceID, productIdorSlug: ProductID?, token: PCAccessToken)
    
        ///Signal a device.
        ///
        ///Make the device conspicuous by causing its LED to flash in rainbow patterns.
        ///
        /// - calls: PUT /v1/devices/:deviceID
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT https://api.particle.io/v1/devices/12345 \
        ///        -d signal=1 \
        ///        -d access_token=123abc
        ///
        ///         //Particle example response
        ///     PUT /v1/devices/12345
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "id": "12345",
        ///        "connected": true,
        ///        "signaling": true
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter deviceID: The device identifier of the device to be affected.
        /// - Parameter rainbowState: An enum determining whether to turn the signal on or off.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: DeviceID.SignalResponse json
    case signalDevice(deviceID: DeviceID, rainbowState: RainbowState, token: PCAccessToken)

        ///Force enable OTA updates
        ///
        ///[Force enable](https://docs.particle.io/getting-started/cloud/ota-updates/) OTA updates on this device.
        ///
        /// - calls: PUT /v1/devices/:deviceID
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT https://api.particle.io/v1/devices/12345 \
        ///        -d firmware_updates_forced=true \
        ///        -d access_token=123abc
        ///
        ///         //Particle example response
        ///     PUT /v1/devices/12345
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "id": "12345",
        ///        "firmware_updates_forced": true
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:update
        /// - Parameter deviceID: The device identifier of the device to be affected.
        /// - Parameter forceEnabled: Boolean to indicate whether ota updates will be fored or not.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: DeviceID.ForceOTAUpdateResponse json
    case forceOverTheAirUpdates(deviceID: DeviceID, enabled: Bool, token: PCAccessToken)
    
        ///Look up device identification from a serial number.
        ///
        ///Return the device ID and SIM card ICCD (if applicable) for a device by serial number. This API can look up devices that you have not yet added to your product and is rate limited to 50 requests per hour. Once you've imported your devices to your product you should instead use the list devices in a product API and filter on serial number. No special rate limits apply to that API.
        ///
        /// - calls: GET /v1/serial_numbers/:serial_number
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/serial_numbers/E26AAA111111111?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/serial_numbers/E26AAA111111111
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///         "ok": true,
        ///         "deviceID": "0123456789abcdef01234567",
        ///         "iccid": "8934076500002589174"
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter serialNumber: The serial number printed on the barcode of the device packaging.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
        /// - Returns: PCDevice.SerialNumberLookupResponse json
    case lookUpDeviceInformation(serialNumber: String, token: PCAccessToken)
        
        ///Refresh device vitals.
        ///
        ///Refresh diagnostic vitals for a single device. This will instruct the device to publish a new event to the Device Cloud containing a device vitals payload. This is an asynchronous request: the HTTP request returns immediately after the request to the device is sent. In order for the device to respond with a vitals payload, it must be online and connected to the Device Cloud.The device will respond by publishing an event named spark/device/diagnostics/update. See the description of the [device vitals event](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event).
        ///
        /// - calls: PUBLISH spark/device/diagnostics/update
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example response
        ///     {
        ///        "device": {
        ///            "network": {
        ///                "cellular": {
        ///                    "radio_access_technology": "3G",
        ///                    "operator": "AT&T Wireless Inc.",
        ///                    "cell_global_identity": {
        ///                        "mobile_country_code": 310,
        ///                        "mobile_network_code": "410",
        ///                        "location_area_code": 45997,
        ///                        "cell_id": 20160117
        ///                    }
        ///                },
        ///                "signal": {
        ///                    "at": "UMTS",
        ///                    "strength": 66.66,
        ///                    "strength_units": "%",
        ///                    "strengthv": -57,
        ///                    "strengthv_units": "dBm",
        ///                    "strengthv_type": "RSCP",
        ///                    "quality": 75.51,
        ///                    "quality_units": "%",
        ///                    "qualityv": -6,
        ///                    "qualityv_units": "dB",
        ///                    "qualityv_type": "ECN0"
        ///                },
        ///                "connection": {
        ///                    "status": "connected",
        ///                    "error": 0,
        ///                    "disconnects": 1,
        ///                    "attempts": 1,
        ///                    "disconnect_reason": "reset"
        ///                }
        ///            },
        ///            "cloud": {
        ///                "connection": {
        ///                    "status": "connected",
        ///                    "error": 0,
        ///                    "attempts": 2,
        ///                    "disconnects": 23,
        ///                    "disconnect_reason": "error"
        ///                },
        ///                "coap": {
        ///                    "transmit": 412,
        ///                    "retransmit": 3,
        ///                    "unack": 0,
        ///                    "round_trip": 1594
        ///                },
        ///                "publish": {
        ///                    "rate_limited": 0
        ///                }
        ///            },
        ///            "power": {
        ///                "battery": {
        ///                    "charge": 87.12,
        ///                    "state": "not_charging"
        ///                },
        ///                "source": "VIN"
        ///            },
        ///            "system": {
        ///                "uptime": 2567461,
        ///                "memory": {
        ///                    "used": 36016,
        ///                    "total": 113664
        ///                }
        ///            }
        ///        },
        ///        "service": {
        ///            "device": {
        ///                "status": "ok"
        ///            },
        ///            "cloud": {
        ///                "uptime": 82925,
        ///                "publish": {
        ///                    "sent": 1384
        ///                }
        ///            },
        ///            "coap": {
        ///                "round_trip": 920
        ///            }
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices.diagnostics:update
        /// - Parameter deviceID: String representing the device id.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token.
        /// - Returns PCRemoteDiagnosticsVitalsResponse json
    case refreshDeviceVitals(deviceID: DeviceID, productIDorSlug: ProductID?, token: PCAccessToken)
    
        ///Get last known device vitals.
        ///
        ///Returns the last device vitals payload sent by the device to the Device Cloud. See [device vitals event payload](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event) for more info.
        ///
        /// - calls: GET /v1/diagnostics/:deviceId/last
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/diagnostics/0123456789abcdef01234567/last?access_token=1234"
        ///
        ///     //Product device request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/diagnostics/0123456789abcdef01234567/last?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/diagnostics/0123456789abcdef01234567/last
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///     "diagnostics": {
        ///            "updated_at": "2017-12-19T12:37:07.318Z",
        ///            "deviceID": "0123456789abcdef01234567",
        ///            "payload": {
        ///                ...
        ///            }
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices.diagnostics:get
        /// - Parameter deviceID: String representing the device id.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to devices.diagnostics:get
        /// - Returns: PCRemoteDiagnosticsVitalsResponse json
    case getLastKnownDeviceVitals(deviceID: DeviceID, productIDorSlug: ProductID?, token: PCAccessToken)
    
        ///Get all historical device vitals.
        ///
        ///Returns all stored device vital records sent by the device to the Device Cloud. Device vitals records will expire after 1 month.
        ///
        /// - calls: GET /v1/diagnostics/:deviceId
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/diagnostics/0123456789abcdef01234567?access_token=1234"
        ///
        ///         //Product device example
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/diagnostics/0123456789abcdef01234567?access_token=1234"
        ///
        ///         //time frame scoped example
        ///     curl "https://api.particle.io/v1/diagnostics/0123456789abcdef01234567?access_token=1234&start_date=2017-12-18T12:37:07.318Z&end_date=2017-12-20T12:37:07.318Z"
        ///
        ///         //Particle example response
        ///     GET /v1/diagnostics/0123456789abcdef01234567/
        ///     HTTP/1.1 200 OK
        ///    
        ///     {
        ///        "diagnostics": [
        ///            {
        ///               "updated_at": "2017-12-19T12:37:07.318Z",
        ///               "deviceID": "0123456789abcdef01234567",
        ///               "payload": {
        ///                   ... the device vitals event payload.
        ///               }
        ///            },
        ///            ...
        ///        ]
        ///     }
        ///
        ///
        ///         //Example errors
        ///     GET /v1/diagnostics/0123456789abcdef01234567?end_date=invalid-date
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///          "error": "bad_request",
        ///          "description": "start_date and end_date must be ISO8601 formatted",
        ///     }
        ///
        ///     GET /v1/diagnostics/0123456789abcdef01234567?end_date=invalid-date
        ///     HTTP/1.1 200 OK
        ///    
        ///     {
        ///          "error": "bad_request",
        ///          "description": "start_date must not be more than than 30 days ago",
        ///     }
        ///
        ///````
        ///
        /// - Requires: Scope of devices.diagnostics:get
        /// - Parameter deviceID: String representing the device id.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter startDate: Date formated String in iso 8601
        /// - Parameter endDate: Date formated String in iso 8601
        /// - Parameter token: A currently active access token scoped to devices.diagnostics:get
        /// - Returns: PCRemoteDiagnosticsVitalsResponse json
    case getAllHistoricalDeviceVitals(deviceID: DeviceID, productIDorSlug: ProductID?, startDate: String?, endDate: String?, token: PCAccessToken)
        
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
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/diagnostics/0123456789abcdef01234567/metadata?access_token=1234"
        ///
        ///         //Product device request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/diagnostics/0123456789abcdef01234567/metadata?access_token=1234"
        ///
        ///         //Particle example response
        ///        GET /v1/diagnostics/0123456789abcdef01234567/metadata
        ///        HTTP/1.1 200 OK
        ///        
        ///     {
        ///        "diagnostics_metadata": {
        ///            "device": {
        ///                "power": {
        ///                    "battery": {
        ///                        "charge": {
        ///                            "title": "battery charge",
        ///                            "type": "number",
        ///                            "priority": 1,
        ///                            "units": {
        ///                                "title": "percent",
        ///                                "convert": {
        ///                                    "type": "round"
        ///                                }
        ///                            },
        ///                            "ranges": {
        ///                                "warning": 20,
        ///                                "type": "below"
        ///                            },
        ///                            "messages": {
        ///                                "description": "The state of charge of the device’s connected battery, represented as a percentage.",
        ///                                "healthy": "The battery’s state of charge is in a healthy range.",
        ///                                "warning": "The charge for this battery is low. Recharge the battery soon to prevent the device from losing power and going offline."
        ///                            }
        ///                        },
        ///                        "state": {
        ///                            "title": "",
        ///                            "type": "string",
        ///                            "describes": "device.power.battery.charge",
        ///                            "values": {
        ///                                "all": [
        ///                                    "unknown",
        ///                                    "not_charging",
        ///                                    "charging",
        ///                                    "charged",
        ///                                    "discharging",
        ///                                    "fault"
        ///                                ],
        ///                                "healthy": [
        ///                                    "charging",
        ///                                    "charged",
        ///                                    "discharging"
        ///                                ],
        ///                                "warning": [
        ///                                    "fault",
        ///                                    "unknown",
        ///                                    "not_charging"
        ///                                ]
        ///                            }
        ///                        }
        ///                    }
        ///                },
        ///                "system": {
        ///                    "memory": {
        ///                        "used": {
        ///                            "title": "RAM used",
        ///                            "type": "number",
        ///                            "priority": 6,
        ///                            "units": {
        ///                                "title": "kB",
        ///                                "convert": {
        ///                                    "type": "divide",
        ///                                    "by": 1024
        ///                                }
        ///                            },
        ///                            "ranges": {
        ///                                "type": "ratio_above",
        ///                                "ratio": 0.9,
        ///                                "param1": "device.system.memory.used",
        ///                                "param2": "device.system.memory.total"
        ///                            },
        ///                            "messages": {
        ///                                "description": "The amount of memory used by the device, combining the heap and the user application’s static RAM in bytes.",
        ///                                "healthy": "The device has a healthy amount of available memory.",
        ///                                "warning": "The device may soon run out of available memory. This can result in unexpected failures in your firmware application. If possible, reduce the amount of RAM that your application uses."
        ///                            }
        ///                        },
        ///                        "total": {
        ///                            "title": "",
        ///                            "type": "number",
        ///                            "units": {
        ///                                "title": "kB",
        ///                                "convert": {
        ///                                    "type": "divide",
        ///                                    "by": 1024
        ///                                }
        ///                            },
        ///                            "describes": "device.system.memory.used"
        ///                        }
        ///                    }
        ///                },
        ///                "network": {
        ///                    "signal": {
        ///                        "strengthv": {
        ///                            "title": "signal strength value",
        ///                            "type": "number",
        ///                            "units": {
        ///                                "title": "dBm"
        ///                            },
        ///                            "describes": "device.network.signal.strength"
        ///                        },
        ///                        "strength": {
        ///                            "title": "signal strength",
        ///                            "type": "number",
        ///                            "priority": 2,
        ///                            "units": {
        ///                                "title": "percent"
        ///                            },
        ///                            "ranges": {
        ///                                "type": "below",
        ///                                "warning": 20
        ///                            },
        ///                            "messages": {
        ///                                "description": "The strength of the device’s connection to the Cellular network, measured in decibels of received signal power.",
        ///                                "healthy": "The device’s signal strength is in a healthy range, with a signal power value of {describes} (the closer to 0, the stronger the signal).",
        ///                                "warning": "The device’s signal strength is poor, with a signal power value of {describes} (the further from 0, the weaker the signal). This can cause the device to drop offline unexpectedly. If possible, move the device to a place with better Cellular signal."
        ///                            }
        ///                        }
        ///                    }
        ///                },
        ///                "cloud": {
        ///                    "disconnects": {
        ///                        "title": "disconnect events",
        ///                        "type": "number",
        ///                        "priority": 3,
        ///                        "units": "count",
        ///                        "ranges": {
        ///                            "type": "ratio_above",
        ///                            "ratio": 0.0013,
        ///                            "param1": "device.cloud.disconnects",
        ///                            "param2": "service.cloud.uptime"
        ///                        },
        ///                        "messages": {
        ///                            "description": "The number of times the device disconnected unexpectedly from the Particle Cloud since its last reset.",
        ///                            "healthy": "The device’s frequency of cloud disconnects is in a healthy range.",
        ///                            "warning": "The device is disconnecting from the Particle Cloud too frequently. Large numbers of cloud disconnects are often caused by poor signal strength or network congestion. If possible, move the device to a place with better Cellular signal."
        ///                        }
        ///                    },
        ///                    "publish": {
        ///                        "rate_limited": {
        ///                            "title": "rate-limited publishes",
        ///                            "type": "number",
        ///                            "priority": 5,
        ///                            "units": {
        ///                                "title": "count"
        ///                            },
        ///                            "ranges": {
        ///                                "type": "ratio_above",
        ///                                "ratio": 0.05,
        ///                                "param1": "device.cloud.publish.rate_limited",
        ///                                "param2": "service.cloud.publish.sent"
        ///                            },
        ///                            "messages": {
        ///                                "description": "Particle devices are allowed to publish an average of 1 event per second in application firmware. Publishing at a rate higher than this will result in rate limiting of events.",
        ///                                "healthy": "The device’s published events are being sent to the Particle Cloud successfully.",
        ///                                "warning": "The device is publishing messages too rapidly, and is being rate limited. This causes messages sent by firmware to be blocked from reaching the Particle cloud. Reduce the frequency of published messages in your application firmware to below 1 per second to avoid rate limiting."
        ///                            }
        ///                        }
        ///                    }
        ///                }
        ///            },
        ///            "service": {
        ///                "coap": {
        ///                    "round_trip": {
        ///                        "title": "round-trip time",
        ///                        "type": "number",
        ///                        "priority": 4,
        ///                        "units": {
        ///                            "title": "ms"
        ///                        },
        ///                        "messages": {
        ///                            "description": "The amount of time it takes for the device to successfully respond to a CoAP message sent by the Particle Cloud in milliseconds.",
        ///                            "healthy": "The device has a round-trip time in a healthy range.",
        ///                            "warning": "The device is taking a long time to respond to messages from the Particle Cloud. A higher than average round trip time is normally caused by poor signal strength or network congestion. If possible, move the device to a place with better Cellular signal."
        ///                        }
        ///                    }
        ///                },
        ///                "cloud": {
        ///                    "publish": {
        ///                        "sent": {
        ///                            "title": "Total events published",
        ///                            "type": "number",
        ///                            "units": {
        ///                                "title": "count"
        ///                            },
        ///                            "describes": "device.cloud.publish.rate_limited"
        ///                        }
        ///                    }
        ///                }
        ///            },
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices.diagnostics.metadata:get
        /// - Parameter deviceID: String representing the device id.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to devices.diagnostics.metadata:get
        /// - Returns: PCRemoteDiagnosticsVitalsResponse json
    case getDeviceVitalsMetadata(deviceID: DeviceID, productIDorSlug: ProductID?, token: PCAccessToken)
    
        ///Get cellular network status.
        ///
        ///Get cellular network status for a given device. Kicks off a long running task that checks if the device/SIM has an active data session with a cell tower. Values for keys in the sim_status object will be null until the task has finished. Poll the endpoint until meta.state is complete. At this point, the sim_status object will be populated.Note that responses are cached by the cellular network providers. This means that on occasion, the real-time status of the device/SIM may not align with the results of this test.
        ///
        /// - calls: GET /v1/sims/:iccid/status
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/sims/1234/status?access_token=1234"
        ///
        ///         //Product device example
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/sims/1234/status?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/sims/:iccid/status
        ///     HTTP/1.1 202
        ///
        ///     {
        ///        "ok": true,
        ///        "meta": {
        ///            "created_at": "2018-05-29T19:31:55.000-06:00",
        ///            "expires_at": "2018-05-29T19:34:55.000-06:00",
        ///            "check_again_after": "2018-05-29T19:32:05.450-06:00",
        ///            "state": "pending",
        ///            "method": "async",
        ///            "task_id": "1234abcd"
        ///        },
        ///        "sim_status": {
        ///            "connected": true,
        ///            "gsm_connection": true,
        ///            "data_connection": true,
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims.status:get
        /// - Parameter deviceID: String representing the device id.
        /// - Parameter iccid: String representing the iccid.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to sims.status:get
        /// - Returns: PCRemoteDiagnosticsCellularNetworkStatusResponse
    case getCellularNetworkStatus(deviceID: DeviceID, iccid: ICCIDNumber, productIDorSlug: ProductID?, token: PCAccessToken)
    
        //MARK: - Users - Done
    
        ///Get user.
        ///
        ///Return the user resource for the currently authenticated user.
        ///
        /// - calls: GET /user
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/user?access_token=12345"
        ///
        ///         //Particle example response
        ///      GET /v1/user
        ///      HTTP/1.1 200 OK
        ///      {
        ///         "username": "testuser@particle.io",
        ///         "subscription_ids": [],
        ///         "account_info": {
        ///             "first_name": "Test",
        ///             "last_name": "User",
        ///             "business_account": false
        ///         },
        ///         scim_provisioned: false,
        ///         no_password: false,
        ///         "mfa": {
        ///          "enabled": false
        ///         },
        ///         "wifi_device_count": 0,
        ///         "cellular_device_count": 0
        ///      }
        ///
        ///
        ///````
        ///
        ///
        /// - Parameter token: A currently active access token.
        /// - Returns: PCUser
    case getUser(token: PCAccessToken)
    
        // FIXME: - find out from particle if this dictionary is just random or what.

        ///Update user.
        ///
        ///Update the logged-in user. Allows changing email, password and other account information.
        ///
        /// - calls: PUT /user
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///         //Changing password
        ///     curl -X PUT https://api.particle.io/v1/user \
        ///         -d "password=I'm a really long password that no one would guess" \
        ///         -d "current_password=My current password" \
        ///         -d access_token=1234
        ///
        ///         //Changing the email
        ///     curl -X PUT https://api.particle.io/v1/user \
        ///         -d "username=testuser@example.com" \
        ///         -d "current_password=My current password" \
        ///         -d access_token=1234
        ///     
        ///         //Changing account info
        ///     curl -X PUT https://api.particle.io/v1/user \
        ///         -d "account_info[first_name]=Test" \
        ///         -d "account_info[last_name]=User" \
        ///         -d access_token=1234
        ///
        ///         //Particle example response
        ///     PUT /v1/user
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///         "ok": true,
        ///         "message": "User's password updated."
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter username: The new account email address to be assigned to the user to be updated.
        /// - Parameter password: The new password to assign to the user to be updated.
        /// - Parameter accountInfo: Dictionary containing at least the ??first_name and last_name keys??. [Particleio documentation is unclear on what info or keys should be used](https://docs.particle.io/reference/cloud-apis/api/#update-user).
        /// - Parameter currentPassword: The current password for the user to be updated.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCUser.UpdateUserResponse
    case updateUser(username: String, password: String?, accountInfo: PCUser.Info, currentPassword: String, token: PCAccessToken)
    
        ///Delete user.
        ///
        ///Delete the logged-in user. Allows removing user account and artifacts from Particle system.
        ///
        /// - calls: PUT /user
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X DELETE https://api.particle.io/v1/user \
        ///        -d "password=mypassword" \
        ///        -d access_token=1234
        ///
        ///         //Particle example response
        ///     PUT /v1/user
        ///     HTTP/1.1 200 OK
        ///    
        ///     {
        ///        "ok": true,
        ///        "message": "User's account has been deleted."
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter password: The new password to assign to the user to be updated.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCUser.DeleteUserResponse
    case deleteUser(password: String, token: PCAccessToken)
    
        ///Forgot password.
        ///
        /// Create a new password reset token and send the user an email with the token. Client doesn't need to be authenticated.
        ///
        /// - calls: POST /user/password-reset
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X POST https://api.particle.io/v1/user/password-reset \
        ///        -d username=forgetful-john@example.com
        ///
        ///         //Particle example response
        ///     POST /v1/user/password-reset
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "ok": true,
        ///        "message": "Password reset email sent."
        ///     }
        ///
        ///
        ///````
        ///
        /// - note: This function will generate an email to the email address passed to username. This call is rate limited to prevent abuse.
        /// - Parameter username: The account email address for the user.
        /// - Returns: PCUser.PassWordResetRequestResponse
    case forgotPassword(username: String)

        //MARK: - Quarantine - Done
    
        ///Approve a quarantined device.
        ///
        ///Approve a quarantined device. This will immediately release the device from quarantine and allow it to publish events, receive firmware updates, etc.
        ///
        /// - calls: POST /v1/products/:productIdOrSlug/devices
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     POST /v1/products/photon/devices
        ///     { "id": "123abc" }
        ///
        ///         //Particle example response
        ///     HTTP/1.1 200 OK
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:import
        /// - Parameter deviceID: String representing the device id of the device to be approved.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to devices:import
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 200
    case approveQuarantinedDevice(deviceID: DeviceID, productIDorSlug: ProductID, token: PCAccessToken)
    
        ///Deny a quarantined device.
        ///
        ///Deny a quarantined device.
        ///
        /// - calls: DELETE /v1/products/:productIdOrSlug/devices/:deviceID
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     DELETE /v1/products/photon/devices/123abc
        ///     { deny: true }
        ///
        ///         //Particle example response
        ///     HTTP/1.1 204 NO CONTENT
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:remove
        /// - Parameter deviceID: String representing the device id of the device to be approved.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to devices:remove
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 204
    case denyQuarantinedDevice(deviceID: DeviceID, productIDorSlug: ProductID, token: PCAccessToken)
    
        //MARK: - SimCard - Done
    
        ///List SIM cards.
        ///
        ///Get a list of the SIM cards owned by an individual or a product. The product endpoint is paginated, by default returns 25 SIM card records per page.
        ///
        /// - calls: GET /v1/sims
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/sims?access_token=12345"
        ///
        ///         //Sim product request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/sims?access_token=12345"
        ///
        ///         //Particle example response
        ///     GET /v1/sims
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "sims": [
        ///            {
        ///
        ///               "_id":"8934076500002589174",
        ///               "activations_count":1,
        ///               "base_country_code":"US",
        ///               "base_monthly_rate":299,
        ///               "deactivations_count":0,
        ///               "first_activated_on":"2017-01-27T23:10:16.994Z",
        ///               "last_activated_on":"2017-01-27T23:10:16.994Z",
        ///               "last_activated_via":"user_setup",
        ///               "last_status_change_action":"activate",
        ///               "last_status_change_action_error":"no",
        ///               "msisdn":"345901000485300",
        ///               "overage_monthly_rate":99,
        ///               "status":"active",
        ///               "stripe_plan_slug":"KickstarterElectronPlan",
        ///               "updated_at":"2017-01-27T23:10:22.622Z",
        ///               "user_id":"5580999caf8bad191600019b",
        ///               "carrier":"telefonica",
        ///               "last_device_id":"123abc",
        ///               "last_device_name":"foo_bar_baz"
        ///            },
        ///            ...
        ///        ]
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims:list
        /// - Parameter arguments: An PCSimCard.ListRequestArgument struct containing the desired properties of the request.
        /// - Parameter token: A currently active access token scoped to sims:list
        /// - Returns: Response Type: PCSimCard.ListResponse
    case listSimCards(arguments: PCSimCard.ListRequestArgument, token: PCAccessToken)
    
        ///Get SIM information.
        ///
        ///Retrieve a SIM card owned by an individual or a product.
        ///
        /// - calls: GET /v1/sims/:iccid
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/sims?access_token=12345"
        ///
        ///         //product request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/sims?access_token=12345"
        ///
        ///         //Particle example response
        ///     GET /v1/sims/8934076500002589174
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///         {
        ///             "_id":"8934076500002589174",
        ///             "activations_count":1,
        ///             "base_country_code":"US",
        ///             "base_monthly_rate":299,
        ///             "deactivations_count":0,
        ///             "first_activated_on":"2017-01-27T23:10:16.994Z",
        ///             "last_activated_on":"2017-01-27T23:10:16.994Z",
        ///             "last_activated_via":"user_setup",
        ///             "last_status_change_action":"activate",
        ///             "last_status_change_action_error":"no",
        ///             "msisdn":"345901000485300",
        ///             "overage_monthly_rate":99,
        ///             "status":"active",
        ///             "stripe_plan_slug":"KickstarterElectronPlan",
        ///             "updated_at":"2017-01-27T23:10:22.622Z",
        ///             "user_id":"5580999caf8bad191600019b",
        ///             "carrier":"telefonica",
        ///             "last_device_id":"123abc",
        ///             "last_device_name":"foo_bar_baz",
        ///             "owner": "someone@particle.io"
        ///         }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims:get
        /// - Parameter iccid: Filter results to SIMs with this ICCID (partial matching) Product endpoint only
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to sims:get
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 200
    case getSimInformation(iccid: String, productIDorSlug: ProductID, token: PCAccessToken)
    
        ///Get data usage.
        ///
        ///Get SIM card data usage for the current billing period, broken out by day. Note that date usage reports can be delayed by up to 1 hour.
        ///
        /// - calls: GET /v1/sims/:iccid/data_usage
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/sims/1234/data_usage?access_token=1234"
        ///
        ///         //product request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/sims/1234/data_usage?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/sims/:iccid/data_usage
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "iccid":"8934076500002589174",
        ///        "usage_by_day": [
        ///            {
        ///                "date":"2017-02-24",
        ///                "mbs_used":0.98,
        ///                "mbs_used_cumulative":0.98
        ///            },
        ///            {
        ///                "date":"2017-02-25",
        ///                "mbs_used":0.50,
        ///                "mbs_used_cumulative":1.48
        ///            },
        ///            ...
        ///        ]
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter iccid: Filter results to SIMs with this ICCID (partial matching) Product endpoint only
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to sims:get
        /// - Returns: Response Type: IccidDataUsageResponse
    case getDataUsage(iccid: String, productIDorSlug: ProductID?, token: PCAccessToken)
    
        ///Get data usage for product fleet.
        ///
        ///Get fleet-wide SIM card data usage for a product in the current billing period, broken out by day. Daily usage totals represent an aggregate of all SIM cards that make up the product. Data usage reports can be delayed until the next day, and occasionally by several days.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/sims/data_usage
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/sims/data_usage?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/products/:productIdOrSlug/sims/data_usage
        ///     HTTP/1.1 200 OK
        ///     {
        ///         "total_mbs_used":200.00,
        ///         "total_active_sim_cards":2000,
        ///         "usage_by_day": [
        ///             {
        ///                 "date":"2017-03-01",
        ///                 "mbs_used":100.00,
        ///                 "mbs_used_cumulative":100.00
        ///             },
        ///             {
        ///                 "date":"2017-03-02",
        ///                 "mbs_used":100.00,
        ///                 "mbs_used_cumulative":200.00
        ///             },
        ///             ...
        ///         ]
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims.usage:get
        /// - Parameter productIDorSlug: String representing the product id or slug of the fleet.
        /// - Parameter token: A currently active access token scoped to sims:get
        /// - Returns: Response Type: FleetDataUsageResponse
    case getDataUsageForProductFleet(productIDorSlug: ProductID, token: PCAccessToken)
    
        ///Activate SIM.
        ///
        ///Activates a SIM card for the first time.
        ///
        /// - calls: POST /v1/products/:productIdOrSlug/sims
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT https://api.particle.io/v1/sims/1234 \
        ///         -d action=activate \
        ///         -d access_token=1234
        ///
        ///         //Particle example response
        ///     PUT /v1/sims/12345
        ///     HTTP/1.1 200 OK
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims:import
        /// - note: Can not be used to activate Product SIM cards. Use the [product import endpoint](x-source-tag://importAndActivateProductSIMs) instead.
        /// - Parameter iccid: The ICCID of the SIM to update
        /// - Parameter token: A currently active access token.
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 200
    case activateSIM(iccid: String, token: PCAccessToken)
    
        ///Import and activate product SIMs.
        ///
        ///Import a group of SIM cards into a product. SIM cards will be activated upon import. Activated SIM cards will receive a prorated charge for the 1MB data plan for the remainder of the month on your next invoice. Either pass an array of ICCIDs or include a file containing a list of SIM cards.Import and activation will be queued for processing. You will receive an email with the import results when all SIM cards have been processed.Importing a SIM card associated with a device will also import the device into the product.
        ///
        /// - calls: POST /v1/products/:productIdOrSlug/sims
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl https://api.particle.io/v1/products/:productIdOrSlug/sims \
        ///         -d sims[]=8934076500002586220 \
        ///         -d access_token=1234
        ///
        ///         //Particle example response
        ///     POST /v1/products/:productIdOrSlug/sims
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///         ok: true
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims:import
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter file: A .txt file containing a single-column list of ICCIDs.
        /// - Parameter sims: An array of SIM ICCIDs to import.
        /// - Parameter token: A currently active access token scoped to sims:import
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 200
        ///  - Tag: importAndActivateProductSIMs
    case importAndActivateProductSIMs(productIDorSlug: ProductID, sims: [String]?, file: String? ,token: PCAccessToken)
    
        ///Deactivate SIM.
        ///
        ///Deactivates a SIM card, disabling its ability to connect to a cell tower. Devices with deactivated SIM cards are not billable.
        ///
        /// - calls: PUT /v1/sims/:iccid
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT https://api.particle.io/v1/sims/1234 \
        ///         -d action=deactivate \
        ///         -d access_token=1234
        ///     
        ///         //product request
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/sims/1234 \
        ///         -d action=deactivate \
        ///         -d access_token=1234
        ///
        ///         //Particle example response
        ///     PUT /v1/sims/12345
        ///     HTTP/1.1 200 OK
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims:update
        /// - Parameter iccid: The ICCID of the SIM to deactivate.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to sims:update
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 200
    case deactivateSIM(iccid: String, productIDorSlug: ProductID?, token: PCAccessToken)
    
        ///Reactivate SIM.
        ///
        ///Re-enables a SIM card to connect to a cell tower. Do this if you'd like to reactivate a SIM that you have deactivated.
        ///
        /// - calls: PUT /v1/sims/:iccid
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT https://api.particle.io/v1/sims/1234 \
        ///         -d action=reactivate \
        ///         -d access_token=1234
        ///     
        ///         //product request
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/sims/1234 \
        ///         -d action=reactivate \
        ///         -d access_token=1234
        ///
        ///         //Particle example response
        ///     PUT /v1/sims/12345
        ///     HTTP/1.1 200 OK
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims:update
        /// - Parameter iccid: The ICCID of the SIM to deactivate.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to sims:update
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 200
    case reactivateSIM(iccid: String, productIDorSlug: ProductID?, token: PCAccessToken)
    
        ///Release SIM from account.
        ///
        ///Remove a SIM card from an account, disassociating the SIM card from a user or a product. The SIM will also be deactivated.
        ///
        ///Once the SIM card has been released, it can be claimed by a different user, or imported into a different product.
        ///
        /// - calls: DELETE /v1/sims/:iccid
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X DELETE https://api.particle.io/v1/sims/1234 \
        ///         -d access_token=1234
        ///    
        ///         //product request
        ///     curl -X DELETE https://api.particle.io/v1/products/:productIdOrSlug/sims/1234 \
        ///         -d access_token=1234
        ///
        ///         //Particle example response
        ///     DELETE /v1/sims/1234
        ///     HTTP/1.1 204 No Content
        ///
        ///         //release pending
        ///     DELETE /v1/sims/1234
        ///     HTTP/1.1 202 Accepted
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of sims:remove
        /// - Parameter iccid: The ICCID of the SIM to deactivate.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to sims:remove
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 202 or 204
    case releaseSimFromAccount(iccid: String, productIDorSlug: ProductID?, token: PCAccessToken)
    
        //MARK: - Events - Done
    
        ///Get a stream of events.
        ///
        ///Get a stream of Particle.publish() events.
        ///
        ///Open a stream of [Server Sent Events](http://www.w3.org/TR/eventsource/) for all public events and private events for your devices matching the filter.Note that as of April 2018, the event prefix filter is required. It was optional before.
        ///
        /// - calls: GET /v1/events/:eventPrefix
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/events/temp?access_token=1234"
        ///
        ///
        ///         //Particle example response
        ///     GET /v1/events/temp
        ///     HTTP/1.1 200 OK
        ///     :ok
        ///     
        ///     //sent as event/text
        ///     event: temperature
        ///     data: {
        ///         "data":"25.34",
        ///         "ttl":"60",
        ///         "published_at":"2015-07-18T00:12:18.174Z",
        ///         "coreid":"0123456789abcdef01234567"
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter eventName: Filters the stream to only events starting with the specified prefix. The event prefix filter is required for this endpoint.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
    case getEventStream(eventName: EventName, token: PCAccessToken)
    
        ///Get a stream of device events.
        ///
        ///Open a stream of Server Sent Events for all public and private events for your devices.
        ///
        /// - calls: GET /v1/devices/events/[:eventPrefix]
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/devices/events?access_token=1234"
        ///
        ///         //filtered event stream
        ///     curl "https://api.particle.io/v1/devices/events/temp?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/events/temp
        ///     HTTP/1.1 200 OK
        ///     :ok
        ///
        ///     //sent as event/text
        ///     event: temperature
        ///     data: {
        ///         "data":"25.34",
        ///         "ttl":"60",
        ///         "published_at":"2015-07-18T00:12:18.174Z",
        ///         "coreid":"0123456789abcdef01234567"
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter eventName: Filters the stream to only events starting with the specified prefix. Omit to get all events.
        /// - Parameter deviceID: The device identifier of the device to filter by.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
    case getDeviceEventStream(eventName: EventName?, deviceID: DeviceID, token: PCAccessToken)

        ///Product event stream.
        ///
        ///Open a stream of [Server Sent Events](http://www.w3.org/TR/eventsource/)  for all public and private events for a product.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/events/[:eventPrefix]
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/photon/events?access_token=1234"
        ///
        ///         //Particle example response
        ///     GET /v1/products/photon/events
        ///     HTTP/1.1 200 OK
        ///     :ok
        ///
        ///      event: temperature
        ///      data: {
        ///          "data":"25.34",
        ///          "ttl":"60",
        ///          "published_at":"2015-07-18T00:12:18.174Z",
        ///          "coreid":"0123456789abcdef01234567"
        ///      }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of events:get
        ///Get a stream of Particle.publish() events.
        /// - Parameter eventName: Filters the stream to only events starting with the specified prefix
        /// - Parameter productIDorSlug: The product identifier of the product to filter by or nil if subscribing to all events by the provided event name.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
    case getProductEventStream(eventName: EventName?, productIdOrSlug: ProductID, token: PCAccessToken)
    
        ///Publish a particle event.
        ///
        ///It is possible to receive an event more than once. The most common reason is a lost ACK, which will cause the device to send the event again. Storing a unique identifier in the event payload may help code defensively for this possibility.
        ///It is possible that events will arrive out-of-order. The most common cause is retransmission, but it can also occur because events can flow through different redundant servers, each with slightly difference latency, so it's possible that two event sent rapidly will arrive out-of-order as well. This is common for multi-part webhook responses.
        ///It is possible that even if Particle.publish returns false, the event will still be received by the cloud later. This occurs because the 20-second timeout is reached, so false is returned, but the event is still buffered in Device OS and will be retransmitted if the reconnection to the cloud succeeds.
        ///
        ///Two common ways Particle devices can trigger external services are webhooks and Server-Sent Events (SSE).The SSE event stream works by having your server make an outbound https (encrypted) connection to the Particle API service. This connection is kept open, and if new events arrive, they are immediately passed down this stream. There are a number of advantages to this:
        /// - Works for developer and product event streams.
        /// - Can get all events, or a subset of events by prefix filter.
        /// - Works from a network behind a firewall or NAT typically with no changes required (no port forwarding required).
        /// - You do not need TLS/SSL server certificates for encrypted communication, because the connection is outbound.
        /// - You do not need separate authentication; Particle API tokens are used for authentication.
        /// - It's efficient - the connection only needs to be established and authenticated once.
        ///
        /// While this sounds great, there are some issues that can occur that make it less than ideal for large device fleets and make webhooks more attractive:
        /// - You can only have one server accepting events with SSE. With webhooks you can have multiple servers behind a load balancer for both server redundancy as well as load sharing.
        /// - If the SSE stream fails for any reason, you could end up losing events. It can take up to a minute to detect that this has happened in some cases.
        ///
        /// # SSE    Webhooks
        ///  - Works from behind a firewall
        /// - `Requires a public IP address`
        /// - Encrypted without a SSL certificate
        /// - `Requires a SSL certificate for the server to support https`
        /// - Best if lost events are not critical
        /// - Event delivery is more reliable
        /// - Only allows a single server
        /// - Can use load balancing and redundant servers
        /// When using SSE, it is recommend using the particle-api-js library with node.js, however any language can be used. It is recommend using a good, well-tested SSE library as there are some things to beware of when implementing the SSE protocol:
        /// - The connection can be closed at any time by the SSE server. You must be able to handle this and reconnect.
        /// - The connection can stop receiving data because the TCP connection is losing all packets when crossing the Internet. You can detect this because the SSE client will not get any events or the 60 second ping, and it should try reconnecting. This also means that you could lose up to 60 seconds of events in the case of an Internet outage.
        /// - Beware of excessively reconnecting and rate limits.
        /// - There is a limit of 100 requests to open an SSE connection in each 5 minute period per public IP address. If rate limiting occurs, you will get a 529 error and you must wait before retrying the connection or you will never be able to successfully connect again. There is also a limit of 100 simultaneous SSE connections from each public IP address. This is not separated by device, access token, etc.; it applies to the public IP address the requests come from.Because of the simultaneous connection limit, if you want to subscribe to multiple events, you should establish one SSE connection to handle all events, and filter the results for the events that you want to handle. While this seems less efficient, it is the preferred method because the overhead of handling multiple SSE sessions is far higher than the incremental overhead of sending many events across a single event stream. Using a common prefix to group multiple events that need to be received from a single SSE event stream is also a good technique to use if possible.
        /// 
        /// - Calls: GET /v1/products/:productIdOrSlug/events/[:eventPrefix]
        ///
        ///
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl https://api.particle.io/v1/devices/events \
        ///         -d "name=myevent" \
        ///         -d "data=Hello World" \
        ///         -d "private=true" \
        ///         -d "ttl=60" \
        ///         -d "access_token=1234"
        ///
        ///         //Particle example response
        ///     POST /v1/devices/events
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///         "ok": true
        ///     }
        ///
        ///
        ///````
        ///
        ///
        /// - note: Publishes are not end-to-end confirmed. Even if the Particle.publish returns true, there is no guarantee that any recipient (another device, webhook, or SSE) will receive it.
        /// - Requires: scope of events:send
        /// - Parameter eventName: Filters the stream to only events starting with the specified prefix. The event prefix filter is required for this endpoint.
        /// - Parameter productIDorSlug: The product identifier of the product to filter by or nil if subscribing to all events by the provided event name.
        /// - Parameter data: The String to be sent as the event content.
        /// - Parameter private: If you wish this event to be publicly visible.
        /// - Parameter ttl: How long the event should persist in seconds.
        /// - Parameter token: The representation of a particle access token with appropriate permissions.
    case publishEvent(eventName: EventName, productIDorSlug: ProductID?, data: String?, private: Bool?, ttl: Int?, token: PCAccessToken)
    
        //MARK: - Integrations / WebHooks
        //TODO: Finish
    
        ///Create a webhook.
        ///
        ///A webhook is a flexible type of integration that allows you to interact with a wide variety of external tools and services. Create a webhook either for devices you own as a Particle developer, or for your product fleet. For more info, check out the [webhooks guide](https://docs.particle.io/integrations/webhooks/ "https://docs.particle.io/integrations/webhooks/").
        ///
        /// - calls: POST /v1/integrations
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/integrations?access_token=12345" \
        ///         -d integration_type=Webhook \
        ///         -d event=hello \
        ///         -d url=https://samplesite.com \
        ///         -d requestType=POST
        ///
        ///         //product request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/integrations?access_token=12345" \
        ///         -d integration_type=Webhook \
        ///         -d event=hello \
        ///         -d url=https://samplesite.com \
        ///         -d requestType=POST
        ///
        ///         //Particle example response
        ///     POST /v1/webhooks
        ///     HTTP/1.1 201 Created
        ///
        ///     {
        ///         "ok": true
        ///         "id": "12345",
        ///         "url": "https://samplesite.com",
        ///         "event": "hello",
        ///         "name": "hello for samplesite.com",
        ///         "created_at": "2016-04-28T17:06:33.123Z",
        ///         "hookUrl": "https://api.particle.io/v1/webhooks/12345"
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of integrations:create
        /// - Parameter arguments: PCWebHookIntegrations.CreationArguments struct used to set parameters for the we call.
        /// - Parameter token: A currently active access token.
        /// - Returns: Response Type: PCWebHookIntegrations.CreationResponse
    case createWebhook(arguments: PCWebHookIntegrations.WebhookCreationArguments, token: PCAccessToken)
    
        //MARK: - Docs Done Til Here -----------------------------------------------------------------


    case enableAzureIoTHubintegration
    case enableGoogleCloudPlatformIntegration
    case enableGoogleMapsintegration
    case editWebhook
    case editAzureIoTHubIntegration
    case editGoogleCloudPlatformIntegration
    case editGoogleMapsIntegration
    case getIntegration
    case listIntegrations
    case testAnIntegration
    case deleteAnIntegration
    
    //Doesn't seem to be anything to implement here..
    //Documentation just describes events like disconnect reconnect etc.
    //May need to add an enum in events to select special events and then subscribe.?.
//    case specialDeviceEvents
//    case specialWebhookEvents
    
        //MARK: - Asset Tracking Events
        //TODO: Finish
    
    case trackerLocationEvents
    case enhancedLocationEvents
    case locationPointSchema
    
        //MARK: - Firmware - Done
    
        ///Update device firmware
        ///
        ///Update the device firmware from source or binary
        /// - usage:  PUT /v1/devices/:deviceIdUpdate
        ///
        /// ````BASH
        ///
        ///            //Particle example request
        ///         curl -X PUT "https://api.particle.io/v1/devices/0123456789abcdef01234567?access_token=1234" \
        ///           -F "file=@application.cpp;filename=application.cpp" \
        ///           -F "file1=@lib/my_lib.cpp;filename=lib/my_lib.cpp" \
        ///           -F "file2=@lib/my_lib.h;filename=lib/my_lib.h"
        ///
        ///             //Particle example response
        ///         PUT /v1/devices/0123456789abcdef01234567
        ///         HTTP/1.1 200 OK
        ///
        ///         {
        ///           "ok": true,
        ///           "message": "Update started"
        ///         }
        ///
        ///
        /// ````
        ///
        /// - Parameter deviceId:The id of the device to be flashed
        /// - Parameter version: The firmware version to compile against. Defaults to latest
        /// - Parameter token: A currently active access token.
        /// - Returns: ServerResponses.Standard
    case updateDeviceFirmware(deviceID: DeviceID, version: String = "latest", token: PCAccessToken)
    
    typealias FilePath = String
    
        ///Flash device firmware
        ///
        ///Flash the device firmware from source.
        ///
        /// - calls PUT /v1/devices/:deviceId
        ///
        /// Usage:
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl -X PUT "https://api.particle.io/v1/devices/0123456789abcdef01234567?access_token=1234" \
        ///        -F "file=@application.cpp;filename=application.cpp" \
        ///        -F "file1=@lib/my_lib.cpp;filename=lib/my_lib.cpp" \
        ///        -F "file2=@lib/my_lib.h;filename=lib/my_lib.h"
        ///
        ///         //Particle example response
        ///     PUT /v1/devices/0123456789abcdef01234567
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "id": "0123456789abcdef01234567",
        ///        "status": "Update started"
        ///     }
        ///
        ///````
        ///
        ///
        /// - Parameter deviceID: The id of the device to be flashed.
        /// - Parameter sourceCodePaths: The paths of the source code to be compiled. Upload is done with the source code encoded in multipart/form-data format
        /// - Returns: PCFirmware.FlashResponse
        /// - Parameter token: A currently active access token.
    case flashDeviceWithSourceCode(deviceID: DeviceID, sourceCodePaths: [FilePath], version: String = "latest", token: PCAccessToken)
    
        ///Flash a device with a pre-compiled binary
        ///
        ///Flash the device firmware from binary.
        /// - calls PUT /v1/devices/:deviceId
        ///
        ///Usage:
        ///
        ///
        ///  ```` BASH
        ///
        ///                  //Particle example request:
        ///              curl -X PUT "https://api.particle.io/v1/devices/0123456789abcdef01234567?access_token=1234" \
        ///                  -F file=@my-firmware-app.bin \
        ///                  -F file_type=binary
        ///
        ///
        ///                  //Particle example response:
        ///              PUT /v1/devices/0123456789abcdef01234567
        ///              HTTP/1.1 200 OK
        ///
        ///              {
        ///                  "id": "0123456789abcdef01234567",
        ///                  "status": "Update started"
        ///              }
        ///
        ///  ````
        ///
        ///
        /// - Parameter deviceID: The id of the device to be flashed
        /// - Parameter build_target_version: The firmware version to compile against. Defaults to latest
        /// - Parameter file: The path to the  pre-compiled. Upload is done in binary encoded in multipart/form-data format
        /// - Parameter file_type: Set to binary to indicate that you are uploading a binary and not source code. Happens in background.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCFirmware.FlashResponse
    case flashDeviceWithPreCompiledBinary(deviceID: DeviceID, build_target_version: String = "latest", file: FilePath, token: PCAccessToken)
    
        ///Compile source code
        ///
        ///Compile source code into a binary for a device.
        ///
        /// - callls: POST /v1/binaries
        ///
        ///
        /// ````BASH
        ///
        ///           //particle example request:
        ///        curl -X POST "https://api.particle.io/v1/binaries?access_token=1234" \
        ///        -F platform_id=6 \
        ///        -F "file=@application.cpp;filename=application.cpp" \
        ///        -F "file1=@lib/my_lib.cpp;filename=lib/my_lib.cpp" \
        ///        -F "file2=@lib/my_lib.h;filename=lib/my_lib.h"
        ///
        ///           //particle example response:
        ///        POST /v1/binaries
        ///        HTTP/1.1 200 OK
        ///
        ///        {
        ///           "ok": true,
        ///           "binary_id": "5734a5d4a71c2601243809e6",
        ///           "binary_url": "/v1/binaries/5734a5d4a71c2601243809e6",
        ///           "build_target_version": "1.5.1",
        ///           "expires_at": "2016-05-13T15:48:27.997Z",
        ///           "sizeInfo": "   text\t   data\t    bss\t    dec\t    hex\tfilename\n  91780\t    952\t   9368\t 102100\t  18ed4\t"
        ///        }
        ///
        /// ````
        ///
        ///
        /// - Parameter filePath: The path to the source code encoded in multipart/form-data format.
        /// - Parameter platform_id: The platform ID to target the compilation.
        /// - Parameter product_id: The product to target for compilation
        /// - Parameter build_target_version: The firmware version to compile against. Defaults to "latest".
        /// - Parameter token: A currently active access token.
        /// - Returns: PCFirmware.CompilationResponse
    case compileSourceCode(filePaths: [FilePath], platform_id: PlatformID, product_id: ProductID, build_target_version: String = "latest", token: PCAccessToken)
    
        ///List firmware build targets
        ///
        ///Lists the firmware versions for all platforms that can be used as build targets during firmware compilation.
        ///
        /// - calls: GET /v1/build_targets
        ///
        ///
        /// ````BASH
        ///
        ///               //Particle example request:
        ///           curl "https://api.particle.io/v1/build_targets"
        ///
        ///               //Particle example response
        ///           PUT /v1/build_targets
        ///           HTTP/1.1 200 OK
        ///
        ///           {
        ///           "targets": [
        ///               {
        ///               "platforms": [
        ///                   0,
        ///                   10,
        ///                   8,
        ///                   6
        ///               ],
        ///               "prereleases": [],
        ///               "firmware_vendor": "Particle",
        ///               "version": "0.6.1"
        ///               }
        ///           ],
        ///           "platforms": {
        ///               "Core": 0,
        ///               "Photon": 6,
        ///               "P1": 8,
        ///               "Electron": 10
        ///           },
        ///           "default_versions": {
        ///               "0": "0.7.0",
        ///               "6": "2.3.1",
        ///               "8": "2.3.1",
        ///               "10": "2.3.1"
        ///           }
        ///        }
        ///
        /// ````
        ///
        ///
        /// - note: As of April, 2023, an access token is no longer required to call this API.
        ///
        /// - Parameter featured: When true, show most relevant (featured) build targets only.
        /// - Returns: PCFirmware.ListResponse
    case listFirmwareBuildTargets(featured: Bool = false)
    
        ///Lock product device.
        ///
        ///Locks a product device to a specific version of product firmware. This device will download and run this firmware if it is not already running it the next time it connects to the cloud. You can optionally trigger an immediate update to this firmware for devices that are currently online.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
        ///
        ///
        ///````BASH
        ///
        ///            //Particle example request
        ///        curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/devices/12345 \
        ///           -d desired_firmware_version=1 \
        ///           -d flash=true \
        ///           -d access_token=123abc
        ///
        ///            //Particle example response
        ///        PUT /v1/products/:productIdOrSlug/devices/12345
        ///        HTTP/1.1 200 OK
        ///        {
        ///           "id": "0123456789abcdef01234567",
        ///           "desired_firmware_version": 1,
        ///           "updated_at": "2017-03-10T20:21:49.059Z"
        ///        }
        ///
        ///
        ///````
        ///
        ///
        /// - Requires: Scope of  devices:update
        /// - Parameter deviceId:The id of the device to be flashed
        /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
        /// - Parameter desired_firmware_version: The firmware version the device should be locked to
        /// - Parameter flash: Set to true to immediately flash to a device. Will only successfully deliver the firmware update if the device is currently online and connected to the cloud.
        /// - Parameter token: A currently active access token with required scope.
        /// - Returns: PCFirmware.DeviceFirmareLockResponse
    case lockProductDevice(deviceID: DeviceID, productIdOrSlug: ProductID, desired_firmware_version: String, flash: Bool, token: PCAccessToken)
    
        ///Unlock product device
        ///
        ///Unlocks a product device from receiving and running a specific version of product firmware. The device will now be eligible to receive released firmware in the product.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
        ///
        ///
        ///````BASH
        ///
        ///
        ///            //Particle example request
        ///         curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/devices/12345 \
        ///            -d desired_firmware_version=null \
        ///            -d access_token=123abc
        ///
        ///           //Particle example response
        ///         PUT /v1/products/:productIdOrSlug/devices/12345
        ///         HTTP/1.1 200 OK
        ///
        ///         {
        ///            "id": "0123456789abcdef01234567",
        ///            "desired_firmware_version": null
        ///            "updated_at": "2017-03-10T20:21:49.059Z"
        ///         }
        ///
        ///
        ///````
        ///
        ///
        /// - Requires; Scope of devices:update
        /// - Parameter deviceId:The id of the device to be flashed
        /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
        /// - Parameter desired_firmware_version: Automatically set to `null` to unlock the device
        /// - Parameter token: A currently active access token.
        /// - Returns: PCFirmware.DeviceFirmareLockResponse
    case unlockProductDevice(deviceID: DeviceID, productIdOrSlug: ProductID, token: PCAccessToken)
    
        ///Mark product development device
        ///
        ///Mark a device in a product fleet as a development device. Once marked as a development device, it will opt-out from receiving automatic product firmware updates. This includes both locked firmware as well as released firmware.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
        ///
        ///````BASH
        ///
        ///
        ///            //Particle example request
        ///       curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/devices/12345 \
        ///          -d development=true \
        ///          -d access_token=123abc
        ///
        ///            //Particle example response
        ///       PUT /v1/products/:productIdOrSlug/devices/12345
        ///       HTTP/1.1 200 OK
        ///
        ///       {
        ///          "id": "0123456789abcdef01234567",
        ///          "development": true
        ///          "updated_at": "2017-03-10T20:21:49.059Z"
        ///       }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:update
        /// - Parameter deviceId:The id of the device to be flashed
        /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
        /// - Parameter development: Set to true to mark as development device
        /// - Parameter token: A currently active access token.
        /// - Requires: PCFirmware.MarkDeviceForDevelopmentResponse
    case markProductDevelopmentDevice(deviceID: DeviceID, productIdOrSlug: ProductID, development: Bool, token: PCAccessToken)
    
        ///Unmark product development device
        ///
        ///Unmark a device in a product fleet as a development device. Once unmarked, the device will opt-in to receiving automatic product firmware updates. This includes both locked firmware as well as released firmware.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
        ///
        /// ````BASH
        ///
        ///            //Particle example request
        ///      curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/devices/12345 \
        ///        -d development=false \
        ///        -d access_token=123abc
        ///
        ///            //Particle example response
        ///      PUT /v1/products/:productIdOrSlug/devices/12345
        ///      HTTP/1.1 200 OK
        ///
        ///      {
        ///         "id": "0123456789abcdef01234567",
        ///         "development": false
        ///         "updated_at": "2017-03-10T20:21:49.059Z"
        ///      }
        ///
        ///
        /// ````
        ///
        /// - Requires: Scope of devices:update
        /// - Parameter deviceId:The id of the device to be flashed
        /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
        /// - Parameter development: Set to true to mark as development device
        /// - Parameter token: A currently active access token.
        /// - Requires: PCFirmware.MarkDeviceForDevelopmentResponse
    case unmarkProductDevelopmentDevice(deviceID: DeviceID, productIdOrSlug: ProductID, development: Bool, token: PCAccessToken)
    
        //MARK: - Product Firmware - Done
    
        ///Get product firmware
        ///
        ///Get a specific version of product firmware.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///      curl "https://api.particle.io/v1/products/:productIdOrSlug/firmware/1?access_token=1234"
        ///
        ///            //Particle example response
        ///
        ///      GET /v1/products/:productIdOrSlug/firmware/1
        ///      HTTP/1.1 200 OK
        ///
        ///      {
        ///          "_id":"58c09bc7df2b9a4d223d9c22",
        ///          "version":1,
        ///          "title":"My Firmware",
        ///          "description":"Sample firmware description",
        ///          "name":"firmware.bin",
        ///          "size":7952,
        ///          "product_default":false,
        ///          "uploaded_on":"2017-03-09T00:03:19.181Z",
        ///          "product_id":295,
        ///          "mandatory":false,
        ///          "uploaded_by":{
        ///              "username":"jeff@particle.io",
        ///              ...
        ///          }
        ///      }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of firmware:get
        /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
        /// - Parameter version: The firmware version to compile against. Defaults to latest
        /// - Parameter token: A currently active access token.
        /// - Returns: PCProductFirmware.ProductFirmwareList
    case getProductFirmware(productIdOrSlug: ProductID, version: String, token: PCAccessToken)
    
        ///ListAllProductFirmwares
        ///
        ///List all versions of product firmware
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/firmware
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/firmware?access_token=1234"
        ///
        ///            //Particle example response
        ///
        ///     GET /v1/products/:productIdOrSlug/firmware
        ///     HTTP/1.1 200 OK
        ///    
        ///     [
        ///         {
        ///         "_id":"58c09bc7df2b9a4d223d9c22",
        ///         "version":1,
        ///         "title":"My Firmware",
        ///         "description":"Sample firmware description",
        ///         "name":"firmware.bin",
        ///         "size":7952,
        ///         "product_default":false,
        ///         "uploaded_on":"2017-03-09T00:03:19.181Z",
        ///         "product_id":295,
        ///         "uploaded_by":{
        ///             "username":"jeff@particle.io",
        ///         },
        ///         "groups":{
        ///             ["asia","europe","america"],
        ///         },
        ///         "device_count":200
        ///         },
        ///         ...
        ///     ]
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of firmware:list
        /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCProductFirmware.ProductFirmwareList
    case listAllProductFirmwares(productIdOrSlug: ProductID, token: PCAccessToken)
    
        ///Upload product firmware
        ///
        ///Upload a new firmware version to a product.
        ///
        /// - calls: POST /v1/products/:productIdOrSlug/firmware
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/firmware?access_token=1234" \
        ///        -F file=@firmware.bin \
        ///        -F version=1 \
        ///        -F title=firmware
        ///
        ///            //Particle example response
        ///
        ///     POST /v1/products/:productIdOrSlug/firmware
        ///     HTTP/1.1 201 Created
        ///     {
        ///        "_id":"58c09bc7df2b9a4d223d9c22",
        ///        "version":1,
        ///        "title":"My Firmware",
        ///        "description":"Sample firmware description",
        ///        "name":"firmware.bin",
        ///        "size":7952,
        ///        "current":false
        ///        "uploaded_on":"2017-03-09T00:03:19.181Z",
        ///        "product_id":295,
        ///        "uploaded_by":{
        ///            "username":"jeff@particle.io",
        ///            ...
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of firmware:create
        /// - Parameter PCProductFirmware.UploadArguments: The arguments to be supplied to the server.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCProductFirmware.ProductFirmwareList
    case uploadProductFirmware(productID: ProductID, path: String, arguments: PCProductFirmware.UploadArguments, token: PCAccessToken)
       
        ///Edit product firmware
        ///
        ///Edit a specific product firmware version
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/firmware/:version
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/firmware/1 \
        ///        -d title="New title" \
        ///        -d description="New description" \
        ///        -d access_token=1234
        ///
        ///            //Particle example response
        ///
        ///     PUT /v1/products/:productIdOrSlug/firmware/1
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "_id":"58c09bc7df2b9a4d223d9c22",
        ///        "version":1,
        ///        "title":"New title",
        ///        "description":"New description",
        ///        "name":"firmware.bin",
        ///        "size":7952,
        ///        "current":false
        ///        "uploaded_on":"2017-03-09T00:03:19.181Z",
        ///        "product_id":295,
        ///        "uploaded_by":{
        ///            "username":"jeff@particle.io",
        ///            ...
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of firmware:update
        /// - Parameter Arguments: The arguments to be supplied to the server.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCProductFirmware.ProductFirmwareList
    case editProductFirmware(productID: ProductID, arguments: PCProductFirmware.EditArguments, token: PCAccessToken)
    
        ///Download firmware binary
        ///
        ///Retrieve and download the original binary of a version of product firmware.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version/binary
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/firmware/1/binary?access_token=1234"
        ///
        ///            //Particle example response
        ///
    
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of firmware.binary:get
        /// - Parameter PCProductFirmware.UploadArguments: The arguments to be supplied to the server.
        /// - Parameter version: Version number of firmware to retrieve
        /// - Parameter token: A currently active access token.
        /// - Returns: The binary file of the requested product firmware version
    case downloadFirmwareBinary(productIdOrSlug: ProductID, version: Int, token: PCAccessToken)
    
        ///Release product firmware
        ///
        ///Release a version of firmware to the fleet of product devices. When releasing as the product default, all non-development devices that are not individually locked to a version of product firmware will automatically download and run this version of firmware the next time they handshake with the cloud.You can also release firmware to specific groups for more fine-grained firmware management.Note: Before releasing firmware for the first time, the firmware must be running on at least one device in your product fleet that has successfully re-connected to the Particle cloud.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/firmware/release
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/firmware/release \
        ///        -d version=1 \
        ///        -d groups[]="foo&groups[]=bar&groups[]=baz"
        ///        -d access_token=1234
        ///
        ///            //Particle example response
        ///
        ///     PUT /v1/products/:productIdOrSlug/firmware/release
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "updated_at": "2017-07-20T23:53:15.298Z",
        ///        "version":1,
        ///        "title":"New title",
        ///        "size":7952,
        ///        "product_default":false,
        ///        "uploaded_on":"2017-03-09T00:03:19.181Z",
        ///        "product_id":295,
        ///        "uploaded_by":{
        ///            "username":"jeff@particle.io",
        ///        },
        ///        "groups": ["foo", "bar", "baz"],
        ///        "intelligent": true
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of firmware:release
    /// - Parameter product: The productID to apply the firmware to .
        /// - Parameter arguments: PCProductFirmware.ReleaseArguments
        /// - Parameter token: A currently active access token.
        /// - Returns: PCProductFirmware.ProductFirmwareList
    case releaseProductFirmware(productID: ProductID, arguments: PCProductFirmware.ReleaseArguments, token: PCAccessToken)
    
        ///Delete unreleased firmware binary
        ///
        ///Delete a version of product firmware that has never been released.
        ///
        /// - calls: DELETE /v1/products/:productIdOrSlug/firmware/:version
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl -X DELETE "https://api.particle.io/v1/products/:productIdOrSlug/firmware/1?access_token=1234"
        ///
        ///            //Particle example response
        ///     DELETE /v1/products/:productIdOrSlug/firmware/1
        ///     HTTP/1.1 204 No Content
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of firmware:remove
        /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
        /// - Parameter version:
        /// - Parameter token: A currently active access token.
        /// - Returns: URLRequestResponse
    case deleteUnreleasedFirmwareBinary(productIdOrSlug: ProductID, version: Int, token: PCAccessToken)
    
        //MARK: - Libraries - Needs Better Documentation
        /// List Libraries
        ///
        ///List firmware libraries. This includes private libraries visibile only to the user.
        /// curl "https://api.particle.io/v1/libraries?scope=official&sort=name&access_token=1234"
        /// - Parameter arguments: PCLibrary.LibraryListArguments see structs inline docs.
        /// - Parameter token: A currently active access token.
        /// - Returns:  LibraryListResponse
    case listLibraries(arguments: PCLibrary.LibraryListArguments, token: PCAccessToken)
    
        ///Get library details
        ///
        ///Get details for a firmware library.
        ///curl "https://api.particle.io/v1/libraries/internetbutton?access_token=1234"
        /// - Parameter arguments: PCLibrary.DetailArguments see structs inline docs.
        /// - Parameter token: A currently active access token.
        /// - Returns:  LibraryListResponse
    case getLibraryDetails(arguments: PCLibrary.DetailArguments, token: PCAccessToken)
    
        ///Get details for all versions of a firmware library.
        /// -  calls GET /v1/libraries/:libraryName:/versions
        ///
        /// - Parameter libraryName: Name of library to retrieve (case insensitive)
        /// - Parameter scope: Which subset of versions to get.
        /// - Parameter token: A currently active access token.
        /// - Returns:  LibraryListResponse
    case getLibraryVersions(libraryName: String, version: PCLibrary.VersionFilter, token: PCAccessToken)
    
        ///Upload library version
        ///
        ///Upload a private version of a firmware library. If the library doesn't exist it is created.The library will be validated and an error response returned if invalid.
        ///
        /// - calls: POST /v1/libraries/:libraryName:
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///    curl -F "archive=@library.tar.gz" "https://api.particle.io/v1/libraries?access_token=1234"    ///
        ///
        ///            //Particle example response
        ///    POST /v1/libraries
        ///    HTTP/1.1 201 Created
        ///    {
        ///       "data": {
        ///           "type": "libraries",
        ///           "id": "testlib43",
        ///           "links": {
        ///               "download": "https://library-archives.particle.io/libraries/testlib43/testlib43-1.0.2.tar.gz"
        ///           },
        ///           "attributes": {
        ///               "name": "testlib43",
        ///               "version": "1.0.2",
        ///               "license": "MIT",
        ///               "author": "JV",
        ///               "sentence": "one sentence description of this library",
        ///               "url": "the URL of the project, like https://github.com/mygithub_user/my_repo",
        ///               "repository": "mygithub_user/my_repo",
        ///               "architectures": [],
        ///               "visibility": "private"
        ///           }
        ///       }
        ///    }
        ///
        ///            //Particle example error
        ///     POST /v1/libraries
        ///     HTTP/1.1 400 Bad Request
        ///     {
        ///        "errors": [
        ///            {
        ///               "message": "This version is not valid. Version must be greater than or equal to 1.0.2"
        ///            }
        ///        ]
        ///     }
        ///
        ///
        ///
        ///````
        ///
        /// - Parameter libraryName: Name of library to upload (case insensitive)
        /// - Parameter filePath: The path to  tar-gzip archive of all the files for the library. The meta data like name and version is taken from library.properties. [See the example library](https://github.com/particle-iot/uber-library-example) for other files to include.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCLibrary The library version created. Described in [Get library details](https://docs.particle.io/reference/cloud-apis/api/#get-library-details)
    case uploadLibraryVersion(libraryName: String, filePath: FilePath, token: PCAccessToken)
    
        ///Make a library version public.
        ///
        ///Make the latest private version of a firmware library public. You must do this before others can access your uploaded library.
        ///
        /// - calls: PATCH /v1/libraries/:libraryName:
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///    - curl -X PATCH -d "visibility=public" "https://api.particle.io/v1/libraries/testlib43?access_token=1234"
        ///
        ///            //Particle example response
        ///     PATCH /v1/libraries/testlib43
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///     "data": {
        ///         "type": "libraries",
        ///         "id": "testlib43",
        ///         "links": {
        ///             "download": "https://library-archives.particle.io/libraries/testlib43/testlib43-1.0.2.tar.gz"
        ///         },
        ///         "attributes": {
        ///             "name": "testlib43",
        ///             "version": "1.0.2",
        ///             "license": "MIT",
        ///             "author": "JV",
        ///             "sentence": "one sentence description of this library",
        ///             "url": "the URL of the project, like https://github.com/mygithub_user/my_repo",
        ///             "repository": "mygithub_user/my_repo",
        ///             "architectures": [],
        ///             "visibility": "public"
        ///         }
        ///     }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Parameter libraryName: Name of library to retrieve (case insensitive)
        /// - Parameter visibility: Must be set to public to publish a library.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCProductFirmware.ProductFirmwareList
    case makeLibraryVersionPublic(libraryName: String, visibility: String = "public", token: PCAccessToken)
    
        //MARK: - Products - Needs Better Documentation
    
        /// - Requires: scope of products_list
        /// - Parameter token: A currently active access token scoped to products:list
    case listProducts(token: PCAccessToken)
    
        /// - Requires: scope of products_get
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to products:get
    case retrieveProduct(productIDorSlug: ProductID, token: PCAccessToken)
    
        /// - Requires: scope of teams_users_list
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to teams.users:list
    case listTeamMembers(productIDorSlug: ProductID, token: PCAccessToken)
    
        /// - Requires: scope of teams_users_invite
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter username: String the username of the invitee. Must be a valid email associated with an Particle user
        /// - Parameter role: The role for the invited user. One of Administrator, Developer, View-only, Support.
        /// - Parameter token: A currently active access token scoped to teams.users:invite
        /// - Returns Response Type: InviteTeamMemberResponse
    case inviteTeamMember(productIDorSlug: ProductID, username: String, role: PCTeamMemberRoles, token: PCAccessToken)
    
        /// - Requires: scope of teams_users_invite
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter friendlyName: A friendly name used to recognise the user.
        /// - Parameter scope: List of scopes to grant for this user.
        /// - Parameter token: A currently active access token scoped to teams.users:invite
    case createAnAPIuser(productIdOrSlug: ProductID, friendlyName: String, scope:[UserPermissions], token: PCAccessToken)
    
        /// - Requires: scope of teams_users_update
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter username: String the username of the invitee. Must be a valid email associated with an Particle user
        /// - Parameter token: A currently active access token scoped to teams.users:update
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs
    case updateTeamMember(productIDorSlug: ProductID, username: String, token: PCAccessToken)
    
        /// - Requires: scope of  teams_users_remove
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter username: String the username of the invitee. Must be a valid email associated with an Particle user
        /// - Parameter token: A currently active access token scoped to teams.users:remove
        /// - Returns: Response Type: PCProduct.DeleteTeamMemberResponse
    case removeTeamMember(productIDorSlug: ProductID, username: String, token: PCAccessToken)
    
        //MARK: - Device Groups - Done
    
        ///Get device group
        ///
        ///Retrieve full info on a specific product group, including its device count.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/groups/:groupName
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/groups/group_a?access_token=1234"
        ///
        ///            //Particle example response
        ///     GET /v1/products/:productIdOrSlug/groups/group_a
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "group": {
        ///            "name":"group_a",
        ///            "description":"first group A",
        ///            "color":"#e74c3c",
        ///            "fw_version":1,
        ///            "device_count":3
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of groups:get
        /// - Parameter productIdOrSlug: Product ID or slug
        /// - Parameter groupName: The group name to fetch
        /// - Parameter token: A currently active access token.
        /// - Returns: [PCDeviceGroup]
    case getDeviceGroup(productIdOrSlug: ProductID, groupName: GroupName, token: PCAccessToken)
    
        ///List device groups
        ///
        ///List the group objects that exist in the product. Optionally, filter by group name (partial match).
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/groups
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl "https://api.particle.io/v1/products/:productIdOrSlug/groups?name=gr&access_token=1234"
        ///
        ///            //Particle example response
        ///     GET /v1/products/:productIdOrSlug/groups?name=gr&access_token=1234
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "groups": [
        ///            {
        ///               "name":"group_a",
        ///               "description":"the A group",
        ///               "fw_version":3,
        ///               "color":"#34495e"
        ///               },
        ///               {
        ///               "name":"group_b",
        ///               "description": "the B group",
        ///               "color":"#34495e"
        ///            }
        ///        ]
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of groups:list
        /// - Parameter productIdOrSlug: Product ID or slug
        /// - Parameter name: String to filter group names by. Partial string matching.
        /// - Parameter token: A currently active access token.
        /// - Returns: [PCDeviceGroup]
    case listDeviceGroups(productIdOrSlug: ProductID, name: String?, token: PCAccessToken)
    
        ///Create device group
        ///
        ///Create a new device group withinin a product
        ///
        /// - calls: POST /v1/products/:productIdOrSlug/groups
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///    curl https://api.particle.io/v1/products/:productIdOrSlug/groups \
        ///       -d name=group_a \
        ///       -d description="the A group" \
        ///       -d color="#34495e" \
        ///       -d access_token=123abc
        ///
        ///            //Particle example response
        ///    POST /v1/products/:productIdOrSlug/groups
        ///    HTTP/1.1 201 Created
        ///    
        ///    {
        ///       "group": {
        ///           "name": "group_a",
        ///           "description": "the A group",
        ///           "color": "#34495e"
        ///       }
        ///    }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of groups:create
        /// - Parameter productIdOrSlug: Product ID or slug
        /// - Parameter name: The name of the group. Must only contain lowercase letters, numbers, dashes, and underscores.
        /// - Parameter color: A hex value representing of the color displayed next to the group tag on the Console
        /// - Parameter description: String A description of the group
        /// - Parameter token: A currently active access token.
        /// - Returns: PCDeviceGroup
    case createDeviceGroup(productIdOrSlug: ProductID, name: GroupName, color: Int?, description: String?, token: PCAccessToken)
    
        ///Edit device group
        ///
        ///Edit attributes of a specific device group. You must pass one of name, color, or description.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/groups/:groupName
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/groups/group_a \
        ///        -d name=double_agent \
        ///        -d access_token=1234
        ///
        ///            //Particle example response
        ///     PUT /v1/products/:productIdOrSlug/groups/group_a
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "group": {
        ///            "name":"double_agent",
        ///            "description":"group description",
        ///            "color":"#e74c3c",
        ///            "fw_version":1,
        ///            "device_count":3
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of groups:update
        /// - Parameter productIdOrSlug: Product ID or slug
        /// - Parameter groupName: The name of the group to edit
        /// - Parameter name: Provide a new group name
        /// - Parameter color: The new color for the group. A hex value representing of the color displayed next to the group tag on the Console
        /// - Parameter description: The new description of the group
        /// - Parameter token: A currently active access token.
        /// - Returns: PCDeviceGroup
    case editDeviceGroup(productIdOrSlug: ProductID, groupName: GroupName, newName: GroupName?, color: Int?, description: String?, token: PCAccessToken)
    
        ///Delete device group
        ///
        ///Delete device group. All devices that belong to this group will be removed from the deleted group.
        ///
        /// - calls: DELETE /v1/products/:productIdOrSlug/groups/:groupName
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl -X DELETE https://api.particle.io/v1/products/:productIdOrSlug/groups/group_a \
        ///        -d access_token=1234
        ///
        ///            //Particle example response
        ///     DELETE /v1/products/:productIdOrSlug/groups/group_a
        ///     HTTP/1.1 204 NO CONTENT
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of groups:remove
        /// - Parameter productIdOrSlug: Product ID or slug
        /// - Parameter groupName: The group name to delete
        /// - Parameter token: A currently active access token.
        /// - Returns: URLRequestResponse only
    case deleteDeviceGroup(productIdOrSlug: ProductID, groupName: GroupName, token: PCAccessToken)
    
        ///Assign groups to a device
        ///
        ///Update group memberships for an individual device. This is an absolute endpoint, meaning that regardless of previous group memberships, the group names passed to this endpoint will be the ones assigned to the device.If you pass a group name that does not yet exist, it will be created and assigned to the device.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/devices/12345 \
        ///        -d groups[]="testing" \
        ///        -d access_token=123abc
        ///
        ///     curl -X PUT https://api.particle.io/v1/products/:productIdOrSlug/devices/12345 \
        ///        -d groups[]="europe&groups[]=asia" \
        ///        -d access_token=123abc
        ///
        ///            //Particle example response
        ///     PUT /v1/products/:productIdOrSlug/devices/12345
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "id": "0123456789abcdef01234567",
        ///        "groups": ["europe", "asia"]
        ///        "updated_at": "2017-03-10T20:21:49.059Z"
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:update
        /// - Parameter deviceId: Device ID.
        /// - Parameter productIdOrSlug: Product ID or slug.
        /// - Parameter groups: Array of group names.
        /// - Parameter token: A currently active access token.
        /// - Returns: PCDeviceGroup.AssignResponse
    case assignGroupsToDevice(deviceId: DeviceID, productIdOrSlug: ProductID, groups: [GroupName], token: PCAccessToken)
    
        ///Batch assign groups to devices
        ///
        ///Assign groups to devices in a product as a batch action. Groups can either be added or removed from all devices passed to the endpoint.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/devices
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl -X PUT "https://api.particle.io/v1/products/:productIdOrSlug/devices?access_token=1234" \
        ///        -H "Content-Type: application/json" \
        ///        -d '{"action": "groups", "devices": ["123", "456"], "metadata": {"add": ["foo"]}}'
        ///
        ///            //Particle example response
        ///     PUT /v1/products/:productIdOrSlug/devices
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "ok": true
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of devices:update
        /// - Parameter productIdOrSlug: Product ID or slug.
        /// - Parameter arguments: PCDeviceGroup.BatchArguments
        /// - Parameter token: A currently active access token.
        /// - Returns: ServerOkResponse
    case batchAssignGroupsToDevices(productIdOrSlug: ProductID, token: PCAccessToken)
    
        ///Impact of taking action
        ///
        ///Understand the number of devices that would receive an over-the-air update as a result of taking an action related to device groups.Currently, this endpoint supports understanding the impact of releasing/unreleasing firmware to one or more device groups. Pass edit_groups_for_firmware as the action parameter when calling the endpoint.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/impact
        ///
        /// Example Usage:
        ///````BASH
        ///
        ///            //Particle example request
        ///     curl https://api.particle.io/v1/products/:productIdOrSlug/impact?\
        ///        &action=edit_groups_for_firmware\
        ///        &groups=asia,europe\
        ///        &firmware_version=3\
        ///        &product_default=false\
        ///        &access_token=1234
        ///
        ///            //Particle example response
        ///     GET /v1/products/:productIdOrSlug/impact
        ///     HTTP/1.1 200 OK
        ///    
        ///     {
        ///        devices: {
        ///           firmware_update: {
        ///              total: 123,
        ///              by_version: [
        ///                  {
        ///                     version: 1,
        ///                     total: 25
        ///                  },
        ///                  {
        ///                     ...
        ///                  }
        ///              ]
        ///           }
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of groups.impact:get
        /// - Parameter productIdOrSlug: Product ID or slug.
        /// - Parameter arguments: PCDeviceGroup.GroupImpactArguments
        /// - Parameter token: A currently active access token.
        /// - Returns: PCDeviceGroup.GroupImpactResponse
    case impactOfTakingAction(productIdOrSlug: ProductID, arguments: PCDeviceGroup.GroupImpactArguments, token: PCAccessToken)
    
        //MARK: - Asset Tracking - Needs helper implementation
    
        ///Query location for devices within a product
        ///
        ///Get latest or historical location data for devices. Date range and bounding box can be specified to narrow the query.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/location
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///         //Historical location request
        ///     curl "https://api.particle.io/v1/products/1234/locations?access_token=abc123&rect_bl=30.5,30.0&rect_tr=36.2,35.6&date_range=2020-12-05T20:00:00Z,2020-12-05T20:07:39Z&device_name=service-truck"
        ///
        ///         //Last known location request
        ///     curl "https://api.particle.io/v1/products/1234/locations?access_token=abc123&rect_bl=30.5,30.0&rect_tr=36.2,35.6"
        ///
        ///         //Particle example response
        ///
        ///         //Historical events response
        ///     GET https://api.particle.io/v1/products/1234/locations
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///     "locations": [{
        ///         "device_id": "1234567890abcdef",
        ///         "product_id": 343,
        ///         "device_name" : "service-truck7",
        ///         "groups": ["us-east", "trucks"],
        ///         "gps_lock": true,
        ///         "last_heard": "2020-12-05T20:06:12Z",
        ///         "timestamps": [
        ///             "2020-12-05T20:03:40Z",
        ///             "2020-12-05T20:04:23Z",
        ///             "2020-12-05T20:05:44Z",
        ///             "2020-12-05T20:06:12Z",
        ///         ],
        ///         "online": false,
        ///         "geometry": {
        ///             "type": "LineString",
        ///             "coordinates": [[
        ///                 34.518699645996094,
        ///                 31.504855323809403
        ///             ],[
        ///                 34.528699645996094,
        ///                 31.604855323809403
        ///             ],[
        ///                 34.538699645996094,
        ///                 31.704855323809403
        ///             ],[
        ///                 34.548699645996094,
        ///                 31.804855323809403
        ///             ]]
        ///         }
        ///     }, {
        ///         "device_id": "deadbeef123456",
        ///         "product_id": 343,
        ///         "device_name": "service-truck11",
        ///         "groups": ["us-east"],
        ///         "gps_lock": true,
        ///         "last_heard": "2020-12-05T20:06:12Z",
        ///         "timestamps": [
        ///             "2020-12-05T20:04:23Z",
        ///             "2020-12-05T20:05:44Z",
        ///             "2020-12-05T20:06:12Z",
        ///         ],
        ///         "online": true,
        ///         "geometry": {
        ///             "type": "LineString",
        ///             "coordinates": [[
        ///                 33.518699645996094,
        ///                 30.504855323809403
        ///             ], [
        ///                 33.528699645996094,
        ///                 30.604855323809403
        ///             ], [
        ///                 33.538699645996094,
        ///                 30.704855323809403
        ///             ]]
        ///         },
        ///     }],
        ///        "meta": {
        ///            "page" : 1,
        ///            "per_page" : 20,
        ///            "total_pages" : 5,
        ///            "devices_found" : 100,
        ///        }
        ///     }
        ///
        ///             //Last known location response
        ///     GET https://api.particle.io/v1/products/1234/locations
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///     "locations": [{
        ///         "device_id": "1234567890abcdef",
        ///         "product_id": 343,
        ///         "device_name" : "deploy-truck32",
        ///         "gps_lock": true,
        ///         "last_heard": "2020-12-07T21:07:12Z",
        ///         "groups": ["us-east", "trucks"],
        ///         "timestamps": [
        ///             "2020-12-07T21:07:12Z",
        ///         ],
        ///         "geometry": {
        ///             "type": "Point",
        ///             "coordinates": [
        ///                 34.518699645996094,
        ///                 31.504855323809403
        ///             ]
        ///         }
        ///     }, {
        ///         "device_id": "deadbeef123456",
        ///         "product_id": 343,
        ///         "groups": ["us-east"],
        ///         "device_name": "service-truck11",
        ///         "timestamp": "2020-12-07T21:07:12Z",
        ///         "gps_lock": true,
        ///         "last_heard": "2020-12-07T21:07:12Z",
        ///         "geometry": {
        ///             "type": "Point",
        ///             "coordinates": [
        ///                 33.548699645996094,
        ///                 30.804855323809403
        ///             ]
        ///         },
        ///     }],
        ///        "meta": {
        ///            "page" : 1,
        ///            "total_pages" : 1,
        ///            "per_page" : 20,
        ///            "devices_found" : 2,
        ///        }
        ///     }
        ///
        ///````
        ///
        /// - Requires: Scope of locations:get
        /// - note: Server responds with AssetTracking.LocationResponse struct or a PCError
        /// - Parameter arguments: struct of AssetTracking.LocationArguments encapsulating the required and optional arguments.
        /// - Parameter token: A currently active access token scoped to locations:get
    case queryLocationForDevicesWithinProduct(arguments: AssetTracking.LocationListArguments, token: PCAccessToken)
    
        ///Query location for a specific device within a product
        ///
        ///Get last known or historical location data for one device. Date range and bounding box can be specified to narrow down the query. Properties and custom data will be returned by default.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/location/:deviceId
        ///
        ///
        ///Example Usage:
        ///
        ///````swift
        ///
        ///         let resource = CloudResource.requestForResource(
        ///                           queryLocationForOneDeviceWithinProduct(
        ///                              productIDorSlug: .myProductID,
        ///                              deviceID: .myDeviceID,
        ///                              dateRange:"2020-12-05T20:00:00Z,2020-12-05T20:07:39Z",
        ///                              rect_bl: "10.5,11",
        ///                              rect_tr: "11.0,11.5",
        ///                              token: AnAccessTokenWithRequiredUserScope
        ///                           )
        ///                        )
        ///                        //Send resource to Particle cloud to process
        ///
        ///````
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///       curl "https://api.particle.io/v1/products/1234/locations/123456?access_token=abc123&rect_bl=10.5,11&rect_tr=11.0,11.5&date_range=2020-12-05T20:00:00Z,2020-12-05T20:07:39Z"
        ///
        ///         //Particle example response
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///     "location": {
        ///         "device_id": "1234567890abcdef",
        ///         "device_name" : "ice-cream-truck3",
        ///         "product_id": 343,
        ///         "gps_lock" : true,
        ///         "last_heard" : "2020-12-05T20:06:120Z",
        ///         "groups": ["us-east", "truck"],
        ///         "timestamps": [
        ///             "2020-12-05T20:03:40Z",
        ///             "2020-12-05T20:04:23Z",
        ///             "2020-12-05T20:05:44Z",
        ///             "2020-12-05T20:06:120Z"
        ///         ],
        ///         "online": true,
        ///         "geometry": {
        ///             "type": "LineString",
        ///             "coordinates": [[
        ///                 34.518699645996094,
        ///                 31.504855323809403
        ///             ],[
        ///                 34.528699645996094,
        ///                 31.604855323809403
        ///             ],[
        ///                 34.538699645996094,
        ///                 31.704855323809403
        ///             ],[
        ///                 34.548699645996094,
        ///                 31.804855323809403
        ///             ]]
        ///         },
        ///         "properties": [{
        ///             "hd" : 36.6,
        ///             "acc_h": 5.0,
        ///             "speed": 13.5,
        ///             "temp": 77.4
        ///         },{
        ///             "hd" : 37.6,
        ///             "acc_h": 6.0,
        ///             "speed": 13.5,
        ///             "temp": 69.4
        ///         },{
        ///             "hd" : 41.6,
        ///             "acc_h": 11.8,
        ///             "speed": 16.5,
        ///             "temp": 75.4
        ///         },{
        ///             "hd" : 42.6,
        ///             "acc_h": 7.9,
        ///             "speed": 15.5,
        ///             "temp": 78.4
        ///         }]
        ///     },
        ///         "meta": {}
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of locations:get
        /// - note: Server responds with AssetTracking.LocationResponse struct or a PCError
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter deviceID:Device ID prefix used to filter  the query
        /// - Parameter date_range: Start and end date in ISO8601 format, separated by comma, to query. Omitting date_range will return last known location.
        /// - Parameter rect_bl:Bottom left of the rectangular bounding box to query. Latitude and longitude separated by comma.
        /// - Parameter rect_tr: Top right of the rectangular bounding box to query. Latitude and longitude separated by comma.
        /// - Parameter token: A currently active access token scoped to locations:get
    case queryLocationForOneDeviceWithinProduct(productIDorSlug: ProductID, deviceID: DeviceID, dateRange: String?, rect_bl: String?, rect_tr: String?, token:PCAccessToken)
    
        ///Get product configuration
        ///
        ///Get the configuration values that are the default for the product.
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/config
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/1234/config?access_token=abc123"
        ///
        ///         //Particle example response
        ///     GET https://api.particle.io/v1/products/1234/config
        ///     HTTP/1.1 200 OK
        ///  
        ///     {
        ///        "configuration": {
        ///            "location": {
        ///                "radius": 1,
        ///                "interval_min": 30,
        ///                "interval_max": 300,
        ///                "min_publish": false
        ///            },
        ///            "imu_trig": {
        ///                "motion": "disable",
        ///                "high_g": "disable"
        ///            },
        ///            "rgb": {
        ///                "type": "tracker",
        ///                "direct": {
        ///                    "red": 0,
        ///                    "blue": 255,
        ///                    "green": 0,
        ///                    "brightness": 255
        ///                }
        ///            }
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - note: Server responds with PCerror or an AssetTracking.ProductConfigurationResponse struct.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token.
    case getProductConfiguration(productIDorSlug: ProductID, token: PCAccessToken)
    
        ///Get device configuration.
        ///
        ///Get the configuration values that are specific to this device.
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/1234/config/abc123?access_token=abc123"
        ///
        ///         //Particle example response
        ///     GET https://api.particle.io/v1/products/1234/config/abc123
        ///     HTTP/1.1 200 OK
        ///     
        ///     {
        ///        "configuration": {
        ///            "current": {
        ///                "imu_trig": {
        ///                    "motion": "disable",
        ///                    "high_g": "disable"
        ///                },
        ///                "location": {
        ///                    "radius": 1,
        ///                    "interval_min": 30,
        ///                    "interval_max": 300,
        ///                    "min_publish": false
        ///                }
        ///            },
        ///            "pending": {
        ///                "location": {
        ///                    "radius": 10,
        ///                    "interval_min": 30,
        ///                    "interval_max": 300,
        ///                    "min_publish": false
        ///                },
        ///                "imu_trig": {
        ///                    "motion": "enable",
        ///                    "high_g": "disable"
        ///                }
        ///            }
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/config/:deviceId
        /// - note: Server responds with PCerror or an AssetTracking.DeviceConfigurationResponse struct.
        /// - Parameter deviceID: String representing the product id or slug.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token.
    case getDeviceConfiguration(deviceID: DeviceID, productIDorSlug: ProductID, token: PCAccessToken)
    
        ///Get product or device schema
        ///
        ///Get the possible values that can be configured for this product, in JSON Schema format
        ///
        /// - calls: GET /v1/products/:productIdOrSlug/config if deviceID is nil or GET /v1/products/:productIdOrSlug/config/:deviceId
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl "https://api.particle.io/v1/products/1234/config/abc123?access_token=abc123" \
        ///         -H "Accept: application/schema+json"
        ///
        ///         //Particle example response
        ///        GET https://api.particle.io/v1/products/1234/config/abc123
        ///        HTTP/1.1 200 OK
        ///    
        ///     {
        ///        "$schema": "http://json-schema.org/draft-07/schema",
        ///        "properties": {
        ///        ...
        ///        }
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of configuration:get
        /// - Requires: Accept header must be set to "application/schema+json" for this endpoint
        /// - Parameter productIDorSlug: The product id or slug.
        /// - Parameter deviceID: The device id.
        /// - Parameter token: A currently active access token scoped to configuration:get
    case getSchema(productIdOrSlug: ProductID, deviceID: DeviceID?, token: PCAccessToken)
    
        ///Delete product configuration schema.
        ///
        ///Delete configuration schema, use Tracker Edge defaults.
        ///
        ///Set some configuration values for the device that will override the product default.
        ///set `resetToProductDefaults` to true to reset the device to product defaults.
        ///In order for `resetToProductDefaults` to have any effect you must provide a device id.
        ///
        ///Returns 200, 202 or 400 for various states
        /// - 200 when the device is online and accepted the configuration changes.
        /// - 202 when the device is offline. We'll complete the request when it comes online again
        /// - 400 When the device is online, but has rejected some of the configuration keys. A list of accepted and rejected keys with device error codes is provided
        ///
        ///
        /// - calls: DELETE /v1/products/:productIdOrSlug/config if deviceID is nil or PUT /v1/products/:productIdOrSlug/config/:deviceId if a device is provided.
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X DELETE "https://api.particle.io/v1/products/1234/config" \
        ///         -H "Authorization: Bearer ACCESS-TOKEN-HERE" \
        ///         -H "Content-Type: application/schema+json" \
        ///         -d '{}'
        ///
        ///         //Particle example response
    
        ///
        ///
        ///````
        ///
        /// - note: You should always get the entire configuration, change values, and set the whole configuration back. In HTTP REST APIs, POST and PUT do not merge changes with the existing data.
        ///
        /// - Requires: Scope of configuration:update
        /// - Parameter productIDorSlug: The product id or slug.
        /// - Parameter deviceID: The device id.
        /// - Parameter resetToProductDefaults: Boolean indicating whether to reset the schema.
        /// - Parameter token: A PCAccessToken with appropriate permissions.
    case deleteOrResetConfigurationSchema(productIdOrSlug: ProductID, deviceID: DeviceID?, resetToProductDefaults: Bool, token: PCAccessToken)
            
        ///Set configuration.
        ///
        ///If deviceId is not nil:
        /// - Set configuration values that will become the default for the product. This will also update eligible devices with this updated configuration.You should always get the entire configuration, change values, and set the whole configuration back. In HTTP REST APIs, POST and PUT do not merge changes with the existing data.
        ///
        ///If deviceId is nil:
        /// - Set some configuration values for the device that will override the product default.Send an empty request to reset the device to product defaults.Returns 200, 202 or 400 for various states
        ///     - 200 when the device is online and accepted the configuration changes.
        ///     - 202 when the device is offline. We'll complete the request when it comes online again
        ///     - 400 When the device is online, but has rejected some of the configuration keys. A list of accepted and rejected keys with device error codes is provided.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/config or PUT /v1/products/:productIdOrSlug/config/:deviceId if device Id is specified
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT "https://api.particle.io/v1/products/1234/config/abc123?access_token=abc123" \
        ///         -H "Content-Type: application/json" \
        ///         -d "{\"location\":{\"radius\":5.0}}"
        ///
        ///         //Particle example response
        ///     
        ///         //success
        ///     PUT https://api.particle.io/v1/products/1234/config/abc123
        ///     HTTP/1.1 200 OK
        ///     {}
        ///
        ///         //accespted
        ///     PUT https://api.particle.io/v1/products/1234/config/abc123
        ///     HTTP/1.1 202 Accepted
        ///     {}
        ///     
        ///         //rejected
        ///     PUT https://api.particle.io/v1/products/1234/config/abc123
        ///     HTTP/1.1 400 Bad Request
        ///     
        ///     {
        ///         error: 'device_rejected_configuration',
        ///         error_description: 'Configuration updates failed for some sections: {location: -19}, these sections were successful: imu_trig'
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of configuration:update
        /// - note: You should always get the entire configuration, change values, and set the whole configuration back. In HTTP REST APIs, POST and PUT do not merge changes with the existing data.
        /// - Parameter productIDorSlug: The product id or slug.
        /// - Parameter deviceID: The device id.
        /// - Parameter token: A PCAccessToken with appropriate permissions.
    case setConfiguration(productIdOrSlug: ProductID, deviceID: DeviceID?, token: PCAccessToken)
    
        ///Set configuration schema
        ///
        ///If deviceId is nil:
        /// - Set configuration schema that will become the default for the product.This must be the entire schema, including the standard Particle parts; there is no merging of changes.
        ///
        ///if deviceId is not nil:
        /// - Set configuration schema for the device.This must be the entire schema, including the standard Particle parts; there is no merging of changes.
        ///
        /// - calls: PUT /v1/products/:productIdOrSlug/config or PUT /v1/products/:productIdOrSlug/config/:deviceId if deviceId is provided.
        ///
        ///
        ///````BASH
        ///
        ///         //Particle example requests
        ///     curl -X PUT "https://api.particle.io/v1/products/1234/config/43210" \
        ///         -H "Authorization: Bearer ACCESS-TOKEN-HERE" \
        ///         -H "Content-Type: application/schema+json" \
        ///         -d '{
        ///             "$schema": "https://particle.io/draft-07/schema#",
        ///             "type": "object",
        ///             "title": "Fake Custom Schema",
        ///             "description": "A customized JSON schema for testing",
        ///             "required": [
        ///                 "foo"
        ///             ],
        ///             "properties": {
        ///                 "foo": {
        ///                     "$id": "#/properties/foo",
        ///                     "type": "integer",
        ///                     "title": "Foo",
        ///                     "description": "A test setting named foo",
        ///                     "default": 1,
        ///                     "examples": [1, 2, 3],
        ///                     "minimum": 0
        ///                 },
        ///                 "bar": {
        ///                     "$id": "#/properties/bar",
        ///                     "type": "string",
        ///                     "title": "Bar",
        ///                     "description": "A test setting named bar",
        ///                     "default": "",
        ///                     "examples": ["one", "two", "three"]
        ///                 }
        ///             }
        ///         }'
        ///
        ///         //Particle example response
        ///
        ///         //accepted
        ///     PUT https://api.particle.io/v1/products/1234/config/43210
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "$schema": "https://particle.io/draft-07/schema#",
        ///        "type": "object",
        ///        "title": "Fake Custom Schema",
        ///        "description": "A customized JSON schema for testing",
        ///        "required": [
        ///            "foo"
        ///        ],
        ///        "properties": {
        ///            "foo": {
        ///                "$id": "#/properties/foo",
        ///                "type": "integer",
        ///                "title": "Foo",
        ///                "description": "A test setting named foo",
        ///                "default": 1,
        ///                "examples": [1, 2, 3],
        ///                "minimum": 0
        ///            },
        ///            "bar": {
        ///                "$id": "#/properties/bar",
        ///                "type": "string",
        ///                "title": "Bar",
        ///                "description": "A test setting named bar",
        ///                "default": "",
        ///                "examples": ["one", "two", "three"]
        ///            }
        ///        }
        ///     }
        ///
        ///             //rejected
        ///     PUT https://api.particle.io/v1/products/1234/config/43210
        ///     HTTP/1.1 422 Bad Request
        ///
        ///     {
        ///        message: 'Invalid Schema',
        ///        description: 'data should NOT have additional properties',
        ///        violations: [
        ///            {
        ///            "keyword": "additionalProperties",
        ///            "dataPath": "",
        ///            "schemaPath": "#/additionalProperties",
        ///            "params": {
        ///                "additionalProperty": "nope"
        ///            },
        ///            "message": "should NOT have additional properties"
        ///            }
        ///        ]
        ///     }
        ///
        ///
        ///````
        ///
        /// - Requires: Scope of configuration:update
        /// - Parameter productIDorSlug: The product id or slug.
        /// - Parameter deviceID: The device id.
        /// - Parameter token: A PCAccessToken with appropriate permission.
    case setConfigurationSchema(productIdOrSlug: ProductID, deviceID: DeviceID?, token: PCAccessToken)
    
        //MARK: - Customers - Needs Better Documentation
    
        ///Create a customer for a product. An access token of a user that belongs to the product is required. The email field can contain a unique identifier instead but some platform functionalities might not work (i.e. sending a password reset email).
        ///
        ///If you wish to provide a mobile app or web app for your customers, it is recommended that you implement your own user management features on your front and back-end. You may want to use common third-party login features such as login with Google, Facebook, Twitter, etc. instead of implementing your own from scratch, but this not required. Implementing user management this way will eliminate the need for customer-specific Particle access tokens, which will greatly simplify the implementation of your front and back-end.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter deviceID: The device identifier of the device to filter by or nil if subscribing to all events by the provided event name.
        /// - Parameter credentials: OAuth client ID and password is the OAuth secret.
        /// - Parameter token: A currently active access token scoped to sims:update
        /// - Returns: Response Type: Undisclosed in Particle Refernce docs. URL response should have code: 200
    case createCustomerWithToken(productIDorSlug: ProductID, clientCredentials: PCClient, token: PCAccessToken)
    
        ///Create a customer for a product using OAuth client credentials grant type.
        ///
        ///This is the way you should hit the POST customers endpoint if you are creating customers from your server (two-legged authentication), or from a mobile application. In this case, you may create a customer without a password, by passing the no_password: true flag.You must give a valid product OAuth client ID and secret in HTTP Basic Auth or in the client_id and client_secret parameters.
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter username: The new customers email address.
        /// - Parameter password: The new customers password or nil if the customer will be using two-legged auth.
        /// - Parameter client: Required: The OAuth client with access to create a customer.
        /// - **Server response is an PCAccessToken**
        /// - warning: `nil` password should be passed for two-legged authentication, **only** if you are creating password-less customers.
    case createCustomerWithClient(productIDorSlug: ProductID, client: PCClient, username: String, password: String?)
    
        ///Create a customer for a product using OAuth implicit grant type.
        ///
        /// This is the way you should hit the POST customers endpoint if you are creating customers from a web browser. After a successful POST, the customer access token will be appended as a hash to the redirect URI associated with the client credentials provided.  For this grant type, you must also pass response_type: token.You must give a valid product OAuth client ID in HTTP Basic Auth or in the client_id parameter.
        ///
        /// - # Server response is an PCAccessToken
        /// - Important: Do not pass the OAuth client secret when creating customers from a web browser.
        /// - Parameter productIDorSlug: Required String representing the product id or slug.
        /// - Parameter client: OAuth client used to create the customer.
        /// - Parameter credentials:Where Customer username can be anything but it is preferable an Email address is used so that forgot email can be handled by the particle server and password is the password for the new customer.
    case createCustomerImplicit(productIDorSlug: ProductID, client: PCClient, customerCredentials: PCCredentials)
    
        /// List customers for a product.
        ///
        /// - Requires: scope of customers:list
        /// - Parameter productIDorSlug: String representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to sims:update
        /// - # Server response is a list of customers associated with the product.
    case listCustomersForProduct(productIdOrSlug: ProductID, token: PCAccessToken)
    
        ///Creates a token scoped to a customer for your organization.
        ///
        ///You must give a valid product OAuth client ID and secret in HTTP Basic Auth or in the client_id and client_secret parameters.
        /// - Parameter arguments: PCCustomer.CustomerScopedAccessTokenArguments struct containing required and optional arguments for the new PCaccessToekn
        /// - # Server response is an PCAccessToken
    case generateCustomerWithScopedAccessToken(arguments: PCCustomer.AccessTokenArguments)
    
        ///Update the account password for a customer.
        ///
        ///Only relevant for non-shadow customers that have a password saved in Particle's system.
        ///Must be called with an access token that has access to the product, not a customer access token.
        /// - Requires: scope of cutomer:update
        /// - Parameter productIDorSlug: ProductID representing the product id or slug.
        /// - Parameter customerCredentials: Email address for using forgot password if email is not the username. The new password for the customer.
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - # Server response is of type PCCustomer.UpdateRequestResponse
    case updateCustomerPassword(productIDorSlug: ProductID, customerCredentials: PCCredentials, token: PCAccessToken)
    
        /// Delete a customer in a product.
        /// - note: Will also revoke all of this customer's access tokens, pending device claim codes and activation codes.
        ///
        /// - Requires: scope of customers:remove**
        /// - Parameter productIDorSlug: ProductID representing the product id or slug.
        /// - Parameter username: username of the customer account that you'd like to remove.
        /// - # Server response is of type PCCustomer.DeletionRequestResponse
    case deleteA_Customer(productIDorSlug: ProductID, username: String, token: PCAccessToken)
    
        ///If you wish to provide a mobile app or web app for your customers, we recommend that you implement your own user management features on your front and back-end. We do not recommend using simple auth or two-legged shadow customers in most cases now. Simple Auth can be used as a simpler alternative, however you will need to provide an additional service if you want to allow your customers to be able to reset their password by email.
        ///
        ///The process works like this:
        ///
        /// Customer loses access, clicks "forgot password" on your mobile or front-end app.
        ///
        /// 1. App hits an endpoint on your back-end. The back-end app should know your Particle access token, the one you used to create that product, and, optionally, list of valid customer emails.
        ///
        /// 2.  The email links to your hosted, brand-themed webpage that shows the a "set new password" field and verifies the reset password token. The customer types in new password, and the front-end hits an endpoint on your back-end with the new password.
        ///
        /// 3. The back-end hits the update customer password API.
        ///
        /// 4. Customer password is reset.
        ///
        /// 5. `PUT /v1/products/:productIdOrSlug/customers/:customerEmail`
        /// `required payload: {password: <new_password>, access_token: <your_token>}`
        ///
        /// - note: A sample app has been provided by Particle Team using: [Heroku and PostgreSQL](https://github.com/particle-iot/password-reset-example). This can be used as-is, or you can use it as an example of how to add support into your existing server infrastructure
        /// - important: This triggers an email to the customer sent from your back-end. This email can have your brand, logo, colors, etc. The email contains link to reset his or her password. Behind the scenes, a short-lived reset password token is created and stored in your back-end database.
        /// - Parameter productIDorSlug: ProductID representing the product id or slug.
        /// - Parameter customerEmail: The customers email address.
        /// - parameter password: The new password to assign the user.
        /// - Parameter token: A currently active access token.
    case resetPassword(productIDorSlug: ProductID, customerEmail: String, token: PCAccessToken)
    
        //MARK: - Service Agreements and Usage - Needs Better Documentation
    
        ///Get global service agreements
        ///
        ///Get the service particle service  agreements.
        ///
        ///calls GET /v1/orgs/particle/service_agreements
        ///
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Requires: Token scope of service_agreements:list
    case getServiceAgreements(token: PCAccessToken)
    
        ///Get user service agreements
        ///
        ///Get the service agreements related to a user
        ///
        ///calls GET /v1/orgs/:name/service_agreements
        ///
        /// - Parameter username: The organization name. In most cases this will be `Sandbox`.
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Requires: Token scope of service_agreements:list
    case getUserServiceAgreements(orgName: String, token: PCAccessToken)
    
        ///Get organization service agreements
        ///
        ///Get the service agreements related to an organization
        ///
        ///calls GET /v1/orgs/:orgIdOrSlug/service_agreements
        /// - Parameter productIDorSlug: ProductID representing the product id or slug.
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Requires: Token scope of service_agreements:list
    case getOrganizationServiceAgreements(productIDorSlug: ProductID, token: PCAccessToken)
    
        ///Get a user usage report
        ///
        ///Get a single usage report related to the user. Expect "download_url" to be present only when the usage report has an "available" state.
        ///
        /// - calls: GET /v1/user/usage_reports/:usageReportId
        ///
        /// ````BASH
        ///
        ///         //Particle example request
        ///     curl "https://api.particle.io/v1/user/usage_reports/:userReportId" \
        ///        -H "Authorization: Bearer <access_token>"
        ///
        ///         //Particle example response
        ///     GET /v1/user/usage_reports/:usageReportId
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///     "data": {
        ///         "id": "1",
        ///         "type": "usage_report",
        ///         "attributes": {
        ///             "state": "pending",
        ///             "service_agreement_id": 1,
        ///             "date_period_start": "2022-01-01",
        ///             "date_period_end": "2022-02-01",
        ///             "created_at": "2022-01-18 13:43:23 -0800",
        ///             "expires_at": null,
        ///             "report_type": "devices",
        ///             "report_params": {
        ///                 "devices": [
        ///                     "device1",
        ///                     "device2"
        ///                 ],
        ///                 "products": [],
        ///                 "recipient_list": [
        ///                     "your@email.com"
        ///                 ]
        ///             },
        ///             "download_url": null
        ///         }
        ///     }
        ///
        /// ````
        ///
        /// - Parameter usageReportId: The usage report ID.
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Returns: PCServiceAgreement.UserUsageReport
    case getUserUsageReport(usageReportId: String, token: PCAccessToken)
    
        ///Get an org usage report
        ///
        ///Get a single usage report related to an organization. Expect "download_url" to be present only when the usage report has an "available" state.
        ///
        ///The user must be an active member of the organization.
        /// - calls: GET /v1/orgs/:orgSlugOrId/usage_reports/:usageReportId
        ///
        /// ````BASH
        ///
        ///         //Particle example request
        ///     curl "https://api.particle.io/v1/orgs/:orgSlugOrId/usage_reports/:usageReportId" \
        ///        -H "Authorization: Bearer <access_token>"
        ///
        ///         //Particle example response
        ///     GET /v1/orgs/:orgSlugOrId/usage_reports/:usageReportId
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///     "data": {
        ///         "id": "1",
        ///         "type": "usage_report",
        ///         "attributes": {
        ///             "state": "pending",
        ///             "service_agreement_id": 1,
        ///             "date_period_start": "2022-01-01",
        ///             "date_period_end": "2022-02-01",
        ///             "created_at": "2022-01-18 13:43:23 -0800",
        ///             "expires_at": null,
        ///             "report_type": "devices",
        ///             "report_params": {
        ///                 "devices": [
        ///                     "device1",
        ///                     "device2"
        ///                 ],
        ///                 "products": [],
        ///                 "recipient_list": [
        ///                     "your@email.com"
        ///                 ]
        ///             },
        ///             "download_url": null
        ///         }
        ///     }
        ///
        ///
        /// ````
        ///
        /// - Requires: Scope of service_agreements.usage_reports:get
        /// - Parameter usageReportId: The usage report ID.
        /// - Parameter orgSlugOrId: Organization Slug or ID
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Returns: PCServiceAgreement.OrganizationUsageReport
    case getOrgUsageReport(usageReportId: String, orgSlugOrId: String, token: PCAccessToken)
    
        ///Create a user usage report
        ///
        ///Request a new usage report related to the user service agreement.The usage report will be processed asynchronously. Expect its "state" to change throughout time.
        ///
        /// - calls: POST /v1/user/service_agreements/:serviceAgreementId/usage_reports
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///     curl -X POST "https://api.particle.io/v1/user/service_agreements/:serviceAgreementId/usage_reports" \
        ///        -H "Authorization: Bearer <access_token>" \
        ///        -H "Content-Type: application/json" \
        ///        -d '{
        ///            "report_type": "devices",
        ///            "date_period_start": "2022-01-01",
        ///            "date_period_end": "2022-01-31",
        ///            "devices": ["device1", "device2"]
        ///        }'
        ///
        ///         //Particle example response
        ///     POST /v1/user/service_agreements/:serviceAgreementId/usage_reports/
        ///     HTTP/1.1 202 OK
        ///
        ///     {
        ///     "data": {
        ///         "id": "1",
        ///         "type": "usage_report",
        ///         "attributes": {
        ///             "state": "pending",
        ///             "service_agreement_id": 1,
        ///             "date_period_start": "2022-01-01",
        ///             "date_period_end": "2022-01-31",
        ///             "created_at": "2022-01-18 13:43:23 -0800",
        ///             "expires_at": null,
        ///             "report_type": "devices",
        ///             "report_params": {
        ///                 "devices": [
        ///                     "device1",
        ///                     "device2"
        ///                 ],
        ///                 "products": [],
        ///                 "recipient_list": [
        ///                     "your@email.com"
        ///                 ]
        ///             },
        ///             "download_url": null
        ///         }
        ///     }
        ///
        ///````
        ///
        /// - Parameter arguments: PCServiceAgreement.ReportCreationArguments used to define the scope of the report.
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Requires: Scope of service_agreements.usage_reports:create
        /// - Returns: PCServiceAgreement.CreationRequestResponse
    case createUserUsageReport(arguments: PCServiceAgreement.ReportCreationArguments, token: PCAccessToken)
    
        ///Create an org usage report
        ///
        ///Request a new usage report related to the organization service agreement.The usage report will be processed asynchronously. Expect its "state" to change throughout time.The user must be an active member of the organization.
        ///
        /// - calls:  POST /v1/orgs/:orgSlugOrId/service_agreements/:serviceAgreementId/usage_reports
        ///
        ///````BASH
        ///
        ///         //Particle example request
        ///
        ///     curl -X POST "https://api.particle.io/v1/orgs/:orgSlugOrId/service_agreements/:serviceAgreementId/usage_reports" \
        ///        -H "Authorization: Bearer <access_token>" \
        ///        -H "Content-Type: application/json" \
        ///        -d '{
        ///            "report_type": "devices",
        ///            "date_period_start": "2022-01-01",
        ///            "date_period_end": "2022-01-31",
        ///            "devices": ["device1", "device2"]
        ///        }'
        ///
        ///         //Particle example response
        ///     POST /v1/orgs/:orgSlugOrId/service_agreements/:serviceAgreementId/usage_reports/
        ///     HTTP/1.1 202 OK
        ///     {
        ///     "data": {
        ///         "id": "1",
        ///         "type": "usage_report",
        ///         "attributes": {
        ///             "state": "pending",
        ///             "service_agreement_id": 1,
        ///             "date_period_start": "2022-01-01",
        ///             "date_period_end": "2022-01-31",
        ///             "created_at": "2022-01-18 13:43:23 -0800",
        ///             "expires_at": null,
        ///             "report_type": "devices",
        ///             "report_params": {
        ///                 "devices": [
        ///                     "device1",
        ///                     "device2"
        ///                 ],
        ///                 "products": [],
        ///                 "recipient_list": [
        ///                     "your@email.com"
        ///                 ]
        ///             },
        ///             "download_url": null
        ///         }
        ///     }
        ///
        ///````
        ///
        /// - Parameter arguments: PCServiceAgreement.ReportCreationArguments used to define the scope of the report.
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Returns: PCServiceAgreement.CreationRequestResponse
    case createOrgUsageReport(arguments: PCServiceAgreement.ReportCreationArguments, token: PCAccessToken)
    
        ///Get notifications for current usage period
        ///
        ///Get user notifications related to a specific service agreement
        /// - Usage reached a certain threshold (70%, 90%, 100%)
        /// - Service was paused
        /// - Service was unpaused
        ///
        /// ````BASH
        ///
        ///         //Particle example requests
        ///
        ///         //Get notifications for a user
        ///     curl "https://api.particle.io/v1/user/service_agreements/:serviceAgreementId/notifications?access_token=123abc"
        ///
        ///         //Get notifications for an organization
        ///     curl "https://api.particle.io/v1/orgs/:orgSlugOrId/service_agreements/:serviceAgreementId/notifications?access_token=123abc"
        ///
        ///         //Particle example response
        ///     GET /v1/user/service_agreements/1234/notifications
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///     "data":[
        ///         {
        ///         "id": "fff25e4e-7457-4c3c-8f6e-c9d6dfc01110",
        ///         "type": "notification",
        ///         "attributes": {
        ///             "state": "completed",
        ///             "event_name": "developer:usage_activity:automatic_unpause",
        ///             "time_period": "2022-01-22",
        ///             "created_at": "2022-01-22 00:01:00 -0800",
        ///             "resource_id": "59",
        ///             "resource_type": "ServiceAgreement",
        ///             "details": {
        ///                 "event_type": "automatic_unpause",
        ///                 "hierarchy_info": {
        ///                     "name": "automatic_unpause",
        ///                     "priority": 7
        ///                 },
        ///                 "device_pause_date": "2022-01-22T00:01:00.567-08:00",
        ///                 "next_billing_period_start": "2022-02-22"
        ///             }
        ///         }
        ///         }
        ///     ]
        ///     }
        ///
        ///
        /// ````
        ///
        /// - calls: GET /v1/user/service_agreements/:serviceAgreementId/notifications
        /// - Requires: Scope of service_agreements.notifications:list
        /// - Parameter serviceAgreementId: Service Agreement ID
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Returns: PCServiceAgreement.CurrentUsageNotificationResponse
    case getUserNotificationsForCurrentUsagePeriod(serviceAgreementId: Int, token: PCAccessToken)
    
        ///Get notifications for current usage period
        ///
        ///Get user notifications related to a specific service agreement
        /// - Usage reached a certain threshold (70%, 90%, 100%)
        /// - Service was paused
        /// - Service was unpaused
        ///
        /// ````BASH
        ///
        ///         //Particle example requests
        ///
        ///         //Get notifications for a user
        ///     curl "https://api.particle.io/v1/user/service_agreements/:serviceAgreementId/notifications?access_token=123abc"
        ///
        ///         //Get notifications for an organization
        ///     curl "https://api.particle.io/v1/orgs/:orgSlugOrId/service_agreements/:serviceAgreementId/notifications?access_token=123abc"
        ///
        ///         //Particle example response
        ///     GET /v1/user/service_agreements/1234/notifications
        ///     HTTP/1.1 200 OK
        ///
        ///     {
        ///        "data":[
        ///            {
        ///               "id": "fff25e4e-7457-4c3c-8f6e-c9d6dfc01110",
        ///               "type": "notification",
        ///               "attributes": {
        ///                   "state": "completed",
        ///                   "event_name": "developer:usage_activity:automatic_unpause",
        ///                   "time_period": "2022-01-22",
        ///                   "created_at": "2022-01-22 00:01:00 -0800",
        ///                   "resource_id": "59",
        ///                   "resource_type": "ServiceAgreement",
        ///                   "details": {
        ///                       "event_type": "automatic_unpause",
        ///                       "hierarchy_info": {
        ///                           "name": "automatic_unpause",
        ///                           "priority": 7
        ///                       },
        ///                       "device_pause_date": "2022-01-22T00:01:00.567-08:00",
        ///                       "next_billing_period_start": "2022-02-22"
        ///                   }
        ///               }
        ///            }
        ///        ]
        ///     }
        ///
        ///
        /// ````
        ///
        /// - calls: GET /v1/user/service_agreements/:serviceAgreementId/notifications
        /// - Requires: Scope of service_agreements.notifications:list
        /// - Parameter orgSlugOrId: Organization Slug or ID
        /// - Parameter serviceAgreementId: Service Agreement ID
        /// - Parameter token: A currently active access token scoped to customers:update and that has access to the product, not a customer access token.
        /// - Returns: PCServiceAgreement.CurrentUsageNotificationResponse
    case getOrganizationNotificationsForCurrentUsagePeriod(orgSlugOrId: String, serviceAgreementId: Int, token: PCAccessToken)
    
}

    //MARK: - Main Method
extension CloudResource {
    
        ///This is the entire workload of the request forming of the requested resource.
        ///
        ///This method calls on the RequestHelper and all cases must be explicitly handled in that file. The goal here was to avoid any programmer errors in the REST api calls and to isolate any such errors in this Package.
        ///The Particle.io api is vast and the requests don't necessarily follow any real rules. Thus encapsulation was required. Any added functionality will cause an abort unless every case is explicitly handled in the helper file.
    internal static func requestForResource(_ resource: CloudResource) -> URLRequest {
        
        let helper = RequestHelper()
        
        var components        = helper.basicParticleUrlComponents()
        components.path       = helper.pathForParticleResource( resource )
        components.queryItems = helper.queryItemsFor( resource )
        
        var request        = URLRequest(url: components.url!)
        request.httpMethod = helper.methodForResource( resource )
        request.httpBody   = helper.payloadForResource( resource )
        
        request.addValue(helper.contentTypeforResource(resource), forHTTPHeaderField: "Content-Type")
        
        if let contentType = helper.acceptHeaderForResource(resource)?.rawValue {
            request.addValue(contentType, forHTTPHeaderField: "Accept")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        if let data = helper.authHeaderForResource(resource) {
            request.addValue(data, forHTTPHeaderField: "Authorization")
        }

        request.assumesHTTP3Capable = false
        
        return request
    }
}
