//
//  PCSimCard.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/14/23.
//

import Foundation
import Combine




// MARK: - Sims
///Struct representing a device sim card.
public struct PCSimCard: Decodable {
    
    
    ///Server response for a sim list request.
    public struct ListResponse: Decodable {
        
        ///Array of sim card respresentations.
        public let sims: [PCSimCard]
        
        private init(sims: [PCSimCard]) { self.sims = sims }
        
        enum CodingKeys: CodingKey {
            case sims
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.sims = try container.decode([PCSimCard].self, forKey: .sims)
        }
    }
    
    ///ICCID of the SIM
    public let id: String
    ///Number of times the SIM has been activated.
    public let activationsCount: Int
    ///The ISO Alpha-2 code of the country where the SIM card is based
    public let baseCountryCode: String
    ///The monthly rate of the 1 MB data plan for this SIM card, in cents
    public let baseMonthlyRate: Int
    ///Number of times the SIM has been deactivated
    public let deactivationsCount: Int
    ///Timestamp of the first activation date of the SIM card
    public let firstActivatedOn: String
    ///Timestamp of the last activation date of the SIM card
    public let lastActivatedOn: String
    
    @available(*, deprecated)
    ///The method used to activate the SIM card. Internal use only, will be deprecated
    public let lastActivatedVia: String?
    ///The last state change of the SIM card
    public let lastStatusChangeAction: String
    ///Whether the last action change resulted in an error. Set to "yes" or "no"
    public let lastStatusChangeActionError: String
    ///MSISDN number of the Ublox modem
    public let msisdn: String
    ///The per-MB overage rate for this SIM card, in cents
    public let overageMonthlyRate: Int
    ///The current connectivity status of the SIM card
    public let status: String
    
    @available(*, deprecated)
    ///Data plan type. Internal use only, will be deprecated
    public let stripePlanSlug: String?
    ///Timestamp representing the last time the SIM was updated
    public let updatedAt: String
    ///The ID of the user who owns the SIM card
    public let userID: String
    ///The ID of the product who owns the SIM card
    public let productID: String?
    ///The Telefony provider for the SIM card's connectivity
    public let carrier: String
    ///The device ID of the SIM card's last associated device
    public let lastDeviceID: String
    ///The device name of the SIM card's last associated device
    public let lastDeviceName: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id", activationsCount = "activations_count", baseCountryCode = "base_country_code", baseMonthlyRate = "base_monthly_rate", deactivationsCount = "deactivations_count", firstActivatedOn = "first_activated_on", lastActivatedOn = "last_activated_on", lastActivatedVia = "last_activated_via", lastStatusChangeAction = "last_status_change_action", lastStatusChangeActionError = "last_status_change_action_error", msisdn, overageMonthlyRate = "overage_monthly_rate", status, stripePlanSlug = "stripe_plan_slug", updatedAt = "updated_at", userID = "user_id", carrier, lastDeviceID = "last_device_id", lastDeviceName = "last_device_name", productID = "product_id"
    }
    
    private init(id: String, activationsCount: Int, baseCountryCode: String, baseMonthlyRate: Int, deactivationsCount: Int, firstActivatedOn: String, lastActivatedOn: String, lastActivatedVia: String?, lastStatusChangeAction: String, lastStatusChangeActionError: String, msisdn: String, overageMonthlyRate: Int, status: String, stripePlanSlug: String?, updatedAt: String, userID: String, productID: String?, carrier: String, lastDeviceID: String, lastDeviceName: String) {
        self.id = id; self.activationsCount = activationsCount; self.baseCountryCode = baseCountryCode; self.baseMonthlyRate = baseMonthlyRate; self.deactivationsCount = deactivationsCount; self.firstActivatedOn = firstActivatedOn; self.lastActivatedOn = lastActivatedOn; self.lastActivatedVia = lastActivatedVia; self.lastStatusChangeAction = lastStatusChangeAction; self.lastStatusChangeActionError = lastStatusChangeActionError; self.msisdn = msisdn; self.overageMonthlyRate = overageMonthlyRate; self.status = status; self.stripePlanSlug = stripePlanSlug; self.updatedAt = updatedAt; self.userID = userID; self.productID = productID; self.carrier = carrier; self.lastDeviceID = lastDeviceID; self.lastDeviceName = lastDeviceName
    }
    
    private static func getFile(at path: String?) -> String? {
        if path == nil {return nil}
        if FileManager.default.fileExists(atPath: path!),
           let file = FileManager.default.contents(atPath: path!) {
            return String(data: file, encoding: .utf8)
        } else {
            return nil
        }
    }
}

