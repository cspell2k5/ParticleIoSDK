//
//  PCFirmware.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/14/23.
//

import Foundation
import Combine


public typealias FilePath = String

    /// - Important: Firmware API limits : While compiling source code using the cloud compiler, or flashing a device with source code, there are limits: Maximum time to compile: 120 seconds, Maximum source code size: 50 MB. This affects the following endpoints: POST /v1/binaries and PUT /v1/devices/:deviceId
public struct PCFirmware: Decodable {
    
        // MARK: - CompilationResponse
    public struct CompilationResponse: Decodable {
        public let ok: Bool
        public let binaryID: String
        public let binaryURL: String
        public let buildTargetVersion: String
        public let expiresAt: String
        public let sizeInfo: String
        
        enum CodingKeys: String, CodingKey {
            case ok
            case binaryID = "binary_id"
            case binaryURL = "binary_url"
            case buildTargetVersion = "build_target_version"
            case expiresAt = "expires_at"
            case sizeInfo
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
}

extension PCFirmware {
    
        // MARK: - FlashResponse
    public struct FlashResponse: Decodable {
        public let id, status: String
        
        private init(id: String, status: String) {
            self.id = id
            self.status = status
        }
    }
}

extension PCFirmware {
     
    // MARK: - ListResponse
    public struct ListResponse: Decodable {
        public let targets: [Target]
        public let platforms: [String : Int]
        public let defaultVersions: [DefaultVersions]
        
        enum CodingKeys: String, CodingKey {
            case targets, platforms
            case defaultVersions = "default_versions"
        }
        
        private init(targets: [Target], platforms: [String: Int], defaultVersions: [DefaultVersions]) {
            self.targets = targets
            self.platforms = platforms
            self.defaultVersions = defaultVersions
        }
    }
    
        // MARK: - Target
    public struct Target: Decodable {
        public let platforms, prereleases: [Int]
        public let firmwareVendor: String
        public let version: String
        
        private enum CodingKeys: String, CodingKey {
            case platforms, prereleases, version, firmwareVendor = "firmware_vendor"
        }
        
        private init(platforms: [Int], prereleases: [Int], firmwareVendor: String, version: String) {
            self.platforms = platforms
            self.prereleases = prereleases
            self.firmwareVendor = firmwareVendor
            self.version = version
        }
    }
    
    
        // MARK: - DefaultVersions
    public struct DefaultVersions: Decodable {
        public let defaultVersions: [String: String]
        
        private init(defaultVersions: [String: String]) {
            self.defaultVersions = defaultVersions
        }
    }
}

extension PCFirmware {
    
        // MARK: - DeviceFirmareLockResponse
    ///Response givin by the server when locking or unlocking a device firmwaret.
    public struct DeviceFirmareLockResponse: Decodable {
        
        ///The id of the device afffected.
       public let id: String
        
        ///The desired firmware version.
       public let desiredFirmwareVersion: Int
        
        ///Time the device was updated.
       public let updatedAt: Date
        
        private enum CodingKeys: String, CodingKey {
            case id, desiredFirmwareVersion = "desired_firmware_version", updatedAt = "updated_at"
        }
        
        ///Required initializer.
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.desiredFirmwareVersion = try container.decode(Int.self, forKey: .desiredFirmwareVersion)
            self.updatedAt = try Date.date(jSonDate: try container.decode(String.self, forKey: .updatedAt))
        }
    }
}

extension PCFirmware {
    
    // MARK: - MarkDeviceForDevelopmentResponse
    ///Response givin by the server when setting or freeing a device from development.
    public struct MarkDeviceForDevelopmentResponse: Decodable {
        
        ///The id of the device afffected.
        public let id: String
        
        ///Bool indicating if it is now a development device
        public let development: Bool
        
        ///Time the device was updated.
        public let updatedAt: Date
        
        private enum CodingKeys: String, CodingKey {
            case id, development
            case updatedAt = "updated_at"
        }
        
        ///Required initializer.
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.development = try container.decode(Bool.self, forKey: .development)
            self.updatedAt = try Date.date(jSonDate: try container.decode(String.self, forKey: .updatedAt))
        }
    }
}


