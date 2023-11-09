//
//  PCProductFirmware.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/14/23.
//

import Foundation

public struct PCProductFirmware: Decodable {
    
        // MARK: - ProductFirmwareList
    struct ProductFirmwareList: Codable, CustomDebugStringConvertible, CustomStringConvertible {
        
        var description: String {
"""
    id: \(id),
    version: \(version),
    title: \(title),
    description: \(info),
    name: \(name),
    size: \(size),
    productDefault: \(productDefault),
    uploadedOn: \(uploadedOn),
    productID: \(productID),
    mandatory: \(mandatory),
    uploadedBy: \(uploadedBy)
"""
        }
        
        public var debugDescription: String {
"""
ProductFirmwareList: {
    id: \(id),
    version: \(version),
    title: \(title),
    description: \(info),
    name: \(name),
    size: \(size),
    productDefault: \(productDefault),
    uploadedOn: \(uploadedOn),
    productID: \(productID),
    mandatory: \(mandatory),
    uploadedBy: \(uploadedBy.username)
}
"""
        }
        
        let id: String
        let version: Int
        let title, info, name: String
        let size: Int
        let productDefault: Bool
        let uploadedOn: String
        let productID: Int
        let mandatory: Bool
        let uploadedBy: UploadedBy
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case version, title
            case info = "description"
            case name, size
            case productDefault = "product_default"
            case uploadedOn = "uploaded_on"
            case productID = "product_id"
            case mandatory
            case uploadedBy = "uploaded_by"
        }
    }
    
        // MARK: - UploadedBy
    struct UploadedBy: Codable, CustomDebugStringConvertible, CustomStringConvertible {
        var description: String {
            "username: \(username)"
        }
        
        var debugDescription: String {
            description
        }
        
        let username: String
    }
}

extension PCProductFirmware {
        
    public struct UploadArguments: CustomDebugStringConvertible {
        
        public typealias FilePath = String
        
//        public var description: String {
//"""
//    version: \(version),
//    title: \(title),
//    file: \(file),
//    productIdOrSlug: \(productIdOrSlug),
//    description: \(description),
//    mandatory: \(mandatory)
//"""
//        }
        
        public var debugDescription: String {
"""
PCProductFirmware: {
    version: \(version),
    title: \(title),
    file: \(file),
    productIdOrSlug: \(productIdOrSlug),
    description: \(String(describing: description)),
    mandatory: \(String(describing: mandatory))
}
"""
        }

        ///The version number of the firmware binary you are uploading
        public let version: Int

            ///Title of the firmware version. Handy for quickly identifying the firmware
        public let title: String
        
            ///A binary file encoded in multipart/form-data format containing the contents of the product firmware (binary is also accepted for backwards compatibility)
        public let file: FilePath
            
            ///Product ID or slug
        public let productIdOrSlug: String
            
            ///Optionally provide a description for the new firmware version
        public let description: String?
        
            ///[Enterprise only] Flag this firmware release as a mandatory release so that product upgrades and downgrades apply this version of firmware before flashing the targeted version.
        public let mandatory: Bool?
        
        public init(version: Int, title: String, file: FilePath, productIdOrSlug: ProductID, description: String?, mandatory: Bool?) {
            self.version = version
            self.title = title
            self.file = file
            self.productIdOrSlug = String(productIdOrSlug.rawValue)
            self.description = description
            self.mandatory = mandatory
        }
    }
    
    public struct EditArguments: CustomDebugStringConvertible {
                
        //        public var description: String {
        //"""
        //    title: \(title),
        //    version: \(version),
        //    productIdOrSlug: \(productIdOrSlug),
        //    description: \(String(describing: description)),
        //    mandatory: \(String(describing: mandatory))
        //"""
        //        }

        public var debugDescription: String {
"""
EditArguments: {
    title: \(title),
    version: \(version),
    productIdOrSlug: \(productIdOrSlug),
    description: \(String(describing: description)),
    mandatory: \(String(describing: mandatory))
}
"""
        }
            ///Title of the firmware version. Handy for quickly identifying the firmware
        public let title: String
        
            ///The version number of the firmware binary you are uploading
        public let version: String

            ///Product ID or slug
        public let productIdOrSlug: String
        
            ///Optionally provide a description for the new firmware version
        public let description: String?
        
            ///[Enterprise only] Flag this firmware release as a mandatory release so that product upgrades and downgrades apply this version of firmware before flashing the targeted version.
        public let mandatory: Bool?
        
        public init(title: String, version: String, productIdOrSlug: ProductID, description: String?, mandatory: Bool? = false) {
            self.title = title
            self.version = String(version)
            self.productIdOrSlug = String(productIdOrSlug.rawValue)
            self.description = description
            self.mandatory = mandatory
        }
    }

    public struct ReleaseArguments: CustomDebugStringConvertible, CustomStringConvertible {
        
        
        public var description: String {
"""
    productIdOrSlug: \(productIdOrSlug),
    version: \(version),
    product_default: \(product_default),
    groups: \(groupsDescription),
    intelligent: \(intelligent)
"""
        }
        
        public var debugDescription: String {
"""
ReleaseArguments: {
    productIdOrSlug: \(productIdOrSlug),
    version: \(version),
    product_default: \(product_default),
    groups: \(groupsDescription),
    intelligent: \(intelligent)
}
"""
        }
        
        private var groupsDescription: String {
            if groups == nil {
                return "nil"
            } else if groups!.isEmpty {
                return "[]"
            }
            return """
[
        \(groups!.joined(separator: ",\n"))
    ]
"""
        }
        
        ///Product ID or slug
        public let productIdOrSlug: String
        
        ///firmware version number to release to the fleet
        public let version: String
        
        ///Pass true to set the firmware version as the product default release
        public let product_default: Bool
        
        ///An array of device groups to release the firmware to.
        public let groups: [String]?
       
            /// Flag this firmware release as an intelligent release so that devices do not need to reconnect to the cloud to receive the update and that they are informed of pending updates when devices are not available for updating.
        public let intelligent: Bool
        
        public init(productIdOrSlug: ProductID, version: Int, product_default: Bool, groups: [String]?, intelligent: Bool) {
            self.productIdOrSlug = String(productIdOrSlug.rawValue)
            self.version = String(version)
            self.product_default = product_default
            self.groups = groups
            self.intelligent = intelligent
        }
    }
}
