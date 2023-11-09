    //
    //  TempHelperFile.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/14/23.
    //

import Foundation

    //MARK: - Access Tokens - Done
extension CloudResource.RequestHelper {
#warning("Contact paticle about how to send the otp.")
        //MARK: Paths
    internal func pathForTokenResource(_ resource: CloudResource) -> String {
        
        switch resource {
            case .generateAccessToken:
                    //POST /oauth/token
                return ParticlePaths.v1oAuth.rawValue
            case .listAccessTokens:
                    //GET /v1/access_tokens
                return ParticlePaths.v1tokens.rawValue
            case .deleteAnAccessToken(let access_token ,_):
                    //DELETE /v1/access_tokens/:token
                return ParticlePaths.v1tokens.rawValue.appending(separator).appending(access_token)
                
            case .deleteAllAccessTokens:
                    //DELETE /v1/access_tokens
                return ParticlePaths.v1tokens.rawValue
                
            case .deleteCurrentAccessToken,
                    .getCurrentAccessTokenInfo:
                    //DELETE /v1/access_tokens/current
                    //GET /v1/access_tokens/current
                return ParticlePaths.v1tokens.rawValue.appending("/current")
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func tokenContentType(_ resource: CloudResource) -> AllowableContentType {
        switch resource {
            case .generateAccessToken,
                    .listAccessTokens,
                    .deleteAnAccessToken,
                    .deleteAllAccessTokens,
                    .deleteCurrentAccessToken,
                    .getCurrentAccessTokenInfo: return .form
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func tokenAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .generateAccessToken(let client,_,_,_,_):
                if let client = client {
                    return "Basic " + "\(client.id):\(client.secret)".data(using: .utf8)!.base64EncodedString()
                } else {
                    return "Basic " + "particle:particle".data(using: .utf8)!.base64EncodedString()
                }
            case .listAccessTokens(let credentials,_),
                    .deleteAnAccessToken(_,let credentials):
                
                return "Basic " + "\(credentials.username):\(credentials.password)".data(using: .utf8)!.base64EncodedString()
                
            case .deleteAllAccessTokens,
                    .deleteCurrentAccessToken,
                    .getCurrentAccessTokenInfo: break
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func tokenHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        switch resource {
            case .generateAccessToken: return .POST
            case .listAccessTokens: return .GET
                
            case .deleteAnAccessToken,
                    .deleteAllAccessTokens,
                    .deleteCurrentAccessToken:
                return .DELETE
                
            case .getCurrentAccessTokenInfo: return .GET
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func tokenQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        switch resource {
            case .generateAccessToken,
                    .listAccessTokens,
                    .deleteAnAccessToken: break
                
            case .deleteAllAccessTokens(let token):
                return [URLQueryItem.init(name: "access_token", value: token.accessToken)]
                
            case .deleteCurrentAccessToken: break
                
            case .getCurrentAccessTokenInfo(let token):
                
                return [URLQueryItem.init(name: "access_token", value: token.accessToken)]
                
            default: abort()
        }
        return nil
    }
    
        //MARK: Payload
    internal func tokenPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .generateAccessToken(let client, let credentials, let grantType, let expire_in, let expire_at):
                
                payload = ["grant_type=\(grantType.rawValue)",
                           "username=\(credentials.username)",
                           "password=\(credentials.password)"]
                
                if client != nil {
                    payload!.append("client_id=\(client!.id)")
                    payload!.append("client_secret=\(client!.id)")
                } else {
                    payload!.append("client_id=particle")
                    payload!.append("client_secret=particle")
                }
                if expire_in != nil { payload!.append("expire_in=\(expire_in!)") }
                else if expire_at != nil { payload!.append("expire_at=\(expire_at!)") }
                
            case .listAccessTokens: break
                
            case .deleteAnAccessToken(_,let credentials):
                payload = ["username=\(credentials.username)",
                           "password=\(credentials.password)"]
                
            case .deleteAllAccessTokens: break
                
            case .deleteCurrentAccessToken(let token),
                    .deleteClient(_,_, let token):
                payload = ["access_token=\(token.accessToken)"]
                
            case .getCurrentAccessTokenInfo: break
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Client - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForClientResource(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .listClients(let productId,_),
                    .createClient(_,let productId,_,_,_):
                
                if productId == nil { return ParticlePaths.v1clients.rawValue }
                return "\(ParticlePaths.v1products.rawValue)/\(productId!.rawValue)/clients"
                
            case .updateClient(let client,_,_,let productId,_),
                    .deleteClient(let client, let productId,_):
                
                if productId == nil { return "\(ParticlePaths.v1clients.rawValue)/\(client.id)" }
                return "\(ParticlePaths.v1products.rawValue)/\(productId!.rawValue)/clients/\(client.id)"
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func clientContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case  .listClients,
                    .createClient,
                    .updateClient,
                    .deleteClient: return .form
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func clientAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .listClients: return nil
                
            case .createClient(_,_,_,_,let token),
                    .updateClient(_,_,_,_,let token),
                    .deleteClient(_,_,let token): return "Bearer \(token.accessToken)"
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func clientHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .listClients:  return .GET
            case .createClient: return .POST
            case .updateClient: return .PUT
            case .deleteClient: return .DELETE
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func clientQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        switch resource {
            case .listClients(_,let token):
                return [URLQueryItem.init(name: "access_token", value: token.accessToken)]
                
            case .createClient,
                    .updateClient,
                    .deleteClient: return nil
                
            default: abort()
        }
    }
    
        //MARK: Payload
    internal func clientPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .listClients: return nil
                
            case .createClient(let name,_,let redirect,let type,_):
                
                payload = ["name=\(name)",
                           "type=\(type.rawValue)"]
                           
                if let redirect = redirect {
                    payload?.append("redirect_uri=\(redirect)")
                }
                                
            case .updateClient(_,let newName, let newScope,_,_):
                
                payload = [String]()
                
                if newName != nil {
                    payload!.append("name=\(newName!)")
                }
                
                if newScope != nil {
                    payload!.append("scope=\(newScope!.rawValue)")
                }
                                
            case .deleteClient: return nil
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - PCAPIUser - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForAPiUserResource(_ resource: CloudResource) -> String {
        
        switch resource {
            case .createAPiUser(let type,_,_):
                switch type {
                    case .organization(let organizationID):
                        return "\(ParticlePaths.v1orgs.rawValue)/\(organizationID.rawValue)/team"
                    case .product(let productID):
                        return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/team"
                }
                
            case .updateAPiUser(let type, let parameters,_):
                switch type {
                    case .organization(let organizationID):
                        return "\(ParticlePaths.v1orgs.rawValue)/\(organizationID.rawValue)/team/\(parameters.friendlyName)"
                    case .product(let productID):
                        return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/team/\(parameters.friendlyName)"
                }
                
                
            case .listAPiUsers(let type,_):
                switch type {
                        
                    case .organization(let organizationID):
                        return "\(ParticlePaths.v1orgs.rawValue)/\(organizationID.rawValue)/team"
                    case .product(let productID):
                        return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/team/"
                }
                
            case .deleteAPiUser(let type, let username,_):
                
                ///v1/products/23748/team/friend+2vmicc5v9k@api.particle.io
                return "\(ParticlePaths.v1products.rawValue)/\(type.carriedValue)/team/\(username)"
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func APiUserContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .createAPiUser, .updateAPiUser, .listAPiUsers, .deleteAPiUser:
                return .jSon
            default: abort()
        }
    }
    
    internal func APiUserAcceptType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .createAPiUser, .updateAPiUser, .listAPiUsers, .deleteAPiUser:
                return .jSon
            default: abort()
        }
    }

        //MARK: AUTH Header
    internal func APiUserAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
            case .createAPiUser(_,_, let token),
                    .updateAPiUser(_,_, let token),
                    .deleteAPiUser(_,_, let token):
                return "Bearer \(token.accessToken)"
                
                case  .listAPiUsers: break
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func APiUserHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .createAPiUser: return .POST
            case .updateAPiUser: return .PUT
            case .listAPiUsers: return .GET
            case .deleteAPiUser: return .DELETE
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func APiUserQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
            case .listAPiUsers(_,let token):
                
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            
                    case .createAPiUser,
                    .updateAPiUser,
                    .deleteAPiUser: return nil
                
            default: abort()
        }
    }
    
