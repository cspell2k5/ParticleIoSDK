//
//  PCServiceAgreements.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/14/23.
//

import Foundation


public struct PCServiceAgreement: Decodable {
    public let data: [Datum]?
    
    private init(data: [Datum]?) {
        self.data = data
    }
    
    
        // MARK: - Datum
    public struct Datum: Decodable {
        public let id, type: String?
        public let attributes: Attributes?
        
        private init(id: String?, type: String?, attributes: Attributes?) {
            self.id = id
            self.type = type
            self.attributes = attributes
        }
    }
    
        // MARK: - Attributes
    public struct Attributes: Decodable {
        public let ownerID, ownerType, name, agreementType: String?
        public let duration, state, startsOn: String?
        public let endsOn: JSONNull?
        public let currentBillingPeriodStart, currentBillingPeriodEnd, nextBillingPeriodStart: String?
        public let currentUsageSummary: CurrentUsageSummary?
        public let pricingTerms: PricingTerms?
        
        private enum CodingKeys: String, CodingKey {
            case ownerID = "owner_id"
            case ownerType = "owner_type"
            case name
            case agreementType = "agreement_type"
            case duration, state
            case startsOn = "starts_on"
            case endsOn = "ends_on"
            case currentBillingPeriodStart = "current_billing_period_start"
            case currentBillingPeriodEnd = "current_billing_period_end"
            case nextBillingPeriodStart = "next_billing_period_start"
            case currentUsageSummary = "current_usage_summary"
            case pricingTerms = "pricing_terms"
        }
        
        private init(ownerID: String?, ownerType: String?, name: String?, agreementType: String?, duration: String?, state: String?, startsOn: String?, endsOn: JSONNull?, currentBillingPeriodStart: String?, currentBillingPeriodEnd: String?, nextBillingPeriodStart: String?, currentUsageSummary: CurrentUsageSummary?, pricingTerms: PricingTerms?) {
            self.ownerID = ownerID
            self.ownerType = ownerType
            self.name = name
            self.agreementType = agreementType
            self.duration = duration
            self.state = state
            self.startsOn = startsOn
            self.endsOn = endsOn
            self.currentBillingPeriodStart = currentBillingPeriodStart
            self.currentBillingPeriodEnd = currentBillingPeriodEnd
            self.nextBillingPeriodStart = nextBillingPeriodStart
            self.currentUsageSummary = currentUsageSummary
            self.pricingTerms = pricingTerms
        }
    }
    
        // MARK: - CurrentUsageSummary
    public struct CurrentUsageSummary: Decodable {
        public let deviceLimitReached: Bool?
        public let connectivity: Connectivity?
        
        private enum CodingKeys: String, CodingKey {
            case deviceLimitReached = "device_limit_reached"
            case connectivity
        }
        
        private init(deviceLimitReached: Bool?, connectivity: Connectivity?) {
            self.deviceLimitReached = deviceLimitReached
            self.connectivity = connectivity
        }
    }
    
        // MARK: - Connectivity
    public struct Connectivity: Decodable {
        public let all, wifi, cellular, assetTracker: All?
        
        private enum CodingKeys: String, CodingKey {
            case all, wifi, cellular
            case assetTracker = "asset_tracker"
        }
        
        private init(all: All?, wifi: All?, cellular: All?, assetTracker: All?) {
            self.all = all
            self.wifi = wifi
            self.cellular = cellular
            self.assetTracker = assetTracker
        }
    }
    
        // MARK: - All
    public struct All: Decodable {
        public let ownedDevices, billableDevices: Int?
        public let deviceData: Int?
        public let deviceMessages: Int?
        
        private enum CodingKeys: String, CodingKey {
            case ownedDevices = "owned_devices"
            case billableDevices = "billable_devices"
            case deviceData = "device_data"
            case deviceMessages = "device_messages"
        }
        
