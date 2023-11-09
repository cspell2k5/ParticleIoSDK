    //
    //  PCAssetTracking.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/14/23.
    //

import Foundation


public struct AssetTracking {
    
    
        // MARK: - Welcome
    public struct ProductConfigurationResponse {
        public let configuration: Configuration
        
        public init(configuration: Configuration) {
            self.configuration = configuration
        }
    }
    
        // MARK: - Configuration
    public struct Configuration {
        public let location: Location
        public let imuTrig: ImuTrig
        public let rgb: RGB
        
        public init(location: Location, imuTrig: ImuTrig, rgb: RGB) {
            self.location = location
            self.imuTrig = imuTrig
            self.rgb = rgb
        }
    }
    
        // MARK: - ImuTrig
    public struct ImuTrig {
        public let motion, highG: String
        
        public init(motion: String, highG: String) {
            self.motion = motion
            self.highG = highG
        }
    }
    
        // MARK: - Location
    public struct Location {
        public let radius, intervalMin, intervalMax: Int
        public let minPublish: Bool
        
        public init(radius: Int, intervalMin: Int, intervalMax: Int, minPublish: Bool) {
            self.radius = radius
            self.intervalMin = intervalMin
            self.intervalMax = intervalMax
            self.minPublish = minPublish
        }
    }
    
        // MARK: - RGB
    public struct RGB {
        public let type: String
        public let direct: Direct
        
        public init(type: String, direct: Direct) {
            self.type = type
            self.direct = direct
        }
    }
    
        // MARK: - Direct
    public struct Direct {
        public let red, blue, green, brightness: Int
        
        public init(red: Int, blue: Int, green: Int, brightness: Int) {
            self.red = red
            self.blue = blue
            self.green = green
            self.brightness = brightness
        }
    }

    
    public struct DeviceConfigurationResponse: Decodable {
            ///The device's current confirmed configuration
        public let current: Current

            ///The configuration this device will be updated to
        public var pending: Current
        
            // MARK: - Current
        public struct Current: Decodable {
            public let imuTrig: ImuTrig
            public let location: Location
            
            private enum CodingKeys: String, CodingKey {
                case imuTrig = "imu_trig"
                case location
            }
            
            private init(imuTrig: ImuTrig, location: Location) {
                fatalError("Requires init with coder.")
            }
        }
        
            // MARK: - ImuTrig
        public struct ImuTrig: Decodable {
            public let motion, highG: String
            
            private enum CodingKeys: String, CodingKey {
                case motion
                case highG = "high_g"
            }
            
            private init(motion: String, highG: String) {
                fatalError("Requires init with coder.")
            }
        }
        
            // MARK: - Location
        public struct Location: Decodable {
            public let radius, intervalMin, intervalMax: Int
            public let minPublish: Bool
            
            private enum CodingKeys: String, CodingKey {
                case radius
                case intervalMin = "interval_min"
                case intervalMax = "interval_max"
                case minPublish = "min_publish"
            }
            
            private init(radius: Int, intervalMin: Int, intervalMax: Int, minPublish: Bool) {
                fatalError("Requires init with coder.")
            }
        }
    }
    
    public struct LocationListArguments {
        
        public var debugDescription: String {
            return "LocationArguments:\ndateRange:\(String(describing: dateRange))\nrectBl:\(rectBl)\nrectTr:\(rectTr)\ndeviceId:\(deviceId.rawValue)\ndeviceName:\(deviceName.rawValue)\ngroups:\(groups?.compactMap {$0.rawValue} ?? [] )\npage\(String(describing: page))\nperPage\(String(describing: perPage))"
        }
        
