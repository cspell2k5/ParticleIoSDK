//
//  ServerResponses.swift
//  ParticleSDK
//
//  Created by Craig Spell on 10/6/23.
//

import Foundation

    // MARK: - Welcome
public struct ServerResponses: Decodable {
    
    public struct Standard: Decodable {
        public let ok: Bool
        public let message: String
        
        private init(ok: Bool, message: String) {
            self.ok = ok
            self.message = message
        }
    }
    
    public struct BoolResponse: Decodable {
        public let ok: Bool

        private init(ok: Bool) {
            self.ok = ok
        }
    }
    
    public struct NoResponse: Decodable {
        
        public let ok: Bool
        
        internal init(ok: Bool) {
            self.ok = ok
        }
        
        public init(from decoder: Decoder) throws {
            fatalError("Must use internal init with Bool.")
        }
    }
}