        private init(ownedDevices: Int?, billableDevices: Int?, deviceData: Int?, deviceMessages: Int?) {
            self.ownedDevices = ownedDevices
            self.billableDevices = billableDevices
            self.deviceData = deviceData
            self.deviceMessages = deviceMessages
        }
    }
    
        // MARK: - PricingTerms
    public struct PricingTerms: Decodable {
        public let rates: Rates?
        public let device: Device?
        public let messaging: Messaging?
        public let deviceData: DeviceData?
        
        private enum CodingKeys: String, CodingKey {
            case rates, device, messaging
            case deviceData = "device_data"
        }
        
        private init(rates: Rates?, device: Device?, messaging: Messaging?, deviceData: DeviceData?) {
            self.rates = rates
            self.device = device
            self.messaging = messaging
            self.deviceData = deviceData
        }
    }
    
        // MARK: - Device
    public struct Device: Decodable {
        public let name, duration: String?
        public let maxDevices: Int?
        
        private enum CodingKeys: String, CodingKey {
            case name, duration
            case maxDevices = "max_devices"
        }
        
        private init(name: String?, duration: String?, maxDevices: Int?) {
            self.name = name
            self.duration = duration
            self.maxDevices = maxDevices
        }
    }
    
        // MARK: - DeviceData
    public struct DeviceData: Decodable {
        public let uom, name, duration: String?
        public let maxData, deviceData, devicesCap: Int?
        public let capException: Bool?
        
        private enum CodingKeys: String, CodingKey {
            case uom, name, duration
            case maxData = "max_data"
            case deviceData = "device_data"
            case devicesCap = "devices_cap"
            case capException = "cap_exception"
        }
        
        private init(uom: String?, name: String?, duration: String?, maxData: Int?, deviceData: Int?, devicesCap: Int?, capException: Bool?) {
            self.uom = uom
            self.name = name
            self.duration = duration
            self.maxData = maxData
            self.deviceData = deviceData
            self.devicesCap = devicesCap
            self.capException = capException
        }
    }
    
        // MARK: - Messaging
    public struct Messaging: Decodable {
        public let name, duration: String?
        public let maxMessages: Int?
        
        private enum CodingKeys: String, CodingKey {
            case name, duration
            case maxMessages = "max_messages"
        }
        
        private init(name: String?, duration: String?, maxMessages: Int?) {
            self.name = name
            self.duration = duration
            self.maxMessages = maxMessages
        }
    }
    
        // MARK: - Rates
    public struct Rates: Decodable {
        public let allPlatforms: AllPlatforms?
        public let pricingModelVersion: String?
        
        private enum CodingKeys: String, CodingKey {
            case allPlatforms = "all_platforms"
            case pricingModelVersion = "pricing_model_version"
        }
        
        private init(allPlatforms: AllPlatforms?, pricingModelVersion: String?) {
            self.allPlatforms = allPlatforms
            self.pricingModelVersion = pricingModelVersion
        }
    }
    
        // MARK: - AllPlatforms
    public struct AllPlatforms: Decodable {
        public let duration: String?
        public let perBlock: Int?
        
        private enum CodingKeys: String, CodingKey {
            case duration
            case perBlock = "per_block"
        }
        
        private init(duration: String?, perBlock: Int?) {
            self.duration = duration
            self.perBlock = perBlock
        }
    }
    
        // MARK: - Encode/decode helpers
    
    public class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public func hash(into hasher: inout Hasher) {
                // No-op
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}

extension PCServiceAgreement {
    public static func getUserServiceAgreements(organization org: OrganizationName, token: PCAccessToken, completion: @escaping (Result<PCServiceAgreement, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.getUserServiceAgreements(orgName: org.rawValue, token: token), type: PCServiceAgreement.self, completion: completion)
    }
}

extension PCServiceAgreement {
    
    
        // MARK: - UserUsageReport
    public struct UserUsageReport: Decodable  {
        public let data: DataClass?
        
        private init(data: DataClass?) {
            self.data = data
        }
        
