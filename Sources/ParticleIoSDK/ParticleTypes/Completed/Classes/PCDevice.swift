//
//  PCDevice.swift
//  Particle
//
//  Created by Craig Spell on 11/8/19.
//  Copyright © 2019 Spell Software Inc. All rights reserved.
//

import Foundation
import Combine


///Representation of the platform id of the physical device.
public enum PlatformID: Int, Codable {
    
    case Core = 0, Photon = 6, P1 = 8, Electron = 10, RaspberryPi = 31, RedBearDuo = 88, Bluz = 103, DigistumpOak = 82, ESP32 = 11, Argon = 12, Boron = 13, Xenon = 14, ASeries = 22, BSeries = 23, XSeries = 24, B5SoM = 25
    case Unknown = -1
    
    ///Human readable description.
    public var description: String {
        switch self {
            case .ASeries: return "A-Series"
            case .Argon: return "Argon"
            case .B5SoM: return "B5-SOM"
            case .BSeries: return "B-Series"
            case .Bluz: return "Bluz"
            case .Boron: return "Boron"
            case .Core: return "Core"
            case .DigistumpOak: return "DigistumpOak"
            case .ESP32: return "ESP32"
            case .Electron: return "Electron"
            case .P1: return "P1"
            case .Photon: return "Photon"
            case .RaspberryPi: return "RaspberryPi"
            case .RedBearDuo: return "RedBearDuo"
            case .Unknown: return "Unknown"
            case .XSeries: return "XSeries"
            case .Xenon: return "Xenon"
        }
    }
    
    
    //used internally to convert json int string into int value then send to designated init.
    private init?(_ rawValue: String?) {
        if let str = rawValue,
           let id = Int(str) {
            self.init(rawValue: id)
        }
        return nil
    }
}



///Representation of the particle device.
///
///The PCDevice is the heart of the Particle API. It is a direct representation of the particle device. This object is currently observable for the property events.
/// - note: Cellular devices may indicate that the device is online for up to 46 minutes after the device has gone offline because it went out of range or was powered off. Wi-Fi devices will generally be accurate to within a few minutes. Online indications are should occur immediately if the device was previously offline for both cellular and Wi-Fi.
public final class PCDevice: NSObject, Decodable, ObservableObject, Identifiable {
    
    public typealias TransferID = String

    //used for currentvaluesubject subscriptions to change output before passing down the line.
    private var cancellables = Set<AnyCancellable>()

    ///Human readable description of the instance.
    public override var description: String {
"""
    id: \(id.rawValue),
    name: \(name.rawValue),
    status:\(String(describing: status)),
    productID:\(String(describing: productID.rawValue)),
    notes:\(String(describing: notes)),
    functions: \(functionsDescription),
    variables: \(variablesDescription),
    owner:\(String(describing: owner)),
    cellular:\(String(describing: cellular)),
    online:\(String(describing: online)),
    connected:\(String(describing: connected)),
    lastIPAddress:\(lastIPAddress),
    lastHeard:\(lastHeard),
    lastHandshakeAt\(lastHandshakeAt),
    platformID:\(String(describing: platformID)),
    firmwareUpdatesEnabled:\(String(describing: firmwareUpdatesEnabled)),
    firmwareUpdatesForced:\(String(describing: firmwareUpdatesForced)),
    serialNumber:\(String(describing: serialNumber)),
    systemFirmwareVersion:\(String(describing: systemFirmwareVersion)),
    currentBuildTarget:\(String(describing: currentBuildTarget)),
    defaultBuildTarget:\(String(describing: defaultBuildTarget)),
    token: \(token?.accessToken.suffix(4) ?? "nil"),
    events: \(events.description)
"""
    }
    
    ///Human readable debug description of the instance.
    public override var debugDescription: String {
"""
PCDevice: {
    id: \(id),
    name: \(name),
    status:\(String(describing: status)),
    productID:\(String(describing: productID)),
    notes:\(String(describing: notes)),
    functions: \(functionsDescription),
    variables: \(variablesDescription),
    owner:\(String(describing: owner)),
    cellular:\(String(describing: cellular)),
    online:\(String(describing: online)),
    connected:\(String(describing: connected)),
    lastIPAddress:\(lastIPAddress),
    lastHeard:\(lastHeard),
    lastHandshakeAt\(lastHandshakeAt),
    platformID:\(String(describing: platformID)),
    firmwareUpdatesEnabled:\(String(describing: firmwareUpdatesEnabled)),
    firmwareUpdatesForced:\(String(describing: firmwareUpdatesForced)),
    serialNumber:\(String(describing: serialNumber)),
    systemFirmwareVersion:\(String(describing: systemFirmwareVersion)),
    currentBuildTarget:\(String(describing: currentBuildTarget)),
    defaultBuildTarget:\(String(describing: defaultBuildTarget)),
    token: \(token?.accessToken.suffix(4) ?? "nil"),
    events: \(events.description)
}
"""
    }
    
    //Description helper
    private var functionsDescription: String {
        if functions.isEmpty {
            return "[]"
        }
        return
"""
[
        \(functions.map({$0.rawValue}).joined(separator: ",\n        "))
    ]
"""
    }
    
    //Description helper
    private var variablesDescription: String {
        if variables.isEmpty {
            return "[]"
        }
        return
"""
[
        \(variables.map({"key: \($0.key), value: \($0.value)"}).joined(separator: ",\n        "))
    ]
"""
    }
    
    ///Events the device has recieved since subscribing.
    @Published public var events = EventCache(countLimit: 10)
    
    ///Keys for the device properties that can be used to get values for those devices. For example if you want to iterate through the cases and get the values. This is actually an internal function left public for giggles.
    public enum PropertyKey: String, CaseIterable {
        case id, name, lastIPAddress, lastHeard, lastHandshakeAt, productID, online, connected, platformID, cellular, notes, functions, variables, status, serialNumber, systemFirmwareVersion, currentBuildTarget, firmwareProductID, groups, targetedFirmwareReleaseVersion, development, quarantined, denied, owner, firmwareUpdatesEnabled, firmwareUpdatesForced, defaultBuildTarget, events
    }
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        
        case id, name, online, connected, cellular, notes, functions, variables, status, groups, development, quarantined, denied, owner
        
