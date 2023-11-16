//
//  PCProduct.swift
//  Particle2
//
//  Created by Craig Spell on 11/20/19.
//  Copyright © 2019 Spell Software Inc. All rights reserved.
//

import Foundation
import Combine


///Encapsulation of a productIdOrSlug.
///Failable init only fails if nil is passed as the rawvalue.
public struct ProductID {
    
    public let rawValue: String
    
    public init(_ rawValue: String) {
//        if rawValue == nil { return nil }
        self.rawValue = rawValue
    }
    
    public init?(_ rawValue: Int?) {
        if rawValue == nil { return nil }
        self.rawValue = String(rawValue!)
    }
}

public struct PCProduct : Decodable, Hashable, CustomDebugStringConvertible {

    public var debugDescription: String {
        "\n   PCProduct:\n      id: \(id)\n      name: \(name)\n      slug: \(slug)\n      description: \(description)\n      groups: [\(groups.joined(separator:",\n      "))]\n      deviceCount: \(deviceCount)\n      settings: \(settings.debugDescription)\n      type: \(type ?? "nil")\n      hardwareVersion: \(hardwareVersion ?? "nil")\n      configId: \(configId ?? "nil")\n      organization:   \(organization ?? "nil")\n      platformId: \(String(describing: platformId))\n      requiresActivationCodes: \(String(describing: requiresActivationCodes))\n"
    }
    
    public let id: Int
    public let name : String
    public let slug : String
    public let description : String
    public let groups: [String]
    public let deviceCount: Int
    public let settings: Settings
    public let type : String?
    public let hardwareVersion : String?
    public let configId : String?
    public let organization : String?
    public let platformId : Int?
    public let requiresActivationCodes : Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
//        case /*product_id*/
        case name
        case slug
        case description
        case groups
        case deviceCount = "device_count"
        case settings
        case type
        case hardwareVersion = "hardware_version"
        case configId = "config_id"
        case organization
        case platformId = "platform_id"
        case requiresActivationCodes = "requires_activation_codes"
    }
    
    
    public struct Settings: Decodable, Hashable, CustomDebugStringConvertible {
        
        public var debugDescription: String {
            " {\n         Settings:\n         location: \(String(describing: location))\n         knownApplication: \(knownApplication)\n         quarantine: \(quarantine)\n         user: \(String(describing: user))\n      }"
        }
        
        public let location: [String:String]?
        public let knownApplication: [String : Bool]
        public let quarantine: Bool
        public let user:String?
        
        enum CodingKeys: String, CodingKey {
            case location
            case knownApplication = "known_application"
            case quarantine
            case user
        }
    }
}

extension PCProduct {
    
    public struct InviteTeamMemberResponse: Decodable {
        public let ok: Bool
        public let invited:[String : String]
        
        private init(ok: Bool, invited: [String : String]) {
            self.ok = ok; self.invited = invited
        }
    }

    
    public struct ListResponse: Decodable, CustomStringConvertible, CustomDebugStringConvertible {
        
        public var description: String {
            debugDescription
        }
        
        public var debugDescription: String {
            "[\(products.map({$0.debugDescription}).joined(separator: ","))]\n"
        }
        
        public let products: [PCProduct]
    }

    public struct DeleteTeamMemberResponse: Decodable {
        public let ok: String
        
        private init(ok: String) { self.ok = ok }
    }
    
    internal struct ProductGetResponse: Decodable {
        internal let product: PCProduct
    }
}


//MARK: - Static Functions
extension PCProduct {
    
        //MARK: CurrentValueSubjects
    public static func listProducts(token: PCAccessToken) -> CurrentValueSubject<PCProduct.ListResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.listProducts(token: token), type: PCProduct.ListResponse.self)
    }
    
    public static func getProduct(productIdOrSlug: ProductID, token: PCAccessToken) -> CurrentValueSubject<PCProduct?, PCError> {
        
        let subject = CurrentValueSubject<PCProduct?, PCError>(nil)
        
        PCNetwork.shared.cloudRequest(.retrieveProduct(productIDorSlug: productIdOrSlug, token: token), type: ProductGetResponse.self)
            .sink { completion in
                subject.send(completion: completion)
            } receiveValue: { response in
                subject.send(response?.product)
            }.store(in: &PCNetwork.shared.cancellables)
       
        return subject
    }
}

    //MARK: Async
extension PCProduct {
    public static func listProducts(token: PCAccessToken) async throws -> PCProduct.ListResponse {
        try await PCNetwork.shared.cloudRequest(.listProducts(token: token), type: PCProduct.ListResponse.self)
    }
    
    public static func getProduct(productIdOrSlug: ProductID, token: PCAccessToken) async throws -> PCProduct {
        try await PCNetwork.shared.cloudRequest(.retrieveProduct(productIDorSlug: productIdOrSlug, token: token), type: ProductGetResponse.self).product
    }
}

    //MARK: Completion Handlers
extension PCProduct {
    
    
    
    public static func listProducts(token: PCAccessToken, completion: @escaping (Result<PCProduct.ListResponse, PCError>) -> Void) {
       
        PCNetwork.shared.cloudRequest(.listProducts(token: token), type: PCProduct.ListResponse.self, completion: completion)
    }
    
    
    
    public static func getProduct(productIdOrSlug: ProductID, token: PCAccessToken, completion: @escaping (Result<PCProduct, PCError>) -> Void) {
       
        PCNetwork.shared.cloudRequest(.retrieveProduct(productIDorSlug: productIdOrSlug, token: token), type: ProductGetResponse.self) { result in
        
            switch result {
                case .success(let response):
                    completion(.success(response.product))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}