            // MARK: - DataClass
        public struct DataClass: Decodable  {
            public let id, type: String?
            public let attributes: Attributes?
            
            private init(id: String?, type: String?, attributes: Attributes?) {
                self.id = id
                self.type = type
                self.attributes = attributes
            }
        }
        
            // MARK: - Attributes
        public struct Attributes: Decodable  {
            public let state: String?
            public let serviceAgreementID: Int?
            public let datePeriodStart, datePeriodEnd, createdAt: String?
            public let expiresAt: String?
            public let reportType: String?
            public let reportParams: ReportParams?
            public let downloadURL: String?
            
            private init(state: String?, serviceAgreementID: Int?, datePeriodStart: String?, datePeriodEnd: String?, createdAt: String?, expiresAt: String?, reportType: String?, reportParams: ReportParams?, downloadURL: String?) {
                self.state = state
                self.serviceAgreementID = serviceAgreementID
                self.datePeriodStart = datePeriodStart
                self.datePeriodEnd = datePeriodEnd
                self.createdAt = createdAt
                self.expiresAt = expiresAt
                self.reportType = reportType
                self.reportParams = reportParams
                self.downloadURL = downloadURL
            }
        }
        
            // MARK: - UsageReportParams
        public struct ReportParams: Decodable  {
            public let devices: [String]?
            public let products: [String]?
            public let recipientList: [String]?
            
            private init(devices: [String]?, products: [String]?, recipientList: [String]?) {
                self.devices = devices
                self.products = products
                self.recipientList = recipientList
            }
        }
    }
}

extension PCServiceAgreement {
    
        // MARK: - OrganizationUsageReport
    public struct OrganizationUsageReport: Decodable {
        public let data: DataClass
        
        private init(data: DataClass) {
            self.data = data
        }
        
        
            // MARK: - DataClass
        public struct DataClass: Decodable  {
            public let id, type: String
            public let attributes: Attributes
            
            private init(id: String, type: String, attributes: Attributes) {
                self.id = id
                self.type = type
                self.attributes = attributes
            }
        }
        
            // MARK: - Attributes
        public struct Attributes: Decodable  {
            public let state: String
            public let serviceAgreementID: Int
            public let datePeriodStart, datePeriodEnd, createdAt: String
            public let expiresAt: String?
            public let reportType: String
            public let reportParams: ReportParams
            public let downloadURL: String?
            
            private init(state: String, serviceAgreementID: Int, datePeriodStart: String, datePeriodEnd: String, createdAt: String, expiresAt: String?, reportType: String, reportParams: ReportParams, downloadURL: String?) {
                self.state = state
                self.serviceAgreementID = serviceAgreementID
                self.datePeriodStart = datePeriodStart
                self.datePeriodEnd = datePeriodEnd
                self.createdAt = createdAt
                self.expiresAt = expiresAt
                self.reportType = reportType
                self.reportParams = reportParams
                self.downloadURL = downloadURL
            }
        }
        
            // MARK: - UsageReportParams
        public struct ReportParams: Decodable  {
            public let devices: [String]
            public let products: [String]
            public let recipientList: [String]
            
            private init(devices: [String], products: [String], recipientList: [String]) {
                self.devices = devices
                self.products = products
                self.recipientList = recipientList
            }
        }
    }
}

//MARK: - Report Generation
extension PCServiceAgreement {
    
    public struct ReportCreationArguments: CustomStringConvertible, CustomDebugStringConvertible {
        
        
        public var description: String {
return """
    orgSlugOrId: \(orgSlugOrId),
    service_agreement_id: \(service_agreement_id),
    report_type: \(report_type),
    date_period_start: \(date_period_start),
    date_period_end: \(date_period_end),
    devices: [
        \(String(describing: devices?.map({$0.rawValue}).joined(separator: ",\n")))
    ]
    products: [
        \(String(describing: products?.map({$0.rawValue}).joined(separator: ",\n")))
    ]
"""
        }
        
