//
//  PCProductFirmware.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/14/23.
//

import Foundation
import Combine

public struct PCProductFirmware: Decodable {
    
        // MARK: - ProductFirmwareList
    public struct ProductFirmwareList: Codable, CustomDebugStringConvertible, CustomStringConvertible {
        
        
        /// A textual representation of this instance.
        ///
        /// Calling this property directly is discouraged. Instead, convert an
        /// instance of any type to a string by using the `String(describing:)`
        /// initializer. This initializer works with any type, and uses the custom
        /// `description` property for types that conform to
        /// `CustomStringConvertible`:
        ///
        ///     struct Point: CustomStringConvertible {
        ///         let x: Int, y: Int
        ///
        ///         var description: String {
        ///             return "(\(x), \(y))"
        ///         }
        ///     }
        ///
        ///     let p = Point(x: 21, y: 30)
        ///     let s = String(describing: p)
        ///     print(s)
        ///     // Prints "(21, 30)"
        ///
        /// The conversion of `p` to a string in the assignment to `s` uses the
        /// `Point` type's `description` property.
       public var description: String {
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
        
        /// A textual representation of this instance, suitable for debugging.
        ///
        /// Calling this property directly is discouraged. Instead, convert an
        /// instance of any type to a string by using the `String(reflecting:)`
        /// initializer. This initializer works with any type, and uses the custom
        /// `debugDescription` property for types that conform to
        /// `CustomDebugStringConvertible`:
        ///
        ///     struct Point: CustomDebugStringConvertible {
        ///         let x: Int, y: Int
        ///
        ///         var debugDescription: String {
        ///             return "(\(x), \(y))"
        ///         }
        ///     }
        ///
        ///     let p = Point(x: 21, y: 30)
        ///     let s = String(reflecting: p)
        ///     print(s)
        ///     // Prints "(21, 30)"
        ///
        /// The conversion of `p` to a string in the assignment to `s` uses the
        /// `Point` type's `debugDescription` property.
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
        
        ///The id of the product firmare.
        public let id: String
        
        ///The version of the product firmware.
        public let version: Int
        
        ///The firmwares title
        public let title: String
        
        ///Supplemental information about the frimware.
        public let info: String
        
        ///The namd of the firmware.
        public let name: String
        
        ///The size of the firmware in bytes.
        public let size: Int
        
        ///Whether this is the default product firmware.
        public let productDefault: Bool
        
        ///The date the firmware was uploaded.
        public let uploadedOn: String
        
        ///The id of the product that owns the firmware.
        public let productID: Int
        
        ///[Enterprise only] Product upgrades and downgrades must install this firmware first.
        public let mandatory: Bool
        
        ///The user who uploaded the frimware.
        public let uploadedBy: UploadedBy
        
        ///Groups the firmware is released to.
        public let groups: [String]
        
        private enum CodingKeys: String, CodingKey {
            case id = "_id"
            case version, title
            case info = "description"
            case name, size
            case productDefault = "product_default"
            case uploadedOn = "uploaded_on"
            case productID = "product_id"
            case mandatory
            case uploadedBy = "uploaded_by"
            case groups
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<PCProductFirmware.ProductFirmwareList.CodingKeys> = try decoder.container(keyedBy: PCProductFirmware.ProductFirmwareList.CodingKeys.self)
            self.id = try container.decode(String.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.id)
            self.version = try container.decode(Int.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.version)
            self.title = try container.decode(String.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.title)
            self.info = try container.decode(String.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.info)
            self.name = try container.decode(String.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.name)
            self.size = try container.decode(Int.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.size)
            self.productDefault = try container.decode(Bool.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.productDefault)
            self.uploadedOn = try container.decode(String.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.uploadedOn)
            self.productID = try container.decode(Int.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.productID)
            self.mandatory = try container.decode(Bool.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.mandatory)
            self.groups = try container.decode([String].self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.groups)
            let uploadedBy = try container.decode(PCProductFirmware.UploadedBy.self, forKey: PCProductFirmware.ProductFirmwareList.CodingKeys.uploadedBy)
            self.uploadedBy = uploadedBy["username"]
        }
    }
}

extension PCProductFirmware {
        