public extension PCFirmware {
    
    
    ///Update device firmware
    ///
    ///Update the device firmware from source or binary
    /// - usage:  PUT /v1/devices/:deviceIdUpdate
    ///
    ///
    /// - Parameter deviceId:The id of the device to be flashed
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter token: A currently active access token.
    /// - Returns: ServerResponses.Standard
    static func updateFirmware(_ device: DeviceID, buildTargetVersion version: String = "latest", token: PCAccessToken) async throws -> ServerResponses.Standard {
        try await PCNetwork.shared.cloudRequest(.updateDeviceFirmware(deviceID: device, version: version, token: token), type: ServerResponses.Standard.self)
    }
    
    
    ///Update device firmware
    ///
    ///Update the device firmware from source or binary
    /// - usage:  PUT /v1/devices/:deviceIdUpdate
    ///
    ///
    /// - Parameter deviceId:The id of the device to be flashed
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter token: A currently active access token.
    /// - Returns: ServerResponses.Standard
    static func updateFirmware(_ device: DeviceID, buildTargetVersion version: String = "latest", token: PCAccessToken, completion: @escaping (Result<ServerResponses.Standard, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.updateDeviceFirmware(deviceID: device, version: version, token: token), type: ServerResponses.Standard.self, completion: completion)
    }



    ///Flash device firmware
    ///
    ///Flash the device firmware from source.
    ///
    /// - calls PUT /v1/devices/:deviceId
    ///
    /// Usage:
    ///
    ///
    ///
    ///
    /// - Parameter deviceID: The id of the device to be flashed.
    /// - Throws: PCError
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter sourceCode: The paths of the source code to be compiled. Upload is done with the source code encoded in multipart/form-data format
    /// - Returns: PCFirmware.FlashResponse
    /// - Parameter token: A currently active access token.
    static func flashDevice(_ device: DeviceID, withSource paths: [FilePath], version: String = "latest", token: PCAccessToken) async throws -> PCFirmware.FlashResponse {
        try await  PCNetwork.shared.cloudRequest(.flashDeviceWithSourceCode(deviceID: device, sourceCodePaths: paths, version: version, token: token), type: PCFirmware.FlashResponse.self)
    }
    
    
    
    ///Flash device firmware
    ///
    ///Flash the device firmware from source.
    ///
    /// - calls PUT /v1/devices/:deviceId
    ///
    /// Usage:
    ///
    ///
    ///
    ///
    /// - Parameter deviceID: The id of the device to be flashed.
    /// - Throws: PCError
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter sourceCodePaths: The paths of the source code to be compiled. Upload is done with the source code encoded in multipart/form-data format
    /// - Returns: PCFirmware.FlashResponse
    /// - Parameter token: A currently active access token.
    static func flashDevice(_ device: DeviceID, withSource paths: [FilePath], version: String = "latest", token: PCAccessToken, completion: @escaping (Result<PCFirmware.FlashResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.flashDeviceWithSourceCode(deviceID: device, sourceCodePaths: paths, version: version, token: token), type: PCFirmware.FlashResponse.self, completion: completion)
    }
    
    
    
    ///Flash a device with a pre-compiled binary
    ///
    ///Flash the device firmware from binary.
    /// - calls PUT /v1/devices/:deviceId
    ///
    ///
    ///
    /// - Parameter deviceID: The id of the device to be flashed
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter binary: The path to the  pre-compiled. Upload is done in binary encoded in multipart/form-data format
    /// - Parameter token: A currently active access token.
    /// - Returns: PCFirmware.FlashResponse
    static func flash(device: DeviceID, withBinary binary: FilePath, version: String = "latest", token: PCAccessToken) async throws -> PCFirmware.FlashResponse {
        
        try await PCNetwork.shared.cloudRequest(.flashDeviceWithPreCompiledBinary(deviceID: device, build_target_version: version, file: binary, token: token), type: PCFirmware.FlashResponse.self)
    }
    
    
    
    ///Flash a device with a pre-compiled binary
    ///
    ///Flash the device firmware from binary.
    /// - calls PUT /v1/devices/:deviceId
    ///
    ///
    ///
    /// - Parameter deviceID: The id of the device to be flashed
    /// - Parameter version: The firmware version to compile against. Defaults to latest
    /// - Parameter binary: The path to the  pre-compiled. Upload is done in binary encoded in multipart/form-data format
    /// - Parameter token: A currently active access token.
    /// - Returns: PCFirmware.FlashResponse
    static func flash(device: DeviceID, withBinary binary: FilePath, version: String = "latest", token: PCAccessToken, completion: @escaping (Result<PCFirmware.FlashResponse, PCError>) -> Void) {
        
        PCNetwork.shared.cloudRequest(.flashDeviceWithPreCompiledBinary(deviceID: device, build_target_version: version, file: binary, token: token), type: PCFirmware.FlashResponse.self, completion: completion)
    }
    
    
    