        public var productIDorSlug: ProductID
            ///Start and end date in ISO8601 format, separated by comma, to query. Omitting date_range will return last known location.
        public var dateRange: String?
            ///Bottom left of the rectangular bounding box to query. Latitude and longitude separated by comma.
        public var rectBl: String
            ///Top right of the rectangular bounding box to query. Latitude and longitude separated by comma.
        public var rectTr: String
            ///Device ID prefix to include in the query
        public var deviceId: DeviceID
            ///Device name prefix to include in the query
        public var deviceName: DeviceName
            /// Array of group names to include in the query
        public var groups: [GroupName]?
            ///Page of results to display. Defaults to 1
        public var page: Int?
            ///Number of results per page. Defaults to 20. Maximum of 100
        public var perPage: Int?
        
       
        
        private enum CodingKeys: String, CaseIterable {
            case dateRange = "date_range"
            case rectBl = "rect_bl"
            case rectTr = "rect_tr"
            case deviceId = "device_id"
            case deviceName = "device_name"
            case groups = "groups"
            case page = "page"
            case perPage = "per_page"
        }
        
        internal var serverQueryItems: [URLQueryItem] {
            var items = [URLQueryItem]()
            
            for key in CodingKeys.allCases {
                if let newItem = self.queryItem(forKey: key) {
                    items.append(newItem)
                }
            }
            
            return items
        }
        
        private func queryItem(forKey key: CodingKeys) -> URLQueryItem? {
           
            switch key {
                case .dateRange:
                    return self.dateRange != nil ? URLQueryItem(name: key.rawValue, value: self.dateRange!) : nil
                case .rectBl:
                    return URLQueryItem(name: key.rawValue, value: self.rectBl)
                case .rectTr:
                    return URLQueryItem(name: key.rawValue, value: self.rectTr)
                case .deviceId:
                    return URLQueryItem(name: key.rawValue, value: self.deviceId.rawValue)
                case .deviceName:
                    return URLQueryItem(name: key.rawValue, value: self.deviceName.rawValue)
                case .groups:
                    return self.groups != nil ? URLQueryItem(name: key.rawValue, value: "\(self.groups!.map({$0.rawValue}))") : nil
                case .page:
                    return self.page != nil ? URLQueryItem(name: key.rawValue, value: "\(self.page!)") : nil
                case .perPage:
                    return self.perPage != nil ? URLQueryItem(name: key.rawValue, value: "\(self.perPage!)") : nil
            }
        }
    }
    
        // MARK: - LocationResponse
    public struct LocationResponse: Codable {
       
        public let locations: [Location]
        public let meta: Meta
        
        private init(locations: [Location], meta: Meta) {
            fatalError("Requires init with coder.")
        }
        
            // MARK: - Location
        public struct Location: Codable {
            public let deviceID: String
            public let productID: Int
            public let deviceName: String
            public let groups: [String]
            public let gpsLock: Bool
            public let lastHeard: Date
            public let timestamps: [Date]
            public let online: Bool
            public let geometry: Geometry
            
            private enum CodingKeys: String, CodingKey {
                case deviceID = "device_id"
                case productID = "product_id"
                case deviceName = "device_name"
                case groups
                case gpsLock = "gps_lock"
                case lastHeard = "last_heard"
                case timestamps, online, geometry
            }
            
            private init(deviceID: String, productID: Int, deviceName: String, groups: [String], gpsLock: Bool, lastHeard: Date, timestamps: [Date], online: Bool, geometry: Geometry) {
                fatalError("Requires init with coder.")
            }
        }
        
            // MARK: - Geometry
        public struct Geometry: Codable {
            public let type: String
            public let coordinates: [[Double]]
            
            private init(type: String, coordinates: [[Double]]) {
                fatalError("Requires init with coder.")
            }
        }
        
            // MARK: - Meta
        public struct Meta: Codable {
            public let page, perPage, totalPages, devicesFound: Int
            
            private enum CodingKeys: String, CodingKey {
                case page
                case perPage = "per_page"
                case totalPages = "total_pages"
                case devicesFound = "devices_found"
            }
            
            private init(page: Int, perPage: Int, totalPages: Int, devicesFound: Int) {
                fatalError("Requires init with coder.")
            }
        }
    }
    
    
        // MARK: - LocationPointSchema
    public struct LocationPointSchema: Codable {
        public let definitions: Definitions
        public let schema: String
        public let id: String
        public let title: String
        public let description: String
        public let type: String
        public let locationPointSchemaRequired: [String]
        public let properties: LocationPointSchemaProperties
        