//MARK: - ListRequestArgument
extension PCSimCard {
    
    ///Arguments to porovide to the sever to limit the scop of the request.
    public struct ListRequestArgument {
        
        internal var debugDescription: String {
            return "iccid:\(String(describing: iccid?.rawValue))\ndeviceId:\(String(describing: deviceId?.rawValue))\ndeviceName:\(String(describing: deviceName?.rawValue))\npage:\(String(describing: page))\nperPage:\(String(describing: perPage))\nproductId:\(String(describing: productId?.rawValue))\n"
        }
        
        ///Filter results to SIMs with this ICCID (partial matching)
        public let iccid: ICCIDNumber?
        ///Filter results to SIMs with this associated device ID (partial matching)
        public let deviceId: DeviceID?
        ///Filter results to SIMs with this associated device name (partial matching)
        public let deviceName: DeviceName?
        ///Current page of results
        public let page: Int?
        ///Records per page
        public let perPage: Int?
        ///Product ID or slug. Product endpoint only
        public let productId: ProductID?
        
        ///Used internally in combination with codingkeys to help ease urlqueryitem forming in RequestHelper
        internal func value(for keys: CodingKeys) -> String? {
            switch keys {
            case .iccid: return self.iccid == nil ? nil : String(self.iccid!.rawValue)
            case .deviceId: return self.deviceId?.rawValue
            case .deviceName: return self.deviceName?.rawValue
            case .page: return self.page == nil ? nil : String(self.page!)
            case .perPage: return self.perPage == nil ? nil : String(self.perPage!)
            case .productId: return self.productId == nil ? nil : String(self.productId!.rawValue)
            }
        }
        
        internal enum CodingKeys: String, CodingKey, CaseIterable {
            case iccid, deviceId, deviceName, page, perPage, productId
        }
        
        public init(productIdOrSlug: ProductID? = nil, iccid: ICCIDNumber?, deviceId: DeviceID?, deviceName: DeviceName? = nil, page: Int? = nil, perPage: Int? = nil) {
            self.iccid = iccid; self.deviceId = deviceId; self.deviceName = deviceName; self.page = page; self.perPage = perPage; self.productId = productIdOrSlug
        }
    }
}

extension PCSimCard {
    // MARK: - GetSimResponse
    ///Sim info returned by the server on sim info request.
    public struct GetSimInfoResponse: Decodable {
        ///ICCID of the SIM
        public let id: String
        ///Number of times the SIM has been activated
        public let activationsCount: Int
        ///The ISO Alpha-2 code of the country where the SIM card is based
        public let baseCountryCode: String
        ///The monthly rate of the 1 MB data plan for this SIM card, in cents
        public let baseMonthlyRate: Int
        ///Number of times the SIM has been deactivated
        public let deactivationsCount: Int
        
        public let firstActivatedOn: String
        public let lastActivatedOn: String
        public let lastActivatedVia: String
        public let lastStatusChangeAction: String
        public let lastStatusChangeActionError: String
        public let msisdn: String
        public let overageMonthlyRate: Int
        public let status: String
        public let stripePlanSlug: String
        public let updatedAt: String
        public let userID: String
        public let carrier: String
        public let lastDeviceID: String
        public let lastDeviceName: String
        public let owner: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "_id", activationsCount = "activations_count", baseCountryCode = "base_country_code", baseMonthlyRate = "base_monthly_rate", deactivationsCount = "deactivations_count", firstActivatedOn = "first_activated_on", lastActivatedOn = "last_activated_on", lastActivatedVia = "last_activated_via", lastStatusChangeAction = "last_status_change_action", lastStatusChangeActionError = "last_status_change_action_error", msisdn, overageMonthlyRate = "overage_monthly_rate", status, stripePlanSlug = "stripe_plan_slug", updatedAt = "updated_at", userID = "user_id", carrier, lastDeviceID = "last_device_id", lastDeviceName = "last_device_name", owner
        }
        
