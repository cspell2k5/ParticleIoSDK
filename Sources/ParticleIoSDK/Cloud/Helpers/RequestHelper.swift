    //
    //  ParticleRequest.swift
    //  ParticleIO
    //
    //  Created by Craig Spell on 11/12/19.
    //  Copyright © 2019 Spell Software Inc. All rights reserved.
    //

import Foundation


public enum HTTPMethodType: String {
    case GET, POST, PUT, DELETE, PATCH
}


extension CloudResource {
    
    internal final class RequestHelper {
        internal let separator = "/"
        internal let accessToken = "access_token"
        
        enum AllowableContentType: String {
            case form = "application/x-www-form-urlencoded"
            case jSon = "application/json"
            case jSon_schema = "application/schema+json"
            case events = "text/event-stream"
        }
                
            //MARK: - ParticlePaths
#warning("needs to be changed back to private after all cases have been made and brought in")
        internal enum ParticlePaths: String {
               
            //MARK: Tokens
            case v1tokens = "/v1/access_tokens"
                //MARK: API User
            case v1orgs = "/v1/orgs"
                //MARK: Devices
            case v1devices = "/v1/devices"
            case v1deviceClaims = "/v1/device_claims"
            case v1serialNumbers = "/v1/serial_numbers/"
            
                //MARK: Events
            case v1events = "/v1/events"
            
                //MARK: Integrations
            
                //MARK: Special Events
            
                //MARK: Asset Tracking Events
            
                //MARK: Firmware
            case v1binaries = "/v1/binaries"
            case v1buildTargets = "/v1/build_targets"
            
                //MARK: Product Firmware
            
                //MARK: Library
            case libraries = "/v1/libraries"
                //MARK: Device Group
            
                //MARK: Asset Tracking
            
                //MARK: Customer
            
                //MARK: Service Agreements
            
                //MARK: Shared
            case v1oAuth = "/oauth/token"
            case v1sims = "/v1/sims"
            case v1users = "/v1/user"
            case v1clients = "/v1/clients"
            case v1products = "/v1/products"
            case preV1Products = "/products"
            case v1Diagnostics = "/v1/diagnostics"
            case v1ServiceAgreements = "/v1/orgs/particle/service_agreements"
            
        }
        
            //MARK: - URL Forming
        internal func basicParticleUrlComponents() -> URLComponents {
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.particle.io"
            
            return components
        }
        
        internal func pathForParticleResource(_ resource: CloudResource) -> String {
            
            switch resource.type {
                case .accessToken: return pathForTokenResource(resource)
                case .client: return pathForClientResource(resource)
                case .apiUser: return pathForAPiUserResource(resource)
                case .device: return pathForDeviceResource(resource)
                case .remoteDiagnostics: return pathForRemoteDiagnosticsResource(resource)
                case .user: return pathForUserResource(resource)
                case .quranatine: return pathForQuarantineResource(resource)
                case .simCard: return pathForSimCardResource(resource)
                case .event: return pathForEventResource(resource)
                    
                case .products: return pathForProductResource(resource)
                    
                case .customers: return pathForCustomer(resource)
                case .serviceAgreements: return pathForServiceAgreements(resource)
                    
                case .libraries: return pathForLibrary(resource)
                    
                default: abort()
            }
        }
        
            //MARK: - Query Forming
        internal func queryItemsFor(_ resource: CloudResource) -> [URLQueryItem]? {
            
            switch resource.type {
                case .accessToken: return tokenQueryItems(resource)
                case .client: return clientQueryItems(resource)
                case .apiUser: return APiUserQueryItems(resource)
                case .device: return deviceQueryItems(resource)
                case .remoteDiagnostics: return remoteDiagnosticsQueryItems(resource)
                case .user: return userQueryItems(resource)
                case .quranatine: return quarantineQueryItems(resource)
                case .simCard: return simCardQueryItems(resource)
                case .event: return eventQueryItems(resource)
                    
                case .products: return productQueryItems(resource)
                    
                case .customers: return customerQueryItems(resource)
                    
                case .serviceAgreements: return serviceAgreementsQueryItems(resource)

                case .libraries: return libraryQueryItems(resource)

                default: abort()
            }
        }
                
