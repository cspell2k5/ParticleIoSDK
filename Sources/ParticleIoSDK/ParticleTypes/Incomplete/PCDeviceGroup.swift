//
//  PCDeviceGroup.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/14/23.
//

import Foundation



public struct PCDeviceGroup : Decodable, Hashable {
    
    
    public let name : GroupName?
    public let description : String?
    public let color : String?
    public let fwVersion : String?
    public let deviceCount : Int?
    
    private enum CodingKeys: String, CodingKey {
        case name, description, color, fwVersion = "fw_version", deviceCount = "device_count"
    }
    
    private init(name: GroupName?, description: String?, color: String?, fwVersion: String?, deviceCount: Int?) {
        fatalError("Must use init with decoder.")
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = GroupName(try container.decode(String.self, forKey: .name))
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.fwVersion = try container.decodeIfPresent(String.self, forKey: .fwVersion)
        self.deviceCount = try container.decodeIfPresent(Int.self, forKey: .deviceCount)
    }
}


extension PCDeviceGroup {
    
    public struct AssignResponse: Decodable {
        
            ///Device ID.
        public let deviceID: String
        
            ///Array of updated device group names.
        public let groups: [String]
        
            ///Timestamp representing the last time the deivce was updated in ISO8601 format.
        public let updated_at: String
        
        private enum CodingKeys: CodingKey {
            case id
            case groups
            case updated_at
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PCDeviceGroup.AssignResponse.CodingKeys.self)
            self.deviceID = try container.decode(String.self, forKey: PCDeviceGroup.AssignResponse.CodingKeys.id)
            self.groups = try container.decode([String].self, forKey: PCDeviceGroup.AssignResponse.CodingKeys.groups)
            self.updated_at = try container.decode(String.self, forKey: PCDeviceGroup.AssignResponse.CodingKeys.updated_at)
        }
    
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
}

extension PCDeviceGroup {

    public struct BatchArguments {
        
        ///Set to groups.
        public let action: String
        
        ///An array of device IDs to update group memberships.
        public let devices: [String]
        
        ///metadata object to inform which groups should be added / removed.
        public let metadata: Metadata
        
        ///Array of group names to add to devices
        public let metadata_add: [GroupName]?
        
        ///Array of group names to remove to devices
        public let metadata_remove: [GroupName]?
    }
        

    public struct Metadata {
        public let add: [String]
        
        public init(add: [String]) {
            self.add = add
        }
    }
}


extension PCDeviceGroup {
    
    public struct GroupImpactArguments: CustomStringConvertible, CustomDebugStringConvertible {
        
        public var description: String {
return """
    action: \(action),
    firmware_version: \(firmware_version),
    groups: [
        \(String(describing: _groups?.joined(separator: ",\n")))
    ],
    product_default: \(String(describing: product_default))
"""
        }
        
        public var debugDescription: String {
return """
GroupImpactArguments: {
    action: \(action),
    firmware_version: \(firmware_version),
    groups: [
        \(String(describing: _groups?.joined(separator: ",\n")))
    ],
    product_default: \(String(describing: product_default))
}
"""
        }
        
        private let _groups: [String]?
        
            ///The action you are about to take. Currently only accepts edit_groups_for_firmware.
        public let action: String
        
            ///Firmware version you wish to release.
        public let firmware_version: String
        
            ///Comma separated list of device group names to release the firmware_version version to. Do not include to simulate the impact of unreleasing to all groups.
        public var groups: String? {
            _groups?.joined(separator: ",")
        }
        
            ///Set to true if you intend to release this firmware_version as the product default firmware. Set to false if the firmware is currently marked as product_default to simulate unreleasing as the product_default.
        public let product_default: Bool?
        
        public init(groups: [String]? = nil, action: String, firmware_version: String, product_default: Bool?) {
            self._groups = groups
            self.action = action
            self.firmware_version = firmware_version
            self.product_default = product_default
        }
    }
    
    
    public struct GroupImpactResponse: Decodable {
        
        public let devices: Devices
        
        private init(devices: Devices) {
            fatalError("Requires init with coder")
        }
    }
    
    public struct Devices: Decodable {
       
        public let firmwareUpdate: FirmwareUpdate
        
        private enum CodingKeys: String, CodingKey {
            case firmwareUpdate = "firmware_update"
        }
        
        private init(firmwareUpdate: FirmwareUpdate) {
            fatalError("Requires init with coder")
        }
    }
    
    public struct FirmwareUpdate: Decodable {
        
        public let total: Int
        public let byVersion: [ByVersion]
        
        private enum CodingKeys: String, CodingKey {
            case total
            case byVersion = "by_version"
        }
        
        private init(total: Int, byVersion: [ByVersion]) {
            fatalError("Requires init with coder")
        }
    }
    
    public struct ByVersion: Decodable {
       
        public let version, total: Int
        
        private init(version: Int, total: Int) {
            fatalError("Requires init with coder")
        }
    }
}