        private init(id: String, activationsCount: Int, baseCountryCode: String, baseMonthlyRate: Int, deactivationsCount: Int, firstActivatedOn: String, lastActivatedOn: String, lastActivatedVia: String, lastStatusChangeAction: String, lastStatusChangeActionError: String, msisdn: String, overageMonthlyRate: Int, status: String, stripePlanSlug: String, updatedAt: String, userID: String, carrier: String, lastDeviceID: String, lastDeviceName: String, owner: String) {
            
            self.id = id; self.activationsCount = activationsCount; self.baseCountryCode = baseCountryCode; self.baseMonthlyRate = baseMonthlyRate; self.deactivationsCount = deactivationsCount; self.firstActivatedOn = firstActivatedOn; self.lastActivatedOn = lastActivatedOn; self.lastActivatedVia = lastActivatedVia; self.lastStatusChangeAction = lastStatusChangeAction; self.lastStatusChangeActionError = lastStatusChangeActionError; self.msisdn = msisdn; self.overageMonthlyRate = overageMonthlyRate; self.status = status; self.stripePlanSlug = stripePlanSlug; self.updatedAt = updatedAt; self.userID = userID; self.carrier = carrier; self.lastDeviceID = lastDeviceID; self.lastDeviceName = lastDeviceName; self.owner = owner
        }
    }
}

// MARK: - DataUsageResponse
extension PCSimCard {
    ///Get SIM card data usage for the current billing period, broken out by day. Note that date usage reports can be delayed by up to 1 hour.
    public struct IccidDataUsageResponse: Decodable {
        ///ICCID of the SIM
        public let iccid: ICCIDNumber
        ///An array of data usage by day
        public let usageByDay: [UsageByDay]
        
        private enum CodingKeys: String, CodingKey {
            case iccid
            case usageByDay = "usage_by_day"
        }
        
        private init(iccid: ICCIDNumber, usageByDay: [UsageByDay]) {
            self.iccid = iccid; self.usageByDay = usageByDay
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.iccid = ICCIDNumber(try container.decode(String.self, forKey: .iccid))
            self.usageByDay = try container.decode([UsageByDay].self, forKey: .usageByDay)
        }
        
        // MARK: - UsageByDay
        public struct UsageByDay: Decodable {
            ///The date of the usage day FORMAT: YYYY-MM-DD
            public let date: String
            ///Megabytes used in the usage day
            public let mbsUsed: Double
            ///Total megabytes used in the billing period, inclusive of this usage day
            public let mbsUsedCumulative: Double
            
            private enum CodingKeys: String, CodingKey {
                case date
                case mbsUsed = "mbs_used"
                case mbsUsedCumulative = "mbs_used_cumulative"
            }
            
            private init(date: String, mbsUsed: Double, mbsUsedCumulative: Double) {
                self.date = date; self.mbsUsed = mbsUsed; self.mbsUsedCumulative = mbsUsedCumulative
            }
        }
    }
}

// MARK: - FleetDataUsageResponse
extension PCSimCard {
    
    ///Get fleet-wide SIM card data usage for a product in the current billing period, broken out by day. Daily usage totals represent an aggregate of all SIM cards that make up the product. Data usage reports can be delayed until the next day, and occasionally by several days.
    public struct FleetDataUsageResponse: Decodable {
        ///The total number of megabytes consumed by the fleet in the current billing period.
        public let totalMbsUsed: Int
        ///The total number of active SIM cards in the product fleet. SIM cards that have been paused due to reaching their monthly data limit are included in this total.
        public let totalActiveSimCards: Int
        ///An array of data usage by day.
        public let usageByDay: [UsageByDay]
        
        private enum CodingKeys: String, CodingKey {
            case totalMbsUsed = "total_mbs_used", totalActiveSimCards = "total_active_sim_cards", usageByDay = "usage_by_day"
        }
        
        private init(totalMbsUsed: Int, totalActiveSimCards: Int, usageByDay: [UsageByDay]) {
            self.totalMbsUsed = totalMbsUsed; self.totalActiveSimCards = totalActiveSimCards; self.usageByDay = usageByDay
        }
    }
    
