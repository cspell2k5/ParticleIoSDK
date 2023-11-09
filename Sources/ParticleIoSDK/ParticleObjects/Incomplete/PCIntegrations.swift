    //
    //  PCIntegrations.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/14/23.
    //

import Foundation


public struct PCWebHookIntegrations: Decodable {}


extension PCWebHookIntegrations.WebhookCreationArguments {
    
    public struct JSonData: Codable {
        
    }
    
}

    //MARK: - CreationArguments
extension PCWebHookIntegrations {
   
    public enum IntegrationType: String {
        case Webhook, AzureIotHub, GoogleCloudPubSub, GoogleMaps
    }
    
    public struct WebhookCreationArguments {
        
        internal var debugDescription: String {
            "integrationType:\(integrationType)\nevent:\(event.rawValue)\nurl:\(url.path)\nname:\(String(describing: name))\nrequestType:\(requestType)\ndeviceID:\(String(describing: deviceID))\nbody:\(String(describing: body))\njson:\(String(describing: json))\nform:\(String(describing: form))\nquery:\(String(describing: query?.description))\nauth:\(String(describing: auth))\nheaders:\(String(describing: headers))\nresponseTopic:\(String(describing: responseTopic))\nerrorResponseTopic:\(String(describing: errorResponseTopic))\nresponseTemplate:\(String(describing: responseTemplate))\nnoDefaults:\(String(describing: noDefaults))\ndisabled:\(String(describing: disabled))\nrejectUnauthorized:\(String(describing: rejectUnauthorized))\nproductIdOrSlug:\(String(describing: productIdOrSlug?.rawValue))\n"
        }
            ///Must be set to Webhook
        public let integrationType: IntegrationType
            ///The name of the Particle event that should trigger the webhook
        public let event: EventName
            ///The web address that will be targeted when the webhook is triggered
        public let url: URL
            ///A human-readable description of the webhook. Defaults to "{event} for {domain}" if omitted.
        public let name: String?
            ///Type of web request triggered by the webhook that can be set to GET, POST, PUT, or DELETE
        public let requestType: HTTPMethodType
            ///Limits the webhook triggering to a single device
        public let deviceID: DeviceID?
            ///Send a custom body along with the HTTP request
        public let body: String?
            ///Send custom data as JSON with the request. This will change the Content-Type header of the request to application/json
        public let json: Codable?
            ///Send custom data as a form with the request by including key/value pairs. This will change the Content-Type header of the request to application/x-www-form-urlencoded
        public let form: Codable?
            ///Send query parameters in the URL of the request by including key/value pairs
        public let query: [String : String]?
            ///Add an HTTP basic auth header by including a JSON object with username/password set data must be in base64 format
            ///
            /// ````swift
            ///         //Required format
            ///         "Basic username:password".data(using: .utf8)?.base64EncodedString()
            ///````
            ///
        public let auth: Data?
            ///Add custom HTTP headers by including key/value pairs
        public let headers: (key: String, value: String)?
            ///Customize the webhook response event name that your devices can subscribe to
        public let responseTopic: String?
            ///Customize the webhook error response event name that your devices can subscribe to
        public let errorResponseTopic: String?
            ///Customize the webhook response body that your devices can subscribe to
        public let responseTemplate: String?
            ///Set to true to not add the triggering Particle event's data to the webhook request
        public let noDefaults: Bool?
            ///Set to true to stop events from being sent to this webhook
        public let disabled: Bool?
            ///Set to false to skip SSL certificate validation of the target URL
        public let rejectUnauthorized: Bool?
            ///Product ID or slug. Product endpoint only.
        public let productIdOrSlug: ProductID?
        
        public init(integrationType: IntegrationType, event: EventName, url: URL, name: String? = nil, requestType: HTTPMethodType, deviceID: DeviceID? = nil, body: String? = nil, json: Codable? = nil, form: Codable? = nil, query: [String : String]? = nil, auth: Data? = nil, headers: (key: String, value: String)? = nil, responseTopic: String? = nil, errorResponseTopic: String? = nil, responseTemplate: String? = nil, noDefaults: Bool? = nil, disabled: Bool? = nil, rejectUnauthorized: Bool? = nil, productIdOrSlug: ProductID? = nil) {
            
            self.integrationType = integrationType; self.event = event; self.url = url; self.name = name; self.requestType = requestType; self.deviceID = deviceID; self.body = body; self.json = json; self.form = form; self.query = query; self.auth = auth; self.headers = headers; self.responseTopic = responseTopic; self.errorResponseTopic = errorResponseTopic; self.responseTemplate = responseTemplate; self.noDefaults = noDefaults; self.disabled = disabled; self.rejectUnauthorized = rejectUnauthorized; self.productIdOrSlug = productIdOrSlug
        }
        