    ///Compile source code
    ///
    ///Compile source code into a binary for a device.
    ///
    /// - callls: POST /v1/binaries
    ///
    ///
    ///
    ///
    /// - Throws: PCError
    /// - Parameter filePath: The path to the source code encoded in multipart/form-data format.
    /// - Parameter platform_id: The platform ID to target the compilation.
    /// - Parameter product_id: The product to target for compilation
    /// - Parameter build_target_version: The firmware version to compile against. Defaults to "latest".
    /// - Parameter token: A currently active access token.
    /// - Returns: PCFirmware.CompilationResponse
    static func compile(_ source: [FilePath], for product: ProductID, platform: PlatformID, version: String = "latest", token: PCAccessToken) async throws ->  PCFirmware.CompilationResponse {
        try await PCNetwork.shared.cloudRequest(.compileSourceCode(filePaths: source, platform_id: platform, product_id: product, build_target_version: version, token: token), type: PCFirmware.CompilationResponse.self)
    }
    
    
    
    ///Compile source code
    ///
    ///Compile source code into a binary for a device.
    ///
    /// - callls: POST /v1/binaries
    ///
    ///
    ///
    ///
    /// - Parameter filePath: The path to the source code encoded in multipart/form-data format.
    /// - Parameter platform_id: The platform ID to target the compilation.
    /// - Parameter product_id: The product to target for compilation
    /// - Parameter build_target_version: The firmware version to compile against. Defaults to "latest".
    /// - Parameter token: A currently active access token.
    /// - Parameter completion:Closure containing  result of PCFirmware.CompilationResponse or PCError
    static func compile(_ source: [FilePath], for product: ProductID, platform: PlatformID, version: String = "latest", token: PCAccessToken, completion: @escaping (Result<PCFirmware.CompilationResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.compileSourceCode(filePaths: source, platform_id: platform, product_id: product, build_target_version: version, token: token), type: PCFirmware.CompilationResponse.self, completion: completion)
    }

    
    
    ///List firmware build targets
    ///
    ///Lists the firmware versions for all platforms that can be used as build targets during firmware compilation.
    ///
    /// - calls: GET /v1/build_targets
    ///
    ///
    ///
    /// - note: As of April, 2023, an access token is no longer required to call this API. ie: you don't have to be logged in.
    /// - throws: PCError
    /// - Parameter featured: When true, show most relevant (featured) build targets only.
    /// - Returns: PCFirmware.ListResponse
    static func listTargets(featured: Bool = true) async throws -> PCFirmware.ListResponse {
        try await PCNetwork.shared.cloudRequest(.listFirmwareBuildTargets(featured: featured), type: PCFirmware.ListResponse.self)
    }
    
    
    
    ///List firmware build targets
    ///
    ///Lists the firmware versions for all platforms that can be used as build targets during firmware compilation.
    ///
    /// - calls: GET /v1/build_targets
    ///
    ///
    ///
    /// - note: As of April, 2023, an access token is no longer required to call this API. ie: you don't have to be logged in.
    ///
    /// - Parameter featured: When true, show most relevant (featured) build targets only.
    /// - Parameter completion:Closure providing an Result of  PCFirmware.ListResponse or PCError.
    static func listTargets(featured: Bool = true, completion: @escaping (Result<PCFirmware.ListResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.listFirmwareBuildTargets(featured: featured), type: PCFirmware.ListResponse.self, completion: completion)
    }
    
    
    
    ///Lock product device.
    ///
    ///Locks a product device to a specific version of product firmware. This device will download and run this firmware if it is not already running it the next time it connects to the cloud. You can optionally trigger an immediate update to this firmware for devices that are currently online.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
    ///
    ///
    ///
    /// - Requires: Scope of  devices:update
    /// - Parameter on:The id of the device to be flashed
    /// - Parameter in: Product ID or slug. Product endpoint only.
    /// - Parameter withVersion: The firmware version the device should be locked to
    /// - Parameter flashImmediately: Set to true to immediately flash to a device. Will only successfully deliver the firmware update if the device is currently online and connected to the cloud.
    /// - Parameter token: A currently active access token with required scope.
    /// - Returns: PCFirmware.DeviceFirmareLockResponse
    static func lockFirmware(on deviceID: DeviceID, in product: ProductID, withVersion: String, flashImmediately: Bool, token: PCAccessToken) async throws -> PCFirmware.DeviceFirmareLockResponse {

        try await PCNetwork.shared.cloudRequest(.lockProductDevice(deviceID: deviceID, productIdOrSlug: product, desired_firmware_version: withVersion, flash: flashImmediately, token: token), type: PCFirmware.DeviceFirmareLockResponse.self)
    }
    
    
    
