//
//  File.swift
//  
//
//  Created by Craig Spell on 10/15/23.
//

import Foundation


// MARK: - DeviceStatus spark/device/diagnostics/update
public struct DiagnosticEvent: CustomStringConvertible {
    
    public var description: String {
"""
DiagnosticEvent: {
    publishedAt: \(publishedAt)
    coreid: \(coreid)
    ttl: \(ttl)
    DeviceStatus: {
        DeviceStatusDevice: {
            Network: {
                Signal: {
                    at: \(deviceStatus.device.network.signal.at),
                    strength: \(deviceStatus.device.network.signal.strength),
                    strengthUnits: \(deviceStatus.device.network.signal.strengthUnits),
                    strengthv: \(deviceStatus.device.network.signal.strengthv),
                    strengthvUnits: \(deviceStatus.device.network.signal.strengthvUnits),
                    strengthvType: \(deviceStatus.device.network.signal.strengthvType),
                    quality: \(deviceStatus.device.network.signal.quality),
                    qualityUnits: \(deviceStatus.device.network.signal.qualityUnits),
                    qualityv: \(deviceStatus.device.network.signal.qualityv),
                    qualityvUnits: \(deviceStatus.device.network.signal.qualityvUnits),
                    qualityvType: \(deviceStatus.device.network.signal.qualityvType)
                },
                Connection: {
                    status: \(deviceStatus.device.network.connection.status),
                    error: \(deviceStatus.device.network.connection.error),
                    attempts: \(deviceStatus.device.network.connection.attempts),
                    disconnects: \(deviceStatus.device.network.connection.disconnects),
                    disconnectReason: \(deviceStatus.device.network.connection.disconnectReason)
                }
            },
            DeviceCloud: {
                Connection: {
                    status: \(deviceStatus.device.cloud.connection.status),
                    error: \(deviceStatus.device.cloud.connection.error),
                    attempts: \(deviceStatus.device.cloud.connection.attempts),
                    disconnects: \(deviceStatus.device.cloud.connection.disconnects),
                    disconnectReason: \(deviceStatus.device.cloud.connection.disconnectReason)
                },
                CloudCoap: {
                    transmit: \(deviceStatus.device.cloud.coap.transmit),
                    retransmit: \(deviceStatus.device.cloud.coap.retransmit),
                    unack: \(deviceStatus.device.cloud.coap.unack),
                    roundTrip: \(deviceStatus.device.cloud.coap.roundTrip)
                },
                    PurplePublish: {
                        rateLimited: \(deviceStatus.device.cloud.publish.rateLimited)
                    }
                },
                System: {
                    uptome: \(deviceStatus.device.system.uptime),
                    Memory: {
                        used: \(deviceStatus.device.system.memory.used),
                        totel: \(deviceStatus.device.system.memory.total)
                }
            }
        },
        Service: {
            ServiceDevice: {
                status: \(deviceStatus.service.device.status)
            },
            ServiceCloud: {
                uptome: \(deviceStatus.service.cloud.uptime),
                FluffyPublish: {
                    sent: \(deviceStatus.service.cloud.publish.sent)
                }
            },
            ServiceCoap: {
                roundTrip: \(deviceStatus.service.coap.roundTrip)
            }
        }
    }
}
"""
    }
    
    public let deviceStatus: DeviceStatus
    public let publishedAt: String
    public let coreid: String
    public let ttl: Int
        
    public init(event: PCEvent) throws {
        self.deviceStatus = try JSONDecoder().decode(DeviceStatus.self,
                                                     from: event.data.value.data(using: .utf8)!)
        self.publishedAt = event.data.publishedAt
        self.coreid = event.data.coreid
        self.ttl = event.data.ttl
    }
    