        //MARK: Payload
    internal func APiUserPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .createAPiUser(_, let parameters,_):
                payload = [
                    "{\"friendly_name\":\"\(parameters.friendlyName)\"",
                    "\"scopes\":[\(parameters.scopes.map({"\"\($0.rawValue)\""}).joined(separator: ","))]}"
                ]
                
                return payload?.joined(separator:",").data(using: .utf8)
                
            case .updateAPiUser(_, let parameters,_):
                
                payload = [
                    "{\"friendly_name\":\"\(parameters.friendlyName)\"",
                    "\"scopes\":[\(parameters.scopes.map({"\"\($0.rawValue)\""}).joined(separator: ","))]}"
                ]
                
                return payload?.joined(separator:",").data(using: .utf8)
                
            case .listAPiUsers(_,_): break
                
            case .deleteAPiUser(_,let username, _):
                payload = [
                    "{\"friendly_name\":\"\(username)\"}",
                ]
                
                return payload?.joined(separator:",").data(using: .utf8)

            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Device - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForDeviceResource(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .listDevices:
                
                return ParticlePaths.v1devices.rawValue
                
            case .listProductDevices(let productId,_,_):

                    //GET /v1/products/:productIdOrSlug/devices
                return "\(ParticlePaths.v1products.rawValue)/\(productId.rawValue)/devices"
                                
            case .importDevices(_,let productID,_,_):
                
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/devices"
            
                
            case .getDeviceInfo(let deviceID,_):
                
                return "\(ParticlePaths.v1devices.rawValue)/\(deviceID.rawValue)"
                
            case .getProductDeviceInfo(_, let productID,_):
                
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/devices/"
                
            case .getVariableValue(let name, let deviceID,let productID,_):
                
                if let id = productID {
                    ///v1/products/:productIdOrSlug/devices/:deviceID/:variableName
                    return "\(ParticlePaths.v1products.rawValue)/\(id.rawValue)/devices/\(deviceID.rawValue)/\(name.rawValue)"
                }
                ///v1/devices/:deviceId/:variableName
                return "\(ParticlePaths.v1devices.rawValue)/\(deviceID.rawValue)/\(name.rawValue)"
                
            case .callFunction(let deviceID, let arguments,_):
                if let productID = arguments.productIdOrSlug {
                    ///v1/products/:productIdOrSlug/devices/:deviceID/:functionName
                    return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/devices/\(deviceID.rawValue)/\(arguments.functionName.rawValue)"
                }
                return "\(ParticlePaths.v1devices.rawValue)/\(deviceID.rawValue)/\(arguments.functionName.rawValue)"
                
            case .pingDevice( let deviceID, let productID,_):
                
                if productID == nil { return "\(ParticlePaths.v1devices.rawValue)/\(deviceID.rawValue)/ping" }
                return "\(ParticlePaths.v1products.rawValue)/\(productID!.rawValue)/devices/\(deviceID.rawValue)/ping"
                
            case .renameDevice(let deviceID, let productID,_,_),
                    .addDeviceNotes(let deviceID,let productID,_,_):
                
                if productID == nil { return "\(ParticlePaths.v1devices.rawValue)/\(deviceID.rawValue)" }
                return "\(ParticlePaths.v1products.rawValue)/\(productID!.rawValue)/devices/\(deviceID.rawValue)"
                
            case .createClaimCode(let arguments,_):
                if let productID = arguments?.productIdOrSlug {
                    return "\(ParticlePaths.v1products)/\(productID.rawValue)/device_claims"
                }
                return ParticlePaths.v1deviceClaims.rawValue
                
            case .claimDevice:
                return ParticlePaths.v1devices.rawValue
                
//            case .requestDeviceTransferFromAnotherUser:
//                return ParticlePaths.v1devices.rawValue
//                
            case .removeDeviceFromProduct(let productID, let deviceID,_):
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/devices/\(deviceID.rawValue)"
                
            case .unclaimDevice(let deviceID, let productID,_):
                if productID == nil { return "\(ParticlePaths.v1devices.rawValue)/\(deviceID.rawValue)" }
                return "\(ParticlePaths.v1products.rawValue)/\(productID!.rawValue)/devices/\(deviceID.rawValue)"
                
            case .signalDevice(let deviceID,_,_),
                    .forceOverTheAirUpdates(let deviceID,_,_):
                
                return "\(ParticlePaths.v1devices.rawValue)/\(deviceID.rawValue)"
                
            case .lookUpDeviceInformation(let serialNumber,_):
                return "\(ParticlePaths.v1serialNumbers.rawValue)/\(serialNumber)"
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func deviceContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .listDevices,
                    .listProductDevices: return .form
                
            case .importDevices: return .jSon
                
            case .getDeviceInfo, .getVariableValue, .callFunction, .pingDevice, .renameDevice, .addDeviceNotes, .createClaimCode, .claimDevice,
//                    .requestDeviceTransferFromAnotherUser,
                    .removeDeviceFromProduct, .unclaimDevice, .signalDevice, .forceOverTheAirUpdates, .lookUpDeviceInformation:
                return .form
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func deviceAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .listDevices, .listProductDevices, .getDeviceInfo, .getProductDeviceInfo, .getVariableValue, .callFunction, .pingDevice, .renameDevice, .addDeviceNotes: return nil
                
            case .importDevices(_,_,_, let token),
                    .createClaimCode(_, let token):
                
                return "Basic " + "\(token.accessToken)".data(using: .utf8)!.base64EncodedString()
                
            case .claimDevice: return nil// .requestDeviceTransferFromAnotherUser: return nil
                
            case .removeDeviceFromProduct(_,_, let token):
                
                return "\(token.accessToken)".data(using: .utf8)!.base64EncodedString()
                
            case .unclaimDevice, .signalDevice, .forceOverTheAirUpdates, .lookUpDeviceInformation: return nil
                
            default: abort()
        }
    }
    
        //MARK:  HTTP Method
    internal func deviceHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        switch resource {
                
            case .listDevices,
                    .listProductDevices:
                return .GET
            case .importDevices:
                return .POST
            case .getDeviceInfo, .getProductDeviceInfo, .getVariableValue:
                return .GET
            case .callFunction:
                return .POST
            case .pingDevice, .renameDevice, .addDeviceNotes:
                return .PUT
            case .createClaimCode, .claimDevice: // .requestDeviceTransferFromAnotherUser:
                return .POST
            case .removeDeviceFromProduct, .unclaimDevice:
                return .DELETE
            case .signalDevice, .forceOverTheAirUpdates:
                return .PUT
            case .lookUpDeviceInformation:
                return .GET
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func deviceQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .listDevices(let arguments, let token):
                
                var query = [URLQueryItem]()
                
                for key in PCDevice.ListArguments.CodingKeys.allCases {
                    if let queryCandidate = arguments?.value(forCodingKey: key) {
                        query.append(URLQueryItem(name: key.rawValue, value: queryCandidate))
                    }
                }
                
                query.append(URLQueryItem.init(name: "access_token", value: token.accessToken))
                
                return query
                
            case .listProductDevices(_, let arguments, let token):
                
                var query = [URLQueryItem]()
                
                for key in PCDevice.ListArguments.CodingKeys.allCases {
                    if let queryCandidate = arguments?.value(forCodingKey: key) {
                        query.append(URLQueryItem(name: key.rawValue, value: queryCandidate))
                    }
                }
                
                query.append(URLQueryItem.init(name: "access_token", value: token.accessToken))
                
                return query
                
                
            case .importDevices: break
                
            case .getDeviceInfo(_, let token):
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            case .getProductDeviceInfo(let deviceID,_,let token):
                
                    //GET https://api.particle.io/v1/products/:productid/devices/?deviceId=:deviceid
                var query = [URLQueryItem(name: "access_token", value: token.accessToken)]
                if let id = deviceID {
                    query.insert(URLQueryItem(name: "deviceId", value: id.rawValue), at: 0)
                }
                return query
                
            case .getVariableValue(_,_,_, let token):
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            case .callFunction: break //Token Handled in Payload
            case .pingDevice: break //Token Handled in Payload
            case .renameDevice: break //Token Handled in Payload
            case .addDeviceNotes: break //Token Handled in Payload
            case .createClaimCode: break //Token Handled in Auth Header
                
            case .claimDevice: break //Token Handled in Payload
//            case .requestDeviceTransferFromAnotherUser: break //Token Handled in Payload
                
            case .removeDeviceFromProduct: break //Token Handled in Auth Header
                
            case .unclaimDevice: break //Token Handled in Payload
                
            case .signalDevice: break //Token Handled in Payload
                
            case .forceOverTheAirUpdates: break //Token Handled in Payload
                
            case .lookUpDeviceInformation(_,let token):
                return [URLQueryItem.init(name: "access_token", value: token.accessToken)]
                
            default: abort()
        }
        return nil
    }
    
        //MARK: Payload
    internal func devicePayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .listDevices,
                    .listProductDevices: break
                
                
                
            case .importDevices(let devices,_,let arguments,_):
                payload = devices.count == 1
                ? ["id=\(devices.first!)"]
                : ["ids=\("[\(devices.map({$0.rawValue}).joined(separator: ","))]")"]

            if arguments != nil {
                for key in PCDevice.ImportArguments.CodingKeys.allCases {
                    if let value = arguments?.value(forCodingKey: key) {
                        payload?.append("\(key.rawValue)=\(value)")
                    }
                }
            }
                
            case .getDeviceInfo,
                    .getProductDeviceInfo,
                    .getVariableValue: break
                
            case .callFunction(_, let arguments, let token):
                payload = ["access_token=\(token.accessToken)"]
                
                if let arg = arguments.functionArgument?.rawValue {
                    payload?.append("arg=\(arg)")
                }
                
            case .pingDevice(_,_,let token):
                payload = ["access_token=\(token.accessToken)"]
                
            case .renameDevice(_,_, let newName, let token):
                payload = ["access_token=\(token.accessToken)","name=\(newName)"]
                
            case .addDeviceNotes(_,_,let note, let token):
                payload = ["notes=\(note)", "access_token=\(token.accessToken)"]
                
            case .createClaimCode: break //Handled in Auth Header
                
            case .claimDevice(let deviceID,let isTransfer, let token):
                payload = [
                    "access_token=\(token.accessToken)",
                    "id=\(deviceID.rawValue)"
                ]
                
                if isTransfer {
                    payload?.append("request_transfer=true")
                }