    ///Lock product device.
    ///
    ///Locks a product device to a specific version of product firmware. This device will download and run this firmware if it is not already running it the next time it connects to the cloud. You can optionally trigger an immediate update to this firmware for devices that are currently online.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
    ///
    ///
    ///
    /// - Requires: Scope of  devices:update
    /// - Parameter on:The id of the device to be flashed
    /// - Parameter in: Product ID or slug. Product endpoint only.
    /// - Parameter withVersion: The firmware version the device should be locked to
    /// - Parameter flashImmediately: Set to true to immediately flash to a device. Will only successfully deliver the firmware update if the device is currently online and connected to the cloud.
    /// - Parameter token: A currently active access token with required scope.
    /// - Returns: PCFirmware.DeviceFirmareLockResponse
    static func lockFirmware(on deviceID: DeviceID, in product: ProductID, withVersion: String, flashImmediately: Bool, token: PCAccessToken, completion: @escaping (Result<PCFirmware.DeviceFirmareLockResponse, PCError>) -> Void) {

        PCNetwork.shared.cloudRequest(.lockProductDevice(deviceID: deviceID, productIdOrSlug: product, desired_firmware_version: withVersion, flash: flashImmediately, token: token), type: PCFirmware.DeviceFirmareLockResponse.self, completion: completion)
    }
    
    
    
    ///Unlock product device
    ///
    ///Unlocks a product device from receiving and running a specific version of product firmware. The device will now be eligible to receive released firmware in the product.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
    ///
    ///
    ///
    /// - Requires; Scope of devices:update
    /// - Parameter on:The id of the device to be flashed
    /// - Parameter in: Product ID or slug. Product endpoint only.
    /// - Parameter token: A currently active access token.
    /// - Returns: PCFirmware.DeviceFirmareLockResponse
    static func unlockFirmware(on device: DeviceID, in product: ProductID, token: PCAccessToken) async throws -> PCFirmware.DeviceFirmareLockResponse {
        try await PCNetwork.shared.cloudRequest(.unlockProductDevice(deviceID: device, productIdOrSlug: product, token: token), type: PCFirmware.DeviceFirmareLockResponse.self)
    }
    
    
    
    ///Unlock product device
    ///
    ///Unlocks a product device from receiving and running a specific version of product firmware. The device will now be eligible to receive released firmware in the product.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
    ///
    ///
    ///
    /// - Requires; Scope of devices:update
    /// - Parameter on:The id of the device to be flashed
    /// - Parameter in: Product ID or slug. Product endpoint only.
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure supplying a Result of PCFirmware.DeviceFirmareLockResponse or PCError.
    static func unlockFirmware(on device: DeviceID, in product: ProductID, token: PCAccessToken, completion: @escaping (Result<PCFirmware.DeviceFirmareLockResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.unlockProductDevice(deviceID: device, productIdOrSlug: product, token: token), type: PCFirmware.DeviceFirmareLockResponse.self, completion: completion)
    }
    
    
    
    ///Mark product development device
    ///
    ///Mark a device in a product fleet as a development device. Once marked as a development device, it will opt-out from receiving automatic product firmware updates. This includes both locked firmware as well as released firmware.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
    ///
    ///
    /// - Requires: Scope of devices:update
    /// - THrows: PCError
    /// - Parameter device:The id of the device to be flashed
    /// - Parameter in: Product ID or slug. Product endpoint only.
    /// - Parameter development: Set to true to mark as development device
    /// - Parameter token: A currently active access token.
    /// - Requires: PCFirmware.MarkDeviceForDevelopmentResponse
    static func mark(_ device: DeviceID, in product: ProductID, development: Bool, token: PCAccessToken) async throws -> PCFirmware.MarkDeviceForDevelopmentResponse {
        try await PCNetwork.shared.cloudRequest(.markProductDevelopmentDevice(deviceID: device, productIdOrSlug: product, development: development, token: token), type: PCFirmware.MarkDeviceForDevelopmentResponse.self)
    }
    
    
    