    public struct DeviceStatus: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
DeviceStatus: {
    DeviceStatusDevice: {
        Network: {
            Signal: {
                at: \(device.network.signal.at),
                strength: \(device.network.signal.strength),
                strengthUnits: \(device.network.signal.strengthUnits),
                strengthv: \(device.network.signal.strengthv),
                strengthvUnits: \(device.network.signal.strengthvUnits),
                strengthvType: \(device.network.signal.strengthvType),
                quality: \(device.network.signal.quality),
                qualityUnits: \(device.network.signal.qualityUnits),
                qualityv: \(device.network.signal.qualityv),
                qualityvUnits: \(device.network.signal.qualityvUnits),
                qualityvType: \(device.network.signal.qualityvType)
            },
            Connection: {
                status: \(device.network.connection.status),
                error: \(device.network.connection.error),
                attempts: \(device.network.connection.attempts),
                disconnects: \(device.network.connection.disconnects),
                disconnectReason: \(device.network.connection.disconnectReason)
            }
        },
        DeviceCloud: {
            Connection: {
                status: \(device.cloud.connection.status),
                error: \(device.cloud.connection.error),
                attempts: \(device.cloud.connection.attempts),
                disconnects: \(device.cloud.connection.disconnects),
                disconnectReason: \(device.cloud.connection.disconnectReason)
            },
            CloudCoap: {
                transmit: \(device.cloud.coap.transmit),
                retransmit: \(device.cloud.coap.retransmit),
                unack: \(device.cloud.coap.unack),
                roundTrip: \(device.cloud.coap.roundTrip)
            },
                PurplePublish: {
                    rateLimited: \(device.cloud.publish.rateLimited)
                }
            },
            System: {
                uptome: \(device.system.uptime),
                Memory: {
                    used: \(device.system.memory.used),
                    totel: \(device.system.memory.total)
            }
        }
    },
    Service: {
        ServiceDevice: {
            status: \(service.device.status)
        },
        ServiceCloud: {
            uptome: \(service.cloud.uptime),
            FluffyPublish: {
                sent: \(service.cloud.publish.sent)
            }
        },
        ServiceCoap: {
            roundTrip: \(service.coap.roundTrip)
        }
    }
}
"""
        }
        
        public let device: Device
        public let service: Service
    }
    
    // MARK: DeviceStatusDevice
    public struct Device: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
DeviceStatus: {
    Network: {
        Signal: {
            at: \(network.signal.at),
            strength: \(network.signal.strength),
            strengthUnits: \(network.signal.strengthUnits),
            strengthv: \(network.signal.strengthv),
            strengthvUnits: \(network.signal.strengthvUnits),
            strengthvType: \(network.signal.strengthvType),
            quality: \(network.signal.quality),
            qualityUnits: \(network.signal.qualityUnits),
            qualityv: \(network.signal.qualityv),
            qualityvUnits: \(network.signal.qualityvUnits),
            qualityvType: \(network.signal.qualityvType)
        },
        Connection: {
            status: \(network.connection.status),
            error: \(network.connection.error),
            attempts: \(network.connection.attempts),
            disconnects: \(network.connection.disconnects),
            disconnectReason: \(network.connection.disconnectReason)
        }
    },
    DeviceCloud: {
        Connection: {
            status: \(cloud.connection.status),
            error: \(cloud.connection.error),
            attempts: \(cloud.connection.attempts),
            disconnects: \(cloud.connection.disconnects),
            disconnectReason: \(cloud.connection.disconnectReason)
        },
        CloudCoap: {
            transmit: \(cloud.coap.transmit),
            retransmit: \(cloud.coap.retransmit),
            unack: \(cloud.coap.unack),
            roundTrip: \(cloud.coap.roundTrip)
        },
            PurplePublish: {
                rateLimited: \(cloud.publish.rateLimited)
            }
        },
        System: {
            uptome: \(system.uptime),
            Memory: {
                used: \(system.memory.used),
                totel: \(system.memory.total)
        }
    }
}

"""
        }
        
        public let network: Network
        public let cloud: DeviceCloud
        public let system: System
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: DeviceCloud
    public struct DeviceCloud: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