        public var debugDescription: String {
return """
ReportCreationArguments: {
    orgSlugOrId: \(orgSlugOrId),
    service_agreement_id: \(service_agreement_id),
    report_type: \(report_type),
    date_period_start: \(date_period_start),
    date_period_end: \(date_period_end),
    devices: [
        \(String(describing: devices?.map({$0.rawValue}).joined(separator: ",\n")))
    ]
    products: [
        \(String(describing: products?.map({$0.rawValue}).joined(separator: ",\n")))
    ]
}
"""
        }
            ///Organization Slug or ID
        public let orgSlugOrId: String
        
            ///Service Agreement ID
        public let service_agreement_id: Int
        
        ///One of the supported report types, "devices" or "products"
        public let report_type: String
        
        ///The start of the date period to query.
        public let date_period_start : String

        ///The end of the date period to query
        public let date_period_end: String

        ///An optional array of Device IDs.
        public let devices: [DeviceID]?
        
        ///An optional array of Product IDs.
        public let products: [ProductID]?
    }
    
    //MARK: CreationRequestResponse
    public struct CreationRequestResponse: Decodable {
        
            ///Usage Report Unique ID
        public let id: String
            ///Object type
        public let type: String
            ///Usage Report attributes
        public let attributes: UsageReportAttributes
        
        private init(id: String, type: String, attributes: UsageReportAttributes) {
            self.id = id
            self.type = type
            self.attributes = attributes
        }

        private enum CodingKeys: CodingKey {
            case data
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PCServiceAgreement.CreationRequestResponse.CodingKeys.self)
            let data = try container.decode([String:String].self, forKey: .data)
            
            self.id = try JSONDecoder().decode(String.self, from: Data(data["id"]!.utf8))
            self.type = try JSONDecoder().decode(String.self, from: Data(data["type"]!.utf8))
            self.attributes = try JSONDecoder().decode(PCServiceAgreement.CreationRequestResponse.UsageReportAttributes.self, from: Data(data["attributes"]!.utf8))
        }
            
            
                // MARK: Attributes
            public struct UsageReportAttributes: Decodable {
                    ///Usage Report current state.
                public let state: String
                    ///Service Agreement Unique ID.
                public let serviceAgreementID: Int
                    ///The start of the date period to query.
                public let datePeriodStart: String
                    ///The end of the date period to query.
                public let datePeriodEnd: String
                    ///UTC timestamp of when the Usage Report request was created.
                public let createdAt: String
                    ///UTC timestamp of when the Usage Report file expires.
                public let expiresAt: String?
                    ///Usage Report type.
                public let reportType: String
                    ///Usage Report parameters.
                public let reportParams: UsageReportParams
                    ///Usage Report file expirable download URL
                public let downloadURL: String?
                
                private enum CodingKeys: String, CodingKey {
                    case state
                    case serviceAgreementID = "service_agreement_id"
                    case datePeriodStart = "date_period_start"
                    case datePeriodEnd = "date_period_end"
                    case createdAt = "created_at"
                    case expiresAt = "expires_at"
                    case reportType = "report_type"
                    case reportParams = "report_params"
                    case downloadURL = "download_url"
                }
                
                private init(state: String, serviceAgreementID: Int, datePeriodStart: String, datePeriodEnd: String, createdAt: String, expiresAt: String, reportType: String, reportParams: UsageReportParams, downloadURL: String) {
                    self.state = state
                    self.serviceAgreementID = serviceAgreementID
                    self.datePeriodStart = datePeriodStart
                    self.datePeriodEnd = datePeriodEnd
                    self.createdAt = createdAt
                    self.expiresAt = expiresAt
                    self.reportType = reportType
                    self.reportParams = reportParams
                    self.downloadURL = downloadURL
                }
            }
            
                // MARK: UsageReportParams
            public struct UsageReportParams: Decodable {
                
                    ///List of Device Unique IDs.
                public let devices: [DeviceID]?
                    ///List of Product Unique IDs.
                public let products: [ProductID]?
                    ///List of emails to send the report via email.
                public let recipientList: [String]?
                