    ///Mark product development device
    ///
    ///Mark a device in a product fleet as a development device. Once marked as a development device, it will opt-out from receiving automatic product firmware updates. This includes both locked firmware as well as released firmware.
    ///
    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
    ///
    ///
    /// - Requires: Scope of devices:update
    /// - THrows: PCError
    /// - Parameter device:The id of the device to be flashed
    /// - Parameter in: Product ID or slug. Product endpoint only.
    /// - Parameter development: Set to true to mark as development device
    /// - Parameter token: A currently active access token.
    /// - Parameter completion: Closure supplying a Result of PCFirmware.MarkDeviceForDevelopmentResponse or PCError.
    static func mark(_ device: DeviceID, in product: ProductID, development: Bool, token: PCAccessToken, completion: @escaping (Result<PCFirmware.MarkDeviceForDevelopmentResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.markProductDevelopmentDevice(deviceID: device, productIdOrSlug: product, development: development, token: token), type: PCFirmware.MarkDeviceForDevelopmentResponse.self, completion: completion)
    }
}

//
//public extension PCFirmware {
//    
//    
//    ///Update device firmware
//    ///
//    ///Update the device firmware from source or binary
//    /// - usage:  PUT /v1/devices/:deviceIdUpdate
//    ///
//    ///
//    /// - Parameter deviceId:The id of the device to be flashed
//    /// - Parameter version: The firmware version to compile against. Defaults to latest
//    /// - Parameter token: A currently active access token.
//    /// - Returns: ServerResponses.Standard
//    static func updateFirmware(_ device: DeviceID, buildTargetVersion version: String = "latest", token: PCAccessToken) async throws -> ServerResponses.Standard {
//        try await PCNetwork.shared.cloudRequest(.updateDeviceFirmware(deviceID: device, version: version, token: token), type: ServerResponses.Standard.self)
//    }
//    
//    
//    ///Update device firmware
//    ///
//    ///Update the device firmware from source or binary
//    /// - usage:  PUT /v1/devices/:deviceIdUpdate
//    ///
//    ///
//    /// - Parameter deviceId:The id of the device to be flashed
//    /// - Parameter version: The firmware version to compile against. Defaults to latest
//    /// - Parameter token: A currently active access token.
//    /// - Returns: ServerResponses.Standard
//    static func updateFirmware(_ device: DeviceID, buildTargetVersion version: String = "latest", token: PCAccessToken, completion: @escaping (Result<ServerResponses.Standard, PCError>) -> Void) {
//        PCNetwork.shared.cloudRequest(.updateDeviceFirmware(deviceID: device, version: version, token: token), type: ServerResponses.Standard.self, completion: completion)
//    }
//
//
//
//    ///Flash device firmware
//    ///
//    ///Flash the device firmware from source.
//    ///
//    /// - calls PUT /v1/devices/:deviceId
//    ///
//    /// Usage:
//    ///
//    ///
//    ///
//    ///
//    /// - Parameter deviceID: The id of the device to be flashed.
//    /// - Throws: PCError
//    /// - Parameter version: The firmware version to compile against. Defaults to latest
//    /// - Parameter sourceCode: The paths of the source code to be compiled. Upload is done with the source code encoded in multipart/form-data format
//    /// - Returns: PCFirmware.FlashResponse
//    /// - Parameter token: A currently active access token.
//    static func flashDevice(_ device: DeviceID, withSource paths: [FilePath], version: String = "latest", token: PCAccessToken) async throws -> PCFirmware.FlashResponse {
//        try await  PCNetwork.shared.cloudRequest(.flashDeviceWithSourceCode(deviceID: device, sourceCodePaths: paths, version: version, token: token), type: PCFirmware.FlashResponse.self)
//    }
//    
//    
//    
//    ///Flash device firmware
//    ///
//    ///Flash the device firmware from source.
//    ///
//    /// - calls PUT /v1/devices/:deviceId
//    ///
//    /// Usage:
//    ///
//    ///
//    ///
//    ///
//    /// - Parameter deviceID: The id of the device to be flashed.
//    /// - Throws: PCError
//    /// - Parameter version: The firmware version to compile against. Defaults to latest
//    /// - Parameter sourceCodePaths: The paths of the source code to be compiled. Upload is done with the source code encoded in multipart/form-data format
//    /// - Returns: PCFirmware.FlashResponse
//    /// - Parameter token: A currently active access token.
//    static func flashDevice(_ device: DeviceID, withSource paths: [FilePath], version: String = "latest", token: PCAccessToken, completion: @escaping (Result<PCFirmware.FlashResponse, PCError>) -> Void) {
//        PCNetwork.shared.cloudRequest(.flashDeviceWithSourceCode(deviceID: device, sourceCodePaths: paths, version: version, token: token), type: PCFirmware.FlashResponse.self, completion: completion)
//    }
//    
//    
//    
//    ///Flash a device with a pre-compiled binary
//    ///
//    ///Flash the device firmware from binary.
//    /// - calls PUT /v1/devices/:deviceId
//    ///
//    ///
//    ///
//    /// - Parameter deviceID: The id of the device to be flashed
//    /// - Parameter version: The firmware version to compile against. Defaults to latest
//    /// - Parameter binary: The path to the  pre-compiled. Upload is done in binary encoded in multipart/form-data format
//    /// - Parameter token: A currently active access token.
//    /// - Returns: PCFirmware.FlashResponse
//    static func flash(device: DeviceID, withBinary binary: FilePath, version: String = "latest", token: PCAccessToken) async throws -> PCFirmware.FlashResponse {
//        
//        try await PCNetwork.shared.cloudRequest(.flashDeviceWithPreCompiledBinary(deviceID: device, build_target_version: version, file: binary, token: token), type: PCFirmware.FlashResponse.self)
//    }
//    
//    
//    
//    ///Flash a device with a pre-compiled binary
//    ///
//    ///Flash the device firmware from binary.
//    /// - calls PUT /v1/devices/:deviceId
//    ///
//    ///
//    ///
//    /// - Parameter deviceID: The id of the device to be flashed
//    /// - Parameter version: The firmware version to compile against. Defaults to latest
//    /// - Parameter binary: The path to the  pre-compiled. Upload is done in binary encoded in multipart/form-data format
//    /// - Parameter token: A currently active access token.
//    /// - Returns: PCFirmware.FlashResponse
//    static func flash(device: DeviceID, withBinary binary: FilePath, version: String = "latest", token: PCAccessToken, completion: @escaping (Result<PCFirmware.FlashResponse, PCError>) -> Void) {
//        
//        PCNetwork.shared.cloudRequest(.flashDeviceWithPreCompiledBinary(deviceID: device, build_target_version: version, file: binary, token: token), type: PCFirmware.FlashResponse.self, completion: completion)
//    }
//    
//    
//    
//    ///Compile source code
//    ///
//    ///Compile source code into a binary for a device.
//    ///
//    /// - callls: POST /v1/binaries
//    ///
//    ///
//    ///
//    ///
//    /// - Throws: PCError
//    /// - Parameter filePath: The path to the source code encoded in multipart/form-data format.
//    /// - Parameter platform_id: The platform ID to target the compilation.
//    /// - Parameter product_id: The product to target for compilation
//    /// - Parameter build_target_version: The firmware version to compile against. Defaults to "latest".
//    /// - Parameter token: A currently active access token.
//    /// - Returns: PCFirmware.CompilationResponse
//    static func compile(_ source: [FilePath], for product: ProductID, platform: PlatformID, version: String = "latest", token: PCAccessToken) async throws ->  PCFirmware.CompilationResponse {
//        try await PCNetwork.shared.cloudRequest(.compileSourceCode(filePaths: source, platform_id: platform, product_id: product, build_target_version: version, token: token), type: PCFirmware.CompilationResponse.self)
//    }
//    
//    
//    
//    ///Compile source code
//    ///
//    ///Compile source code into a binary for a device.
//    ///
//    /// - callls: POST /v1/binaries
//    ///
//    ///
//    ///
//    ///
//    /// - Parameter filePath: The path to the source code encoded in multipart/form-data format.
//    /// - Parameter platform_id: The platform ID to target the compilation.
//    /// - Parameter product_id: The product to target for compilation
//    /// - Parameter build_target_version: The firmware version to compile against. Defaults to "latest".
//    /// - Parameter token: A currently active access token.
//    /// - Parameter completion:Closure containing  result of PCFirmware.CompilationResponse or PCError
//    static func compile(_ source: [FilePath], for product: ProductID, platform: PlatformID, version: String = "latest", token: PCAccessToken, completion: @escaping (Result<PCFirmware.CompilationResponse, PCError>) -> Void) {
//        PCNetwork.shared.cloudRequest(.compileSourceCode(filePaths: source, platform_id: platform, product_id: product, build_target_version: version, token: token), type: PCFirmware.CompilationResponse.self, completion: completion)
//    }
//
//    
//    
//    ///List firmware build targets
//    ///
//    ///Lists the firmware versions for all platforms that can be used as build targets during firmware compilation.
//    ///
//    /// - calls: GET /v1/build_targets
//    ///
//    ///
//    ///
//    /// - note: As of April, 2023, an access token is no longer required to call this API. ie: you don't have to be logged in.
//    /// - throws: PCError
//    /// - Parameter featured: When true, show most relevant (featured) build targets only.
//    /// - Returns: PCFirmware.ListResponse
//    static func listTargets(featured: Bool = true) async throws -> PCFirmware.ListResponse {
//        try await PCNetwork.shared.cloudRequest(.listFirmwareBuildTargets(featured: featured), type: PCFirmware.ListResponse.self)
//    }
//    
//    
//    
//    ///List firmware build targets
//    ///
//    ///Lists the firmware versions for all platforms that can be used as build targets during firmware compilation.
//    ///
//    /// - calls: GET /v1/build_targets
//    ///
//    ///
//    ///
//    /// - note: As of April, 2023, an access token is no longer required to call this API. ie: you don't have to be logged in.
//    ///
//    /// - Parameter featured: When true, show most relevant (featured) build targets only.
//    /// - Parameter completion:Closure providing an Result of  PCFirmware.ListResponse or PCError.
//    static func listTargets(featured: Bool = true, completion: @escaping (Result<PCFirmware.ListResponse, PCError>) -> Void) {
//        PCNetwork.shared.cloudRequest(.listFirmwareBuildTargets(featured: featured), type: PCFirmware.ListResponse.self, completion: completion)
//    }
//    
//    
//    
//    ///Lock product device.
//    ///
//    ///Locks a product device to a specific version of product firmware. This device will download and run this firmware if it is not already running it the next time it connects to the cloud. You can optionally trigger an immediate update to this firmware for devices that are currently online.
//    ///
//    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
//    ///
//    ///
//    ///
//    /// - Requires: Scope of  devices:update
//    /// - Parameter on:The id of the device to be flashed
//    /// - Parameter in: Product ID or slug. Product endpoint only.
//    /// - Parameter withVersion: The firmware version the device should be locked to
//    /// - Parameter flashImmediately: Set to true to immediately flash to a device. Will only successfully deliver the firmware update if the device is currently online and connected to the cloud.
//    /// - Parameter token: A currently active access token with required scope.
//    /// - Returns: PCFirmware.DeviceFirmareLockResponse
//    static func lockFirmware(on deviceID: DeviceID, in product: ProductID, withVersion: String, flashImmediately: Bool, token: PCAccessToken) async throws -> PCFirmware.DeviceFirmareLockResponse {
//
//        try await PCNetwork.shared.cloudRequest(.lockProductDevice(deviceID: deviceID, productIdOrSlug: product, desired_firmware_version: withVersion, flash: flashImmediately, token: token), type: PCFirmware.DeviceFirmareLockResponse.self)
//    }
//    
//    
//    
//    ///Lock product device.
//    ///
//    ///Locks a product device to a specific version of product firmware. This device will download and run this firmware if it is not already running it the next time it connects to the cloud. You can optionally trigger an immediate update to this firmware for devices that are currently online.
//    ///
//    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
//    ///
//    ///
//    ///
//    /// - Requires: Scope of  devices:update
//    /// - Parameter on:The id of the device to be flashed
//    /// - Parameter in: Product ID or slug. Product endpoint only.
//    /// - Parameter withVersion: The firmware version the device should be locked to
//    /// - Parameter flashImmediately: Set to true to immediately flash to a device. Will only successfully deliver the firmware update if the device is currently online and connected to the cloud.
//    /// - Parameter token: A currently active access token with required scope.
//    /// - Returns: PCFirmware.DeviceFirmareLockResponse
//    static func lockFirmware(on deviceID: DeviceID, in product: ProductID, withVersion: String, flashImmediately: Bool, token: PCAccessToken, completion: @escaping (Result<PCFirmware.DeviceFirmareLockResponse, PCError>) -> Void) {
//
//        PCNetwork.shared.cloudRequest(.lockProductDevice(deviceID: deviceID, productIdOrSlug: product, desired_firmware_version: withVersion, flash: flashImmediately, token: token), type: PCFirmware.DeviceFirmareLockResponse.self, completion: completion)
//    }
//    
//    
//    
//    ///Unlock product device
//    ///
//    ///Unlocks a product device from receiving and running a specific version of product firmware. The device will now be eligible to receive released firmware in the product.
//    ///
//    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
//    ///
//    ///
//    ///
//    /// - Requires; Scope of devices:update
//    /// - Parameter on:The id of the device to be flashed
//    /// - Parameter in: Product ID or slug. Product endpoint only.
//    /// - Parameter token: A currently active access token.
//    /// - Returns: PCFirmware.DeviceFirmareLockResponse
//    static func unlockFirmware(on device: DeviceID, in product: ProductID, token: PCAccessToken) async throws -> PCFirmware.DeviceFirmareLockResponse {
//        try await PCNetwork.shared.cloudRequest(.unlockProductDevice(deviceID: device, productIdOrSlug: product, token: token), type: PCFirmware.DeviceFirmareLockResponse.self)
//    }
//    
//    
//    
//    ///Unlock product device
//    ///
//    ///Unlocks a product device from receiving and running a specific version of product firmware. The device will now be eligible to receive released firmware in the product.
//    ///
//    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
//    ///
//    ///
//    ///
//    /// - Requires; Scope of devices:update
//    /// - Parameter on:The id of the device to be flashed
//    /// - Parameter in: Product ID or slug. Product endpoint only.
//    /// - Parameter token: A currently active access token.
//    /// - Parameter completion: Closure supplying a Result of PCFirmware.DeviceFirmareLockResponse or PCError.
//    static func unlockFirmware(on device: DeviceID, in product: ProductID, token: PCAccessToken, completion: @escaping (Result<PCFirmware.DeviceFirmareLockResponse, PCError>) -> Void) {
//        PCNetwork.shared.cloudRequest(.unlockProductDevice(deviceID: device, productIdOrSlug: product, token: token), type: PCFirmware.DeviceFirmareLockResponse.self, completion: completion)
//    }
//    
//    
//    
//    ///Mark product development device
//    ///
//    ///Mark a device in a product fleet as a development device. Once marked as a development device, it will opt-out from receiving automatic product firmware updates. This includes both locked firmware as well as released firmware.
//    ///
//    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
//    ///
//    ///
//    /// - Requires: Scope of devices:update
//    /// - THrows: PCError
//    /// - Parameter device:The id of the device to be flashed
//    /// - Parameter in: Product ID or slug. Product endpoint only.
//    /// - Parameter development: Set to true to mark as development device
//    /// - Parameter token: A currently active access token.
//    /// - Requires: PCFirmware.MarkDeviceForDevelopmentResponse
//    static func mark(_ device: DeviceID, in product: ProductID, development: Bool, token: PCAccessToken) async throws -> PCFirmware.MarkDeviceForDevelopmentResponse {
//        try await PCNetwork.shared.cloudRequest(.markProductDevelopmentDevice(deviceID: device, productIdOrSlug: product, development: development, token: token), type: PCFirmware.MarkDeviceForDevelopmentResponse.self)
//    }
//    
//    
//    
//    ///Mark product development device
//    ///
//    ///Mark a device in a product fleet as a development device. Once marked as a development device, it will opt-out from receiving automatic product firmware updates. This includes both locked firmware as well as released firmware.
//    ///
//    /// - calls: PUT /v1/products/:productIdOrSlug/devices/:deviceId
//    ///
//    ///
//    /// - Requires: Scope of devices:update
//    /// - THrows: PCError
//    /// - Parameter device:The id of the device to be flashed
//    /// - Parameter in: Product ID or slug. Product endpoint only.
//    /// - Parameter development: Set to true to mark as development device
//    /// - Parameter token: A currently active access token.
//    /// - Parameter completion: Closure supplying a Result of PCFirmware.MarkDeviceForDevelopmentResponse or PCError.
//    static func mark(_ device: DeviceID, in product: ProductID, development: Bool, token: PCAccessToken, completion: @escaping (Result<PCFirmware.MarkDeviceForDevelopmentResponse, PCError>) -> Void) {
//        PCNetwork.shared.cloudRequest(.markProductDevelopmentDevice(deviceID: device, productIdOrSlug: product, development: development, token: token), type: PCFirmware.MarkDeviceForDevelopmentResponse.self, completion: completion)
//    }
//}