//            case .requestDeviceTransferFromAnotherUser(let deviceID, let token):
//                payload = [
//                    "id=\(deviceID.rawValue)",
//                    "request_transfer=true",
//                    "access_token=\(token.accessToken)"
//                ]
                
            case .removeDeviceFromProduct: break //Token handled in Auth Header
                
            case .unclaimDevice(_,_, let token):
                
                payload = ["access_token=\(token.accessToken)"]
            case .signalDevice(_, let rainbowState, let token):
                
                payload = ["signal=\(rainbowState.rawValue)", "access_token=\(token.accessToken)"]
            case .forceOverTheAirUpdates(_, let forceEnabled, let token):
                
                payload = ["firmware_updates_forced=\(forceEnabled)", "access_token=\(token.accessToken)"]
            case .lookUpDeviceInformation: break
                
                
            default: abort()
        }
        return (payload?.isEmpty ?? true) ? nil : payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Remote Diagnostics - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForRemoteDiagnosticsResource(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .refreshDeviceVitals(let deviceID, let productID,_):
                if let id = productID {
                    return "\(ParticlePaths.v1products.rawValue)/\(id.rawValue)/diagnostics/\(deviceID.rawValue)/update"
                }
                return "\(ParticlePaths.v1Diagnostics.rawValue)/\(deviceID.rawValue)/update"
                
            case .getLastKnownDeviceVitals(let deviceID, let productID,_):
                if let id = productID { return "\(ParticlePaths.v1products.rawValue)/\(id.rawValue)/diagnostics/\(deviceID.rawValue)"}
                return "\(ParticlePaths.v1Diagnostics.rawValue)/\(deviceID.rawValue)"
                
            case .getAllHistoricalDeviceVitals(let deviceID, let productID,_,_,_):
                if let id = productID { return "\(ParticlePaths.v1products.rawValue)/\(id.rawValue)/diagnostics/\(deviceID.rawValue)/last"}
                return "\(ParticlePaths.v1Diagnostics.rawValue)/\(deviceID.rawValue)/last"
                
            case .getDeviceVitalsMetadata(let deviceID, let productID,_):
                if let id = productID?.rawValue {
                    //GET /v1/products/:productIdOrSlug/diagnostics/0123456789abcdef01234567/metadata
                    return ParticlePaths.v1products.rawValue.appending(separator).appending(id).appending("/diagnostics/").appending(deviceID.rawValue).appending("/metadata")
                }
                //GET /v1/diagnostics/:deviceId/metadata
                return ParticlePaths.v1Diagnostics.rawValue.appending(separator).appending(deviceID.rawValue).appending("/metadata")
                
            case .getCellularNetworkStatus(let deviceID, let iccid, let productID,_):
                if let id = productID { return "\(ParticlePaths.v1products.rawValue)/\(id.rawValue)/sims/\(deviceID.rawValue)/status"}
                return "\(ParticlePaths.v1sims.rawValue)/\(iccid)/status"
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func remoteDiagnosticsContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .refreshDeviceVitals,
                    .getLastKnownDeviceVitals,
                    .getAllHistoricalDeviceVitals,
                    .getDeviceVitalsMetadata,
                    .getCellularNetworkStatus: return .form
                
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func remoteDiagnosticsAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .refreshDeviceVitals,
                    .getLastKnownDeviceVitals,
                    .getAllHistoricalDeviceVitals,
                    .getDeviceVitalsMetadata,
                    .getCellularNetworkStatus: break
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func remoteDiagnosticsHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .refreshDeviceVitals: return .POST
            case .getLastKnownDeviceVitals,
                    .getAllHistoricalDeviceVitals,
                    .getDeviceVitalsMetadata,
                    .getCellularNetworkStatus: return .GET
                
                
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func remoteDiagnosticsQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .refreshDeviceVitals(_,_,let token),
                    .getLastKnownDeviceVitals(_,_,let token):
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            case .getAllHistoricalDeviceVitals(_,_, let startDate, let endDate, let token):
                var items =  [URLQueryItem(name: "access_token", value: token.accessToken)]
                
                if let start = startDate {
                    items.append(URLQueryItem(name: "start_date", value: start))
                }
                
                if let end = endDate {
                    items.append(URLQueryItem(name: "end_date", value: end))
                }
                
                return items
                
            case .getDeviceVitalsMetadata(_,_, let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            case .getCellularNetworkStatus(_,_,_, let token):
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            default: abort()
        }
    }
    
        //MARK: Payload
    internal func remoteDiagnosticsPayload(_ resource: CloudResource) -> Data? {
        
        switch resource {
                
            case .refreshDeviceVitals,
                    .getLastKnownDeviceVitals,
                    .getAllHistoricalDeviceVitals,
                    .getDeviceVitalsMetadata,
                    .getCellularNetworkStatus: break
                
            default: abort()
        }
        return nil
    }
}

    //MARK: - User - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForUserResource(_ resource: CloudResource) -> String {
        
        switch resource {
            case .getUser,
                    .updateUser,
                    .deleteUser:
                
                return ParticlePaths.v1users.rawValue
                
            case .forgotPassword:
                return "\(ParticlePaths.v1users.rawValue)/password-reset"
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func userContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .getUser: return .form
            case .updateUser: return .form
            case .deleteUser: return .form
            case .forgotPassword: return .form
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func userAuthHeader(_ resource: CloudResource) -> String? {
        switch resource {
                
            case .getUser, .updateUser, .deleteUser, .forgotPassword: break
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func userHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        switch resource {
            case .getUser: return .GET
            case .updateUser: return .PUT
            case .deleteUser: return .PUT
            case .forgotPassword: return .POST
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func userQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        switch resource {
            case .getUser(let token):
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
            case .updateUser,
                    .deleteUser,
                    .forgotPassword:
                return nil
                
            default: abort()
        }
    }
    
        //MARK: Payload
    internal func userPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
            case .getUser: break
            case .updateUser(let username, let password, let accountInfo, let currentPassword, let token):
                payload = ["username=\(username)",
                           "accountInfo[first_name]=\(String(describing: accountInfo.firstName))",
                           "accountInfo[last_name]=\(String(describing: accountInfo.lastName))",
                           "accountInfo[business_account]=\(accountInfo.businessAccount)",
                           "accountInfo[company_name]=\(String(describing: accountInfo.companyName))",
                           "current_password=\(currentPassword)",
                           "access_token=\(token.accessToken)"]
                if let password = password {
                    payload?.append( "password=\(password)" )
                }
                
            case .deleteUser(let password, let token):
                payload = ["password=\(password)", "access_token=\(token.accessToken)"]
                
            case .forgotPassword(let username):
                payload = ["username=\(username)"]
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Quarantine - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForQuarantineResource(_ resource: CloudResource) -> String {
        
        switch resource {
            case .approveQuarantinedDevice(_, let productID,_):
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/devices"
                
            case .denyQuarantinedDevice(_, let productID,_):
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/devices"
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func quarantineContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .approveQuarantinedDevice,
                    .denyQuarantinedDevice:
                
                return .form
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func quarantineAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .approveQuarantinedDevice(_,_,let token),
                    .denyQuarantinedDevice(_,_, let token):
                
                return "\(token.accessToken)".data(using: .utf8)!.base64EncodedString()
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func quarantineHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .approveQuarantinedDevice:
                return .POST
                
            case .denyQuarantinedDevice:
                return .DELETE
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func quarantineQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
            case .approveQuarantinedDevice,
                    .denyQuarantinedDevice: return nil
                
            default: abort()
        }
    }
    
        //MARK: Payload
    internal func quarantinePayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .approveQuarantinedDevice(let deviceID,_,_):
                payload = ["id=\(deviceID.rawValue)"]
                
            case .denyQuarantinedDevice:
                payload = ["deny=true"]
                
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Sim Cards - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForSimCardResource(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .listSimCards(let arguments,_):
                if let id = arguments.productId { return "\(ParticlePaths.v1products.rawValue)/\(id)/sims" }
                return ParticlePaths.v1sims.rawValue
                
            case .getDataUsage(let iccid, let productID,_):
                if let id = productID { return "\(ParticlePaths.v1products.rawValue)/\(id.rawValue)/sims/\(iccid)/data_usage" }
                return "\(ParticlePaths.v1sims.rawValue)/\(iccid)/data_usage"
                
            case .getDataUsageForProductFleet(let productID,_):
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/sims/data_usage"
                
            case .activateSIM(let iccid,_):
                return "\(ParticlePaths.v1sims.rawValue)/\(iccid)"
                
            case .importAndActivateProductSIMs(let productID,_,_,_):
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/sims"
                
            case .deactivateSIM(let iccid, let productID,_),
                    .reactivateSIM(let iccid, let productID,_),
                    .releaseSimFromAccount(let iccid, let productID,_):
                
                if let id = productID { return "\(ParticlePaths.v1products.rawValue)/\(id.rawValue)/sims/\(iccid)" }
                return "\(ParticlePaths.v1sims.rawValue)/\(iccid)"
                
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func simCardContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .listSimCards,
                    .getDataUsage,
                    .getDataUsageForProductFleet,
                    .activateSIM,
                    .importAndActivateProductSIMs,
                    .deactivateSIM,
                    .reactivateSIM,
                    .releaseSimFromAccount:
                
                return .form
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func simCardAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .listSimCards,
                    .getDataUsage,
                    .getDataUsageForProductFleet,
                    .activateSIM,
                    .importAndActivateProductSIMs,
                    .deactivateSIM,
                    .reactivateSIM,
                    .releaseSimFromAccount: break
                
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func simCardHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .listSimCards,
                    .getDataUsage,
                    .getDataUsageForProductFleet:
                
                return .GET
                
            case .activateSIM: return .PUT
            case .importAndActivateProductSIMs: return .POST
            case .deactivateSIM,
                    .reactivateSIM:
                return .PUT
                
            case .releaseSimFromAccount: return .DELETE
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func simCardQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .listSimCards(let arguments, let token):
                var queryItems = [URLQueryItem(name: "access_token", value: token.accessToken)]
                
                for key in PCSimCard.ListRequestArgument.CodingKeys.allCases {
                    if let value = arguments.value(for: key) {
                        queryItems.append( URLQueryItem(name: key.rawValue, value: value) )
                    }
                }
                
            case .getDataUsage(_,_,let token),
                    .getDataUsageForProductFleet(_, let token):
                
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            case .activateSIM,
                    .importAndActivateProductSIMs,
                    .deactivateSIM,
                    .reactivateSIM,
                    .releaseSimFromAccount: return nil
                
            default: abort()
        }
        return nil
    }
    
        //MARK: Payload
    internal func simCardPayload(_ resource: CloudResource) -> Data? {
        
        var payload: [String]?
        
        switch resource {
                
            case .listSimCards,
                    .getDataUsage,
                    .getDataUsageForProductFleet: return nil
                
            case .activateSIM(_, let token):
                payload = ["action=activate", "access_token=\(token.accessToken)"]
                
            case .importAndActivateProductSIMs(_, let sims, let file, let token):
                payload = []
                if let sims = sims { payload?.append("sims[]=\(sims)") }
                if let file = file {payload?.append("file=\(file)")}
                payload?.append("access_token=\(token.accessToken)")
                
            case .deactivateSIM(_,_,let token):
                payload = ["action=deactivation", "access_token=\(token.accessToken)"]
                
            case .reactivateSIM(_,_,let token):
                payload = ["action=reactivate", "access_token=\(token.accessToken)"]
                
            case .releaseSimFromAccount(_,_,let token):
                payload = ["access_token=\(token.accessToken)"]
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Events - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForEventResource(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .getEventStream(let eventName,_):

                return "\(ParticlePaths.v1events.rawValue)/\(eventName.rawValue)"
                
            case .getDeviceEventStream(let eventName, let deviceId,_):
                
                if let name = eventName {
                    ///v1/devices/events/:eventName
                    return "\(ParticlePaths.v1devices.rawValue)/\(deviceId.rawValue)/events/\(name.rawValue)"
                }
                ///v1/devices/events
                return ParticlePaths.v1devices.rawValue.appending("/events")

                    ///Open a stream of Server Sent Events for all public and private events for a product.
                    ///requires scope:  events:get
            case .getProductEventStream(let eventName, let productID,_):
                if let name = eventName?.rawValue {
                    return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/events/\(name)"
                }
                return "\(ParticlePaths.v1products.rawValue)/\(productID.rawValue)/events"

            case .publishEvent(_, let prodID,_,_,_,_):
                    //POST https://api.particle.io/v1/products/:productID/events
                if let prodID = prodID { return "\(ParticlePaths.v1products.rawValue)/\(prodID.rawValue)/events" }
                return "\(ParticlePaths.v1devices.rawValue)/events"
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func eventsAcceptType(_ resource: CloudResource) -> AllowableContentType? {
        
        switch resource {
            case .getEventStream,
                    .getDeviceEventStream,
                    .getProductEventStream: return .events
                
            case .publishEvent: return .jSon
                
            default: abort()
        }
    }
    
    internal func eventContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .getEventStream,
                    .getDeviceEventStream,
                    .getProductEventStream,
                    .publishEvent: return .form
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func eventAuthHeader(_ resource: CloudResource) -> String? {
        switch resource {
            case .getEventStream,
                    .getDeviceEventStream,
                    .getProductEventStream: break
                
            case .publishEvent(_,_,_,_,_,let token):
                return "Bearer \(token.accessToken)"
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func eventHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        switch resource {
            case .getEventStream,
                    .getDeviceEventStream,
                    .getProductEventStream: return .GET
                
            case .publishEvent: return .POST
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func eventQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        switch resource {
            case .getEventStream(_,let token),
                    .getDeviceEventStream(_,_, let token),
                    .getProductEventStream(_,_, let token):
                
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            case .publishEvent: return nil
                
            default: abort()
        }
    }
    
        //MARK: Payload
    internal func eventPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
            case .getEventStream,
                    .getDeviceEventStream,
                    .getProductEventStream: break
                
            case .publishEvent(let name,_, let content, let isPrivate, let ttl,_):
                payload = ["name=\(name.rawValue)"]
                if let content = content { payload?.append("data=\(content)")}
                if let isPrivate = isPrivate { payload?.append("private=\(isPrivate)") }
                if let ttl = ttl { payload?.append("ttl=\(ttl)") }
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Integrations and Webhooks
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForIntegrationsAndWebhooks(_ resource: CloudResource) -> String {
        
        switch resource {
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func integrationsAndWebhooksContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func integrationsAndWebhooksAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func integrationsAndWebhooksHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func integrationsAndWebhooksQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func integrationsAndWebhooksPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //    MARK: - Special Events
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForSpecialEvents(_ resource: CloudResource) -> String {
        
        switch resource {
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func specialEventsContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func specialEventsAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func specialEventsHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func specialEventsQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func specialEventsPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Asset Tracking Special Events
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForAssetTrackingSpecialEvents(_ resource: CloudResource) -> String {
        
        switch resource {
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func assetTrackingSpecialEventsContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func assetTrackingSpecialEventsAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func assetTrackingSpecialEventsHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func assetTrackingSpecialEventsQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func assetTrackingSpecialEventsPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Firmware
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForFirmware(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .updateDeviceFirmware(let deviceID,_,_):
                
                    //PUT /v1/devices/:deviceId
                return ParticlePaths.v1devices.rawValue.appending(separator).appending(deviceID.rawValue)
                
            case .flashDeviceWithSourceCode(let deviceID,_,_,_):
                
                    //PUT /v1/devices/:deviceID?access_token=1234
                return ParticlePaths.v1devices.rawValue.appending(separator).appending(deviceID.rawValue)
                
            case .flashDeviceWithPreCompiledBinary(let deviceID,_,_,_):
                
                    //PUT /v1/devices/:deviceId
                return ParticlePaths.v1devices.rawValue.appending(separator).appending(deviceID.rawValue)
                
            case .compileSourceCode:
                
                    //POST /v1/binaries
                return ParticlePaths.v1binaries.rawValue
                
            case .listFirmwareBuildTargets:
                
                    //GET /v1/build_targets
                return ParticlePaths.v1buildTargets.rawValue
                
            case .lockProductDevice(let deviceID, let productId,_,_,_):
                
                    //PUT /v1/products/:productIdOrSlug/devices/:deviceId
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue.description).appending("/devices/").appending(deviceID.rawValue)
                
            case .unlockProductDevice(let deviceID, let productId,_):
                    //PUT /v1/products/:productIdOrSlug/devices/:deviceId
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue.description).appending("/devices/").appending(deviceID.rawValue)
                
            case .unmarkProductDevelopmentDevice(let deviceID, let productIdOrSlug,_,_):
                
                    //PUT /v1/products/:productIdOrSlug/devices/:deviceId
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productIdOrSlug.rawValue.description).appending("/devices/").appending(deviceID.rawValue)
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func firmwareContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .flashDeviceWithSourceCode: return .form
            case .updateDeviceFirmware: return .form
            case .flashDeviceWithPreCompiledBinary: return .form
            case .compileSourceCode: return .form
            case .listFirmwareBuildTargets: return .form
            case .lockProductDevice: return .form
            case .unlockProductDevice: return .form
            case .unmarkProductDevelopmentDevice: return .form
                
            default: abort()
        }
    }
    
    internal func firmwareContentAcceptType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .flashDeviceWithSourceCode: return .jSon
            case .updateDeviceFirmware: return .jSon
            case .flashDeviceWithPreCompiledBinary: return .jSon
            case .compileSourceCode: return .jSon
            case .listFirmwareBuildTargets: return .jSon
            case .lockProductDevice: return .jSon
            case .unlockProductDevice: return .jSon
            case .unmarkProductDevelopmentDevice: return .jSon
                
            default: abort()
        }
    }
    
    
        //MARK: AUTH Header
    internal func firmwareAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .flashDeviceWithSourceCode: return nil
            case .updateDeviceFirmware: return nil
            case .flashDeviceWithPreCompiledBinary: return nil
            case .compileSourceCode: return nil
            case .listFirmwareBuildTargets: return nil
            case .lockProductDevice: return nil
            case .unlockProductDevice: return nil
            case .unmarkProductDevelopmentDevice: return nil
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func firmwareHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
            case .flashDeviceWithSourceCode: return .PUT
            case .updateDeviceFirmware: return .PUT
            case .flashDeviceWithPreCompiledBinary: return .PUT
            case .compileSourceCode: return .POST
            case .listFirmwareBuildTargets: return .GET
            case .lockProductDevice: return .PUT
            case .unlockProductDevice: return .PUT
            case .unmarkProductDevelopmentDevice: return .PUT
                
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func firmwareQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .updateDeviceFirmware(_,_,let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            case .flashDeviceWithSourceCode(_,_,_,let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            case .flashDeviceWithPreCompiledBinary(_,_,_,let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            case .compileSourceCode(_,_,_,_,let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            case .listFirmwareBuildTargets(let featured):
                return [URLQueryItem(name: "featured", value: "\(featured)")]
                
            case .lockProductDevice: return nil
            case .unlockProductDevice: return nil
            case .unmarkProductDevelopmentDevice: return nil
                
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func firmwarePayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
            case .updateDeviceFirmware(_,let version,_):
                payload = ["build_target_version=\(version)"]
                
            case .flashDeviceWithSourceCode(_,let sourceCodePaths,let version,_):
                payload = ["build_target_version=\(version)"]
                payload!.append("file=@\(sourceCodePaths[0]);filename=\(sourceCodePaths[0])")
            
                var count = 0
                for path in sourceCodePaths {
                    if count > 0 {
                        payload!.append("file\(count)=@\(path);filename=\(path)")
                    }
                    count += 1
                }
                
            case .flashDeviceWithPreCompiledBinary(_,let build_target_version,let filePath,_):
                
                payload = [
                    "file=@\(filePath)",
                    "file_type=binary",
                    "build_target_version=\(build_target_version)"
                ]
                
            case .compileSourceCode(let filePaths,_, let product_id,_,_):
                
                payload = [
                    "platform_id=\(product_id.rawValue)",
                ]
            
            if !filePaths.isEmpty {
                payload!.append("file=@\(filePaths[0]);filename=\(filePaths[0])")
            }
                
                var count = 0
                for path in filePaths {
                    if count > 0 {
                        payload!.append("file\(count)=@\(path);filename=\(path)")
                    }
                    count += 1
                }
                
            case .listFirmwareBuildTargets: return nil
                
            case .lockProductDevice(_,_,let version, let flash, let token):
                
                payload = [
                    "desired_firmware_version=\(version)",
                    "flash=\(flash)",
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
            case .unlockProductDevice(_,_,let token):
                payload = [
                    "desired_firmware_version=null",
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
            case .unmarkProductDevelopmentDevice(_,_,let development, let token):
                payload = [
                    "development=\(development)",
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Product Firmware
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForProductFirmware(_ resource: CloudResource) -> String {
        
        switch resource {
            case .getProductFirmware(let productId, let version,_):
                
                    // GET /v1/products/:productIdOrSlug/firmware/:version
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/firmware/").appending(version)
                
            case .listAllProductFirmwares(let productId,_):
                
                    //                GET /v1/products/:productIdOrSlug/firmware
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/firmware")
                
            case .uploadProductFirmware(let productID,_,_,_):
                
                    //POST /v1/products/:productIdOrSlug/firmware
            return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/firmware")
                
            case .editProductFirmware(let productID, let arguments,_):
                
                    //PUT /v1/products/:productIdOrSlug/firmware/:version
            return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/firmware/").appending(arguments.version)
                
                
            case .downloadFirmwareBinary(let productId, let version,_):
                
                    //GET /v1/products/:productIdOrSlug/firmware/:version/binary
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/firmware/").appending(String(version)).appending("/binary")
                
            case .releaseProductFirmware(let productID,_,_):
                
                    // PUT /v1/products/:productIdOrSlug/firmware/release
            return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/firmware/release")
                
            case .deleteUnreleasedFirmwareBinary(let productId, let version,_):
                
                    //DELETE /v1/products/:productIdOrSlug/firmware/:version
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/firmware/").appending(String(version))
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func productFirmwareContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .getProductFirmware,
                    .listAllProductFirmwares,
                    .uploadProductFirmware,
                    .editProductFirmware,
                    .downloadFirmwareBinary,
                    .releaseProductFirmware,
                    .deleteUnreleasedFirmwareBinary: return .form
                
            default: abort()
        }
    }
    
        //MARK: Accept Type
    internal func productFirmwareAcceptType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .getProductFirmware,
                    .listAllProductFirmwares,
                    .uploadProductFirmware,
                    .editProductFirmware,
                    .downloadFirmwareBinary,
                    .releaseProductFirmware,
                    .deleteUnreleasedFirmwareBinary: return .jSon
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func productFirmwareAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .getProductFirmware,
                    .listAllProductFirmwares,
                    .uploadProductFirmware,
                    .editProductFirmware,
                    .downloadFirmwareBinary,
                    .releaseProductFirmware,
                    .deleteUnreleasedFirmwareBinary: return nil
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func productFirmwareHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .getProductFirmware,
                    .listAllProductFirmwares: return .GET
                
            case .uploadProductFirmware:
                return .POST
                
            case .editProductFirmware:
                return .PUT
                
            case .downloadFirmwareBinary: return .GET
                
            case .releaseProductFirmware: return .PUT
                
            case .deleteUnreleasedFirmwareBinary: return .DELETE
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func productFirmwareQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .getProductFirmware(_,_,let token),
                    .listAllProductFirmwares(_, let token),
                    .uploadProductFirmware(_,_,_, let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken )]
                
            case .editProductFirmware:  return nil
                
            case .downloadFirmwareBinary(_,_, let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken )]
                
            case .releaseProductFirmware: return nil
                
            case .deleteUnreleasedFirmwareBinary(_,_, let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken )]
                
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func productFirmwarePayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .getProductFirmware,
                    .listAllProductFirmwares: return nil
                
            case .uploadProductFirmware(_,let filePath,let arguments,_):
                
            let data = FileManager.default.contents(atPath: filePath)!.base64EncodedData()
            
                payload = [
                    "file=@\(data)",
                    "version=\(arguments.version)",
                    "title=\(arguments.title)"
                ]
                
                if let description = arguments.description {
                    payload?.append("description=\(description)")
                }
                
                if let mandatory = arguments.mandatory {
                    payload?.append("mandatory=\(String(mandatory))")
                }
                
            case .editProductFirmware(_, let arguments, let token):
                payload = [
                    "title=\(arguments.title)",
                    "version=\(arguments.version)",
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
                if let description = arguments.description {
                    payload?.append("description=\(description)")
                }
                
                if let manditory = arguments.mandatory {
                    payload?.append("mandatory=\(String(manditory))")
                }
                
            case .downloadFirmwareBinary: return nil
                
                
            case .releaseProductFirmware(_,let arguments, let token):
               
            payload = [
                    "version=\(arguments.version)",
                    "product_default=\(arguments.product_default)",
                    "intelligent=\(arguments.intelligent)",
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
                if let groups = arguments.groups {
                    payload?.append("groups[]=\(groups.joined(separator: "&groups[]="))")
                }
                
            case .deleteUnreleasedFirmwareBinary: return nil
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Library
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForLibrary(_ resource: CloudResource) -> String {
        
        switch resource {
            case .listLibraries:
                    // GET /v1/libraries?scope=official&sort=name&access_token=1234
                return ParticlePaths.libraries.rawValue
                
            case .getLibraryDetails(let arguments,_):
                    //GET /v1/libraries/:libraryName:
                return ParticlePaths.libraries.rawValue.appending(separator).appending(arguments.libraryName)
                
            case .getLibraryVersions(let libraryName,_,_):
                    //GET /v1/libraries/:libraryName:/versions
                return ParticlePaths.libraries.rawValue.appending(separator).appending(libraryName).appending("/versions")
                
            case .uploadLibraryVersion(let name,_,_):
                    //POST /v1/libraries/:libraryName:
                return ParticlePaths.libraries.rawValue.appending(separator).appending(name)
                
                
            case .makeLibraryVersionPublic(let libraryName,_,_):
                    //PATCH /v1/libraries/:libraryName:
                return ParticlePaths.libraries.rawValue.appending(separator).appending(libraryName)
                
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func libraryContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .listLibraries,
                    .getLibraryDetails,
                    .getLibraryVersions,
                    .uploadLibraryVersion,
                    .makeLibraryVersionPublic: return .form
                
                
                
            default: abort()
        }
    }
    
    internal func libraryAcceptType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .listLibraries,
                    .getLibraryDetails,
                    .getLibraryVersions,
                    .uploadLibraryVersion,
                    .makeLibraryVersionPublic: return .jSon
                
                
                
            default: abort()
        }
    }
    
    
    
    
        //MARK: AUTH Header
    internal func libraryAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
            case .listLibraries,
                    .getLibraryDetails,
                    .getLibraryVersions: return nil
                
            case .uploadLibraryVersion:
                return nil //may need auth header?.?
                
            case .makeLibraryVersionPublic: return nil
                
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func libraryHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .listLibraries: return .GET
            case .getLibraryDetails: return .GET
            case .getLibraryVersions: return .GET
            case .uploadLibraryVersion: return .POST
            case .makeLibraryVersionPublic: return .PATCH
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func libraryQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                    // GET /v1/libraries?scope=official&sort=name&access_token=1234
            case .listLibraries(let arguments, let token):
                var queryItems = [
                    URLQueryItem(name: "filter", value: arguments.filter),
                    URLQueryItem(name: "scope", value: arguments.scope.rawValue),
                    URLQueryItem(name: "sort", value: arguments.sortOrder.rawValue.appending(arguments.sort.rawValue)),
                    URLQueryItem(name: "page", value: String(arguments.page)),
                    URLQueryItem(name: "limit", value: String(arguments.limit)),
                    URLQueryItem(name: "access_token", value: token.accessToken)
                ]
                
                if let excluded = arguments.excludeScopes?.map({$0.rawValue}).joined(separator: ",") {
                    queryItems.append( URLQueryItem(name: "excludeScopes", value: excluded) )
                }
                
                if let architectures = arguments.architectures?.joined(separator: ",") {
                    queryItems.append( URLQueryItem(name: "architectures", value: architectures) )
                }
                
                return queryItems
                
                
            case .getLibraryDetails(let arguments, let token):
                return [
                    URLQueryItem(name: "scope", value: arguments.version.rawValue),
                    URLQueryItem(name: "access_token", value: token.accessToken)
                ]
                
            case .getLibraryVersions(_,let scope,let token):
                return [
                    URLQueryItem(name: "scope", value: scope.rawValue),
                    URLQueryItem(name: accessToken, value: token.accessToken)
                ]
                
            case .uploadLibraryVersion(_,_,let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)] //may need auth header instead?.?
                
            case .makeLibraryVersionPublic(_,_,let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
                
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func libraryPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .listLibraries: return nil
            case .getLibraryDetails: return nil
            case .getLibraryVersions: return nil
                
            case .uploadLibraryVersion:
                return nil
            case .makeLibraryVersionPublic(_,let visibility,_):
                payload = ["visibility=\(visibility)"]
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Products - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForProductResource(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .listProducts:
                    //GET /v1/user/products
                return ParticlePaths.v1users.rawValue.appending("/products")
                
            case .retrieveProduct(let productID,_):
                    //GET /v1/products/:productIdOrSlug
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue)
                
            case .listTeamMembers(let productID,_):
                    //GET /v1/products/:productIdOrSlug/team
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/team")
                
            case .inviteTeamMember(let productID,_,_,_):
                    //POST /v1/products/:productIdOrSlug/team
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/team")
                
            case .createAnAPIuser(let productID,_,_,_):
                    //POST /v1/products/:productIdOrSlug/team
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/team")
                
            case .updateTeamMember(let productID, let username,_):
                    //POST /v1/products/:productIdOrSlug/team/:username
                return ParticlePaths.v1products.rawValue.appending("/").appending(productID.rawValue).appending("/team/").appending(username)
                
            case .removeTeamMember(let productID, let username,_):
                    //DELETE /v1/products/:productIdOrSlug/team/:username
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/team/").appending(username)
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func productContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .listProducts,
                    .retrieveProduct,
                    .listTeamMembers,
                    .inviteTeamMember: return .form
                
            case .createAnAPIuser: return .jSon
                
            case .updateTeamMember,
                    .removeTeamMember: return .form
                
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func productAuthHeader(_ resource: CloudResource) -> String? {
        switch resource {
                
            case .listProducts(let token):
                return "Bearer \(token.accessToken)"
                
            case .retrieveProduct,
                    .listTeamMembers,
                    .inviteTeamMember,
                    .createAnAPIuser: break
                
            case .updateTeamMember(_,_, let token):
                return "\(token.accessToken)".data(using: .utf8)!.base64EncodedString()
                
            case .removeTeamMember(_,_, let token):
                return "\(token.accessToken)".data(using: .utf8)!.base64EncodedString()
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func productHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        switch resource {
                
            case .listProducts,
                    .retrieveProduct,
                    .listTeamMembers: return .GET
                
            case .inviteTeamMember,
                    .createAnAPIuser,
                    .updateTeamMember: return .POST
                
            case .removeTeamMember: return .DELETE
                
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func productQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        switch resource {
            case .listProducts: break
            case .retrieveProduct(_,let token),
                    .listTeamMembers(_, let token):
                
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            case .inviteTeamMember: break
                
            case .createAnAPIuser(_,_,_, let token):
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            case .updateTeamMember: break
                
            case .removeTeamMember: break
                
                
            default: abort()
        }
        return nil
    }
    
        //MARK: Payload
    internal func productPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
            case .listProducts,
                    .retrieveProduct,
                    .listTeamMembers: break
                
            case .inviteTeamMember(_,let username, let role, let token):
                payload = ["username=\(username)",
                           "role=\(role.rawValue)",
                           "access_token=\(token.accessToken)"]
                
            case .createAnAPIuser(_, let friendlyName, let scope,_):
                payload = ["friendly_name=\(friendlyName)",
                           "scopes=\(scope.map{ $0.rawValue })"]
                
            case .updateTeamMember,
                    .removeTeamMember: break
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Device Groups
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForDeviceGroups(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .getDeviceGroup(let productId, let groupName,_):
                
                    // GET /v1/products/:productIdOrSlug/groups/:groupName
                return ParticlePaths.v1products.rawValue.appending(separator) // /v1/products/
                    .appending(productId.rawValue) //:productIdOrSlug
                    .appending("/groups/") // /groups/
                    .appending(groupName.rawValue) //:groupName
                
            case .listDeviceGroups(let productId,_,_):
                    //GET /v1/products/:productIdOrSlug/groups
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/groups")
                
            case .createDeviceGroup(let productId,_,_,_,_):
                
                    //POST /v1/products/:productIdOrSlug/groups
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/groups")
                
            case .editDeviceGroup(let productId, let groupName,_,_,_,_):
                
                    //PUT /v1/products/:productIdOrSlug/groups/:groupName
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/groups/").appending(groupName.rawValue)

            case .deleteDeviceGroup(let productId, let groupName,_):
                
                // DELETE /v1/products/:productIdOrSlug/groups/:groupName
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/groups/").appending(groupName.rawValue)
            
            case .assignGroupsToDevice(let deviceId, let productId,_,_):

                //PUT /v1/products/:productIdOrSlug/devices/:deviceId
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/devices/").appending(deviceId.rawValue)
                
            case .batchAssignGroupsToDevices(let productId,_):
                
                //PUT /v1/products/:productIdOrSlug/devices
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/devices")
                
            case .impactOfTakingAction(let productId,_,_):
                
                //GET /v1/products/:productIdOrSlug/impact
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/impact")

            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func deviceGroupsContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .getDeviceGroup,
                    .createDeviceGroup,
                    .editDeviceGroup,
                    .deleteDeviceGroup,
                    .assignGroupsToDevice,
                    .batchAssignGroupsToDevices,
                    .impactOfTakingAction: return .form

            default: abort()
        }
    }
    
        //MARK: Accept Type
    internal func deviceGroupsAcceptType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .getDeviceGroup,
                    .createDeviceGroup,
                    .editDeviceGroup,
                    .deleteDeviceGroup,
                    .assignGroupsToDevice,
                    .batchAssignGroupsToDevices,
                    .impactOfTakingAction: return .jSon
                
            default: abort()
        }
    }

    
        //MARK: AUTH Header
    internal func deviceGroupsAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .getDeviceGroup,
                    .listDeviceGroups,
                    .createDeviceGroup,
                    .editDeviceGroup,
                    .deleteDeviceGroup,
                    .assignGroupsToDevice,
                    .batchAssignGroupsToDevices,
                    .impactOfTakingAction: return nil

            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func deviceGroupsHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
            case .getDeviceGroup,
                    .listDeviceGroups: return .GET

            case .createDeviceGroup:return .POST
            
            case .editDeviceGroup: return .PUT
                
            case .deleteDeviceGroup: return .DELETE

            case .assignGroupsToDevice,
                    .batchAssignGroupsToDevices: return .PUT

            case .impactOfTakingAction: return .GET

            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func deviceGroupsQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .getDeviceGroup(_,_,let token):
                
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            case .listDeviceGroups(_, let name, let token):

                return [
                    URLQueryItem(name: accessToken, value: token.accessToken),
                    URLQueryItem(name: "name", value: name)
                ]
                
            case .createDeviceGroup,
                    .editDeviceGroup,
                    .deleteDeviceGroup,
                    .assignGroupsToDevice,
                    .batchAssignGroupsToDevices: return nil
                
                
            case .impactOfTakingAction(_,_,let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]

                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func deviceGroupsPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .getDeviceGroup,
                    .listDeviceGroups: return nil


            case .createDeviceGroup(_, let name, let color, let description, let token):

                payload = [
                    "name=\(name.rawValue)",
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
                if let color = color {
                    payload?.append("color=\(color)")
                }
                
                if let description = description {
                    payload?.append("description=\(description)")
                }
                
            case .editDeviceGroup(_,_, let newName, let color, let description, let token):
                
                payload = [
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
                if let color = color {
                    payload?.append("color=\(color)")
                }
                
                if let description = description {
                    payload?.append("description=\(description)")
                }
                
                if let newName = newName {
                    payload?.append("newName=\(newName.rawValue)")
                }
                
            case .deleteDeviceGroup(_,_, let token):
                
                payload = [accessToken.appending("=").appending(token.accessToken)]
                
            case .assignGroupsToDevice(_,_, let groups, let token):

                payload = [
                    "groups[]=\(groups.map({$0.rawValue}).joined(separator:"groups[]="))",
                    accessToken.appending("=").appending(token.accessToken)
                ]
                
            case .batchAssignGroupsToDevices(_, let token):

                payload = [accessToken.appending("=").appending(token.accessToken)]

            case .impactOfTakingAction: return nil
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Asset Tracking
extension CloudResource.RequestHelper {
    
        //case setConfiguration(let productID, let deviceID, let token):
        //case setConfigurationSchema(let productID, let deviceID, let token):
    
        //MARK: Paths
    internal func pathForAssetTracking(_ resource: CloudResource) -> String {
        
        switch resource {
            case .queryLocationForDevicesWithinProduct(let arguments,_):
                    //v1/products/:productIdOrSlug/location
                    // note singular `location` endpoint
                return ParticlePaths.v1products.rawValue.appending("/").appending(String(arguments.productIDorSlug.rawValue)).appending("/location")
                
            case .queryLocationForOneDeviceWithinProduct(let productID, let deviceID,_,_,_,_):
                    //v1/products/:productIdOrSlug/location/:deviceId
                    // note plural `locations` endpoint
                return ParticlePaths.v1products.rawValue.appending("/").appending(productID.rawValue).appending("/locations/").appending(deviceID.rawValue)
                
            case .getProductConfiguration(let productID,_):
                    //GET /v1/products/:productIdOrSlug/config
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/config")
                
            case .getDeviceConfiguration(let deviceID, let productID,_):
                    //GET /v1/products/:productIdOrSlug/config/:deviceId
                return ParticlePaths.v1products.rawValue.appending(productID.rawValue).appending("/config/").appending(deviceID.rawValue)
                
            case .getSchema(let productID, let deviceID,_):
                if let id = deviceID?.rawValue {
                        //GET /v1/products/:productIdOrSlug/config/:deviceId
                    return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/config/").appending(id)
                }
                    //GET /v1/products/:productIdOrSlug/config
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/config")
                
#warning("Fix this mess.")
            case .deleteOrResetConfigurationSchema(let productID, let deviceID, let reset,_):
                    //delete or reset device
                    //DELETE /v1/products/:productIdOrSlug/config/:deviceID
                if reset == false {
                    if let id = deviceID?.rawValue {
                            //DELETE /v1/products/:productIdOrSlug/config/:deviceId
                        return ParticlePaths.v1products.rawValue.appending(separator).appending(productID.rawValue).appending("/config/").appending(id)
                    } else {
                            //
                            //PUT /v1/products/:productIdOrSlug/config
                        return ParticlePaths.v1products.rawValue.appending(separator).appending("/config")
                    }
                } else {
                    if let id = deviceID?.rawValue {
                        
                    }
                }
                
                return ""
                
            case .setConfiguration(let productId, let deviceID,_):
                if let id = deviceID?.rawValue {
                        //PUT /v1/products/:productIdOrSlug/config/:deviceId
                    return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/config/").appending(id)
                }
                //PUT /v1/products/:productIdOrSlug/config
                return ParticlePaths.v1products.rawValue.appending(separator).appending(productId.rawValue).appending("/config")
                
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func assetTrackingContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .queryLocationForDevicesWithinProduct,
                    .queryLocationForOneDeviceWithinProduct,
                    .getProductConfiguration,
                    .getDeviceConfiguration,
                    .getSchema,
                    .setConfiguration: return .form
                
            default: abort()
        }
    }
    
    internal func assetTrackingAcceptType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .queryLocationForDevicesWithinProduct,
                    .queryLocationForOneDeviceWithinProduct,
                    .getProductConfiguration,
                    .getDeviceConfiguration: return .jSon
                
            case .getSchema: return .jSon_schema
                
            case .setConfiguration: return .jSon
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func assetTrackingAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
            case .queryLocationForDevicesWithinProduct,
                    .queryLocationForOneDeviceWithinProduct,
                    .getProductConfiguration,
                    .getDeviceConfiguration: return nil
                
            case .getSchema(_,_,let token):
                return token.accessToken.data(using: .utf8)?.base64EncodedString()
                
            case .setConfiguration: 
                return nil
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func assetTrackingHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
            case .queryLocationForDevicesWithinProduct,
                    .queryLocationForOneDeviceWithinProduct,
                    .getProductConfiguration,
                    .getDeviceConfiguration,
                    .getSchema: return .GET
                
            case .setConfiguration: return .PUT

                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func assetTrackingQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .queryLocationForDevicesWithinProduct(let arguments, let token):
                let token = [URLQueryItem(name: "access_token", value: token.accessToken)]
                return token + arguments.serverQueryItems
                
            case .queryLocationForOneDeviceWithinProduct(_,_,let dateRange, let rect_bl, let rect_tr, let token):
                return [
                    URLQueryItem(name: "access_token", value: token.accessToken),
                    URLQueryItem(name: "date_range", value: dateRange),
                    URLQueryItem(name: "rect_bl", value: rect_bl),
                    URLQueryItem(name: "rect_tr", value: rect_tr)
                ]
                
            case .getProductConfiguration(_, let token),
                    .getDeviceConfiguration(_,_,let token),
                    .getSchema(_,_, let token):
                
                return [URLQueryItem(name: "access_token", value: token.accessToken)]
                
            case .setConfiguration(_,_, let token):
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            default: abort()
        }
    }
    
        //MARK: Payload
    internal func assetTrackingPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
            case .queryLocationForDevicesWithinProduct,
                    .queryLocationForOneDeviceWithinProduct,
                    .getProductConfiguration,
                    .getDeviceConfiguration,
                    .getSchema: return nil
                   
            case .setConfiguration:
                payload = [
                
                ]
                
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Customer - Done
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForCustomer(_ resource: CloudResource) -> String {
        
        switch resource {
                
            case .createCustomerWithToken(let productID,_,_),
                    .createCustomerWithClient(let productID,_,_,_),
                    .createCustomerImplicit(let productID,_,_),
                    .listCustomersForProduct(let productID,_):
                return ParticlePaths.v1products.rawValue + "/\(productID.rawValue)/customers"
                
            case .generateCustomerWithScopedAccessToken:
                return ParticlePaths.v1oAuth.rawValue
                
            case .updateCustomerPassword(let productID, let credentials,_):
                return ParticlePaths.v1products.rawValue + "/\(productID.rawValue)/customers\(credentials.username)"
                
            case .deleteA_Customer(let productID, let username,_):
                return ParticlePaths.v1products.rawValue + "/\(productID.rawValue)/customers/\(username)"
                
            case .resetPassword(let productID, let email,_):
                return ParticlePaths.v1products.rawValue + "/\(productID.rawValue)/customers/\(email)"
                
            default:
                abort()
        }
    }
    
        //MARK: Content Type
    internal func customerContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
            case .createCustomerWithToken,
                    .createCustomerWithClient,
                    .createCustomerImplicit,
                    .listCustomersForProduct,
                    .generateCustomerWithScopedAccessToken,
                    .updateCustomerPassword,
                    .deleteA_Customer,
                    .resetPassword: return .form
                
                
            default: abort()
        }
    }
    
        //MARK: AUTH Header
    internal func customerAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
            case .createCustomerWithToken(_,_,let token):
                
                return "access_token:\(token.accessToken)".data(using: .utf8)!.base64EncodedString()
                
            case .createCustomerWithClient(_, let client,_,_):
                
                return "\(client.id):\(client.secret)".data(using: .utf8)!.base64EncodedString()
                
            case .createCustomerImplicit(_,let client,_):
                
                return "\(client.id)".data(using: .utf8)!.base64EncodedString()
                
            case .listCustomersForProduct(_, let token):
                
                return "access_token:\(token.accessToken)".data(using: .utf8)!.base64EncodedString()
                
            case .generateCustomerWithScopedAccessToken(let arguments):
                
                return "\(arguments.clientID):\(arguments.clientSecret)".data(using: .utf8)!.base64EncodedString()
                
            case .updateCustomerPassword,
                    .deleteA_Customer: break
                
            case .resetPassword: break
                
            default: abort()
        }
        return nil
    }
    
        //MARK: HTTP Method
    internal func customerHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
            case .createCustomerWithToken,
                    .createCustomerWithClient,
                    .createCustomerImplicit:
                return .POST
                
            case .listCustomersForProduct: return .POST
                
            case .generateCustomerWithScopedAccessToken: return .POST
                
            case .updateCustomerPassword: return .PUT
                
            case .deleteA_Customer: return .DELETE
                
            case .resetPassword: return .PUT
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func customerQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
            case .createCustomerWithToken,
                    .createCustomerWithClient,
                    .createCustomerImplicit,
                    .listCustomersForProduct,
                    .generateCustomerWithScopedAccessToken,
                    .updateCustomerPassword,
                    .deleteA_Customer,
                    .resetPassword: return nil
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func customerPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
            case .createCustomerWithToken(_, let credentials, let token):
                payload = ["username=\(credentials.id)", "password=\(credentials.secret)", "access_token=\(token.accessToken)"]
                
            case .createCustomerWithClient(_,let client, let username, let password):
                payload = ["client_id=\(client.id)",
                           "client_secret=\(client.secret)",
                           "email=\(username)"]
                if let password = password {
                    payload?.append("password=\(password)")
                } else {
                    payload?.append("no_password=true")
                }
                
            case .createCustomerImplicit(_,_,let credentials):
                payload = ["username=\(credentials.username)",
                           "password=\(credentials.password)",
                           "response_type=token"]
                
            case .listCustomersForProduct: return nil
                
            case .generateCustomerWithScopedAccessToken(let arguments):
                payload = [
                    "client_id=\(arguments.clientID)",
                    "client_secret=\(arguments.clientSecret)",
                    "grant_type=\(arguments.grant_type)",
                    "scope=customer=\(arguments.username)"
                ]
                
                if let expireIn = arguments.expiresIn {
                    payload?.append("expires_in=\(expireIn)")
                }
                
                if let expireAt = arguments.expiresAt {
                    payload?.append("expires_at=\(expireAt)")
                }
                
                
            case .updateCustomerPassword(_,let credentials, let token):
                payload = ["password=\(credentials.password)", "access_token=\(token.accessToken)"]
                
            case .deleteA_Customer(_,_, let token):
                payload = ["access_token=\(token.accessToken)"]
                
            case .resetPassword(_,let email, let token):
                payload = ["password=\(email)", "access_token=\(token.accessToken)"]
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}

    //MARK: - Service Agreements
extension CloudResource.RequestHelper {
    
        //MARK: Paths
    internal func pathForServiceAgreements(_ resource: CloudResource) -> String {
        
        switch resource {
                
                    //GET /v1/user/service_agreements
            case .getServiceAgreements:
                return "/v1/user/service_agreements"
                
            case .getUserServiceAgreements(let user,_):
                    //GET /v1/orgs/:user/service_agreements
                return ParticlePaths.v1orgs.rawValue.appending(separator).appending(user).appending("/service_agreements")
                
            case .getOrganizationServiceAgreements(let productID,_):
                    //GET /v1/orgs/:orgIdOrSlug/service_agreements
                return ParticlePaths.v1orgs.rawValue.appending(separator).appending(productID.rawValue).appending("/service_agreements")
                
            case .getUserUsageReport(let usageReportId,_):
                
                    //GET /v1/user/usage_reports/:usageReportId
                return ParticlePaths.v1users.rawValue.appending("/usage_reports/").appending(usageReportId)
                
            case .getOrgUsageReport(_,let orgSlugOrId,_):
                    // GET /v1/orgs/:orgSlugOrId/usage_reports/:usageReportId
                return ParticlePaths.v1orgs.rawValue.appending(separator).appending(orgSlugOrId).appending("/usage_reports/")
                
            case .createUserUsageReport(let arguments,_):
                
                    //POST /v1/user/service_agreements/:serviceAgreementId/usage_reports
                return ParticlePaths.v1users.rawValue.appending("/service_agreements/").appending("\(arguments.service_agreement_id)").appending("/usage_reports")
                
            case .createOrgUsageReport(let arguments,_):
                    //POST /v1/orgs/:orgSlugOrId/service_agreements/:serviceAgreementId/usage_reports
                return ParticlePaths.v1orgs.rawValue.appending(separator).appending(arguments.orgSlugOrId).appending("/service_agreements/").appending(String(arguments.service_agreement_id)).appending("/usage_reports")
                
            case .getUserNotificationsForCurrentUsagePeriod(let serviceAgreementId,_):
                    //GET /v1/user/service_agreements/:serviceAgreementId/notifications
                return ParticlePaths.v1users.rawValue.appending("/service_agreements/").appending(String(serviceAgreementId)).appending("/notifications")
                
            case .getOrganizationNotificationsForCurrentUsagePeriod(let org, let serviceAgreementId,_):
                    //GET/v1/orgs/:orgSlugOrId/service_agreements/:serviceAgreementId/notifications?access_token=123abc"
                return ParticlePaths.v1orgs.rawValue.appending(separator).appending(org).appending("/service_agreements/").appending(String(serviceAgreementId)).appending("/notifications")
                
            default: abort()
        }
    }
    
        //MARK: Content Type
    internal func serviceAgreementsContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .getServiceAgreements,
                    .getUserServiceAgreements,
                    .getOrganizationServiceAgreements,
                    .getUserUsageReport,
                    .getOrgUsageReport,
                    .createUserUsageReport,
                    .createOrgUsageReport,
                    .getUserNotificationsForCurrentUsagePeriod,
                    .getOrganizationNotificationsForCurrentUsagePeriod: return .form
                
            default: abort()
        }
    }
    
        //MARK: Accept Type
    internal func serviceAgreementsAcceptType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
            case .getServiceAgreements,
                    .getUserServiceAgreements,
                    .getOrganizationServiceAgreements,
                    .getUserUsageReport,
                    .getOrgUsageReport,
                    .createUserUsageReport,
                    .createOrgUsageReport,
                    .getUserNotificationsForCurrentUsagePeriod,
                    .getOrganizationNotificationsForCurrentUsagePeriod: return .jSon
                
            default: abort()
        }
    }
    
    
        //MARK: AUTH Header
    internal func serviceAgreementsAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
            case .getServiceAgreements(let token),
                    .getUserServiceAgreements(_,let token),
                    .getOrganizationServiceAgreements(_,let token),
                    .getUserUsageReport(_,let token),
                    .getOrgUsageReport(_,_,let token),
                    .createUserUsageReport(_, let token),
                    .createOrgUsageReport(_, let token):
                
                return "Bearer \(token.accessToken)"
                
            case .getUserNotificationsForCurrentUsagePeriod,
                    .getOrganizationNotificationsForCurrentUsagePeriod: return nil
                
            default: abort()
        }
    }
    
        //MARK: HTTP Method
    internal func serviceAgreementsHTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
            case .getServiceAgreements,
                    .getUserServiceAgreements,
                    .getOrganizationServiceAgreements,
                    .getUserUsageReport,
                    .getOrgUsageReport: return .GET
                
            case .createUserUsageReport,
                    .createOrgUsageReport: return .POST
                
            case .getUserNotificationsForCurrentUsagePeriod,
                    .getOrganizationNotificationsForCurrentUsagePeriod: return .GET
                
            default: abort()
        }
    }
    
        //MARK: Query Items
    internal func serviceAgreementsQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
            case .getServiceAgreements,
                    .getUserServiceAgreements,
                    .getOrganizationServiceAgreements,
                    .getUserUsageReport: return nil
                
            case .getOrgUsageReport(let usageReportId,_,_):
                return [URLQueryItem(name: usageReportId, value: "usageReportId")]
                
            case .createUserUsageReport,
                    .createOrgUsageReport: return nil
                
            case .getUserNotificationsForCurrentUsagePeriod(_, let token),
                    .getOrganizationNotificationsForCurrentUsagePeriod(_,_, let token):
                
                return [URLQueryItem(name: accessToken, value: token.accessToken)]
                
            default: abort()
        }
        
    }
    
        //MARK: Payload
    internal func serviceAgreementsPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
            case .getServiceAgreements,
                    .getUserServiceAgreements,
                    .getOrganizationServiceAgreements,
                    .getUserUsageReport,
                    .getOrgUsageReport: return nil
                
            case .createUserUsageReport(let arguments,_),
                    .createOrgUsageReport(let arguments,_):
                
                payload = [
                    "date_period_start=\(arguments.date_period_start)",
                    "date_period_end=\(arguments.date_period_end)",
                    "orgSlugOrId=\(arguments.orgSlugOrId)",
                    "report_type=\(arguments.report_type)"
                ]
                
                if let devices = arguments.devices {
                    payload?.append("devices=\(devices.map({$0.rawValue}).joined(separator: ","))")
                }
                
                if let products = arguments.products {
                    payload?.append("products=\(products.map({String($0.rawValue)}).joined(separator: ","))")
                }
                
            case .getUserNotificationsForCurrentUsagePeriod,
                    .getOrganizationNotificationsForCurrentUsagePeriod: return nil
                
            default: abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}




    //MARK: - Basic Patern
    //
    //extension CloudResource.RequestHelper {
    //
    //        //MARK: Paths
    //    internal func pathFor<#name#>(_ resource: CloudResource) -> String {
    //
    //        switch resource {
    //
    //            default:
    //                abort()
    //        }
    //    }
    //
    //        //MARK: Content Type
    //    internal func <#name#>ContentType(_ resource: CloudResource) -> AllowableContentType {
    //
    //        switch resource {
    //
    //
    //            default:
    //                abort()
    //        }
    //    }
    //
    //        //MARK: AUTH Header
    //    internal func <#name#>AuthHeader(_ resource: CloudResource) -> String? {
    //
    //        switch resource {
    //
    //
    //            default: abort()
    //        }
    //    }
    //
    //        //MARK: HTTP Method
    //    internal func <#name#>HTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
    //
    //        switch resource {
    //
    //
    //            default: abort()
    //        }
    //    }
    //
    //        //MARK: Query Items
    //    internal func <#name#>QueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
    //
    //        switch resource {
    //
    //
    //            default: abort()
    //        }
    //
    //    }
    //
    //        //MARK: Payload
    //    internal func <#name#>Payload(_ resource: CloudResource) -> Data? {
    //
    //        var payload : [String]? = nil
    //
    //        switch resource {
    //
    //
    //            default:
    //                abort()
    //        }
    //        return payload?.joined(separator: "&").data(using: .utf8)
    //    }
    //}