DeviceCloud: {
    Connection: {
        status: \(connection.status),
        error: \(connection.error),
        attempts: \(connection.attempts),
        disconnects: \(connection.disconnects),
        disconnectReason: \(connection.disconnectReason)
    },
    CloudCoap: {
        transmit: \(coap.transmit),
        retransmit: \(coap.retransmit),
        unack: \(coap.unack),
        roundTrip: \(coap.roundTrip)
    },
    PurplePublish: {
        rateLimited: \(publish.rateLimited)
    }
}
"""
        }
        
        public let connection: Connection
        public let coap: CloudCoap
        public let publish: PurplePublish
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: CloudCoap
    public struct CloudCoap: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
CloudCoap: {
    transmit: \(transmit),
    retransmit: \(retransmit),
    unack: \(unack),
    roundTrip: \(roundTrip)
}
"""
        }
        
        public let transmit: Int
        public let retransmit: Int
        public let unack: Int
        public let roundTrip: Int
        
        private enum CodingKeys: String, CodingKey {
            case transmit, retransmit, unack, roundTrip = "round_trip"
        }

        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: Connection
    public struct Connection: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Connection: {
    status: \(status),
    error: \(error),
    attempts: \(attempts),
    disconnects: \(disconnects),
    disconnectReason: \(disconnectReason)
}
"""
        }
        
        public let status: String
        public let error: Int
        public let attempts: Int
        public let disconnects: Int
        public let disconnectReason: String
        
        private enum CodingKeys: String, CodingKey {
            case status, error, attempts, disconnects, disconnectReason = "disconnect_reason"
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: PurplePublish
    public struct PurplePublish: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
PurplePublish: {
    rateLimited: \(rateLimited)
}
"""
        }
        
        public let rateLimited: Int
        
        private enum CodingKeys: String, CodingKey {
            case rateLimited = "rate_limited"
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: Network
    public struct Network: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Network: {
    Signal: {
        at: \(signal.at),
        strength: \(signal.strength),
        strengthUnits: \(signal.strengthUnits),
        strengthv: \(signal.strengthv),
        strengthvUnits: \(signal.strengthvUnits),
        strengthvType: \(signal.strengthvType),
        quality: \(signal.quality),
        qualityUnits: \(signal.qualityUnits),
        qualityv: \(signal.qualityv),
        qualityvUnits: \(signal.qualityvUnits),
        qualityvType: \(signal.qualityvType)
    },
    Connection: {
        status: \(connection.status),
        error: \(connection.error),
        attempts: \(connection.attempts),
        disconnects: \(connection.disconnects),
        disconnectReason: \(connection.disconnectReason)
    }
}
"""
        }
        
        public let signal: Signal
        public let connection: Connection
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: Signal
    public struct Signal: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Signal: {
    at: \(at),
    strength: \(strength),
    strengthUnits: \(strengthUnits),
    strengthv: \(strengthv),
    strengthvUnits: \(strengthvUnits),
    strengthvType: \(strengthvType),
    quality: \(quality),
    qualityUnits: \(qualityUnits),
    qualityv: \(qualityv),
    qualityvUnits: \(qualityvUnits),
    qualityvType: \(qualityvType)
}
"""
        }
        
        public let at: String
        public let strength: Int
        public let strengthUnits: String
        public let strengthv: Int
        public let strengthvUnits: String
        public let strengthvType: String
        public let quality: Double
        public let qualityUnits: String
        public let qualityv: Int
        public let qualityvUnits: String
        public let qualityvType: String
        
        private enum CodingKeys: String, CodingKey {
            case at, strength
            case strengthUnits = "strength_units"
            case strengthv
            case strengthvUnits = "strengthv_units"
            case strengthvType = "strengthv_type"
            case quality
            case qualityUnits = "quality_units"
            case qualityv
            case qualityvUnits = "qualityv_units"
            case qualityvType = "qualityv_type"
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: System
    public struct System: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
System: {
    uptome: \(uptime),
    Memory: {
        used: \(memory.used),
        totel: \(memory.total)
    }
}
"""
        }
        
        public let uptime: Int
        public let memory: Memory
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: Memory
    public struct Memory: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Memory: {
    used: \(used),
    total: \(total)
}
"""
        }
        
        public let used: Int
        public let total: Int
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: Service
    public struct Service: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Service: {
    ServiceDevice: {
        status: \(device.status)
    },
    ServiceCloud: {
        uptome: \(cloud.uptime),
        FluffyPublish: {
            sent: \(cloud.publish.sent)
        }
    },
    ServiceCoap: {
        roundTrip: \(coap.roundTrip)
    }
}
"""
        }
        
        public let device: ServiceDevice
        public let cloud: ServiceCloud
        public let coap: ServiceCoap
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: ServiceCloud
    public struct ServiceCloud: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
ServiceCloud: {
    uptime: \(uptime),
    FluffyPublish: {
        \(publish.sent)
    }
}
"""
        }
        
        public let uptime: Int
        public let publish: FluffyPublish
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: FluffyPublish
    public struct FluffyPublish: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
FluffyPublish: {
    sent: \(sent)
}
"""
        }
        
        public let sent: Int
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: ServiceCoap
    public struct ServiceCoap: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
ServiceCoap: {
    roundTrip: \(roundTrip)
}
"""
        }
        private enum CodingKeys: String, CodingKey {
            case roundTrip = "round_trip"
        }
        
        public let roundTrip: Int
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
    
    // MARK: ServiceDevice
    public struct ServiceDevice: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
ServiceDevice: {
    status: \(status)
}
"""
        }
        
        public let status: String
        
        private init() {
            fatalError("Must use init with decoder.")
        }
    }
}
