//
//  PCVariable.swift
//  Particle2
//
//  Created by Craig Spell on 11/19/19.
//  Copyright © 2019 Spell Software Inc. All rights reserved.
//

import Foundation



///Used to represent the variable returned by the server. This type should not be interacted with directly instead use the get variable method on PCDevice.
///
/// Example:
///
///
///````swift
///
///         let success = Bool(someBoolVariable.result)
///         let voltage = Double(pinValue.result) / 4095 * 3.3
///         let string =  someStringVariable.result
///
///````
///
/// - note: Paritcleio supports 3 variable types bool, double, and string.  This struct interprets all of them as String to remove complexity. To convert the value simply use the corresponding init.
public struct PCVariable: Decodable {
    
    public let name: String?
    public let coreInfo: CoreInfo?
    public let result: String
    
    private enum CodingKeys: CodingKey {
        case name, coreInfo, result
    }
    
    private init() {
        fatalError("Must use init with decoder.")
    }
        
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.coreInfo = try container.decodeIfPresent(CoreInfo.self, forKey: .coreInfo)
       
        if let result = try? container.decode(Bool.self, forKey: .result) {
            self.result = result.description
        } else if let result = try? container.decode(Double.self, forKey: .result) {
            self.result = result.description
        } else {
            self.result = try container.decode(String.self, forKey: .result)
        }
    }
    
    public struct CoreInfo : Decodable, Hashable {
        
        public let name : String?
        public let deviceID : String?
        public let connected : Bool?
        public let lastHandshakeAt : String?
        public let lastApp : String?
        
        private enum CodingKeys: String, CodingKey {
            case name, deviceID, connected, lastHandshakeAt = "last_handshake_at", lastApp = "last_app"
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
}
