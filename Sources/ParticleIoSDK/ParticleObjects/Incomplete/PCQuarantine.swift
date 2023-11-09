//
//  PCQuarantine.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/14/23.
//

import Foundation


public struct PCQuarantine {
   
    
    public enum QuarantineAction {
        case approve, deny
    }
    
    public struct QuarantineActionResponse: Decodable {
        public let id: String
        
        private init(id: String) { self.id = id }
    }
}


