//
//  PCCredentials.swift
//  ParticleIO
//
//  Created by Craig Spell on 11/22/19.
//  Copyright © 2019 Spell Software Inc. All rights reserved.
//

import Foundation


///Credentials used to interact with the server.
public struct PCCredentials : Codable  {
    public var username : String
    public var password : String

    public init(username: String, password: String) {
        self.username = username; self.password = password
    }
}