        private enum CodingKeys: String, CodingKey {
            case definitions = "definitions"
            case schema = "$schema"
            case id = "$id"
            case title = "title"
            case description = "description"
            case type = "type"
            case locationPointSchemaRequired = "required"
            case properties = "properties"
        }
        
        private init(definitions: Definitions, schema: String, id: String, title: String, description: String, type: String, locationPointSchemaRequired: [String], properties: LocationPointSchemaProperties) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - Definitions
    public struct Definitions: Codable {
        
        public init() {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - LocationPointSchemaProperties
    public struct LocationPointSchemaProperties: Codable {
        public let cmd: Cmd
        public let time: LOCCb
        public let loc: LOC
        public let trig: Trig
        public let locCb: LOCCb
        public let towers: Towers
        public let wps: Wps
        
        private enum CodingKeys: String, CodingKey {
            case cmd = "cmd"
            case time = "time"
            case loc = "loc"
            case trig = "trig"
            case locCb = "loc_cb"
            case towers = "towers"
            case wps = "wps"
        }
        
        private init(cmd: Cmd, time: LOCCb, loc: LOC, trig: Trig, locCb: LOCCb, towers: Towers, wps: Wps) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - Cmd
    public struct Cmd: Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let type: TypeEnum
        public let cmdEnum: [String]?
        public let cmdDefault: String?
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case description = "description"
            case type = "type"
            case cmdEnum = "enum"
            case cmdDefault = "default"
        }
        
        private init(id: String, title: String, description: String?, type: TypeEnum, cmdEnum: [String]?, cmdDefault: String?) {
            fatalError("Requires init with coder.")
        }
    }
    
    public enum TypeEnum: String, Codable {
        case boolean = "boolean"
        case integer = "integer"
        case number = "number"
        case string = "string"
    }
    
        // MARK: - LOC
    public struct LOC: Codable {
        public let id: String
        public let title: String
        public let description: String
        public let type: String
        public let locRequired: [String]
        public let properties: LOCProperties
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case description = "description"
            case type = "type"
            case locRequired = "required"
            case properties = "properties"
        }
        
        private init(id: String, title: String, description: String, type: String, locRequired: [String], properties: LOCProperties) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - LOCProperties
    public struct LOCProperties: Codable {
        public let lck: LOCCb
        public let time: LOCCb
        public let lat: LOCCb
        public let lon: LOCCb
        public let alt: Cmd
        public let hd: LOCCb
        public let spd: LOCCb
        public let hAcc: LOCCb
        public let vAcc: LOCCb
        public let temp: LOCCb
        public let batt: LOCCb
        public let cell: LOCCb
        
        private enum CodingKeys: String, CodingKey {
            case lck = "lck"
            case time = "time"
            case lat = "lat"
            case lon = "lon"
            case alt = "alt"
            case hd = "hd"
            case spd = "spd"
            case hAcc = "h_acc"
            case vAcc = "v_acc"
            case temp = "temp"
            case batt = "batt"
            case cell = "cell"
        }
        
        private init(lck: LOCCb, time: LOCCb, lat: LOCCb, lon: LOCCb, alt: Cmd, hd: LOCCb, spd: LOCCb, hAcc: LOCCb, vAcc: LOCCb, temp: LOCCb, batt: LOCCb, cell: LOCCb) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - LOCCb
    public struct LOCCb: Codable {
        public let id: String
        public let title: String
        public let description: String
        public let type: TypeEnum
        public let minimum: Int?
        public let maximum: Int?
        public let locCbDefault: Default?
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case description = "description"
            case type = "type"
            case minimum = "minimum"
            case maximum = "maximum"
            case locCbDefault = "default"
        }
        
        private init(id: String, title: String, description: String, type: TypeEnum, minimum: Int?, maximum: Int?, locCbDefault: Default?) {
            fatalError("Requires init with coder.")
        }
    }
    