        private enum CodingKeys: String, CodingKey, CaseIterable {
            case integrationType = "integration_type", event, url, name, requestType, deviceID, body, json, form, query, auth, headers, responseTopic, errorResponseTopic, responseTemplate, noDefaults, disabled, rejectUnauthorized, productIdOrSlug
        }
        
        
        internal func payloadvalues() -> [String]? {
            var payload = [String]()
            
            for key in CodingKeys.allCases {
                
                switch key {
                        
                    case .integrationType:
                        payload.append("\(key.rawValue)=\(integrationType.rawValue)")
                    case .event:
                        payload.append("\(key.rawValue)=\(event.rawValue)")
                    case .url:
                        payload.append("\(key.rawValue)=\(url.path)")
                    case .name:
                        if let value = self.name {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .requestType:
                        payload.append("\(key.rawValue)=\(requestType.rawValue)")
                    case .deviceID:
                        if let value = self.deviceID?.rawValue {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .body:
                        if let value = self.body {
                            payload.append(key.rawValue + "=" + value)
                        }
                    case .json:
                        if let json = self.json,
                           let value = try? JSONSerialization.data(withJSONObject: json) {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .form:
                        if let value = self.form {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .query:
                        if let value = self.query {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .auth:
                        if let value = self.auth {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .headers:
                        if let value = self.headers {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .responseTopic:
                        if let value = self.responseTopic {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .errorResponseTopic:
                        if let value = self.errorResponseTopic {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .noDefaults:
                        if let value = self.noDefaults {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .disabled:
                        if let value = self.disabled {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .rejectUnauthorized:
                        if let value = self.rejectUnauthorized {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .productIdOrSlug:
                        if let value = self.productIdOrSlug?.rawValue {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                    case .responseTemplate:
                        if let value = self.responseTemplate {
                            payload.append("\(key.rawValue)=\(value)")
                        }
                }
            }
            return payload.compactMap{$0}
        }
        
    }
    
}

    // MARK: - CreationResponse
extension PCWebHookIntegrations {
    
    public struct CreationResponse: Decodable {
            ///Bool indicating whether or not the request was successful.
        public let ok: Bool
            ///The webhook ID
        public let id: String
            ///The path of the web address that will be targeted when the webhook is triggered.
        public let url: String
            ///Timestamp of when the webhook was created
        public let event: String
            ///Should be returned as "webhook"
        public let integrationType: String
            ///Timestamp of when the webhook was created formatted in iso8601
        public let createdAt: String
            ///Particle API endpoint for GET information on the webhook.
        public let hookURL: String
        
        private enum CodingKeys: String, CodingKey {
            case ok, id, url, event
            case integrationType = "integration_type"
            case createdAt = "created_at"
            case hookURL = "hookUrl"
        }
        
        private init(ok: Bool, id: String, url: String, event: String, integrationType: String, createdAt: String, hookURL: String) {
            self.ok = ok; self.id = id; self.url = url; self.event = event; self.integrationType = integrationType; self.createdAt = createdAt; self.hookURL = hookURL
        }
    }
}


extension CloudResource.RequestHelper {
    
        //MARK: - Paths
    internal func pathForIntegrationResource(_ resource: CloudResource) -> String {
        
        switch resource {
                
            default:
                abort()
        }
    }
    
        //MARK: - Content Type
    internal func integrationContentType(_ resource: CloudResource) -> AllowableContentType {
        
        switch resource {
                
                
            default:
                abort()
        }
    }
    
        //MARK: - AUTH Header
    internal func integrationAuthHeaderAuthHeader(_ resource: CloudResource) -> String? {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: - HTTP Method
    internal func integrationTTPMethod(_ resource: CloudResource) -> HTTPMethodType {
        
        switch resource {
                
                
            default: abort()
        }
    }
    
        //MARK: - Query Items
    internal func integrationQueryItems(_ resource: CloudResource) -> [URLQueryItem]? {
        
        switch resource {
                
                
            default: abort()
        }
        
    }
    
        //MARK: - Payload
    internal func integrationPayload(_ resource: CloudResource) -> Data? {
        
        var payload : [String]? = nil
        
        switch resource {
                
                
            default:
                abort()
        }
        return payload?.joined(separator: "&").data(using: .utf8)
    }
}