                private enum CodingKeys: String, CodingKey {
                    case devices, products
                    case recipientList = "recipient_list"
                }
                
                private init(devices: [DeviceID]?, products: [ProductID]?, recipientList: [String]?) {
                    self.devices = devices
                    self.products = products
                    self.recipientList = recipientList
                }
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.devices  = (try container.decodeIfPresent([String].self, forKey: .devices))?.map({DeviceID($0)})
                    self.products = (try container.decodeIfPresent([String].self, forKey: .products))?.map({ProductID($0)})
                    self.recipientList = try container.decodeIfPresent([String].self, forKey: .recipientList)
                }
            }
        }
    
}

extension PCServiceAgreement {
    
        // MARK: - CurrentUsageNotificationResponse
    public struct CurrentUsageNotificationResponse: Decodable {

        ///Notification Unique ID
        public let id: String
        
        ///Object type
        public let type: String
        
        ///Notification attributes
        public let attributes: Attributes

        enum CodingKeys: CodingKey {
            case data
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PCServiceAgreement.CurrentUsageNotificationResponse.CodingKeys.self)
            let data = try container.decode([String : String].self, forKey: .data)
            
            self.id = try JSONDecoder().decode(String.self, from: Data(data["id"]!.utf8))
            self.type = try JSONDecoder().decode(String.self, from: Data(data["type"]!.utf8))
            self.attributes = try JSONDecoder().decode(Attributes.self, from: Data(data["attributes"]!.utf8))
        }
        
        private init() {
            fatalError("CurrentUsageNotificationResponse can only be initialized with a decoder.")
        }
        
            // MARK: Attributes
        public struct Attributes: Decodable {
            
            ///indicates the state of the notification.
            public let state: String
            
            ///Notification event name.
            public let eventName: String
            
            ///Notification time period.
            public let timePeriod: String
            
            ///Notification created date/time.
            public let createdAt: String
               
                ///Notification updated date/time.
            public let updatedAt: String

            ///Notification Service agreement Id
            public let resourceID: String
       
            ///Notification resource type
            public let resourceType: String
            
            ///Notification details.
            public let details: Details
            
            private enum CodingKeys: String, CodingKey {
                case state
                case eventName = "event_name"
                case timePeriod = "time_period"
                case createdAt = "created_at"
                case updatedAt = "updated_at"
                case resourceID = "resource_id"
                case resourceType = "resource_type"
                case details
                
            }
            
            private init(state: String, eventName: String, timePeriod: String, createdAt: String, resourceID: String, resourceType: String, details: Details) {
                fatalError("CurrentUsageNotificationResponse.Attributes can only be initialized with a decoder.")
            }
        }
        
            // MARK: Details
        public struct Details: Decodable {
            ///Type of event.
            public let eventType: String
            /// HierarchyInfo
            public let hierarchyInfo: HierarchyInfo
            ///Device pause date
            public let devicePauseDate: String
       
            ///The next billing period starting date.
            public let nextBillingPeriodStart: String
            
            private enum CodingKeys: String, CodingKey {
                case eventType = "event_type"
                case hierarchyInfo = "hierarchy_info"
                case devicePauseDate = "device_pause_date"
                case nextBillingPeriodStart = "next_billing_period_start"
            }
            
            private init(eventType: String, hierarchyInfo: HierarchyInfo, devicePauseDate: String, nextBillingPeriodStart: String) {
                fatalError("CurrentUsageNotificationResponse.Details can only be initialized with a decoder.")
            }
        }
        
            // MARK: HierarchyInfo
        public struct HierarchyInfo: Decodable {
            
            ///name of the request?
            public let name: String
            
            ///Priority of the request?
            public let priority: Int
            
            private init(name: String, priority: Int) {
                fatalError("CurrentUsageNotificationResponse.HierarchyInfo can only be initialized with a decoder.")
            }
        }
    }
}