    public struct UploadArguments: CustomDebugStringConvertible {
        
        
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
        /// A textual representation of this instance, suitable for debugging.
        public var debugDescription: String {
"""
PCProductFirmware: {
    version: \(version),
    title: \(title),
    description: \(String(describing: description)),
    mandatory: \(String(describing: mandatory))
}
"""
        }

        ///The version number of the firmware binary you are uploading
        public let version: Int

            ///Title of the firmware version. Handy for quickly identifying the firmware
        public let title: String
                    
            
            ///Optionally provide a description for the new firmware version
        public let description: String?
        
            ///[Enterprise only] Flag this firmware release as a mandatory release so that product upgrades and downgrades apply this version of firmware before flashing the targeted version.
        public let mandatory: Bool?
        
        public init(version: Int, title: String, file: FilePath, productIdOrSlug: ProductID, description: String?, mandatory: Bool?) {
            self.version = version
            self.title = title
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
    description: \(String(describing: description)),
    mandatory: \(String(describing: mandatory))
}
"""
        }
            ///Title of the firmware version. Handy for quickly identifying the firmware
        public let title: String
        
            ///The version number of the firmware binary you are uploading
        public let version: String
        
            ///Optionally provide a description for the new firmware version
        public let description: String?
        
            ///[Enterprise only] Flag this firmware release as a mandatory release so that product upgrades and downgrades apply this version of firmware before flashing the targeted version.
        public let mandatory: Bool?
        
        public init(title: String, version: String, description: String?, mandatory: Bool? = false) {
            self.title = title
            self.version = String(version)
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


public extension PCProduct {
    
    
    
    ///Get product firmware
    ///
    ///Get a specific version of product firmware.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    /// - Requires: Scope of firmware:get
    /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func getFirmware(_ product: ProductID, version: String = "latest", token: PCAccessToken) -> Future<PCProductFirmware.ProductFirmwareList, PCError> {
        PCNetwork.shared.cloudRequest(.getProductFirmware(productIdOrSlug: product, version: version, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }
    
    
    
    ///Get product firmware
    ///
    ///Get a specific version of product firmware.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    /// - Requires: Scope of firmware:get
    /// - Throws: PCError
    /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func getFirmware(_ product: ProductID, version: String = "latest", token: PCAccessToken) async throws -> PCProductFirmware.ProductFirmwareList {
        try await PCNetwork.shared.cloudRequest(.getProductFirmware(productIdOrSlug: product, version: version, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }

    
    
    ///Get product firmware
    ///
    ///Get a specific version of product firmware.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    /// - Requires: Scope of firmware:get
    /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: PCProductFirmware.ProductFirmwareList
    static func getFirmware(_ product: ProductID, version: String = "latest", token: PCAccessToken, completion: @escaping (Result<PCProductFirmware.ProductFirmwareList, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.getProductFirmware(productIdOrSlug: product, version: version, token: token), type: PCProductFirmware.ProductFirmwareList.self, completion: completion)
    }
    
    
    
    
    ///ListAllProductFirmwares
    ///
    ///List all versions of product firmware
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware
    ///
    ///
    ///
    /// - Requires: Scope of firmware:list
    /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func listFirmware(_ product: ProductID, token: PCAccessToken)
    -> Future<PCProductFirmware.ProductFirmwareList, PCError> {
        PCNetwork.shared.cloudRequest(.listAllProductFirmwares(productIdOrSlug: product, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }
    
    
    
    ///ListAllProductFirmwares
    ///
    ///List all versions of product firmware
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware
    ///
    ///
    ///
    /// - Requires: Scope of firmware:list
    /// - Throws: PCError
    /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func listFirmware(_ product: ProductID, token: PCAccessToken)
    async throws -> PCProductFirmware.ProductFirmwareList {
        try await PCNetwork.shared.cloudRequest(.listAllProductFirmwares(productIdOrSlug: product, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }
    
    
    
    ///ListAllProductFirmwares
    ///
    ///List all versions of product firmware
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware
    ///
    ///
    ///
    /// - Requires: Scope of firmware:list
    /// - Parameter productIdOrSlug: Product ID or slug. Product endpoint only.
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: PCProductFirmware.ProductFirmwareList
    static func listFirmware(_ product: ProductID, token: PCAccessToken, completion: @escaping (Result<PCProductFirmware.ProductFirmwareList, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.listAllProductFirmwares(productIdOrSlug: product, token: token), type: PCProductFirmware.ProductFirmwareList.self, completion: completion)
    }
    
    
    ///Upload product firmware
    ///
    ///Upload a new firmware version to a product.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/firmware
    ///
    ///
    /// - Requires: Scope of firmware:create
    /// - Parameter firmware:A binary file encoded in multipart/form-data format containing the contents of the product firmware (binary is also accepted for backwards compatibility)
    /// - Parameter product: The id of the product to recieve the firmware.
    /// - Parameter with: The arguments to be supplied to the server.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func upload(_ firmware: FilePath, to product: ProductID, with args: PCProductFirmware.UploadArguments, token: PCAccessToken)
    -> Future<PCProductFirmware.ProductFirmwareList, PCError> {
        
        PCNetwork.shared.cloudRequest(.uploadProductFirmware(productID: product, path: firmware, arguments: args, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }
    
    
    
    
    ///Upload product firmware
    ///
    ///Upload a new firmware version to a product.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/firmware
    ///
    ///
    /// - Requires: Scope of firmware:create
    /// - Throws: PCError
    /// - Parameter firmware:A binary file encoded in multipart/form-data format containing the contents of the product firmware (binary is also accepted for backwards compatibility)
    /// - Parameter product: The id of the product to recieve the firmware.
    /// - Parameter with: The arguments to be supplied to the server.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func upload(_ firmware: FilePath, to product: ProductID, with args: PCProductFirmware.UploadArguments, token: PCAccessToken) async throws -> PCProductFirmware.ProductFirmwareList {
        
        try await PCNetwork.shared.cloudRequest(.uploadProductFirmware(productID: product, path: firmware, arguments: args, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }

    
    
    
    ///Upload product firmware
    ///
    ///Upload a new firmware version to a product.
    ///
    /// - calls: POST /v1/products/:productIdOrSlug/firmware
    ///
    ///
    /// - Requires: Scope of firmware:create
    /// - Parameter firmware:A binary file encoded in multipart/form-data format containing the contents of the product firmware (binary is also accepted for backwards compatibility)
    /// - Parameter product: The id of the product to recieve the firmware.
    /// - Parameter with: The arguments to be supplied to the server.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func upload(_ firmware: FilePath, to product: ProductID, with args: PCProductFirmware.UploadArguments, token: PCAccessToken, completion: @escaping (Result<PCProductFirmware.ProductFirmwareList, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.uploadProductFirmware(productID: product, path: firmware, arguments: args, token: token), type: PCProductFirmware.ProductFirmwareList.self, completion: completion)
    }

    
    
    
    ///Edit product firmware
    ///
    ///Edit a specific product firmware version
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    ///
    /// - Requires: Scope of firmware:update
    /// - Parameter product: The productID to apply the firmware to .
    /// - Parameter Arguments: The arguments to be supplied to the server.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func editFirmware(for product: ProductID, arguments: PCProductFirmware.EditArguments, token: PCAccessToken) -> Future<PCProductFirmware.ProductFirmwareList, PCError> {
        PCNetwork.shared.cloudRequest(.editProductFirmware(productID: product, arguments: arguments, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }
    
    
    
    
    ///Edit product firmware
    ///
    ///Edit a specific product firmware version
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    ///
    /// - Requires: Scope of firmware:update
    /// - Parameter product: The productID to apply the firmware to .
    /// - Parameter Arguments: The arguments to be supplied to the server.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func editFirmware(for product: ProductID, arguments: PCProductFirmware.EditArguments, token: PCAccessToken) async throws -> PCProductFirmware.ProductFirmwareList {
        try await PCNetwork.shared.cloudRequest(.editProductFirmware(productID: product, arguments: arguments, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }

    
    
    
    ///Edit product firmware
    ///
    ///Edit a specific product firmware version
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    ///
    /// - Requires: Scope of firmware:update
    /// - Parameter product: The productID to apply the firmware to .
    /// - Parameter Arguments: The arguments to be supplied to the server.
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: PCProductFirmware.ProductFirmwareList
    static func editFirmware(for product: ProductID, arguments: PCProductFirmware.EditArguments, token: PCAccessToken, completion: @escaping (Result<PCProductFirmware.ProductFirmwareList, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.editProductFirmware(productID: product, arguments: arguments, token: token), type: PCProductFirmware.ProductFirmwareList.self, completion: completion)
    }
    
    
    
    
    ///Download firmware binary
    ///
    ///Retrieve and download the original binary of a version of product firmware.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version/binary
    ///
    ///
    /// - Requires: Scope of firmware.binary:get
    /// - Parameter PCProductFirmware.UploadArguments: The arguments to be supplied to the server.
    /// - Parameter version: Version number of firmware to retrieve
    /// - Parameter token: A currently active access token.
    /// - Returns: The binary file of the requested product firmware version
    static func downloadFirmwareBinary(for product: ProductID, version: Int, token: PCAccessToken) -> Future<Data, PCError> {
        PCNetwork.shared.cloudRequest(.downloadFirmwareBinary(productIdOrSlug: product, version: version, token: token), type: Data.self)
    }
    
    
    
    
    ///Download firmware binary
    ///
    ///Retrieve and download the original binary of a version of product firmware.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version/binary
    ///
    ///
    /// - Requires: Scope of firmware.binary:get
    /// - Throws: PCError
    /// - Parameter PCProductFirmware.UploadArguments: The arguments to be supplied to the server.
    /// - Parameter version: Version number of firmware to retrieve
    /// - Parameter token: A currently active access token.
    /// - Returns: The binary file of the requested product firmware version
    static func downloadFirmwareBinary(for product: ProductID, version: Int, token: PCAccessToken) async throws -> Data {
        try await PCNetwork.shared.cloudRequest(.downloadFirmwareBinary(productIdOrSlug: product, version: version, token: token), type: Data.self)
    }

    
    
    
    ///Download firmware binary
    ///
    ///Retrieve and download the original binary of a version of product firmware.
    ///
    /// - calls: GET /v1/products/:productIdOrSlug/firmware/:version/binary
    ///
    ///
    /// - Requires: Scope of firmware.binary:get
    /// - Parameter PCProductFirmware.UploadArguments: The arguments to be supplied to the server.
    /// - Parameter version: Version number of firmware to retrieve
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure containing The binary data of the requested product firmware version or an PCError.
    static func downloadFirmwareBinary(for product: ProductID, version: Int, token: PCAccessToken, completion: @escaping (Result<Data, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.downloadFirmwareBinary(productIdOrSlug: product, version: version, token: token), type: Data.self, completion: completion)
    }
    
    
    
    ///Release product firmware
    ///
    ///Release a version of firmware to the fleet of product devices. When releasing as the product default, all non-development devices that are not individually locked to a version of product firmware will automatically download and run this version of firmware the next time they handshake with the cloud.You can also release firmware to specific groups for more fine-grained firmware management.Note: Before releasing firmware for the first time, the firmware must be running on at least one device in your product fleet that has successfully re-connected to the Particle cloud.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/firmware/release
    ///
    ///
    ///
    /// - Requires: Scope of firmware:release
    /// - Parameter product: The productID to apply the firmware to .
    /// - Parameter arguments: PCProductFirmware.ReleaseArguments
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func releaseProductFirmware(for product: ProductID, arguments: PCProductFirmware.ReleaseArguments, token: PCAccessToken) -> Future<PCProductFirmware.ProductFirmwareList, PCError> {
        PCNetwork.shared.cloudRequest(.releaseProductFirmware(productID: product, arguments: arguments, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }
    
    
    
    ///Release product firmware
    ///
    ///Release a version of firmware to the fleet of product devices. When releasing as the product default, all non-development devices that are not individually locked to a version of product firmware will automatically download and run this version of firmware the next time they handshake with the cloud.You can also release firmware to specific groups for more fine-grained firmware management.Note: Before releasing firmware for the first time, the firmware must be running on at least one device in your product fleet that has successfully re-connected to the Particle cloud.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/firmware/release
    ///
    ///
    ///
    /// - Requires: Scope of firmware:release
    /// - Throws: PCError
    /// - Parameter product: The productID to apply the firmware to .
    /// - Parameter arguments: PCProductFirmware.ReleaseArguments
    /// - Parameter token: A currently active access token.
    /// - Returns: PCProductFirmware.ProductFirmwareList
    static func releaseProductFirmware(for product: ProductID, arguments: PCProductFirmware.ReleaseArguments, token: PCAccessToken) async throws -> PCProductFirmware.ProductFirmwareList {
        try await PCNetwork.shared.cloudRequest(.releaseProductFirmware(productID: product, arguments: arguments, token: token), type: PCProductFirmware.ProductFirmwareList.self)
    }
    
    
    
    ///Release product firmware
    ///
    ///Release a version of firmware to the fleet of product devices. When releasing as the product default, all non-development devices that are not individually locked to a version of product firmware will automatically download and run this version of firmware the next time they handshake with the cloud.You can also release firmware to specific groups for more fine-grained firmware management.Note: Before releasing firmware for the first time, the firmware must be running on at least one device in your product fleet that has successfully re-connected to the Particle cloud.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/firmware/release
    ///
    ///
    ///
    /// - Requires: Scope of firmware:release
    /// - Parameter product: The productID to apply the firmware to .
    /// - Parameter arguments: PCProductFirmware.ReleaseArguments
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure containing PCProductFirmware.ProductFirmwareList or a PCError
    static func releaseProductFirmware(for product: ProductID, arguments: PCProductFirmware.ReleaseArguments, token: PCAccessToken, completion: @escaping (Result<PCProductFirmware.ProductFirmwareList, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.releaseProductFirmware(productID: product, arguments: arguments, token: token), type: PCProductFirmware.ProductFirmwareList.self, completion: completion)
    }
    
    
    
    
    ///Delete unreleased firmware binary
    ///
    ///Delete a version of product firmware that has never been released.
    ///
    /// - calls: DELETE /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    ///
    /// - Requires: Scope of firmware:remove
    /// - Parameter product: Product ID or slug. Product endpoint only.
    /// - Parameter version: The version number to delete.
    /// - Parameter token: A currently active access token.
    /// - Returns: Future of type Bool
    static func deleteUnreleasedFirmware(_ product: ProductID, version: Int, token: PCAccessToken) -> Future<Bool, PCError> {
        return Future { promise in
            Task {
                do {
                    promise(.success(try await PCNetwork.shared.cloudRequest(.deleteUnreleasedFirmwareBinary(productIdOrSlug: product, version: version, token: token), type: ServerResponses.NoResponse.self).ok))
                } catch {
                    
                    promise(.failure(error as! PCError))
                }
            }
        }
    }
    
    
    
    
    ///Delete unreleased firmware binary
    ///
    ///Delete a version of product firmware that has never been released.
    ///
    /// - calls: DELETE /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    ///
    /// - Requires: Scope of firmware:remove
    /// - Throws: PCError
    /// - Parameter product: Product ID or slug. Product endpoint only.
    /// - Parameter version: The version number to delete.
    /// - Parameter token: A currently active access token.
    /// - Returns: Bool
    static func deleteUnreleasedFirmware(_ product: ProductID, version: Int, token: PCAccessToken) async throws -> Bool {
        try await PCNetwork.shared.cloudRequest(.deleteUnreleasedFirmwareBinary(productIdOrSlug: product, version: version, token: token), type: ServerResponses.NoResponse.self).ok
    }
    
    
    
    
    ///Delete unreleased firmware binary
    ///
    ///Delete a version of product firmware that has never been released.
    ///
    /// - calls: DELETE /v1/products/:productIdOrSlug/firmware/:version
    ///
    ///
    ///
    /// - Requires: Scope of firmware:remove
    /// - Parameter product: Product ID or slug. Product endpoint only.
    /// - Parameter version: The version number to delete.
    /// - Parameter token: A currently active access token.
    /// - Returns: Closure providing Result of type Bool
    static func deleteUnreleasedFirmware(_ product: ProductID, version: Int, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.deleteUnreleasedFirmwareBinary(productIdOrSlug: product, version: version, token: token), type: ServerResponses.NoResponse.self) { response in
            
            switch response {
            case .success(let result):
                completion(.success(result.ok))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
