//
//  Organizations.swift
//  ParticleSDK
//
//  Created by Craig Spell on 10/7/23.
//

import Foundation


public struct OrganizationName: Decodable {
    public let rawValue: String
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