    // MARK: - UsageByDay
    public struct UsageByDay: Decodable {
        ///The date of the usage day FORMAT: YYYY-MM-DD
        public let date: String
        ///Megabytes used in the usage day.
        public let mbsUsed: Int
        ///Total megabytes used in the billing period, inclusive of this usage day.
        public let mbsUsedCumulative: Int
        
        private enum CodingKeys: String, CodingKey {
            case date, mbsUsed = "mbs_used", mbsUsedCumulative = "mbs_used_cumulative"
        }
    }
}



extension PCSimCard {
    
    //MARK: - CurrentValueSubjects
    
    
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
    /// - Parameter token: A currently active access token scoped to sims:list
    /// - Returns: `CurrentValueSubject<ListResponse?, PCError>`
    public static func listSimCards(arguments: ListRequestArgument, token: PCAccessToken) -> CurrentValueSubject<ListResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.listSimCards(arguments: arguments, token: token), type: ListResponse.self)
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
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Returns: `CurrentValueSubject<GetSimInfoResponse?, PCError>`
    public static func getSimInformation(iccid: ICCIDNumber, productIDorSlug: ProductID, token: PCAccessToken) -> CurrentValueSubject<GetSimInfoResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.getSimInformation(iccid: iccid.rawValue, productIDorSlug: productIDorSlug, token: token), type: GetSimInfoResponse.self)
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
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Returns: `CurrentValueSubject<IccidDataUsageResponse?, PCError>`
    public static func getDataUsage(iccid: ICCIDNumber, productIDorSlug: ProductID, token: PCAccessToken) -> CurrentValueSubject<IccidDataUsageResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.getDataUsage(iccid: iccid.rawValue, productIDorSlug: productIDorSlug, token: token), type: IccidDataUsageResponse.self)
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
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Returns: `CurrentValueSubject<PCSimCard.FleetDataUsageResponse?, PCError>`
    public static func getFleetDataUsage(productIDorSlug: ProductID, token: PCAccessToken) -> CurrentValueSubject<FleetDataUsageResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.getDataUsageForProductFleet(productIDorSlug: productIDorSlug, token: token), type: FleetDataUsageResponse.self)
    }
    
    
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
    /// - Parameter token: A currently active access token.
    /// - Returns: CurrentValueSubject<ServerResponses.NoResponse?, PCError>
    public static func activateSim(iccid: ICCIDNumber, token: PCAccessToken) -> CurrentValueSubject<ServerResponses.NoResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.activateSIM(iccid: iccid.rawValue, token: token), type: ServerResponses.NoResponse.self)
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
    /// - Parameter token: A currently active access token.
    /// - Returns: CurrentValueSubject<ServerResponses.BoolResponse?, PCError>
    public static func importAndActivateProductSim(productIdOrSlug: ProductID, iccids: [ICCIDNumber]?, filePath: String?, token: PCAccessToken) -> CurrentValueSubject<ServerResponses.BoolResponse?, PCError> {
        
        let file = getFile(at: filePath)
        
        if filePath != nil && file == nil {
            let subject = CurrentValueSubject<ServerResponses.BoolResponse?, PCError>(nil)
            subject.send(completion: .failure(PCError(code: .invalidArguments, description: "Could not get file at path \(filePath!)")))
            return subject
        }
        
        return PCNetwork.shared.cloudRequest(.importAndActivateProductSIMs(productIDorSlug: productIdOrSlug, sims: iccids?.map({$0.rawValue}), file: getFile(at: filePath), token: token), type: ServerResponses.BoolResponse.self)
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
    /// - Parameter token: A currently active access token scoped to sims:update
    /// - Returns:` CurrentValueSubject<ServerResponses.NoResponse?, PCError>`.
    public static func deActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken) -> CurrentValueSubject<ServerResponses.NoResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.deactivateSIM(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self)
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
    /// - Parameter token: A currently active access token scoped to sims:update
    /// - Returns:`CurrentValueSubject<Bool?, PCError>`
    public static func reActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken) -> CurrentValueSubject<ServerResponses.NoResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.reactivateSIM(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self)
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
    /// - Parameter token: A currently active access token scoped to sims:remove
    /// - Returns: `CurrentValueSubject<ServerResponses.NoResponse?, PCError>`
    public static func releaseSimFromAccount(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken) -> CurrentValueSubject<ServerResponses.NoResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.releaseSimFromAccount(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self)
    }
}