        //        case customerID = "customer_id"
        //        case userID = "user_id"
        case lastIPAddress = "last_ip_address"
        case lastHeard = "last_heard"
        case lastHandshakeAt = "last_handshake_at"
        case productID = "product_id"
        case platformID = "platform_id"
        case serialNumber = "serial_number"
        case systemFirmwareVersion = "system_firmware_version"
        case currentBuildTarget = "current_build_target"
        case firmwareProductID = "firmware_product_id"
        case targetedFirmwareReleaseVersion = "targeted_firmware_release_version"
        case firmwareUpdatesEnabled = "firmware_updates_enabled"
        case firmwareUpdatesForced = "firmware_updates_forced"
        case defaultBuildTarget = "default_build_target"
        case events
    }
        
    ///The id of the physical particle device.
    public let id: DeviceID
    
    ///The currently assigned name of of the physical device.
    private(set) public var name: DeviceName
    
    ///The last detected ip address of the physical device.
    public let lastIPAddress: String
    
    ///The last time the cloud heard from the physical device.
    public let lastHeard: String
    
    ///The last successful handshake with the phsyical device.
    public let lastHandshakeAt: String
    
    ///The id of the product that the physical device is assigned to.
    /// - note: If the productID has a length of 5 it is a productID otherwise it is a value assigned by particle.
    public let productID: ProductID
    
    ///The platform id of the physical device.
    /// - note: A best effort was made to account for all possible device types, but the enum also contains an unknown case if the product is not found.
    public let platformID: PlatformID
    
    ///The id of the firmware currently assigned to the product that the device is associated with. Returns nil if firmware is not assigned or if the physical device is not associated with a product.
    public let firmwareProductID: Int?
    
    ///Bool indicating if the phsyical device was online when the 'internal or application'  instance was created.
    public let online: Bool
    
    ///Bool indicating if the phsyical device was connected to the cloud when the 'internal or application'  instance was created.
    public let connected: Bool
    
    ///Bool indicating if the physical device connects to a cellular network.
    public let cellular: Bool
    
    ///Bool indicating whether automatic firmware updates are enabled.
    public let firmwareUpdatesEnabled: Bool
    
    ///Bool indicating whether automatic firmware updates are forced on the physical device.
    public let firmwareUpdatesForced: Bool?
    
    ///Notes kept in the cloud for the physical device or nil if not present.
    private(set) public var notes: String?
    
    ///The last known status pf the physical device.
    /// - Important: This status can change over time and is not automatically updated.
    public let status: String
    
    ///The serial number of the physical particle device.
    public let serialNumber: String
    
    ///Current system firmware version on the physical device.
    public let systemFirmwareVersion: String
    
    ///The current build target for the device firmware.
    public let currentBuildTarget: String
    
    ///The default build target for the device firmware.
    public let defaultBuildTarget: String
    
    ///Targeted firmware release verion..?
    public let targetedFirmwareReleaseVersion: String?
    
    ///The current owner of the physical device. If the device has been claimed by a user or a customer.
    public let owner: String?
    
    ///The names of the functions the device has exposed to the cloud.
    /// - note: If you update these function names in the actual device firmware you must replace the device representation in memory. ie: get the device again.
    public let functions: [FunctionName]
    
    ///The names of the variables the device has exposed to the cloud and type of that variable.
    /// - note: If you update these variable in the actual device firmware you must replace the device representation in memory. ie: get the device again.
    public let variables: [String : String]
    
    ///Names of the groups the device is associated with.
    public let groups: [String]?
    
    ///The Product the device belongs to.
    public private(set) var product: PCProduct?
    
    ///Private hold of the token used to get the device.
    private var token: PCAccessToken?
    
    ///Bool indicating if the device is in development.
    public let development: Bool?
    
    ///Bool indiacting if the device is in quarantine.
    public let quarantined: Bool?
    
    ///Bool indiacting if the device denied leaving quarantine.
    public let denied: Bool?
    
    ///Used to share properties for easy iteration. The keys can be used with func value(forKey key: PropertyKey) -> Any?.
    public var propertyKeys: [PropertyKey] {
        PropertyKey.allCases
    }
    
    //Made required for security reasons. Shielding from public abuse.
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = DeviceID(try container.decode(String.self, forKey: .id))
        self.name = DeviceName(try container.decode(String.self, forKey: .name))
        self.functions = try container.decode([String].self, forKey: .functions).map({FunctionName($0)})
        self.variables = try container.decode([String : String].self, forKey: .variables)
        self.status = try container.decode(String.self, forKey: .status)
        self.owner = try container.decodeIfPresent(String.self, forKey: .owner)
        self.cellular = try container.decode(Bool.self, forKey: .cellular)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.online = try container.decode(Bool.self, forKey: .online)
        self.connected = try container.decode(Bool.self, forKey: .connected)
        self.lastIPAddress = try container.decode(String.self, forKey: .lastIPAddress)
        self.lastHeard = try container.decode(String.self, forKey: .lastHeard)
        self.lastHandshakeAt = try container.decode(String.self, forKey: .lastHandshakeAt)
        self.productID = ProductID(try container.decode(Int.self, forKey: .productID)) ?? ProductID("0") //Fault value
        self.platformID = PlatformID(rawValue: try container.decode(Int.self, forKey: .platformID)) ?? PlatformID.Unknown
        self.firmwareUpdatesEnabled = try container.decode(Bool.self, forKey: .firmwareUpdatesEnabled)
        self.firmwareUpdatesForced = try container.decodeIfPresent(Bool.self, forKey: .firmwareUpdatesForced)
        self.serialNumber = try container.decode(String.self, forKey: .serialNumber)
        self.systemFirmwareVersion = try container.decode(String.self, forKey: .systemFirmwareVersion)
        self.currentBuildTarget = try container.decode(String.self, forKey: .currentBuildTarget)
        self.defaultBuildTarget = try container.decode(String.self, forKey: .defaultBuildTarget)
        self.groups = try container.decodeIfPresent([String].self, forKey: .groups)
        self.development = try container.decodeIfPresent(Bool.self, forKey: .development)
        self.quarantined = try container.decodeIfPresent(Bool.self, forKey: .quarantined)
        self.denied = try container.decodeIfPresent(Bool.self, forKey: .denied)
        self.targetedFirmwareReleaseVersion = try container.decodeIfPresent(String.self, forKey: .targetedFirmwareReleaseVersion)
        self.firmwareProductID = try container.decodeIfPresent(Int.self, forKey: .firmwareProductID)
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenUnavailable) , name: .pc_token_unavailable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tokenAvailable), name: .pc_token_available, object: nil)
    }
    
    //Stay in sync with token availability.
    @objc private func tokenAvailable() {
        self.token = PCAuthenticationManager.shared.token
    }
    
    @objc private func tokenUnavailable() {
        self.token = nil
    }
    
    ///Provides a property value for associated property key.
    public func description(for key: PropertyKey) -> String? {
        
        switch key {
                
            case .id:
                return self.id.rawValue
            case .name:
                return self.name.rawValue
            case .lastIPAddress:
                return self.lastIPAddress.description
            case .lastHeard:
                return self.lastHeard.description
            case .lastHandshakeAt:
                return self.lastHandshakeAt.description
            case .productID:
                return self.productID.rawValue
            case .online:
            return self.online.description
            case .connected:
                return self.connected.description
            case .platformID:
                return self.platformID.description
            case .cellular:
                return self.cellular.description
            case .notes:
                return self.notes?.description ?? "nil"
            case .functions:
                return "[\n\(self.functions.map({"  \($0.rawValue)"}).joined(separator: ",\n"))\n]"
            case .variables:
                return "[\n\(self.variables.map({"  \($0):\($1)"}).joined(separator: ",\n"))\n]"
            case .status:
                return self.status.description
            case .serialNumber:
                return self.serialNumber.description
            case .systemFirmwareVersion:
                return self.systemFirmwareVersion.description
            case .currentBuildTarget:
                return self.currentBuildTarget.description
            case .firmwareProductID:
                return self.firmwareProductID?.description ?? "nil"
            case .groups:
                return self.groups?.description ?? "nil"
            case .targetedFirmwareReleaseVersion:
                return self.targetedFirmwareReleaseVersion?.description ?? "nil"
            case .development:
                return self.development?.description ?? "nil"
            case .quarantined:
                return self.quarantined?.description ?? "nil"
            case .denied:
                return self.denied?.description ?? "nil"
            case .owner:
                return self.owner?.description ?? "nil"
            case .firmwareUpdatesEnabled:
                return self.firmwareUpdatesEnabled.description
            case .firmwareUpdatesForced:
                return self.firmwareUpdatesForced?.description ?? "nil"
            case .defaultBuildTarget:
                return self.defaultBuildTarget.description
            case .events:
                return self.events.description
        }
    }
    
    ///Little cheat to iterate over all property values.
    public func value(for key: PropertyKey) -> Any? {
        
        switch key {
                
            case .id:
                return self.id
            case .name:
                return self.name
            case .lastIPAddress:
                return self.lastIPAddress
            case .lastHeard:
                return self.lastHeard
            case .lastHandshakeAt:
                return self.lastHandshakeAt
            case .productID:
                return self.productID
            case .online:
                return self.online
            case .connected:
                return self.connected
            case .platformID:
                return self.platformID
            case .cellular:
                return self.cellular
            case .notes:
                return self.notes
            case .functions:
                return self.functions
            case .variables:
                return self.variables
            case .status:
                return self.status
            case .serialNumber:
                return self.serialNumber
            case .systemFirmwareVersion:
                return self.systemFirmwareVersion
            case .currentBuildTarget:
                return self.currentBuildTarget
            case .firmwareProductID:
                return self.firmwareProductID
            case .groups:
                return self.groups
            case .targetedFirmwareReleaseVersion:
                return self.targetedFirmwareReleaseVersion
            case .development:
                return self.development
            case .quarantined:
                return self.quarantined
            case .denied:
                return self.denied
            case .owner:
                return self.owner
            case .firmwareUpdatesEnabled:
                return self.firmwareUpdatesEnabled
            case .firmwareUpdatesForced:
                return self.firmwareUpdatesForced
            case .defaultBuildTarget:
                return self.defaultBuildTarget
            case .events:
                return self.events
        }
    }

    
    ///Comparason operator for Equatable conformance.
    public static func ==(lhs: PCDevice, rhs: PCDevice) -> Bool {
        lhs.id == rhs.id
    }
                               
    ///Hash function for Hashable protocol.
    public override var hash: Int {
        var hasher = Hasher()
            hasher.combine(id.rawValue)
            hasher.combine(name.rawValue)
            hasher.combine(lastIPAddress)
            hasher.combine(lastHeard)
            hasher.combine(lastHandshakeAt)
            hasher.combine(productID.rawValue)
            hasher.combine(platformID)
            hasher.combine(online)
            hasher.combine(connected)
            hasher.combine(cellular)
            hasher.combine(firmwareUpdatesEnabled)
            hasher.combine(firmwareUpdatesForced)
            hasher.combine(notes)
            hasher.combine(status)
            hasher.combine(serialNumber)
            hasher.combine(systemFirmwareVersion)
            hasher.combine(currentBuildTarget)
            hasher.combine(defaultBuildTarget)
            hasher.combine(owner)
            hasher.combine(variables)
            hasher.combine(events)
            hasher.combine(token)
        
        return hasher.finalize()
    }
    
    deinit {
        print("deinit of device \(id)")
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Refresh
extension PCDevice {
    
    ///Refresh the PCDevice instance against the physical device.
    public func refresh() -> Future<Bool, PCError> {
        
        Future { promise in
            
            guard let token = PCAuthenticationManager.shared.token
            else {
                promise(.failure( PCError(code: .unauthenticated, description: "Could not complete the operation because you are not currently authenticated.")))
                return
            }
            
            Task {
                let device = try await PCDevice.getDevice(deviceID: self.id, token: token)
                
                for propertyKey in device.propertyKeys {
                    if propertyKey != .events {
                        self.setValue(device.value(for: propertyKey), forKey: propertyKey.rawValue)
                    }
                }
                
                self.token = token
                
                promise(.success(true))
            }
        }
    }

    ///Refresh the PCDevice instance against the physical device.
    public func refresh(completion: ((Result<Never, PCError>) -> Void)? = nil) {
        
        guard let token = PCAuthenticationManager.shared.token
        else {
            completion?(.failure(PCError(code: .unauthenticated, description: "Could not complete the operation because you are not currently authenticated.")))
            return
        }
        PCDevice.getDevice(deviceID: self.id, token: token) { result in
            do {
                let device = try result.get()
                
                for propertyKey in device.propertyKeys {
                    self.setValue(device.value(for: propertyKey), forKey: propertyKey.rawValue)
                }
                
                self.token = token
            } catch {
                completion?(.failure(error as! PCError))
            }
        }
    }
    
    ///Refresh the PCDevice instance against the physical device.
    public func refresh() async throws {
        
        guard let token = PCAuthenticationManager.shared.token
        else {
            throw PCError(code: .unauthenticated, description: "Could not complete the operation because you are not currently authenticated.")
        }
        
        let device = try await PCDevice.getDevice(deviceID: self.id, token: token)
        
        for propertyKey in device.propertyKeys {
            if propertyKey != .events {
                self.setValue(device.value(for: propertyKey), forKey: propertyKey.rawValue)
            }
        }
        
        self.token = token
        
    }
}


//MARK: - Events
extension PCDevice {
    
    //Shared error handling
    private enum NameType {
        case event, productID
    }
    
    //Shared error handling
    private func checkName(_ name: String, type: NameType) -> PCError? {
        if name.isEmpty{
            return PCError(code: .invalidArguments, description: "\(type == .event ? "Event name" : "ProductID" ) parameter cannot be an empty string.")
        }
        return nil
    }
    
    ///Subscribe to events by the product they are sent with.
    public func subscribeToProductEvents(_ name: EventName, productID: ProductID, token: PCAccessToken, onEvent: EventBlock?, completion: CompletionBlock?) {
        
        if let error = checkName(productID.rawValue, type: .productID) {
            completion?(error)
            return
        }
        
        guard let token = self.token
        else {
            completion?(PCError.unauthenticated)
            return
        }
        
        PCNetwork.shared.subscribeToProductEvents(eventName: name, productID: productID, token: token) { event in
            onEvent?(event)
        } completion: { error in
            completion?(error)
        }
    }
    
    ///Subscribe to any events matching the event name.
    public func subscribeToEvents(eventName: EventName, onEvent: EventBlock?, completion: CompletionBlock?) {
        
        guard let token
        else {
            completion?(PCError.unauthenticated)
            return
        }
        
        if let error = checkName(eventName.rawValue, type: .event) {
            completion?(error)
            return
        }
        
        PCNetwork.shared.subscribeToEvents(eventName: eventName, token: token) { event in
            onEvent?(event)
        } completion: { error in
            completion?(error)
        }
    }
    
    ///Subscribe to events issued by the represented device only.
    public func subscribeToDeviceEvents(eventName: EventName, onEvent: EventBlock?, completion: CompletionBlock?) {
        
        guard let token
        else {
            completion?(PCError.unauthenticated)
            return
        }
        
        if let error = checkName(eventName.rawValue, type: .event) {
            completion?(error)
            return
        }
        
        PCNetwork.shared.subscribeToDeviceEvents(eventName: eventName, deviceId: self.id, token: token) { event in
            onEvent?(event)
        } completion: { error in
            completion?(error)
        }
    }
}



extension PCDevice {
    
    ///Causes the device to publish a product event.
    public func publishProductEvent(_ eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, completion: @escaping (Result<Bool, PCError>) -> Void)  {
        
        guard let token = self.token
        else {
            completion(.failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.\n")))
            return
        }
        
        if self.productID.rawValue.count != 5 {
            completion(.failure(PCError(code: .invalidArguments, description: "The device \(self.id) is not claimed by a product. You cannot publish a product event through a device not associated with a product. Use PCEvent.publishEvent instead.\n")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.publishEvent(eventName: eventName, productIDorSlug: self.productID, data: data, private: isPrivate, ttl: ttl, token: token), type: PCEvent.PublishResponse.self) { response in
            do {
                let result = try response.get().ok
                completion(.success(result))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }
    
    ///Causes the device to publish a product event.
    public func publishProductEvent(_ eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil) async throws -> Bool  {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.\n")
        }
        
        if self.productID.rawValue.count != 5 {
            throw PCError(code: .invalidArguments, description: "The device \(self.id) is not claimed by a product. You cannot publish a product event through a device not associated with a product. Use PCEvent.publishEvent instead.\n")
        }
        
        return try await PCNetwork.shared.cloudRequest(.publishEvent(eventName: eventName, productIDorSlug: self.productID, data: data, private: isPrivate, ttl: ttl, token: token), type: PCEvent.PublishResponse.self).ok
    }

    
    //MARK: Async
    
    ///Publishes a device event.
    public func publishEvent(eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil) async throws -> Bool {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
            
        }
        
        return try await PCNetwork.shared.cloudRequest(.publishEvent(eventName: eventName, productIDorSlug: nil, data: data, private: isPrivate, ttl: ttl, token: token), type: PCEvent.PublishResponse.self).ok
    }
    
    
    //MARK: Completion Handlers
    
    ///Publishes a device event.
    public func publishEvent(_ eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, completion: @escaping (Result<Bool, PCError>) -> Void)  {
        
        guard let token = self.token
        else {
            completion(.failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.publishEvent(eventName: eventName, productIDorSlug: nil, data: data, private: isPrivate, ttl: ttl, token: token), type: PCEvent.PublishResponse.self) { response in
            do {
                let result = try response.get().ok
                completion(.success(result))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }
}


//MARK: - Functions
extension PCDevice {
    
    ///Used to provide arguments to the server when making a function call on the physical devices firmware.
    public struct FunctionArguments {
        
        ///Human readable description of the instance.
        var description: String {
            return "functionName:\(functionName)\nargument:\(String(describing: functionArgument))\nproductIdOrSlug:\(String(describing: productIdOrSlug))"
        }
        
        ///The name of the function to call.
        public let functionName: FunctionName
        ///Function argument with a maximum length of 63 characters
        public let functionArgument: FunctionArgument?
        ///Product ID or Slug.
        ///Product endpoint only.
        public let productIdOrSlug: ProductID?
        
        //Create arguments to be passed with particle function call.
        public init(
            functionName: FunctionName,
            functionArgument: FunctionArgument? = nil,
            productIdOrSlug: ProductID? = nil
        ) {
            self.functionName = functionName
            self.functionArgument = functionArgument
            self.productIdOrSlug = productIdOrSlug
        }
    }
    
    ///A struct created using the json response of the sevrer.
    public struct FunctionResponse : Decodable {
        
        ///The id of the device on which the function was called.
        public let id : String
        ///The name of the device on which the function was called.
        public let name : String
        
        ///Flag indicating whether or not the device is currently connected to the cloud.
        public let connected : Bool
        
        ///The return value of the function call.
        public let returnValue : Int
        
        ///Made private for security reasons. Shielding from public abuse.
        private enum CodingKeys: String, CodingKey {
            case id, name, connected, returnValue = "return_value"
        }
        
        //Made private for security reasons. Shielding from public abuse.
        private init() {
            fatalError("Function response must be inititalized from a decoder.")
        }
    }
    
    
    //MARK: CurrentValueSubjects
    
    ///Call a cloud function.
    ///
    ///Use this instance method to call an exposed function on a prticle device.
    ///[see docs](https://docs.particle.io/reference/device-os/api/cloud-functions/overview-of-api-field-limits/)
    ///
    ///
    /// Functions can be called on a device you own, or for any device that is part of a product you are a team member of.
    /// - Important: Each function call request and response uses one Data Operation from your monthly or yearly quota. Setting up function calls does not use Data Operations.
    /// - Note  Up to 15 cloud functions may be registered and each function name is limited to a maximum of 12 characters (prior to 0.8.0), 64 characters (since 0.8.0).
    /// - Attention: Only use letters, numbers, underscores and dashes in function names. Spaces and special characters may be escaped by different tools and libraries causing unexpected results. A function callback procedure needs to return as quickly as possible otherwise the cloud call will timeout.
    /// - Parameter arguments: The arguments to provide to the cloud function. The function name is required.
    /// - Requires: Scope of devices.function:call
    /// - Returns: `CurrentValueSubject<PCDevice.FunctionResponse?, PCError>`
    public func callFunction(_ arguments: FunctionArguments)
    -> CurrentValueSubject<FunctionResponse?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<FunctionResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.callFunction(deviceID: self.id, arguments: arguments, token: token), type: FunctionResponse.self)
    }
    
    ///Call a cloud function.
    ///
    ///Use this type method to call an exposed function on a prticle device.
    ///[see docs](https://docs.particle.io/reference/device-os/api/cloud-functions/overview-of-api-field-limits/)
    ///
    ///
    /// Functions can be called on a device you own, or for any device that is part of a product you are a team member of.
    /// - Important: Each function call request and response uses one Data Operation from your monthly or yearly quota. Setting up function calls does not use Data Operations.
    /// - Note  Up to 15 cloud functions may be registered and each function name is limited to a maximum of 12 characters (prior to 0.8.0), 64 characters (since 0.8.0).
    /// - Attention: Only use letters, numbers, underscores and dashes in function names. Spaces and special characters may be escaped by different tools and libraries causing unexpected results. A function callback procedure needs to return as quickly as possible otherwise the cloud call will timeout.
    /// - parameter arguments: The arguments to provide to the cloud function. The function name is required.
    /// - Requires: Scope of devices.function:call
    /// - Returns: `CurrentValueSubject<PCDevice.FunctionResponse?, PCError>`
    public static func callFunction(deviceID: DeviceID, arguments: FunctionArguments, token: PCAccessToken)
    -> CurrentValueSubject<FunctionResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.callFunction(deviceID: deviceID, arguments: arguments, token: token), type: FunctionResponse.self)
    }
    
    //MARK: Async
    
    ///Call a cloud function.
    ///
    ///Use this instance method to call an exposed function on a prticle device.
    ///[see docs](https://docs.particle.io/reference/device-os/api/cloud-functions/overview-of-api-field-limits/)
    ///
    ///
    /// Functions can be called on a device you own, or for any device that is part of a product you are a team member of.
    /// - Important: Each function call request and response uses one Data Operation from your monthly or yearly quota. Setting up function calls does not use Data Operations.
    /// - Note  Up to 15 cloud functions may be registered and each function name is limited to a maximum of 12 characters (prior to 0.8.0), 64 characters (since 0.8.0).
    /// - Attention: Only use letters, numbers, underscores and dashes in function names. Spaces and special characters may be escaped by different tools and libraries causing unexpected results. A function callback procedure needs to return as quickly as possible otherwise the cloud call will timeout.
    /// - Throws: PCError indicating the failure reason.
    /// - parameter arguments: The arguments to provide to the cloud function. The function name is required.
    /// - Requires: Scope of devices.function:call
    /// - Returns: PCDevice.FunctionResponse
    public func callFunction(_ arguments: FunctionArguments) async throws -> FunctionResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.callFunction(deviceID: self.id, arguments: arguments, token: token), type: FunctionResponse.self)
    }
    
    ///Call a cloud function.
    ///
    ///Use this type method to call an exposed function on a prticle device.
    ///[see docs](https://docs.particle.io/reference/device-os/api/cloud-functions/overview-of-api-field-limits/)
    ///
    ///
    /// Functions can be called on a device you own, or for any device that is part of a product you are a team member of.
    /// - Important: Each function call request and response uses one Data Operation from your monthly or yearly quota. Setting up function calls does not use Data Operations.
    /// - Note  Up to 15 cloud functions may be registered and each function name is limited to a maximum of 12 characters (prior to 0.8.0), 64 characters (since 0.8.0).
    /// - Attention: Only use letters, numbers, underscores and dashes in function names. Spaces and special characters may be escaped by different tools and libraries causing unexpected results. A function callback procedure needs to return as quickly as possible otherwise the cloud call will timeout.
    /// - Throws: PCError indicating the failure reason.
    /// - parameter arguments: The arguments to provide to the cloud function. The function name is required.
    /// - Requires: Scope of devices.function:call
    /// - Returns: PCDevice.FunctionResponse
    public static func callFunction(deviceID: DeviceID, arguments: FunctionArguments, token: PCAccessToken) async throws -> FunctionResponse {
        try await PCNetwork.shared.cloudRequest(.callFunction(deviceID: deviceID, arguments: arguments, token: token), type: FunctionResponse.self)
    }
    
    //MARK: Completion Handlers
    
    ///Call a cloud function.
    ///
    ///Use this instance method to call an exposed function on a prticle device.
    ///[see docs](https://docs.particle.io/reference/device-os/api/cloud-functions/overview-of-api-field-limits/)
    /// Functions can be called on a device you own, or for any device that is part of a product you are a team member of.
    /// - Important: Each function call request and response uses one Data Operation from your monthly or yearly quota. Setting up function calls does not use Data Operations.
    /// - Note  Up to 15 cloud functions may be registered and each function name is limited to a maximum of 12 characters (prior to 0.8.0), 64 characters (since 0.8.0).
    /// - Attention: Only use letters, numbers, underscores and dashes in function names. Spaces and special characters may be escaped by different tools and libraries causing unexpected results. A function callback procedure needs to return as quickly as possible otherwise the cloud call will timeout.
    /// - parameter arguments: The arguments to provide to the cloud function. The function name is required.
    /// - parameter completion: Closure providing either a PCDevice.FunctionResponse if the call succeeded or a PCError indicating the failure.
    /// - Requires: Scope of devices.function:call
    public func callFunction(_ arguments: FunctionArguments, completion: @escaping (Result<FunctionResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.callFunction(deviceID: self.id, arguments: arguments, token: token), type: FunctionResponse.self, completion: completion)
    }
    
    ///Call a cloud function.
    ///
    ///Use this type method to call an exposed function on a prticle device.
    ///[see docs](https://docs.particle.io/reference/device-os/api/cloud-functions/overview-of-api-field-limits/)
    ///
    /// Functions can be called on a device you own, or for any device that is part of a product you are a team member of.
    /// - Important: Each function call request and response uses one Data Operation from your monthly or yearly quota. Setting up function calls does not use Data Operations.
    /// - Note  Up to 15 cloud functions may be registered and each function name is limited to a maximum of 12 characters (prior to 0.8.0), 64 characters (since 0.8.0).
    /// - Attention: Only use letters, numbers, underscores and dashes in function names. Spaces and special characters may be escaped by different tools and libraries causing unexpected results. A function callback procedure needs to return as quickly as possible otherwise the cloud call will timeout.
    /// - parameter arguments: The arguments to provide to the cloud function. The function name is required.
    /// - parameter completion: Closure providing either a PCDevice.FunctionResponse if the call succeeded or a PCError indicating the failure.
    /// - Requires: Scope of devices.function:call
    public static func callFunction(deviceID: DeviceID, arguments: FunctionArguments, token: PCAccessToken, completion: @escaping (Result<FunctionResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.callFunction(deviceID: deviceID, arguments: arguments, token: token), type: FunctionResponse.self, completion: completion)
    }
}

//MARK: - Listing devices
extension PCDevice {
    
    // MARK: Responses
    
    ///Server response for the list devices request.
    public struct ListResponse: Decodable, CustomStringConvertible {
        
        ///Human readable description of the response.
        public var description: String {
"""
ListResponse: {
    devices: \(String(describing: devices?.description)),
    customers: \(String(describing: customers?.description)),
    metaData: \(String(describing: metaData?.debugDescription))
}
"""
        }
        
        
        ///Human readable debug description of the response.
        public var debugDescription: String {
            "ListResponse:\ndevices:\(String(describing: devices?.debugDescription))\ncustomers:\(String(describing: customers?.debugDescription))\nmeta:\(metaData.debugDescription)\n"
        }
        
        ///Devices returned by the server.
        public let devices: [PCDevice]?
        
        ///Array of customer info returned by the server.
        public let customers: [CustomerInfo]?
        
        ///Meta data returned by the server.
        public let metaData: MetaData?
        
        private enum CodingKeys: String, CodingKey {
            case devices
            case customers
            case metaData = "meta"
        }
        
        //Hide init and force use of decoder.
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        // MARK: MetaData
        public struct MetaData: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
            
            ///Human readable description.
            public var description: String {
"""
MetaData: {
    totalPages: \(String(describing: totalPages)),
    totalRecords: \(String(describing: totalRecords))
}
"""
            }
            
            ///Human readable debug description.
            public var debugDescription: String {
                "MetaData:\ntotalPages: \(String(describing: totalPages))\ntotalRecords: \(String(describing: totalRecords))\n"
            }
            
            ///The total number of pages of records provided by the server.
            public let totalPages: Int?
            
            ///The total number of records returned by the server.
            public let totalRecords: Int?
            
            //Made private for security reasons. Shielding from public abuse.
            private init() {
                fatalError("Must use init with decoder.")
            }
        }
        
    }
    
    
    //MARK: Arguments
    ///Optional arguments for listing devices in a product.
    public struct ListArguments: CustomDebugStringConvertible, CustomStringConvertible {
        
        //The direction to sort the results of the request.
        public enum SortDirection: String {
            
            ///Ascending sort direction.
            case ascending = "asc"
            
            ///Descending sort direction.
            case descending = "desc"
        }
        
        ///The attribute to use for result sorting.
        public enum SortAttribute: String {
            
            ///Sort results by last connection to the cloud.
            case lastConnection
            
            ///Sort results by the firmware version.
            case firmwareVersion
            
            ///Sort the results by the device id.
            case deviceId
        }
        
        private var groupsDescription: String {
            if groups?.isEmpty ?? true {
                return " []"
            }
            return """
[
        \(groups!.map({$0.rawValue}).joined(separator: ",\n"))
    ],
"""
        }
        
        ///Human readable description of the arguments.
        public var description: String {
"""
ListArguments: {
    deviceID: \(deviceID?.rawValue ?? "nil"),
    groups: \(groupsDescription),
    deviceName: \(deviceName?.rawValue ?? "nil"),
    serialNumber: \(serialNumber?.rawValue ?? "nil"),
    sortAttribute: \(sortAttr?.rawValue ?? "nil"),
    sortDirection: \(sortDir?.rawValue ?? "nil"),
    quarantined: \(String(describing: quarantined)),
    page: \(String(describing: page)),
    perPage: \(String(describing: perPage))
}
"""
        }
        
        ///Human readable debug description.
        public var debugDescription: String {
            "deviceID:\(String(describing: deviceID))\ngroups:\(String(describing: groups))\ndeviceName:\(String(describing: deviceName))\nserialNumber:\(String(describing: serialNumber))\nsortAttr:\(String(describing: sortAttr))\nsortDir:\(String(describing: sortDir))\nquarantined:\(String(describing: quarantined))\npage:\(String(describing: page))\nperPage:\(String(describing: perPage))\n"
        }
        
        ///Filter results to devices with this ID (partial matching)
        public let deviceID: DeviceID?
        
        ///Comma separated list of full group names to filter results to devices belonging to these groups only
        /// - note: commas are added in the initializer. simply pass an array of groupNames
        public let groups: [GroupName]?
        
        ///Filter results to devices with this name (partial matching)
        public let deviceName: DeviceName?
        
        ///Filter results to devices with this serial number (partial matching)
        public let serialNumber: SerialNumber?
        
        ///The attribute by which to sort results.
        ///Options for sorting are deviceId, firmwareVersion, or lastConnection.
        ///By default, if no sortAttr parameter is set, devices will be sorted by last connection, in descending order
        public let sortAttr: SortAttribute?
        
        ///The direction of sorting.
        /// - note: Converted to asc for ascending sorting or desc for descending sorting inside initializer.
        public let sortDir: SortDirection?
        
        ///Include / exclude quarantined devices
        public let quarantined: Bool?
        
        ///Current page of results
        public let page: Int?
        
        ///Records per page
        public let perPage: Int?
        
        ///Inernal to be used with value(forCodingKey) and case iterable for request forming.
        internal enum CodingKeys: String, CodingKey, CaseIterable {
            case deviceID = "deviceId", groups, deviceName, serialNumber, sortAttr, sortDir, quarantined, page, perPage
        }
        
        ///Used internaly with request forming.
        internal func value(forCodingKey key: PCDevice.ListArguments.CodingKeys) -> String? {
            
            switch key {
                    
                case .deviceID:
                    return self.deviceID?.rawValue
                case .groups:
                    return self.groups?.map({$0.rawValue}).joined(separator: ",")
                case .deviceName:
                    return self.deviceName?.rawValue
                case .serialNumber:
                    return self.serialNumber?.rawValue
                case .sortAttr:
                    return self.sortAttr?.rawValue
                case .sortDir:
                    return self.sortDir?.rawValue
                case .quarantined:
                    return self.quarantined == nil ? nil : String(self.quarantined!)
                case .page:
                    return self.page == nil ? nil : String(self.page!)
                case .perPage:
                    return self.perPage == nil ? nil : String(self.perPage!)
            }
        }
        
        ///Initializes a new instance of List Argument.
        public init(deviceID: DeviceID? = nil, groups: [GroupName]? = nil, deviceName: DeviceName? = nil, serialNumber: SerialNumber? = nil, sortAttribute: SortAttribute? = nil, sortDirection: SortDirection? = nil, quarantined: Bool? = nil, page: Int? = nil, perPage: Int? = nil) {
            self.deviceID = deviceID
            self.groups = groups
            self.deviceName = deviceName
            self.serialNumber = serialNumber
            self.sortAttr = sortAttribute
            self.sortDir = sortDirection
            self.quarantined = quarantined
            self.page = page
            self.perPage = perPage
        }
    }
    
    
    //MARK: CurrentValueSubjects
    
    /// List Particle devices linked to the current access token.
    ///  - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    ///  - Parameter token: The current Particle Cloud Access Token.
    ///  - Returns: `CurrentValueSubject<[PCDevice]?, PCError>`
    static public func listDevices(arguments: PCDevice.ListArguments?,token: PCAccessToken)
    -> CurrentValueSubject<[PCDevice]?, PCError> {
        
        let subject = CurrentValueSubject<[PCDevice]?, PCError>(nil)
        
        PCNetwork.shared.cloudRequest(.listDevices(arguments: arguments, token: token), type: [PCDevice].self)
            .sink { completion in
                subject.send(completion: completion)
            } receiveValue: { devices in
                devices?.forEach({ device in
                    device.token = token
                })
                subject.send(devices)
            }.store(in: &PCNetwork.shared.cancellables)
        
        
        return subject
    }
    
    /// List Particle devices linked to the current access token.
    ///  - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    ///  - Parameter token: The current Particle Cloud Access Token.
    ///  - Returns: `CurrentValueSubject<[PCDevice]?, PCError>`
    static public func listProductDevices(productIdOrSlug: ProductID, arguments: PCDevice.ListArguments?,token: PCAccessToken)
    -> CurrentValueSubject<[PCDevice]?, PCError> {
        
        let subject = CurrentValueSubject<[PCDevice]?, PCError>(nil)
        
        PCNetwork.shared.cloudRequest(.listProductDevices(productIdOrSlug: productIdOrSlug, arguments: arguments, token: token), type: PCDevice.ListResponse.self)
            .sink { completion in
                subject.send(completion: completion)
            } receiveValue: { response in
                response?.devices?.forEach({ device in
                    device.token = token
                })
                subject.send(response?.devices)
            }.store(in: &PCNetwork.shared.cancellables)
        
        return subject
    }
    
    
    //MARK: - Async
    
    /// List Particle devices linked to the current access token.
    ///
    /// - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    /// - Parameter token: The current Particle Cloud Access Token.
    /// - Returns: An array of PCDevice.
    /// - Throws: PCError
    static public func listDevices(arguments: PCDevice.ListArguments?, token: PCAccessToken) async throws -> [PCDevice] {
        let devices = try await PCNetwork.shared.cloudRequest(.listDevices(arguments: arguments, token: token), type: [PCDevice].self)
        devices.forEach({
            $0.token = token
        })
        return devices
    }
    
    /// List Particle devices linked to the current access token.
    ///
    /// - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    /// - Parameter token: The current Particle Cloud Access Token.
    /// - Returns: An array of PCDevice.
    /// - Throws: PCError
    static public func listProductDevices(productIdOrSlug: ProductID, arguments: PCDevice.ListArguments?, token: PCAccessToken) async throws -> [PCDevice] {
        let devices = try await PCNetwork.shared.cloudRequest(.listProductDevices(productIdOrSlug: productIdOrSlug, arguments: arguments, token: token), type: PCDevice.ListResponse.self).devices ?? []
        devices.forEach { device in
            device.token = token
        }
        return devices
    }
    
    //MARK: Completion Handlers
    
    /// List Particle devices linked to the current access token.
    ///  - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    ///  - Parameter token: The current Particle Cloud Access Token.
    ///  - Parameter completion: Completion closure delivering either an [PCDevice] or a PCError.
    static public func listDevices(arguments: PCDevice.ListArguments?,token: PCAccessToken, completion: @escaping (Result<[PCDevice], PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.listDevices(arguments: arguments, token: token), type: [PCDevice].self) { result in
            
            switch result {
                case .success(let devices):
                    devices.forEach { device in
                        device.token = token
                    }
                    completion(.success(devices))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    /// List Particle devices linked to the current access token.
    ///  - Parameter arguments: Arguments used to filter the list of devices by. Passing nil to this parameter will list all devices accessible with the token provided.
    ///  - Parameter token: The current Particle Cloud Access Token.
    ///  - Parameter completion: Completion closure delivering either an [PCDevice] or a PCError.
    static public func listProductDevices(productIdOrSlug: ProductID, arguments: PCDevice.ListArguments?,token: PCAccessToken, completion: @escaping (Result<[PCDevice], PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.listProductDevices(productIdOrSlug: productIdOrSlug, arguments: arguments, token: token), type: PCDevice.ListResponse.self) { result in
            
            switch result {
                case .success(let response):
                    response.devices?.forEach { device in
                        device.token = token
                    }
                    completion(.success(response.devices ?? []))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

//MARK: - Getting a device
extension PCDevice {
    
    //MARK: CurrentValueSubjects
    
    ///Get a device.
    ///
    ///Encapsulates the device info and allows use of device through proxy.
    ///
    /// - Requires: Scope of devices:get
    /// - Returns: `CurrentValueSubject<PCDevice?, PCError>`
    public static func getDevice(deviceID: DeviceID, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice?, PCError> {
        let subject = CurrentValueSubject<PCDevice?, PCError>(nil)
        PCNetwork.shared.cloudRequest(.getDeviceInfo(deviceID: deviceID, token: token), type: PCDevice.self)
            .sink { completion in
                subject.send(completion: completion)
            } receiveValue: { device in
                device?.token = token
            }.store(in: &PCNetwork.shared.cancellables)
        return subject
    }
    
    ///Get a device.
    ///
    ///Encapsulates the device claimed by a product and allows use of device through proxy.
    ///
    /// - Requires: Scope of devices:get
    /// - Returns: `CurrentValueSubject<PCDevice?, PCError>`
    public static func getProductDevice(deviceID: DeviceID?, productIdorSlug: ProductID, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice?, PCError> {
        
        let subject = CurrentValueSubject<PCDevice?, PCError>(nil)
        (PCNetwork.shared.cloudRequest(
            .getProductDeviceInfo(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token),
            type: PCDevice.self
        ) as CurrentValueSubject<PCDevice?, PCError> ) //xcode was choosing wrong overload cast as a quick fix
        .sink { completion in
            switch completion {
                case .finished: subject.send(completion: .finished)
                case .failure(let error): subject.send(completion: .failure(error))
            }
        } receiveValue: { device in
            
            device?.token = token
            subject.send(device)
        }.store(in: &PCNetwork.shared.cancellables)
        
        return subject
    }
    
    //MARK: Async
    
    ///Get a device.
    ///
    ///Encapsulates the device info and allows use of device through proxy.
    ///
    /// - Throws: PCError indicating the failure.
    /// - Requires: Scope of devices:get
    /// - Returns: A PCDevice
    static public func getDevice(deviceID: DeviceID, token: PCAccessToken) async throws -> PCDevice {
        let device = try await PCNetwork.shared.cloudRequest(.getDeviceInfo(deviceID: deviceID, token: token), type: PCDevice.self)
        device.token = token
        return device
    }
    
    ///Get a device.
    ///
    ///Encapsulates the device claimed by a product info and allows use of device through proxy.
    ///
    /// - Throws: PCError indicating the failure.
    /// - Requires: Scope of devices:get
    /// - Returns: A PCDevice
    static public func getProductDevice(deviceID: DeviceID?, productIdOrSlug: ProductID, token: PCAccessToken) async throws -> PCDevice {
        let device = try await PCNetwork.shared.cloudRequest(.getProductDeviceInfo(deviceID: deviceID, productIdorSlug: productIdOrSlug, token: token), type: PCDevice.self)
        
        device.token = token
        return device
    }
    
    //MARK: Completion Handlers
    public static func getDevice(deviceID: DeviceID, token: PCAccessToken, completion: @escaping (Result<PCDevice, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.getDeviceInfo(deviceID: deviceID, token: token), type: PCDevice.self) { result in
            switch result {
                case .success(let device):
                    device.token = token
                    completion(.success(device))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public static func getProductDevice(deviceID: DeviceID?, productIdOrSlug: ProductID, token: PCAccessToken, completion: @escaping (Result<PCDevice, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.getProductDeviceInfo(deviceID: deviceID, productIdorSlug: productIdOrSlug, token: token), type: PCDevice.self){ result in
            switch result {
                case .success(let device):
                    device.token = token
                    completion(.success(device))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

//MARK: - Importing Devices
extension PCDevice {
    
    //MARK: Responses
    public struct ImportResponse: Codable {
        
        ///The number of devices successfully added to the product.
        public let updated: Int
        
        ///Device identifiers that have been added to the product.
        ///The identifiers correspond to what was passed in the file or id field of the request, so they could be device IDs, serial numbers, IMEIs or ICCIDs.
        public let updatedDeviceIDS: [String]
        
        ///Device identifiers that were already in the product
        public let existingDeviceIDS: [String]
        
        ///Device identifiers that belong to another owner and could not be imported.
        public let nonmemberDeviceIDS: [String]
        
        ///Device identifiers that were invalid and could not be imported.
        public let invalidDeviceIDS: [String]
        
        private enum CodingKeys: String, CodingKey {
            case updated
            case updatedDeviceIDS   = "updatedDeviceIds"
            case existingDeviceIDS  = "existingDeviceIds"
            case nonmemberDeviceIDS = "nonmemberDeviceIds"
            case invalidDeviceIDS   = "invalidDeviceIds"
        }
        
        //Made private for security reasons. Shielding from public abuse.
        private init(updated: Int, updatedDeviceIDS: [String], existingDeviceIDS: [String], nonmemberDeviceIDS: [String], invalidDeviceIDS: [String]) {
            self.updated = updated; self.updatedDeviceIDS = updatedDeviceIDS; self.existingDeviceIDS = existingDeviceIDS; self.nonmemberDeviceIDS = nonmemberDeviceIDS; self.invalidDeviceIDS = invalidDeviceIDS
        }
    }
    
    //MARK: Arguments
    
    ///Arguments used for importing a device.
    public struct ImportArguments: CustomStringConvertible, CustomDebugStringConvertible {
                
        //Human readable description of the Import Argument.
        public var description: String {
            return """
    importSims: \(String(describing: importSims)),
    claimUser: \(String(describing: claimUser)),
    filePath: \(String(describing: filePath))
"""
        }
        
        public var debugDescription: String {
"""
ImportArguments: {
    importSims: \(String(describing: importSims)),
    claimUser: \(String(describing: claimUser)),
    filePath: \(String(describing: filePath))
}
"""
        }
                
        /// Import SIM card associated with each device into the product
        public let importSims: Bool?
        
        ///The username (email) of a Particle user to claim the imported devices. This user must be a member of the product team.
        public let claimUser: String?
        
        ///A .txt file containing a single-column list of device identifiers: device IDs, serial numbers, IMEIs or ICCIDs.
        ///This is an alternative to ids for importing many devices into a product at once.
        ///Must be encoded in multipart/form-data format
        public let filePath: String?
        
        
        internal enum CodingKeys: String, CodingKey, CaseIterable {
            case filePath = "file"
            case importSims = "import_sims"
            case claimUser = "claim_user"
        }
        
        internal func value(forCodingKey key: PCDevice.ImportArguments.CodingKeys) -> String? {
            
            switch key {
                case .claimUser:
                    return self.claimUser == nil ? nil : String(self.claimUser!)
                case .filePath:
                    if let path = self.filePath,
                       path.suffix(4) == ".txt",
                       FileManager.default.fileExists(atPath: path),
                       let file = FileManager.default.contents(atPath: path) {
                        return String(data: file, encoding: .utf8)
                    }
                    return nil
                case .importSims:
                    return self.importSims == nil ? nil : String(self.importSims!)
            }
        }
        
        public init(importSims: Bool?, claimUser: String?, filePath: String?)  {
            self.importSims = importSims; self.claimUser = claimUser; self.filePath = filePath
        }
    }
    
    
    //MARK: CurrentValueSubjects
    
    
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
    /// - Parameter token: The current Particle Cloud Access Token.
    /// - Returns: `CurrentValueSubject<PCDevice.ImportResponse?, PCError>`
    static public func importDevices(_ devices: [DeviceID], into productID: ProductID, arguments: PCDevice.ImportArguments?, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.ImportResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.importDevices(devices, into: productID, arguments: arguments, token: token), type: PCDevice.ImportResponse.self)
    }
    
    //MARK: Async
    
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
    /// - Parameter token: The current Particle Cloud Access Token.
    /// - Returns: An `PCDevice.ImportResponse`
    static public func importDevices(_ devices: [DeviceID],  into productID: ProductID, arguments: PCDevice.ImportArguments?, token: PCAccessToken) async throws-> PCDevice.ImportResponse {
        try await PCNetwork.shared.cloudRequest(.importDevices(devices, into: productID, arguments: arguments, token: token), type: PCDevice.ImportResponse.self)
    }
    
    //MARK: Completion Handlers
    
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
    /// - Parameter token: The current Particle Cloud Access Token.
    /// - Parameter completion: Closure containing a result of PCDevice.ImportResponse of an PCError indicating the failure.
    static public func importDevices(_ devices: [DeviceID], into productID: ProductID, arguments: PCDevice.ImportArguments?, token: PCAccessToken, completion: @escaping (Result< PCDevice.ImportResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.importDevices(devices, into: productID, arguments: arguments, token: token), type: PCDevice.ImportResponse.self, completion: completion)
    }
}

//MARK: - Variables
extension PCDevice {
    
    //MARK: CurrentValueSubjects
    public func getVariable(name: VariableName, productIdOrSlug: ProductID? = nil)
    -> CurrentValueSubject<PCVariable?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<PCVariable?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.getVariableValue(name: name, deviceID: self.id, productIdOrSlug: productIdOrSlug, token: token), type: PCVariable.self )
    }
    
    
    //MARK: Async
    public func getVariable(name: VariableName, productIdOrSlug: ProductID? = nil) async throws -> PCVariable {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.getVariableValue(name: name, deviceID: self.id, productIdOrSlug: productIdOrSlug, token: token), type: PCVariable.self )
    }

    
    //MARK: Completion Handlers
    public func getVariable(name: VariableName, productIdOrSlug: ProductID? = nil, completion: @escaping (Result<PCVariable, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.getVariableValue(name: name, deviceID: self.id, productIdOrSlug: productIdOrSlug, token: token), type: PCVariable.self, completion: completion)
    }
}


//MARK: - Ping
extension PCDevice {
    
    //MARK: Responses
    
    ///Response sent by the server to a device ping request.
    public struct PingResponse: Decodable {
        
        ///Simple bool to describe the success of the ping.
        public let ok: Bool
        
        ///Bool idicating if the device is online or not.
        public let online: Bool
        
        //Made private for security reasons. Shielding from public abuse.
        private init(online: Bool, ok: Bool) {
            self.online = online; self.ok = ok
        }
    }
    
    
    //MARK: CurrentValueSubjects
    public func ping() -> CurrentValueSubject<PCDevice.PingResponse?, PCError>  {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<PCDevice.PingResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        if productID.rawValue.count == 5 {
            return PCNetwork.shared.cloudRequest(.pingDevice(deviceID: self.id, productIdorSlug: self.productID, token: token), type: PCDevice.PingResponse.self)
        } else {
            return PCNetwork.shared.cloudRequest(.pingDevice(deviceID: self.id, productIdorSlug: nil, token: token), type: PCDevice.PingResponse.self)
        }
    }
    
    public static func pingDevice(deviceID: DeviceID, productIdorSlug: ProductID? = nil, token: PCAccessToken) -> CurrentValueSubject<PCDevice.PingResponse?, PCError>  {
        PCNetwork.shared.cloudRequest(.pingDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: PCDevice.PingResponse.self)
    }
    
    //MARK: Async
    public func ping() async throws -> PCDevice.PingResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.pingDevice(deviceID: self.id, productIdorSlug: productID, token: token), type: PCDevice.PingResponse.self)
    }
    
    public static func pingDevice(deviceID: DeviceID, productIdorSlug: ProductID? = nil, token: PCAccessToken) async throws
    -> PCDevice.PingResponse  {
        try await PCNetwork.shared.cloudRequest(.pingDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: PCDevice.PingResponse.self)
    }
    
    //MARK: Completion Handlers
    public func ping(completion: @escaping (Result<PCDevice.PingResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        return PCNetwork.shared.cloudRequest(.pingDevice(deviceID: self.id, productIdorSlug: self.productID, token: token), type: PCDevice.PingResponse.self, completion: completion)
    }
    
    public static func pingDevice(deviceID: DeviceID, productIdorSlug: ProductID? = nil, token: PCAccessToken, completion: @escaping (Result<PCDevice.PingResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.pingDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: PCDevice.PingResponse.self, completion: completion)
    }
}


//MARK: - Renaming
extension PCDevice {
    
    //MARK: Responses
    public struct NameUpdateResponse: Codable {
        public let id, name: String
        ///Timestamp representing the last time the deivce was updated in ISO8601 format
        public  let updatedAt: String
        
        private enum CodingKeys: String, CodingKey {
            case id, name
            case updatedAt = "updated_at"
        }
        
        //Made private for security reasons. Shielding from public abuse.
        private init(id: String, name: String, updatedAt: String) {
            self.id = id; self.name = name; self.updatedAt = updatedAt
        }
    }
    
    //MARK: CurrentValueSubjects
    public func rename(newName: String) -> CurrentValueSubject<PCDevice.NameUpdateResponse?, PCError> {
        
        let sub = CurrentValueSubject<PCDevice.NameUpdateResponse?, PCError>(nil)
        
        guard let token = self.token
        else {
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        PCNetwork.shared.cloudRequest(.renameDevice(deviceID: self.id, productIdorSlug: self.productID, newName: newName, token: token), type: PCDevice.NameUpdateResponse.self)
            .sink { completion in
                sub.send(completion: completion)
            } receiveValue: { response in
                if let name = response?.name {
                    self.name = DeviceName(name)
                }
                sub.send(response)
            }.store(in: &cancellables)
        
        return sub
    }
    
    public static func renameDevice(deviceID: DeviceID, productIdorSlug: ProductID? = nil, newName: String, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.NameUpdateResponse?, PCError>  {
        PCNetwork.shared.cloudRequest(.renameDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, newName: newName, token: token), type: PCDevice.NameUpdateResponse.self)
    }
    
    //MARK: Async
    public func rename(_ productIdorSlug: ProductID? = nil, newName: String) async throws
    -> PCDevice.NameUpdateResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        let response =  try await PCNetwork.shared.cloudRequest(.renameDevice(deviceID: self.id, productIdorSlug: self.productID, newName: newName, token: token), type: PCDevice.NameUpdateResponse.self)
        
        self.name = DeviceName(response.name)
        
        return response
    }
    
    public static func renameDevice(deviceID: DeviceID, productIdorSlug: ProductID? = nil, newName: String, token: PCAccessToken) async throws -> PCDevice.NameUpdateResponse {
        try await PCNetwork.shared.cloudRequest(.renameDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, newName: newName, token: token), type: PCDevice.NameUpdateResponse.self)
    }
    
    //MARK: Completion Handlers
    public func rename(newName: String, completion: @escaping (Result<PCDevice.NameUpdateResponse, PCError>) -> Void)  {
        
        guard let token = self.token
        else {
            completion(.failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.renameDevice(deviceID: self.id, productIdorSlug: self.productID, newName: newName, token: token), type: PCDevice.NameUpdateResponse.self) { response in
            
            if let result = try? response.get() {
                self.name = DeviceName(result.name)
            }
            
            completion(response)
        }
    }
    
    public static func renameDevice(deviceID: DeviceID, productIdorSlug: ProductID? = nil, newName: String, token: PCAccessToken, completion: @escaping (Result<PCDevice.NameUpdateResponse, PCError>) -> Void)  {
        PCNetwork.shared.cloudRequest(.renameDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, newName: newName, token: token), type: PCDevice.NameUpdateResponse.self, completion: completion)
    }
}

//MARK: - Notes
extension PCDevice {
    
    //Mark: Responses
    ///Struct representing the response of the server when a note is added.
    public struct AddNoteResponse: Decodable {
        
        /// Id of the device that the note was added to.
        public let id: String
        
        ///The notes now assigned to the device.
        public let notes: String
        
        ///The iso 8601* date / time when the note was added on the server.
        public let updatedAt: String
        
        private enum CodingKeys: String, CodingKey {
            case id, notes
            case updatedAt = "updated_at"
        }
        
        //Made private for security reasons. Shielding from public abuse.
        private init(id: String, notes: String, updatedAt: String) {
            self.id = id; self.notes = notes; self.updatedAt = updatedAt
        }
    }
    
    //MARK: CurrentValueSubjects
    public func addNote(_ note: String)
    -> CurrentValueSubject<PCDevice.AddNoteResponse?, PCError>  {
        
        let sub = CurrentValueSubject<PCDevice.AddNoteResponse?, PCError>(nil)

        guard let token = self.token
        else {
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
          PCNetwork.shared.cloudRequest(.addDeviceNotes(deviceID: self.id, productIdorSlug: self.productID, note: note, token: token), type: PCDevice.AddNoteResponse.self)
            .sink { completion in
                sub.send(completion: completion)
            } receiveValue: { response in
                sub.send(response)
                self.notes = response?.notes
            }.store(in: &cancellables)
        
        return sub
    }
    
    public static func addDeviceNote(deviceID: DeviceID, productIdorSlug: ProductID? = nil, note: String, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.AddNoteResponse?, PCError>  {
        PCNetwork.shared.cloudRequest(.addDeviceNotes(deviceID: deviceID, productIdorSlug: productIdorSlug, note: note, token: token), type: PCDevice.AddNoteResponse.self)
    }
    
    //MARK: Async
    public func addNote(_ note: String) async throws-> PCDevice.AddNoteResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        let response = try await PCNetwork.shared.cloudRequest(.addDeviceNotes(deviceID: self.id, productIdorSlug: self.productID, note: note, token: token), type: PCDevice.AddNoteResponse.self)
        
        self.notes = response.notes
        
        return response
    }
    
    public static func addDeviceNote(deviceID: DeviceID, productIdorSlug: ProductID? = nil, note: String, token: PCAccessToken) async throws -> PCDevice.AddNoteResponse {
        try await PCNetwork.shared.cloudRequest(.addDeviceNotes(deviceID: deviceID, productIdorSlug: productIdorSlug, note: note, token: token), type: PCDevice.AddNoteResponse.self)
    }
    
    //MARK: Completion Handlers
    public func addNote(_ note: String, completion: @escaping (Result<PCDevice.AddNoteResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion(.failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.addDeviceNotes(deviceID: self.id, productIdorSlug: self.productID, note: note, token: token), type: PCDevice.AddNoteResponse.self) { result in
           
            if let response = try? result.get() {
                self.notes = response.notes
            }
            
            completion(result)
        }
    }
    
    public static func addDeviceNote(deviceID: DeviceID, productIdorSlug: ProductID? = nil, note: String, token: PCAccessToken, completion: @escaping (Result<PCDevice.AddNoteResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.addDeviceNotes(deviceID: deviceID, productIdorSlug: productIdorSlug, note: note, token: token), type: PCDevice.AddNoteResponse.self, completion: completion)
    }
}

//MARK: - Device Claiming and Transfer
extension PCDevice {
    
    // MARK: Responses
    public struct ClaimCodeResponse: Decodable {
        
        ///a claim code for use during the device setup process
        public let claimCode: String
        
        ///Array of device IDs that already belong to the user
        public let deviceIds: [String]
        
        private enum CodingKeys: String, CodingKey {
            case claimCode = "claim_code"
            case deviceIds = "device_ids"
        }
    }
    
    public struct ClaimResponse: Decodable {
        
        ///Unique ID that represents the transfer
        let transferId: String
        
        enum CodingKeys: String, CodingKey {
            case transferId = "transfer_id"
        }
        
    }
    
    public struct ClaimResponse2: Decodable {
        
        
        public let ok: String
        
        public let id: String
        
        public let connected: String
        
        public let customerID: String
        
        public let productID: String
        
        public let updatedAt: String
        
        private enum CodingKeys: String, CodingKey {
            
            case connected, id, ok
            
            case customerID = "customer_id"
            case productID = "product_id"
            case updatedAt = "updated_at"
        }
        
        //Made private for security reasons. Shielding from public abuse.
        private init(connected: String, customerID: String, id: String, ok: String, productID: String, updatedAt: String) {
            self.connected = connected; self.customerID = customerID; self.id = id; self.ok = ok; self.productID = productID; self.updatedAt = updatedAt
        }
    }
    
    public struct TransferRequestResponse: Decodable {
        ///Unique ID that represents the transfer
        let transfer_id: String
        
        //Made private for security reasons. Shielding from public abuse.
        private init(transfer_id: String) { self.transfer_id = transfer_id }
    }
    
    
    public struct UnclaimDeviceResponse: Decodable {
        let ok: Bool
        
        //Made private for security reasons. Shielding from public abuse.
        private init(ok: Bool) { self.ok = ok }
    }
    
    //MARK: Arguments
    public struct ClaimRequestArguments {
        
        ///IMEI number of the Electron you are generating a claim for.
        ///This will be used as the claim code if iccid is not specified.
        public let imei: String?
        ///ICCID number (SIM card ID number) of the SIM you are generating a claim for.
        /// This will be used as the claim code.
        public let iccid: String?
        ///Activation Code.
        ///Only required if product is in private beta.
        ///Product endpoint only.
        public let activation_code: String?
        ///Product ID or Slug. Product endpoint only.
        public let productIdOrSlug: ProductID?
        
        //Made private for security reasons. Shielding from public abuse.
        public init(productIdOrSlug: ProductID? = nil, imei: String? = nil, iccid: String? = nil, activation_code: String? = nil) {
            self.imei = imei; self.iccid = iccid; self.activation_code = activation_code; self.productIdOrSlug = productIdOrSlug
        }
    }
    
    //MARK: CurrentValueSubjects
    
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
    /// - Parameter arguments: An encapsulation of the arguments for the request.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: Current value subject containing the optional ClaimCodeResponse or an PCError indicating the failure.
    public static func createClaimCode(arguments: PCDevice.ClaimRequestArguments? = nil, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.ClaimCodeResponse?, PCError>  {
        
        PCNetwork.shared.cloudRequest(.createClaimCode(arguments: arguments, token: token), type: PCDevice.ClaimCodeResponse.self)
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: Current value subject containing the optional PCDevice.ClaimResponse or an PCError indicating the failure.
    static public func claimDevice(_ deviceID: DeviceID, isTransfer: Bool = false, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.ClaimResponse?, PCError> {
                
        PCNetwork.shared.cloudRequest(.claimDevice(deviceID: deviceID, isTransfer: isTransfer, token: token), type: PCDevice.ClaimResponse.self)

    }
    
    
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: CurrrentValueSubject containing a bool representing the succes of the call. Or a PCError indicating the failure.
    static public func unclaimDevice(_ deviceID: DeviceID, productIdorSlug: ProductID?, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.UnclaimDeviceResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.unclaimDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: PCDevice.UnclaimDeviceResponse.self)
    }

    //MARK: Async
    
    
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: An PCDevice.ClaimCodeResponse.
    static public func createClaimCode(arguments: PCDevice.ClaimRequestArguments? = nil, token: PCAccessToken) async throws -> PCDevice.ClaimCodeResponse {
        try await PCNetwork.shared.cloudRequest(.createClaimCode(arguments: arguments, token: token), type: PCDevice.ClaimCodeResponse.self)
    }
    
    
    
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: An PCDevice.TransferID
    static public func claimDevice(_ deviceID: DeviceID, isTransfer: Bool = false, token: PCAccessToken) async throws -> TransferID {
        try await PCNetwork.shared.cloudRequest(.claimDevice(deviceID: deviceID, isTransfer: isTransfer, token: token), type: PCDevice.ClaimResponse.self).transferId
    }
    
    
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - throws: PCError indicating the failure.
    /// - Returns: A bool representing the succes of the call.
    static public func unclaimDevice(_ deviceID: DeviceID, productIdorSlug: ProductID?, token: PCAccessToken) async throws-> PCDevice.UnclaimDeviceResponse {
        try await PCNetwork.shared.cloudRequest(.unclaimDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: PCDevice.UnclaimDeviceResponse.self)
    }
    
    //MARK: Completion Handlers
    
    
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Parameter completion: Closure with a result containing the ClaimCodeResponse or an PCError indicating the failure.
    static public func createClaimCode(arguments: PCDevice.ClaimRequestArguments? = nil, token: PCAccessToken, completion: @escaping (Result<PCDevice.ClaimCodeResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.createClaimCode(arguments: arguments, token: token), type: PCDevice.ClaimCodeResponse.self, completion: completion)
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Parameter completion: Closure with a result containing the  PCDevice.ClaimResponse or an PCError indicating the failure.
    static public func claimDevice(_ deviceID: DeviceID, isTransfer: Bool = false, token: PCAccessToken, completion: @escaping (Result<TransferID, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.claimDevice(deviceID: deviceID, isTransfer: isTransfer, token: token), type: PCDevice.ClaimResponse.self) { result in
            switch result {
                case .success(let response): completion(.success(response.transferId))
                case .failure(let error): completion(.failure(error))
            }
        }
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
    static public func unclaimDevice(_ deviceID: DeviceID, productIdorSlug: ProductID?, token: PCAccessToken, completion: @escaping (Result<PCDevice.UnclaimDeviceResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.unclaimDevice(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: PCDevice.UnclaimDeviceResponse.self, completion: completion)
    }
}

//MARK: - Product Interactions
extension PCDevice {
    
    //MARK: CurrentValueSubjects
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
    /// - Returns: CurrentValueSubject<ServerResponses.NoResponse?, PCError>
    public func removeFromProduct() -> CurrentValueSubject<ServerResponses.NoResponse?, PCError> {
        
        let sub = CurrentValueSubject<ServerResponses.NoResponse?, PCError>(nil)
        guard let token = self.token
        else {
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        
        return PCNetwork.shared.cloudRequest(.removeDeviceFromProduct(deviceID: self.id, productIdorSlug: self.productID, token: token), type: ServerResponses.NoResponse.self)
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: CurrentValueSubject<ServerResponses.NoResponse?, PCError>
    static public func removeDeviceFromProduct(deviceID: DeviceID, productIdorSlug: ProductID, token: PCAccessToken)
    -> CurrentValueSubject<ServerResponses.NoResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.removeDeviceFromProduct(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: ServerResponses.NoResponse.self)
    }
    
    //MARK: Async
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
    public func removeFromProduct() async throws-> Bool {
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
            return try await PCNetwork.shared.cloudRequest(.removeDeviceFromProduct(deviceID: self.id, productIdorSlug: productID, token: token), type: ServerResponses.NoResponse.self).ok
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - throws: PCError indicating the failure reason.
    /// - Returns: Bool indicating the success of the API call.
    static public func removeDeviceFromProduct(deviceID: DeviceID, productIdorSlug: ProductID, token: PCAccessToken) async throws -> Bool {
        try await PCNetwork.shared.cloudRequest(.removeDeviceFromProduct(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: ServerResponses.NoResponse.self).ok
    }
    
    //MARK: Completion Handlers
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    public func removeFromProduct(completion: @escaping (Result<Bool, PCError>) -> Void) {
        guard let token = self.token
        else {
            completion(.failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
            PCNetwork.shared.cloudRequest(.removeDeviceFromProduct(deviceID: self.id, productIdorSlug: productID, token: token), type: ServerResponses.NoResponse.self) { response in
                switch response {
                    case .success(let result):
                        completion(.success(result.ok))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    static public func removeDeviceFromProduct(deviceID: DeviceID, productIdorSlug: ProductID, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.removeDeviceFromProduct(deviceID: deviceID, productIdorSlug: productIdorSlug, token: token), type: ServerResponses.NoResponse.self) { response in
            
            switch response {
                case .success(let result):
                    completion(.success(result.ok))
                case .failure(let error):
                    completion(.failure(error))
            }
            
        }
    }
}


//MARK: - Signalling

//MARK: Enums

///Enum representing the rainbow L.E.D.  on the particle device. This indicates if the device is being signaled.
public enum RainbowState: Int {
    
    case on = 1, off = 0
    
    public var description: String {
        return self == .on ? "On" : "Off"
    }
    
    public init(_ rawValue: Bool) {
        self.init(rawValue: rawValue ? 1 : 0)!
    }
    
    @discardableResult public mutating func toggle() -> RainbowState {
        if self == .on {
            self = .off
        } else {
            self = .on
        }
        return self
    }
}
extension PCDevice {
    
    //MARK: Responses
    
    ///Signal response sent by the server.
    public struct SignalResponse: Decodable {
        
        ///The id of the device being signaled.
        public let deviceId: DeviceID
        
        ///Bool indicating if the device is currently connected to the internet.
        public let isConnected: Bool
        
        ///The current state of the signal L.E.D. on the device.
        public let signalState: RainbowState
        
        ///Bool indicating if the device is currently in a signal state.
        public var isSignaling: Bool {
            return signalState == .on
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        private enum CodingKeys: String, CodingKey {
            case deviceId = "id"
            case isConnected = "connected"
            case isSignaling = "signaling"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.deviceId = DeviceID(try container.decode(String.self, forKey: .deviceId))
            self.isConnected = try container.decode(Bool.self, forKey: .isConnected)
            let isSignaling = try container.decode(Bool.self, forKey: .isSignaling)
            self.signalState = RainbowState(isSignaling)
        }
    }
    
    //MARK: CurrentValueSubjects
    
    ///Signal a device.
    ///
    ///Make the device conspicuous by causing its LED to flash in rainbow patterns.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///             let subject = device.signal(.on)
    ///                         .replaceError(with: nil)
    ///                         .sink { response in
    ///                              let deviceID = response.deviceID
    ///                              let connected = response?.isConnected
    ///                              let state = response?.signalState
    ///                              print("device with id \(deviceID) is \(connected ? "online" : "offline") and \(state ? "is signaling" : "is not signaling")")
    ///                          }
    ///
    ///````
    ///
    /// - Parameter rainbowState: An enum determining whether to turn the signal on or off.
    /// - Returns: `DeviceID.SignalResponse`
    public func signal(_ rainbowState: RainbowState)
    -> CurrentValueSubject<PCDevice.SignalResponse?, PCError> {
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<PCDevice.SignalResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.signalDevice(deviceID: self.id, rainbowState: rainbowState, token: token), type: PCDevice.SignalResponse.self)
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
    ///             let subject = PCDevice.signalDevice(DeviceID("validID", rainbowState: .off, token: token)
    ///                         .replaceError(with: nil)
    ///                         .sink { response in
    ///                              let deviceID = response.deviceID
    ///                              let connected = response?.isConnected
    ///                              let state = response?.signalState
    ///                              print("device with id \(deviceID) is \(connected ? "online" : "offline") and \(state ? "is signaling" : "is not signaling")")
    ///                          }
    ///
    ///````
    ///
    /// - Parameter deviceID: The device identifier of the device to be affected.
    /// - Parameter rainbowState: An enum determining whether to turn the signal on or off.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: `DeviceID.SignalResponse`
    static public func signalDevice(_ deviceID: DeviceID, rainbowState: RainbowState, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.SignalResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.signalDevice(deviceID: deviceID, rainbowState: rainbowState, token: token), type: PCDevice.SignalResponse.self)
    }
    
    //MARK: Async
    ///Signal a device.
    ///
    ///Make the device conspicuous by causing its LED to flash in rainbow patterns.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///            let response = try await device.signal(.on)
    ///            let deviceId = response.deviceID
    ///            let connected = response.connected
    ///            let state = response.signalState
    ///            
    ///            print("device with id \(deviceID) is \(connected ? "online" : "offline") and \(state ? "is signaling" : "is not signaling")")
    ///
    ///
    ///````
    ///
    /// - Parameter rainbowState: An enum determining whether to turn the signal on or off.
    /// - throws: PCError indicating the reason for failure.
    /// - Returns: `DeviceID.SignalResponse`
    public func signal(rainbowState: RainbowState) async throws -> PCDevice.SignalResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.signalDevice(deviceID: self.id, rainbowState: rainbowState, token: token), type: PCDevice.SignalResponse.self)
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
    ///            let response = try await PCDevice.signalDevice(deviceID, rainbowState: .on, token: token)
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
    static public func signalDevice(_ deviceID: DeviceID, rainbowState: RainbowState, token: PCAccessToken) async throws -> PCDevice.SignalResponse {
        try await PCNetwork.shared.cloudRequest(.signalDevice(deviceID: deviceID, rainbowState: rainbowState, token: token), type: PCDevice.SignalResponse.self)
    }
    
    //MARK: Completion Handlers
    
    ///Signal a device.
    ///
    ///Make the device conspicuous by causing its LED to flash in rainbow patterns.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///            let response = device.signal(.on) { result in
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
    /// - Parameter rainbowState: An enum determining whether to turn the signal on or off.
    /// - Parameter completion: Closure with a Result containing the signal reponse or an PCError indicating the failure.
    /// - Returns: `DeviceID.SignalResponse`
    public func signal(rainbowState: RainbowState, completion: @escaping (Result<PCDevice.SignalResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.signalDevice(deviceID: self.id, rainbowState: rainbowState, token: token), type: PCDevice.SignalResponse.self, completion: completion)
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
    ///            let response = PCDevice.signalDevice(deviceID, rainbowState: .on, token: token) { result in
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
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Parameter completion: Closure with a Result containing the signal reponse or an PCError indicating the failure.
    /// - Returns: `DeviceID.SignalResponse`
    static public func signalDevice(_ deviceID: DeviceID, rainbowState: RainbowState, token: PCAccessToken, completion: @escaping (Result<PCDevice.SignalResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.signalDevice(deviceID: deviceID, rainbowState: rainbowState, token: token), type: PCDevice.SignalResponse.self, completion: completion)
    }
}

//MARK: - OTA Updates
extension PCDevice {
    
    //MARK: Responses
    public struct SerialNumberLookupResponse: Decodable {
        public let ok: Bool
        public let deviceID, iccid: String
        
        //Made private for security reasons. Shielding from public abuse.
        private init(ok: Bool, deviceID: String, iccid: String) {
            self.ok = ok; self.deviceID = deviceID; self.iccid = iccid
        }
    }
    
    
    public struct ForceOTAUpdateResponse: Codable {
        public let id: String
        public let firmwareUpdatesForced: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case firmwareUpdatesForced = "firmware_updates_forced"
        }
        
        //Made private for security reasons. Shielding from public abuse.
        private init(id: String, firmwareUpdatesForced: Bool) {
            self.id = id; self.firmwareUpdatesForced = firmwareUpdatesForced
        }
    }
    
    
    //MARK: CurrentValueSubjects
    
    ///Force enable OTA updates
    ///
    ///[Force enable](https://docs.particle.io/getting-started/cloud/ota-updates/) OTA updates on this device.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///     let subject = device.forceOverTheAirUpdates(true)
    ///            .replaceError(with: nil)
    ///            .sink { response in
    ///                print(response?.id, response?.firmwareUpdatesForced)
    ///            }.store(in: &cancellables)
    ///
    ///````
    ///
    /// - Requires: Scope of devices:update
    /// - Parameter forceEnabled: Boolean to indicate whether ota updates will be fored or not.
    /// - Returns: `CurrentValueSubject` carrying the `PCDevice.ForceOTAUpdateResponse` or an PCError indicating the failure.
    public func forceOverTheAirUpdates(_ enabled: Bool)
    -> CurrentValueSubject<PCDevice.ForceOTAUpdateResponse?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<PCDevice.ForceOTAUpdateResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: self.id, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self)
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
    ///     let subject = PCDevice.forceEnable_OTA_Updates(on: deviceID, enabled: true, token: token)
    ///            .replaceError(with: nil)
    ///            .sink { response in
    ///                print(response?.id, response?.firmwareUpdatesForced)
    ///            }.store(in: &cancellables)
    ///
    ///````
    ///
    /// - Requires: Scope of devices:update
    /// - Parameter deviceID: The device identifier of the device to be affected.
    /// - Parameter enabled: Boolean to indicate whether ota updates will be fored or not.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: `CurrentValueSubject` carrying the `PCDevice.ForceOTAUpdateResponse` or an PCError indicating the failure.
    static public func forceEnable_OTA_Updates(on deviceID: DeviceID, enabled: Bool, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.ForceOTAUpdateResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: deviceID, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self)
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
    ///              PCDevice.lookUpDeviceInformation(from: serialNumber, token: token)
    ///                     .replaceError(wiht: nil)
    ///                     .sink(recieveValue: { response in
    ///                        print(response.deviceID, response.iccid)
    ///                     }.store(in: &cancellables)
    ///
    ///````
    /// - Parameter serialNumber: The serial number printed on the barcode of the device packaging.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: CurrentValueSubject with the SerialNumberLookupResponse indicating the servers response. Or an PCError indicating the failure.
    static public func lookUpDeviceInformation(with serialNumber: String, token: PCAccessToken)
    -> CurrentValueSubject<PCDevice.SerialNumberLookupResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.lookUpDeviceInformation(serialNumber: serialNumber, token: token), type: PCDevice.SerialNumberLookupResponse.self)
    }
    
    //MARK: Async
    
    ///Force enable OTA updates
    ///
    ///[Force enable](https://docs.particle.io/getting-started/cloud/ota-updates/) OTA updates on this device.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///             let response = try await device.forceEnable_OTA_Updates(true)
    ///             print(response?.id, response?.firmwareUpdatesForced)
    ///
    ///````
    ///
    /// - throws: PCError indicating the failure.
    /// - Requires: Scope of devices:update
    /// - Parameter enabled: Boolean to indicate whether ota updates will be fored or not.
    /// - Returns: `PCDevice.ForceOTAUpdateResponse` indicating the servers response.
    public func forceEnable_OTA_Updates(_ enabled: Bool) async throws -> PCDevice.ForceOTAUpdateResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: self.id, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self)
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
    ///             let response = try await PCDevice.forceEnable_OTA_Updates(on: deviceID, enabled: true, token: token)
    ///             print(response?.id, response?.firmwareUpdatesForced)
    ///
    ///````
    ///
    /// - throws: PCError indicating the failure.
    /// - Requires: Scope of devices:update
    /// - Parameter deviceID: The device identifier of the device to be affected.
    /// - Parameter enabled: Boolean to indicate whether ota updates will be fored or not.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Returns: `PCDevice.ForceOTAUpdateResponse` indicating the servers response.
    static public func forceEnable_OTA_Updates(on deviceID: DeviceID, enabled: Bool, token: PCAccessToken) async throws -> PCDevice.ForceOTAUpdateResponse {
        try await PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: deviceID, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self)
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
    ///              do {
    ///                 let response = try PCDevice.lookUpDeviceInformation(from: serialNumber, token: token)
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
    static public func lookUpDeviceInformation(from serialNumber: String, token: PCAccessToken) async throws-> PCDevice.SerialNumberLookupResponse {
        try await PCNetwork.shared.cloudRequest(.lookUpDeviceInformation(serialNumber: serialNumber, token: token), type: PCDevice.SerialNumberLookupResponse.self)
    }
    
    //MARK: Completion Handlers
    
    ///Force enable OTA updates
    ///
    ///[Force enable](https://docs.particle.io/getting-started/cloud/ota-updates/) OTA updates on this device.
    ///
    /// - calls: PUT /v1/devices/:deviceID
    ///
    ///
    ///````swift
    ///
    ///             device.forceEnable_OTA_Updates(true) { result in
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
    public func forceEnable_OTA_Updates(_ enabled: Bool, completion: @escaping (Result<PCDevice.ForceOTAUpdateResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: self.id, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self, completion: completion)
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
    ///             PCDevice.forceEnable_OTA_Updates(on: deviceID, enabled: true, token: token) { result in
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
    static public func forceEnable_OTA_Updates(on deviceID: DeviceID, enabled: Bool, token: PCAccessToken, completion: @escaping (Result<PCDevice.ForceOTAUpdateResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.forceOverTheAirUpdates(deviceID: deviceID, enabled: enabled, token: token), type: PCDevice.ForceOTAUpdateResponse.self, completion: completion)
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
    ///         PCDevice.lookUpDeviceInformation(from: serialNumber, token: token) { result in
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
    static public func lookUpDeviceInformation(from serialNumber: String, token: PCAccessToken, completion: @escaping (Result<PCDevice.SerialNumberLookupResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.lookUpDeviceInformation(serialNumber: serialNumber, token: token), type: PCDevice.SerialNumberLookupResponse.self, completion: completion)
    }
}


//MARK: - Remote Diagnostics
extension PCDevice {
    
    //MARK: CurrentValueSubjects
    
    ///Refresh device vitals.
    ///
    ///Refresh diagnostic vitals for a single device. This will instruct the device to publish a new event to the Device Cloud containing a device vitals payload. This is an asynchronous request: the HTTP request returns immediately after the request to the device is sent. In order for the device to respond with a vitals payload, it must be online and connected to the Device Cloud.The device will respond by publishing an event named spark/device/diagnostics/update. See the description of the [device vitals event](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event).
    ///
    /// - calls: PUBLISH spark/device/diagnostics/update
    ///
    ///
    ///````swift
    ///             device.subscribe(EventName("spark/device/diagnostics/update", onEvent: {
    ///                 print($0.description)
    ///             })
    ///
    ///             let subject = device.refreshVitals()
    ///                     .replaceError(...
    ///
    ///
    ///````
    ///
    /// - Requires: Scope of devices.diagnostics:update
    /// - Parameter deviceID: String representing the device id.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter token: A currently active access token.
    /// - Returns A discardable result containing a CurrentValueSubject containing a bool response indicating success on the server or an PCError indicating the failure.
    @discardableResult public func refreshVitals() -> CurrentValueSubject<ServerResponses.BoolResponse?, PCError> {
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<ServerResponses.BoolResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.refreshDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, token: token), type: ServerResponses.BoolResponse.self)
    }
    
    ///Get last known device vitals.
    ///
    ///Returns the last device vitals payload sent by the device to the Device Cloud. See [device vitals event payload](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event) for more info.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId/last
    ///
    ///
    /// - Requires: Scope of devices.diagnostics:get
    /// - Returns: CurrentValueSubject with  optional LastKnownDiagnosticsResponse or an PCError indicating the failure.
    public func getLastKnownVitals() -> CurrentValueSubject<LastKnownDiagnosticsResponse?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<LastKnownDiagnosticsResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.getLastKnownDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, token: token), type: LastKnownDiagnosticsResponse.self)
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
    /// - Returns: CurrentValueSubject with  optional LastKnownDiagnosticsResponse or an PCError indicating the failure.
    static public func getLastKnownVitals(for deviceID: DeviceID, in product: ProductID, token: PCAccessToken) -> CurrentValueSubject<LastKnownDiagnosticsResponse?, PCError> {
        
        PCNetwork.shared.cloudRequest(.getLastKnownDeviceVitals(deviceID: deviceID, productIDorSlug: product, token: token), type: LastKnownDiagnosticsResponse.self)
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
    /// - Parameter startDate: Starting  date for query.
    /// - Parameter endDate: Ending date for query.
    /// - Returns: Current value subject containing the optional HistoricalDiagnosticsResponse or a PCError indicating the failure.
    public func getHistoricalVitals(startDate: Date? = nil, endDate: Date? = nil) -> CurrentValueSubject<HistoricalDiagnosticsResponse?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<HistoricalDiagnosticsResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.getAllHistoricalDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, startDate: try? startDate?.jSonDate(), endDate: try? endDate?.jSonDate(), token: token), type: HistoricalDiagnosticsResponse.self)
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
    /// - Returns: Current value subject containing the optional HistoricalDiagnosticsResponse or a PCError indicating the failure.
    static public func getHistoricalVitals(for device: DeviceID, in product: ProductID, startDate: Date? = nil, endDate: Date? = nil, token: PCAccessToken) -> CurrentValueSubject<HistoricalDiagnosticsResponse?, PCError> {
        
        PCNetwork.shared.cloudRequest(.getAllHistoricalDeviceVitals(deviceID: device, productIDorSlug: product, startDate: try? startDate?.jSonDate(), endDate: try? endDate?.jSonDate(), token: token), type: HistoricalDiagnosticsResponse.self)
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
    /// - Returns: Current Value subject containg the optional PCRemoteDiagnosticsMetaDataResponse or an PCError indicating the failure.
    public func getVitalMetadata() -> CurrentValueSubject<PCRemoteDiagnosticsMetaDataResponse?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<PCRemoteDiagnosticsMetaDataResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        return PCNetwork.shared.cloudRequest(.getDeviceVitalsMetadata(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCRemoteDiagnosticsMetaDataResponse.self)
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
    /// - Returns: Current Value subject containg the optional PCRemoteDiagnosticsMetaDataResponse or an PCError indicating the failure.
    static public func getVitalMetadata(for device: DeviceID, in product: ProductID, token: PCAccessToken) -> CurrentValueSubject<PCRemoteDiagnosticsMetaDataResponse?, PCError> {
                
        PCNetwork.shared.cloudRequest(.getDeviceVitalsMetadata(deviceID: device, productIDorSlug: product, token: token), type: PCRemoteDiagnosticsMetaDataResponse.self)
    }

    
    
    ///Get cellular network status.
    ///
    ///Get cellular network status for a given device. Kicks off a long running task that checks if the device/SIM has an active data session with a cell tower. Values for keys in the sim_status object will be null until the task has finished. Poll the endpoint until meta.state is complete. At this point, the sim_status object will be populated.Note that responses are cached by the cellular network providers. This means that on occasion, the real-time status of the device/SIM may not align with the results of this test.
    ///
    /// - calls: GET /v1/sims/:iccid/status
    ///
    ///
    /// - Requires: Scope of sims.status:get
    /// - Parameter iccid: The iccid number of the device to query.
    /// - Returns: Current value subject containing  the optional PCRemoteDiagnosticsCellularNetworkStatusResponse or an PCError indicating the failure.
    public func getCellularNetworkStatus(iccid: ICCIDNumber) -> CurrentValueSubject<PCRemoteDiagnosticsCellularNetworkStatusResponse?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<PCRemoteDiagnosticsCellularNetworkStatusResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return sub
        }
        
        guard self.cellular == true else {
            let subject = CurrentValueSubject<PCRemoteDiagnosticsCellularNetworkStatusResponse?, PCError>(nil)
            subject.send(completion: .failure(PCError(code: .notAvailableOnPlatform, description: "You cannot get cellular status on a non cellular device.")))
            return subject
        }
        
        return PCNetwork.shared.cloudRequest(.getCellularNetworkStatus(deviceID: self.id, iccid: iccid, productIDorSlug: self.productID, token: token), type: PCRemoteDiagnosticsCellularNetworkStatusResponse.self)
    }
    
    
    
    ///Get cellular network status.
    ///
    ///Get cellular network status for a given device. Kicks off a long running task that checks if the device/SIM has an active data session with a cell tower. Values for keys in the sim_status object will be null until the task has finished. Poll the endpoint until meta.state is complete. At this point, the sim_status object will be populated.Note that responses are cached by the cellular network providers. This means that on occasion, the real-time status of the device/SIM may not align with the results of this test.
    ///
    /// - calls: GET /v1/sims/:iccid/status
    ///
    ///
    /// - Requires: Scope of sims.status:get
    /// - Parameter deviceID: The id of the cellular device to query.
    /// - Parameter iccid: The iccid number of the device to query.
    /// - Parameter productIDorSlug: The id of the product the device is associated with.
    /// - Parameter token: A currently active access token with appropriate scopes..
    /// - Returns: Current value subject containing  the optional PCRemoteDiagnosticsCellularNetworkStatusResponse or an PCError indicating the failure.
    static public func getCellularNetworkStatus(for device: DeviceID, iccid: ICCIDNumber, in product: ProductID, token: PCAccessToken) -> CurrentValueSubject<PCRemoteDiagnosticsCellularNetworkStatusResponse?, PCError> {
        
        return PCNetwork.shared.cloudRequest(.getCellularNetworkStatus(deviceID: device, iccid: iccid, productIDorSlug: product, token: token), type: PCRemoteDiagnosticsCellularNetworkStatusResponse.self)
    }

    
    
    //MARK: Async
    
    ///Refresh device vitals.
    ///
    ///Refresh diagnostic vitals for a single device. This will instruct the device to publish a new event to the Device Cloud containing a device vitals payload. This is an asynchronous request: the HTTP request returns immediately after the request to the device is sent. In order for the device to respond with a vitals payload, it must be online and connected to the Device Cloud.The device will respond by publishing an event named spark/device/diagnostics/update. See the description of the [device vitals event](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event).
    ///
    /// - calls: PUBLISH spark/device/diagnostics/update
    ///
    ///
    ///````swift
    ///
    ///             device.subscribe(EventName("spark/device/diagnostics/update", onEvent: {
    ///                 print($0.description)
    ///             })
    ///
    ///             if device.refreshVitals() {
    ///                 //expect an diagnostic event
    ///                 //event delivery is not guaranteed consider using another diagnostic call if you need guarantee of delivery.
    ///             }
    ///
    ///````
    ///
    /// - Requires: Scope of devices.diagnostics:update
    /// - throws: PCError
    /// - Returns A discardable bool response indicating success on the server.
    @discardableResult public func refreshVitals() async throws -> Bool {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.refreshDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, token: token), type: ServerResponses.BoolResponse.self).ok
    }
    
    
    ///Get last known device vitals.
    ///
    ///Returns the last device vitals payload sent by the device to the Device Cloud. See [device vitals event payload](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event) for more info.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId/last
    ///
    ///
    /// - Requires: Scope of devices.diagnostics:get
    /// - throws: PCError
    /// - Returns: LastKnownDiagnosticsResponse
    public func getLastKnownVitals() async throws -> LastKnownDiagnosticsResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.getLastKnownDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, token: token), type: LastKnownDiagnosticsResponse.self)
    }
    
    
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
    static public func getLastKnownVitals(for deviceID: DeviceID, in product: ProductID, token: PCAccessToken) async throws -> LastKnownDiagnosticsResponse {
        
        try await PCNetwork.shared.cloudRequest(.getLastKnownDeviceVitals(deviceID: deviceID, productIDorSlug: product, token: token), type: LastKnownDiagnosticsResponse.self)
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
    /// - throws: PCError indicating the failure.
    /// - Parameter startDate: Starting  date for query.
    /// - Parameter endDate: Ending date for query.
    /// - Returns: An HistoricalDiagnosticsResponse.
    public func getHistoricalVitals(startDate: Date? = nil, endDate: Date? = nil) async throws -> HistoricalDiagnosticsResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.getAllHistoricalDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, startDate: try? startDate?.jSonDate(), endDate: try? endDate?.jSonDate(), token: token), type: HistoricalDiagnosticsResponse.self)
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
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productIDorSlug: The productID the device is associated with.
    /// - Parameter startDate: Starting  date for query.
    /// - Parameter endDate: Ending date for query.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics:get
    /// - Returns: An HistoricalDiagnosticsResponse.
    static public func getHistoricalVitals(for deviceID: DeviceID, in product: ProductID, startDate: Date? = nil, endDate: Date? = nil, token: PCAccessToken) async throws -> HistoricalDiagnosticsResponse {
                
        try await PCNetwork.shared.cloudRequest(.getAllHistoricalDeviceVitals(deviceID: deviceID, productIDorSlug: product, startDate: try? startDate?.jSonDate(), endDate: try? endDate?.jSonDate(), token: token), type: HistoricalDiagnosticsResponse.self)
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
    /// - Returns: Current Value subject containg the optional PCRemoteDiagnosticsMetaDataResponse or an PCError indicating the failure.
    public func getVitalMetadata() async throws -> PCRemoteDiagnosticsMetaDataResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.getDeviceVitalsMetadata(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCRemoteDiagnosticsMetaDataResponse.self)
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
    /// - throws: PCError indicating the failure.
    /// - Parameter deviceID: The id of the device to query.
    /// - Parameter productIDorSlug: The id of the product that the device is associated with.
    /// - Parameter token: A currently active access token scoped to devices.diagnostics.metadata:get
    /// - Returns: An PCRemoteDiagnosticsMetaDataResponse.
    static public func getVitalMetadata(for device: DeviceID, in product: ProductID, token: PCAccessToken) async throws -> PCRemoteDiagnosticsMetaDataResponse {
                
        try await PCNetwork.shared.cloudRequest(.getDeviceVitalsMetadata(deviceID: device, productIDorSlug: product, token: token), type: PCRemoteDiagnosticsMetaDataResponse.self)
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
    /// - Parameter iccid: The iccid number of the device to query.
    /// - Returns: An PCRemoteDiagnosticsCellularNetworkStatusResponse.
    public func getCellularNetworkStatus(iccid: ICCIDNumber) async throws-> PCRemoteDiagnosticsCellularNetworkStatusResponse {
        
        guard let token = self.token
        else {
            throw PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
        }
        
        guard self.cellular == true else {
            throw PCError(code: .notAvailableOnPlatform, description: "You cannot get cellular status on a non cellular device.")
        }
        
        return try await PCNetwork.shared.cloudRequest(.getCellularNetworkStatus(deviceID: self.id, iccid: iccid , productIDorSlug: self.productID, token: token), type: PCRemoteDiagnosticsCellularNetworkStatusResponse.self)
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
    static public func getCellularNetworkStatus(for device: DeviceID, iccid: ICCIDNumber, in product: ProductID, token: PCAccessToken) async throws -> PCRemoteDiagnosticsCellularNetworkStatusResponse {
        
        return try await PCNetwork.shared.cloudRequest(.getCellularNetworkStatus(deviceID: device, iccid: iccid, productIDorSlug: product, token: token), type: PCRemoteDiagnosticsCellularNetworkStatusResponse.self)
    }

    
    //MARK: Completion Handlers
    
    ///Refresh device vitals.
    ///
    ///Refresh diagnostic vitals for a single device. This will instruct the device to publish a new event to the Device Cloud containing a device vitals payload. This is an asynchronous request: the HTTP request returns immediately after the request to the device is sent. In order for the device to respond with a vitals payload, it must be online and connected to the Device Cloud.The device will respond by publishing an event named spark/device/diagnostics/update. See the description of the [device vitals event](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event).
    ///
    /// - calls: PUBLISH spark/device/diagnostics/update
    ///
    ///
    ///````swift
    ///
    ///             device.subscribe(EventName("spark/device/diagnostics/update", onEvent: {
    ///                 print($0.description)
    ///             })
    ///
    ///             let subject = device.refreshVitals() { result in
    ///                 //check for server success
    ///             }
    ///
    ///````
    ///
    /// - Requires: Scope of devices.diagnostics:update
    /// - Parameter deviceID: String representing the device id.
    /// - Parameter productIDorSlug: String representing the product id or slug.
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure containing a bool response indicating success on the server or an PCError indicating the failure.
    public func refreshVitals(completion: @escaping (Result<Bool, PCError>) -> Void){
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        return PCNetwork.shared.cloudRequest(.refreshDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, token: token), type: ServerResponses.BoolResponse.self) { result in
        
            do{
                completion(.success(try result.get().ok))
            } catch {
                completion(.failure(error as! PCError))
            }
        }
    }
    
    
    ///Get last known device vitals.
    ///
    ///Returns the last device vitals payload sent by the device to the Device Cloud. See [device vitals event payload](https://docs.particle.io/reference/cloud-apis/api/#device-vitals-event) for more info.
    ///
    /// - calls: GET /v1/diagnostics/:deviceId/last
    ///
    ///
    /// - Requires: Scope of devices.diagnostics:get
    /// - Returns: Closure containg a result of the  LastKnownDiagnosticsResponse or a PCError indicating failure.
    public func getLastKnownVitals(completion: @escaping (Result<LastKnownDiagnosticsResponse, PCError>) -> Void) {
       
        guard let token = self.token
        else {
            completion(.failure(PCError.unauthenticated))
            return
        }
        
        PCNetwork.shared.cloudRequest(.getLastKnownDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, token: token), type: LastKnownDiagnosticsResponse.self, completion: completion)
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
    static public func getLastKnownVitals(for deviceID: DeviceID, in product: ProductID, token: PCAccessToken, completion: @escaping (Result<LastKnownDiagnosticsResponse, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.getLastKnownDeviceVitals(deviceID: deviceID, productIDorSlug: product, token: token), type: LastKnownDiagnosticsResponse.self, completion: completion)
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
    /// - Parameter startDate: Starting  date for query.
    /// - Parameter endDate: Ending date for query.
    /// - Parameter completion: Closure containing a result of HistoricalDiagnosticsResponse or a PCError indicating the failure.
    public func getHistoricalVitals(startDate: Date? = nil, endDate: Date? = nil, completion: @escaping (Result<HistoricalDiagnosticsResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        return PCNetwork.shared.cloudRequest(.getAllHistoricalDeviceVitals(deviceID: self.id, productIDorSlug: self.productID, startDate: try? startDate?.jSonDate(), endDate: try? endDate?.jSonDate(), token: token), type: HistoricalDiagnosticsResponse.self, completion: completion)
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
    static public func getHistoricalVitals(for device: DeviceID, in product: ProductID, startDate: Date? = nil, endDate: Date? = nil, token: PCAccessToken, completion: @escaping (Result<HistoricalDiagnosticsResponse, PCError>) -> Void) {
        
        return PCNetwork.shared.cloudRequest(.getAllHistoricalDeviceVitals(deviceID: device, productIDorSlug: product, startDate: try? startDate?.jSonDate(), endDate: try? endDate?.jSonDate(), token: token), type: HistoricalDiagnosticsResponse.self, completion: completion)
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
    /// - Parameter completion: Closure containg the PCRemoteDiagnosticsMetaDataResponse or an PCError indicating the failure.
    public func getVitalMetadata(completion: @escaping (Result<PCRemoteDiagnosticsMetaDataResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        return PCNetwork.shared.cloudRequest(.getDeviceVitalsMetadata(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCRemoteDiagnosticsMetaDataResponse.self, completion: completion)
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
    static public func getVitalMetadata(for device: DeviceID, in product: ProductID, token: PCAccessToken, completion: @escaping (Result<PCRemoteDiagnosticsMetaDataResponse, PCError>) -> Void) {
                
        PCNetwork.shared.cloudRequest(.getDeviceVitalsMetadata(deviceID: device, productIDorSlug: product, token: token), type: PCRemoteDiagnosticsMetaDataResponse.self, completion: completion)
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
    public func getCellularNetworkStatus(iccid: ICCIDNumber, completion: @escaping (Result<PCRemoteDiagnosticsCellularNetworkStatusResponse, PCError> ) -> Void) {
        
        guard let token = self.token
        else {
            completion( .failure(PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")))
            return
        }
        
        guard self.cellular == true else {
            completion(.failure(PCError(code: .notAvailableOnPlatform, description: "You cannot get cellular status on a non cellular device.")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.getCellularNetworkStatus(deviceID: self.id, iccid: iccid , productIDorSlug: self.productID, token: token), type: PCRemoteDiagnosticsCellularNetworkStatusResponse.self, completion: completion)
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
    static public func getCellularNetworkStatus(for device: DeviceID, iccid: ICCIDNumber, in product: ProductID, token: PCAccessToken, completion: @escaping (Result<PCRemoteDiagnosticsCellularNetworkStatusResponse, PCError>) -> Void) {
        
       PCNetwork.shared.cloudRequest(.getCellularNetworkStatus(deviceID: device, iccid: iccid , productIDorSlug: product, token: token), type: PCRemoteDiagnosticsCellularNetworkStatusResponse.self, completion: completion)
    }
}


//MARK: - Quarantine
public extension PCDevice {
    
    
    ///Approve or deny a quarantined device.
    ///
    ///Approval will immediately release the device from quarantine and allow it to publish events, receive firmware updates, etc.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/devices
    ///
    ///
    /// - Requires: Scope of devices:import for approval and devices:remove for denial.
    /// - Parameter action: The action to take on the quarantined device.
    /// - Returns: CurrentValueSubject containing the optional QuarantineActionResponse or an PCError indicating the failure.
    func handleQuarantine(action: PCQuarantine.QuarantineAction) -> CurrentValueSubject<PCQuarantine.QuarantineActionResponse?, PCError> {
        
        guard let token = self.token
        else {
            let sub = CurrentValueSubject<PCQuarantine.QuarantineActionResponse?, PCError>(nil)
            sub.send(completion: .failure(PCError.unauthenticated))
            return sub
        }
        
        switch action {
        case .approve:
            
            return PCNetwork.shared.cloudRequest(.approveQuarantinedDevice(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCQuarantine.QuarantineActionResponse.self)
            
        case .deny:
            
            return PCNetwork.shared.cloudRequest(.denyQuarantinedDevice(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCQuarantine.QuarantineActionResponse.self)
        }
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
    /// - Parameter token: A currently active access token scoped to devices:import
    /// - Returns: CurrentValueSubject containing the optional QuarantineActionResponse or an PCError indicating the failure.
    static func handleQuarantine(for device: DeviceID, in product: ProductID, action: PCQuarantine.QuarantineAction, token: PCAccessToken) -> CurrentValueSubject<PCQuarantine.QuarantineActionResponse?, PCError> {
                
        switch action {
        case .approve:
            
            return PCNetwork.shared.cloudRequest(.approveQuarantinedDevice(deviceID: device, productIDorSlug: product, token: token), type: PCQuarantine.QuarantineActionResponse.self)
            
        case .deny:
            
            return PCNetwork.shared.cloudRequest(.denyQuarantinedDevice(deviceID: device, productIDorSlug: product, token: token), type: PCQuarantine.QuarantineActionResponse.self)
        }
    }

    
    ///Approve or deny a quarantined device.
    ///
    ///Approval will immediately release the device from quarantine and allow it to publish events, receive firmware updates, etc.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/devices
    ///
    ///
    /// - Requires: Scope of devices:import for approval and devices:remove for denial.
    /// - throws: PCError indicating the failure.
    /// - Parameter action: The action to take on the quarantined device.
    /// - Returns: PCQuarantine.QuarantineActionResponse
    func handleQuarantine(action: PCQuarantine.QuarantineAction) async throws -> PCQuarantine.QuarantineActionResponse {
        
        guard let token = self.token
        else {
            throw PCError.unauthenticated
        }
        
        switch action {
        case .approve:
            
            return try await PCNetwork.shared.cloudRequest(.approveQuarantinedDevice(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCQuarantine.QuarantineActionResponse.self)
            
        case .deny:
            
            return try await PCNetwork.shared.cloudRequest(.denyQuarantinedDevice(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCQuarantine.QuarantineActionResponse.self)
        }
    }
    
    
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
    /// - Parameter token: A currently active access token scoped to devices:import
    /// - Returns: PCQuarantine.QuarantineActionResponse
    static func handleQuarantine(for device: DeviceID, in product: ProductID, action: PCQuarantine.QuarantineAction, token: PCAccessToken) async throws -> PCQuarantine.QuarantineActionResponse {
                
        switch action {
        case .approve:
            
            return try await PCNetwork.shared.cloudRequest(.approveQuarantinedDevice(deviceID: device, productIDorSlug: product, token: token), type: PCQuarantine.QuarantineActionResponse.self)
            
        case .deny:
            
            return try await PCNetwork.shared.cloudRequest(.denyQuarantinedDevice(deviceID: device, productIDorSlug: product, token: token), type: PCQuarantine.QuarantineActionResponse.self)
        }
    }

    
    ///Approve or deny a quarantined device.
    ///
    ///Approval will immediately release the device from quarantine and allow it to publish events, receive firmware updates, etc.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/devices
    ///
    ///
    /// - Requires: Scope of devices:import for approval and devices:remove for denial.
    /// - Parameter action: The action to take on the quarantined device.
    /// - Parameter completion: Closure containing the QuarantineActionResponse or an PCError indicating the failure.
    func handleQuarantine(action: PCQuarantine.QuarantineAction, completion: @escaping (Result<PCQuarantine.QuarantineActionResponse, PCError>) -> Void) {
        
        guard let token = self.token
        else {
            completion(.failure(PCError.unauthenticated)); return
        }
        
        switch action {
            
        case .approve:
            
            PCNetwork.shared.cloudRequest(.approveQuarantinedDevice(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCQuarantine.QuarantineActionResponse.self, completion: completion)
            
        case .deny:
            
            PCNetwork.shared.cloudRequest(.denyQuarantinedDevice(deviceID: self.id, productIDorSlug: self.productID, token: token), type: PCQuarantine.QuarantineActionResponse.self, completion: completion)
        }
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
    /// - Parameter token: A currently active access token scoped to devices:import
    /// - Parameter completion: Closure containing the QuarantineActionResponse or an PCError indicating the failure.
    static func handleQuarantine(for device: DeviceID, in product: ProductID, action: PCQuarantine.QuarantineAction, token: PCAccessToken, completion: @escaping (Result<PCQuarantine.QuarantineActionResponse, PCError>) -> Void) {
                
        switch action {
        case .approve:
            
            PCNetwork.shared.cloudRequest(.approveQuarantinedDevice(deviceID: device, productIDorSlug: product, token: token), type: PCQuarantine.QuarantineActionResponse.self, completion: completion)
            
        case .deny:
            
            PCNetwork.shared.cloudRequest(.denyQuarantinedDevice(deviceID: device, productIDorSlug: product, token: token), type: PCQuarantine.QuarantineActionResponse.self, completion: completion)
        }
    }
}