            //MARK: - HTTPMethod Decicion Tree
        internal func methodForResource(_ resource: CloudResource) -> String {
            
            switch resource.type {
                case .accessToken: return tokenHTTPMethod(resource).rawValue
                case .client: return clientHTTPMethod(resource).rawValue
                case .apiUser: return APiUserHTTPMethod(resource).rawValue
                case .device: return deviceHTTPMethod(resource).rawValue
                case .remoteDiagnostics: return remoteDiagnosticsHTTPMethod(resource).rawValue
                case .user: return userHTTPMethod(resource).rawValue
                case .quranatine: return quarantineHTTPMethod(resource).rawValue
                case .simCard: return simCardHTTPMethod(resource).rawValue
                case .event: return eventHTTPMethod(resource).rawValue
                    
                case .products: return productHTTPMethod(resource).rawValue
                    
                case .customers: return customerHTTPMethod(resource).rawValue
                    
                case .serviceAgreements: return serviceAgreementsHTTPMethod(resource).rawValue

                case .libraries: return libraryHTTPMethod(resource).rawValue

                default: abort()
            }
        }
        
        internal func contentTypeforResource(_ resource: CloudResource) -> String {
            switch resource.type {
                case .accessToken: return tokenContentType(resource).rawValue
                case .client: return clientContentType(resource).rawValue
                case .apiUser: return APiUserContentType(resource).rawValue
                case .device: return deviceContentType(resource).rawValue
                case .remoteDiagnostics: return remoteDiagnosticsContentType(resource).rawValue
                case .user: return userContentType(resource).rawValue
                case .quranatine: return quarantineContentType(resource).rawValue
                case .simCard: return simCardContentType(resource).rawValue
                case .event: return eventContentType(resource).rawValue
                    
                case .products: return productContentType(resource).rawValue
                    
                case .customers: return customerContentType(resource).rawValue
                    
                case .serviceAgreements: return serviceAgreementsContentType(resource).rawValue

                case .libraries: return libraryContentType(resource).rawValue

                    
                default: abort()
            }
        }
        
        internal func authHeaderForResource(_ resource: CloudResource) -> String? {
            
            switch resource.type {
                case .accessToken: return tokenAuthHeader(resource)
                case .client: return clientAuthHeader(resource)
                case .apiUser: return APiUserAuthHeader(resource)
                case .device: return deviceAuthHeader(resource)
                case .remoteDiagnostics: return remoteDiagnosticsAuthHeader(resource)
                case .user: return userAuthHeader(resource)
                case .quranatine: return quarantineAuthHeader(resource)
                case .simCard: return simCardAuthHeader(resource)
                case .event: return eventAuthHeader(resource)
                    
                case .products: return productAuthHeader(resource)
                    
                case .customers: return customerAuthHeader(resource)
                    
                case .serviceAgreements: return serviceAgreementsAuthHeader(resource)

                case .libraries: return libraryAuthHeader(resource)

                default: abort()
            }
        }
        
        internal func acceptHeaderForResource(_ resource: CloudResource) -> AllowableContentType? {
            
            switch resource.type {
                case .accessToken: return nil
                case .client: return nil
                case .apiUser: return nil
                case .device: return nil
                case .remoteDiagnostics: return nil
                case .user: return nil
                case .quranatine: return nil
                case .simCard: return nil
                case .event: return eventsAcceptType(resource)
                    
                case .products: return nil
                    
                case .customers: return nil
                    
                case .serviceAgreements: return nil
                case .assetTracking: return assetTrackingAcceptType(resource)
                    
                case .libraries: return libraryAcceptType(resource)

                default: abort()
            }
        }

            //MARK: - Data Forming
        internal func payloadForResource(_ resource: CloudResource) -> Data? {
            
            switch resource.type {
                case .accessToken:  return tokenPayload(resource)
                case .client: return clientPayload(resource)
                case .apiUser: return APiUserPayload(resource)
                case .device: return devicePayload(resource)
                case .remoteDiagnostics: return remoteDiagnosticsPayload(resource)
                case .user: return userPayload(resource)
                case .quranatine: return quarantinePayload(resource)
                case .simCard: return simCardPayload(resource)
                case .event: return eventPayload(resource)
                    
                case .products: return productPayload(resource)
                    
                case .customers: return customerPayload(resource)
                    
                case .serviceAgreements: return serviceAgreementsPayload(resource)

                case .libraries: return libraryPayload(resource)

                    
                default: abort()
            }
        }
    }
}