    public enum Default: Codable {
        case bool(Bool)
        case integer(Int)
        case string(String)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Bool.self) {
                self = .bool(x)
                return
            }
            if let x = try? container.decode(Int.self) {
                self = .integer(x)
                return
            }
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            throw DecodingError.typeMismatch(Default.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Default"))
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
                case .bool(let x):
                    try container.encode(x)
                case .integer(let x):
                    try container.encode(x)
                case .string(let x):
                    try container.encode(x)
            }
        }
    }
    
        // MARK: - Towers
    public struct Towers: Codable {
        public let id: String
        public let title: String
        public let description: String
        public let type: String
        public let towersDefault: [JSONAny]
        public let items: TowersItems
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case description = "description"
            case type = "type"
            case towersDefault = "default"
            case items = "items"
        }
        
        private init(id: String, title: String, description: String, type: String, towersDefault: [JSONAny], items: TowersItems) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - TowersItems
    public struct TowersItems: Codable {
        public let id: String
        public let title: String
        public let type: String
        public let itemsRequired: [String]
        public let properties: PurpleProperties
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case type = "type"
            case itemsRequired = "required"
            case properties = "properties"
        }
        
        private init(id: String, title: String, type: String, itemsRequired: [String], properties: PurpleProperties) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - PurpleProperties
    public struct PurpleProperties: Codable {
        public let str: LOCCb
        public let rat: LOCCb
        public let mcc: LOCCb
        public let mnc: LOCCb
        public let lac: LOCCb
        public let cid: LOCCb
        public let nid: LOCCb
        public let ch: LOCCb
        
        private enum CodingKeys: String, CodingKey {
            case str = "str"
            case rat = "rat"
            case mcc = "mcc"
            case mnc = "mnc"
            case lac = "lac"
            case cid = "cid"
            case nid = "nid"
            case ch = "ch"
        }
        
        private init(str: LOCCb, rat: LOCCb, mcc: LOCCb, mnc: LOCCb, lac: LOCCb, cid: LOCCb, nid: LOCCb, ch: LOCCb) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - Trig
    public struct Trig: Codable {
        public let id: String
        public let title: String
        public let description: String
        public let type: String
        public let trigDefault: [JSONAny]
        public let items: Cmd
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case description = "description"
            case type = "type"
            case trigDefault = "default"
            case items = "items"
        }
        
        private init(id: String, title: String, description: String, type: String, trigDefault: [JSONAny], items: Cmd) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - Wps
    public struct Wps: Codable {
        public let id: String
        public let title: String
        public let description: String
        public let type: String
        public let wpsDefault: [JSONAny]
        public let items: WpsItems
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case description = "description"
            case type = "type"
            case wpsDefault = "default"
            case items = "items"
        }
        
        private init(id: String, title: String, description: String, type: String, wpsDefault: [JSONAny], items: WpsItems) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - WpsItems
    public struct WpsItems: Codable {
        public let id: String
        public let title: String
        public let type: String
        public let itemsRequired: [String]
        public let properties: FluffyProperties
        
        private enum CodingKeys: String, CodingKey {
            case id = "$id"
            case title = "title"
            case type = "type"
            case itemsRequired = "required"
            case properties = "properties"
        }
        
        private init(id: String, title: String, type: String, itemsRequired: [String], properties: FluffyProperties) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - FluffyProperties
    public struct FluffyProperties: Codable {
        public let bssid: LOCCb
        public let str: LOCCb
        public let ch: LOCCb
        
        private enum CodingKeys: String, CodingKey {
            case bssid = "bssid"
            case str = "str"
            case ch = "ch"
        }
        
        private init(bssid: LOCCb, str: LOCCb, ch: LOCCb) {
            fatalError("Requires init with coder.")
        }
    }
    
        // MARK: - Encode/decode helpers
    
    public class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(0)
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
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    public class JSONAny: Codable {
        
        public let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }

}