extension PCSimCard {
    
    //MARK: - Async
    
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
    /// - Parameter token: A currently active access token scoped to sims:list
    /// - Returns: PCSimCard.ListRequestArgument
    public static func listSimCards(arguments: ListRequestArgument, token: PCAccessToken) async throws -> ListResponse {
        try await PCNetwork.shared.cloudRequest(.listSimCards(arguments: arguments, token: token), type: ListResponse.self)
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
    /// - Throws: PCError
    /// - Parameter iccid: Filter results to SIMs with this ICCID (partial matching) Product endpoint only
    /// - Parameter productIDorSlug: The id of the product the sim belongs to.
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Returns: `PCSimCard.GetSimInfoResponse`
    public static func getSimInformation(iccid: ICCIDNumber, productIDorSlug: ProductID, token: PCAccessToken) async throws -> GetSimInfoResponse {
        try await PCNetwork.shared.cloudRequest(.getSimInformation(iccid: iccid.rawValue, productIDorSlug: productIDorSlug, token: token), type: GetSimInfoResponse.self)
    }
    
    
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
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Returns: `PCSimCard.IccidDataUsageResponse`
    public static func getDataUsage(iccid: ICCIDNumber, productIDorSlug: ProductID, token: PCAccessToken) async throws -> IccidDataUsageResponse {
        try await PCNetwork.shared.cloudRequest(.getDataUsage(iccid: iccid.rawValue, productIDorSlug: productIDorSlug, token: token), type: IccidDataUsageResponse.self)
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
    /// - Throws: PCError
    /// - Parameter productIDorSlug: String representing the product id or slug of the fleet.
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Returns: `PCSimCard.FleetDataUsageResponse`
    public static func getFleetDataUsage(productIDorSlug: ProductID, token: PCAccessToken) async throws -> FleetDataUsageResponse {
        try await PCNetwork.shared.cloudRequest(.getDataUsageForProductFleet(productIDorSlug: productIDorSlug, token: token), type: FleetDataUsageResponse.self)
    }
    
    
    ///Activate SIM.
    ///
    ///Activates a SIM card for the first time.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/sims
    ///
    ///
    ///
    /// - Requires: Scope of sims:import
    /// - Throws: PCError
    /// - note: Can not be used to activate Product SIM cards. Use the importAndActivateProductSim instead.
    /// - Parameter iccid: The ICCID of the SIM to update
    /// - Parameter token: A currently active access token.
    /// - Returns: ServerResponses.NoResponse containing a bool indicating success.
    public static func activateSim(iccid: ICCIDNumber, token: PCAccessToken) async throws -> ServerResponses.NoResponse {
        try await PCNetwork.shared.cloudRequest(.activateSIM(iccid: iccid.rawValue, token: token), type: ServerResponses.NoResponse.self)
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
    /// - Throws: PCError
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter filePath: A path to a .txt file containing a single-column list of ICCIDs.
    /// - Parameter sims: An array of SIM ICCIDs to import.
    /// - Parameter token: A currently active access token.
    /// - Returns:Bool indicating success.
    public static func importAndActivateProductSim(productIdOrSlug: ProductID, iccids: [ICCIDNumber]?, filePath: String?, token: PCAccessToken) async throws -> Bool {
        
        let file = getFile(at: filePath)
        
        if filePath != nil && file == nil {
            throw PCError(code: .invalidArguments, description: "Could not get file at path \(filePath!)")
        }
        
        return try await PCNetwork.shared.cloudRequest(.importAndActivateProductSIMs(productIDorSlug: productIdOrSlug, sims: iccids?.map({$0.rawValue}), file: filePath, token: token), type: ServerResponses.BoolResponse.self).ok
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
    /// - Parameter token: A currently active access token scoped to sims:update
    /// - Returns: Bool indicating success.
    public static func deActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken) async throws -> Bool {
        try await PCNetwork.shared.cloudRequest(.deactivateSIM(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self).ok
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
    /// - Throws: PCError
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter token: A currently active access token scoped to sims:update
    /// - Returns: Bool
    public static func reActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken) async throws -> Bool {
        try await PCNetwork.shared.cloudRequest(.reactivateSIM(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self).ok
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
    /// - Throws: PCError
    /// - Parameter iccid: The ICCID of the SIM to deactivate.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter token: A currently active access token scoped to sims:remove
    /// - Returns: Bool indicating success.
    public static func releaseSimFromAccount(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken) async throws -> Bool {
        try await PCNetwork.shared.cloudRequest(.releaseSimFromAccount(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self).ok
    }
}


extension PCSimCard {
    
    //MARK: - Completion Handlers
    
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
    /// - Parameter token: A currently active access token scoped to sims:list
    /// - Parameter completion: Closure containing `Result<ListResponse?, PCError>`
    public static func listSimCards(arguments: ListRequestArgument, token: PCAccessToken, completion: @escaping (Result<ListResponse, PCError>) -> Void){
        PCNetwork.shared.cloudRequest(.listSimCards(arguments: arguments, token: token), type: ListResponse.self, completion: completion)
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
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Returns: Closure containing `Result<PCSimCard.GetSimInfoResponse?, PCError>`
    public static func getSimInformation(iccid: ICCIDNumber, productIDorSlug: ProductID, token: PCAccessToken, completion: @escaping (Result<GetSimInfoResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.getSimInformation(iccid: iccid.rawValue, productIDorSlug: productIDorSlug, token: token), type: GetSimInfoResponse.self, completion: completion)
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
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Parameter completion: Closure containing `Result<PCSimCard.IccidDataUsageResponse?, PCError>`
    public static func getDataUsage(iccid: ICCIDNumber, productIDorSlug: ProductID, token: PCAccessToken, completion: @escaping (Result<IccidDataUsageResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.getDataUsage(iccid: iccid.rawValue, productIDorSlug: productIDorSlug, token: token), type: IccidDataUsageResponse.self, completion: completion)
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
    /// - Parameter token: A currently active access token scoped to sims:get
    /// - Parameter completion: Closure containing `Result<PCSimCard.FleetDataUsageResponse, PCError>`
    public static func getFleetDataUsage(productIDorSlug: ProductID, token: PCAccessToken, completion: @escaping (Result<FleetDataUsageResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.getDataUsageForProductFleet(productIDorSlug: productIDorSlug, token: token), type: FleetDataUsageResponse.self, completion: completion)
    }
    
    
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
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure containing `Result<ServerResponses.NoResponse, PCError>`
    public static func activateSim(iccid: ICCIDNumber, token: PCAccessToken, completion: @escaping (Result<ServerResponses.NoResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.activateSIM(iccid: iccid.rawValue, token: token), type: ServerResponses.NoResponse.self, completion: completion)
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
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure containing `Result<ServerResponses.BoolResponse, PCError>`
    public static func importAndActivateProductSim(productIdOrSlug: ProductID, iccids: [ICCIDNumber]?, filePath: String?, token: PCAccessToken, completion: @escaping (Result<ServerResponses.BoolResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.importAndActivateProductSIMs(productIDorSlug: productIdOrSlug, sims: iccids?.map({$0.rawValue}), file: filePath, token: token), type: ServerResponses.BoolResponse.self, completion: completion)
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
    /// - Parameter token: A currently active access token scoped to sims:update
    /// - Parameter completion: Closure containing ` Result<Bool?, PCError>`.
    public static func deActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.deactivateSIM(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self) { response in
            
            switch response {
            case .success(let result):
                completion(.success(result.ok))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
    /// - Parameter token: A currently active access token scoped to sims:update
    /// - Parameter completion:Closure containing `Result<Bool, PCError>`
    public static func reActivateSIM(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.reactivateSIM(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self) { response in
            switch response {
            case .success(let result):
                completion(.success(result.ok))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
    /// - Parameter token: A currently active access token scoped to sims:remove
    /// - Parameter completion: Closure containing `Result<Bool, PCError>`
    public static func releaseSimFromAccount(productIdOrSlug: ProductID?, iccid: ICCIDNumber, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.releaseSimFromAccount(iccid: iccid.rawValue, productIDorSlug: productIdOrSlug, token: token), type: ServerResponses.NoResponse.self) { response in
            
            switch response {
            case .success(let result):
                completion(.success(result.ok))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
