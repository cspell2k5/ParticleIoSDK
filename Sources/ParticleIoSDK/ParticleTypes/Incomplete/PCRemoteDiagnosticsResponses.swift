// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pCRemoteDiagnosticsRefreshVitalsResponse = try? JSONDecoder().decode(PCRemoteDiagnosticsRefreshVitalsResponse.self, from: jsonData)

import Foundation

// MARK: - PCRemoteDiagnosticsVitalsResponse
//public struct PCRemoteDiagnosticsVitalsResponse: Decodable {
//    public let diagnostics: Diagnostics
//    
//    private enum CodingKeys: CodingKey {
//        case diagnostics
//    }
//    
//    private init() {
//        fatalError("Must use init with decoder.")
//    }
//    
//    
//    // MARK: Diagnostics
//    public struct Diagnostics: Decodable {
//        public let updatedAt, deviceID: String
//        public let payload: Payload
//        
//        private init() {
//            fatalError("Must use init with decoder.")
//        }
//    }
//    
//    
//    // MARK: Payload
//    public struct Payload: Decodable {
//        public let device: DeviceVitalsResponse
//        public let service: Service
//        
//        private init() {
//            fatalError("Must use init with decoder.")
//        }
//        
//        // MARK: DeviceVitalsResponse
//        public struct DeviceVitalsResponse: Decodable {
//            public let network: Network
//            public let cloud: DeviceCloud
//            public let power: Power
//            public let system: System
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: DeviceCloud
//        public struct DeviceCloud: Decodable {
//            public let connection: Connection
//            public let coap: CloudCoap
//            public let publish: PurplePublish
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: CloudCoap
//        public struct CloudCoap: Decodable {
//            public let transmit, retransmit, unack, roundTrip: Int
//            
//            private enum CodingKeys: String, CodingKey {
//                case transmit, retransmit, unack
//                case roundTrip = "round_trip"
//            }
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: Connection
//        public struct Connection: Decodable {
//            public let status: String
//            public let error, attempts, disconnects: Int
//            public let disconnectReason: String
//            
//            private enum CodingKeys: String, CodingKey {
//                case status, error, attempts, disconnects
//                case disconnectReason = "disconnect_reason"
//            }
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: PurplePublish
//        public struct PurplePublish: Decodable {
//            public let rateLimited: Int
//            
//            private enum CodingKeys: String, CodingKey {
//                case rateLimited = "rate_limited"
//            }
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: Network
//        public struct Network: Decodable {
//            public let cellular: Cellular
//            public let signal: Signal
//            public let connection: Connection
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: Cellular
//        public struct Cellular: Decodable {
//            public let radioAccessTechnology, cellularOperator: String
//            public let cellGlobalIdentity: CellGlobalIdentity
//            
//            private enum CodingKeys: String, CodingKey {
//                case radioAccessTechnology = "radio_access_technology"
//                case cellularOperator = "operator"
//                case cellGlobalIdentity = "cell_global_identity"
//            }
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: CellGlobalIdentity
//        public struct CellGlobalIdentity: Decodable {
//            public let mobileCountryCode: Int
//            public let mobileNetworkCode: String
//            public let locationAreaCode, cellID: Int
//            
//            private enum CodingKeys: String, CodingKey {
//                case mobileCountryCode = "mobile_country_code"
//                case mobileNetworkCode = "mobile_network_code"
//                case locationAreaCode = "location_area_code"
//                case cellID = "cell_id"
//            }
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: Signal
//        public struct Signal: Decodable {
//            public let at: String
//            public let strength: Double
//            public let strengthUnits: String
//            public let strengthv: Int
//            public let strengthvUnits, strengthvType: String
//            public let quality: Double
//            public let qualityUnits: String
//            public let qualityv: Int
//            public let qualityvUnits, qualityvType: String
//            
//            private enum CodingKeys: String, CodingKey {
//                case at, strength
//                case strengthUnits = "strength_units"
//                case strengthv
//                case strengthvUnits = "strengthv_units"
//                case strengthvType = "strengthv_type"
//                case quality
//                case qualityUnits = "quality_units"
//                case qualityv
//                case qualityvUnits = "qualityv_units"
//                case qualityvType = "qualityv_type"
//            }
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: Power
//        public struct Power: Decodable {
//            public let battery: Battery
//            public let source: String
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: Battery
//        public struct Battery: Decodable {
//            public let charge: Double
//            public let state: String
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        // MARK: Service
//        public struct Service: Decodable {
//            public let device: ServiceDevice
//            public let cloud: ServiceCloud
//            public let coap: ServiceCoap
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//        
//        
//        // MARK: ServiceDevice
//        public struct ServiceDevice: Decodable {
//            public let status: String
//            
//            private init() {
//                fatalError("Must use init with decoder.")
//            }
//        }
//    }
//}

public struct PCRemoteDiagnosticsVitalsResponse: Decodable {
    public let diagnostics: Diagnostics
    
    private enum CodingKeys: CodingKey {
        case diagnostics
    }
    
    private init() {
        fatalError("Must use init with decoder.")
    }
}


// MARK: - PCRemoteDiagnosticsMetaDataResponse
public struct PCRemoteDiagnosticsMetaDataResponse: Decodable, CustomStringConvertible {
    
    public var description: String {
"""
PCRemoteDiagnosticsMetaDataResponse: {
    DiagnosticsMetadata: {
        Service: {
            Cloud: {
                PurplePublish: {
                    Sent: {
                        title: \(diagnosticsMetadata.service.cloud.publish.sent.title),
                        type: \(diagnosticsMetadata.service.cloud.publish.sent.type),
                        Units: {
                            title: \(String(describing: diagnosticsMetadata.service.cloud.publish.sent.units?.title)),
                            PurpleConvert: {
                                by: \(String(describing: diagnosticsMetadata.service.cloud.publish.sent.units?.convert?.by)),
                                type: \(String(describing: diagnosticsMetadata.service.cloud.publish.sent.units?.convert?.type))
                            }
                        },
                        Value: {
                            all: [
                                \(String(describing: diagnosticsMetadata.service.cloud.publish.sent.values?.all.joined(separator: ",                              ")))
                            ],
                            warning: [
                                \(String(describing: diagnosticsMetadata.service.cloud.publish.sent.values?.warning.joined(separator: ",                              ")))
                            ],
                            healthy: [
                                \(String(describing: diagnosticsMetadata.service.cloud.publish.sent.values?.healthy.joined(separator: ",                              ")))
                            ]
                        }
                    }
                }
            },
            Coap: {
                Roundtrip: {
                    title: \(diagnosticsMetadata.service.coap.roundTrip.title),
                    type: \(diagnosticsMetadata.service.coap.roundTrip.type),
                    priority: \(diagnosticsMetadata.service.coap.roundTrip.priority),
                    Ranges: {
                        type: \(String(describing: diagnosticsMetadata.service.coap.roundTrip.ranges?.type)),
                        ratio: \(String(describing: diagnosticsMetadata.service.coap.roundTrip.ranges?.ratio)),
                        param1: \(String(describing: diagnosticsMetadata.service.coap.roundTrip.ranges?.param1)),
                        param2: \(String(describing: diagnosticsMetadata.service.coap.roundTrip.ranges?.param2))
                    },
                    Units: {
                        title: \(diagnosticsMetadata.service.coap.roundTrip.units.title)
                    },
                    Messages: {
                        description: \(diagnosticsMetadata.service.coap.roundTrip.messages.cloudDescription),
                        warning: \(diagnosticsMetadata.service.coap.roundTrip.messages.warning),
                        healthy: \(diagnosticsMetadata.service.coap.roundTrip.messages.healthy)
                    }
                }
            }
        },
        Device: {
            Cloud: {
                PurplePublish: {
                    RoundTrip: {
                        title: \(diagnosticsMetadata.device.cloud.publish.rateLimited.title),
                        type: \(diagnosticsMetadata.device.cloud.publish.rateLimited.type),
                        priority: \(diagnosticsMetadata.device.cloud.publish.rateLimited.priority),
                        DisconnectRanges: {
                            type: \(String(describing: diagnosticsMetadata.device.cloud.publish.rateLimited.ranges?.type)),
                            ratio: \(String(describing: diagnosticsMetadata.device.cloud.publish.rateLimited.ranges?.ratio)),
                            param1: \(String(describing: diagnosticsMetadata.device.cloud.publish.rateLimited.ranges?.param1)),
                            param2: \(String(describing: diagnosticsMetadata.device.cloud.publish.rateLimited.ranges?.param2))
                        },
                        Units: {
                            title: \(diagnosticsMetadata.device.cloud.publish.rateLimited.units.title)
                        },
                        Messages: {
                            description: \(diagnosticsMetadata.device.cloud.publish.rateLimited.messages.cloudDescription),
                            warning: \(diagnosticsMetadata.device.cloud.publish.rateLimited.messages.warning),
                            healthy: \(diagnosticsMetadata.device.cloud.publish.rateLimited.messages.healthy)
                        }
                    }
                },
                Disconnects: {
                    title: \(diagnosticsMetadata.device.cloud.disconnects.title),
                    type: \(diagnosticsMetadata.device.cloud.disconnects.type),
                    priority: \(diagnosticsMetadata.device.cloud.disconnects.priority),
                    units: \(diagnosticsMetadata.device.cloud.disconnects.units),
                    Ranges: {
                        type: \(diagnosticsMetadata.device.cloud.disconnects.ranges.type),
                        ratio: \(diagnosticsMetadata.device.cloud.disconnects.ranges.ratio),
                        param1: \(diagnosticsMetadata.device.cloud.disconnects.ranges.param1),
                        param2: \(diagnosticsMetadata.device.cloud.disconnects.ranges.param2)
                    },
                    Messages: {
                        description: \(diagnosticsMetadata.device.cloud.disconnects.messages.cloudDescription),
                        warning: \(diagnosticsMetadata.device.cloud.disconnects.messages.warning),
                        healthy: \(diagnosticsMetadata.device.cloud.disconnects.messages.healthy)
                    }
                }
            }
        }
    }
}
"""
    }
    
    public let diagnosticsMetadata: DiagnosticsMetadata
    
    private enum CodingKeys: String, CodingKey {
        case diagnosticsMetadata = "diagnostics_metadata"
    }
    
    private init() {
        fatalError("Must use init with decoder.")
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.diagnosticsMetadata = try! container.decode(DiagnosticsMetadata.self, forKey: .diagnosticsMetadata)
    }
    
    // MARK: - DiagnosticsMetadata
    public struct DiagnosticsMetadata: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
DiagnosticsMetadata: {
    Service: {
        Cloud: {
            PurplePublish: {
                Sent: {
                    title: \(service.cloud.publish.sent.title),
                    type: \(service.cloud.publish.sent.type),
                    Units: {
                        title: \(String(describing: service.cloud.publish.sent.units?.title)),
                        PurpleConvert: {
                            by: \(String(describing: service.cloud.publish.sent.units?.convert?.by)),
                            type: \(String(describing: service.cloud.publish.sent.units?.convert?.type))
                        }
                    },
                    Value: {
                        all: [
                            \(String(describing: service.cloud.publish.sent.values?.all.joined(separator: ",                             ")))
                        ],
                        warning: [
                            \(String(describing: service.cloud.publish.sent.values?.warning.joined(separator: ",                             ")))
                        ],
                        healthy: [
                            \(String(describing: service.cloud.publish.sent.values?.healthy.joined(separator: ",                             ")))
                        ]
                    }
                }
            }
        },
        Coap: {
            RoundTrip: {
                title: \(service.coap.roundTrip.title),
                type: \(service.coap.roundTrip.type),
                priority: \(service.coap.roundTrip.priority),
                Ranges: {
                    type: \(String(describing: service.coap.roundTrip.ranges?.type)),
                    ratio: \(String(describing: service.coap.roundTrip.ranges?.ratio)),
                    param1: \(String(describing: service.coap.roundTrip.ranges?.param1)),
                    param2: \(String(describing: service.coap.roundTrip.ranges?.param2))
                },
                Units: {
                    title: \(service.coap.roundTrip.units.title)
                },
                Messages: {
                    description: \(service.coap.roundTrip.messages.cloudDescription),
                    warning: \(service.coap.roundTrip.messages.warning),
                    healthy: \(service.coap.roundTrip.messages.healthy)
                }
            }
        }
    }
},
Device: {
    Cloud: {
        PurplePublish: {
            RoundTrip: {
                title: \(device.cloud.publish.rateLimited.title),
                type: \(device.cloud.publish.rateLimited.type),
                priority: \(device.cloud.publish.rateLimited.priority),
                DisconnectRanges: {
                    type: \(String(describing: device.cloud.publish.rateLimited.ranges?.type)),
                    ratio: \(String(describing: device.cloud.publish.rateLimited.ranges?.ratio)),
                    param1: \(String(describing: device.cloud.publish.rateLimited.ranges?.param1)),
                    param2: \(String(describing: device.cloud.publish.rateLimited.ranges?.param2))
                },
                Units: {
                    title: \(device.cloud.publish.rateLimited.units.title)
                },
                Messages: {
                    description: \(device.cloud.publish.rateLimited.messages.cloudDescription),
                    warning: \(device.cloud.publish.rateLimited.messages.description),
                    healthy: \(device.cloud.publish.rateLimited.messages.description)
                }
            }
        },
        Disconnects: {
            title: \(device.cloud.disconnects.title),
            type: \(device.cloud.disconnects.type),
            priority: \(device.cloud.disconnects.priority),
            units: \(device.cloud.disconnects.units),
            Ranges: {
                type: \(device.cloud.disconnects.ranges.type),
                ratio: \(device.cloud.disconnects.ranges.ratio),
                param1: \(device.cloud.disconnects.ranges.param1),
                param2: \(device.cloud.disconnects.ranges.param2)
            },
            Messages: {
                description: \(device.cloud.disconnects.messages.cloudDescription),
                warning: \(device.cloud.disconnects.messages.warning),
                healthy: \(device.cloud.disconnects.messages.healthy)
            }
        }
    },
    Network: {
        Signal: {
            Strength: {
                title: \(device.network.signal.strength.title),
                type: \(device.network.signal.strength.type),
                priority: \(device.network.signal.strength.priority),
                Units: {
                    title: \(device.network.signal.strength.units.title)
                },
                Ranges: {
                    title: \(device.network.signal.strength.ranges.type),
                    warning: \(device.network.signal.strength.ranges.warning)
                },
                Messages: {
                    description: \(device.network.signal.strength.messages.cloudDescription),
                    healthy: \(device.network.signal.strength.messages.healthy),
                    warning: \(device.network.signal.strength.messages.warning)
                }
            },
            Strengthv: {
                title: \(device.network.signal.strengthv.title),
                type: \(device.network.signal.strengthv.type),
                Units: {
                    title: \(String(describing: device.network.signal.strengthv.units?.title))
                },
                PurpleConvert: {
                    by: \(String(describing: device.network.signal.strengthv.units?.convert?.by)),
                    type: \(String(describing: device.network.signal.strengthv.units?.convert?.type))
                },
                Values: {
                    all: [
                        \(String(describing: device.network.signal.strengthv.values?.all.joined(separator: ",                             ")))
                    ],
                    warning: [
                        \(String(describing: device.network.signal.strengthv.values?.warning.joined(separator: ",                             ")))
                    ],
                    healthy: [
                        \(String(describing: device.network.signal.strengthv.values?.healthy.joined(separator: ",                             ")))
                    ]
                }
            }
        }
    },
    System: {
        Memory: {
            used: \(device.system.memory.usage),
            total: \(device.system.memory.total)
        },
    },
    Power: {
        Battery: {
            State: {
                title: \(device.power.battery.state.title),
                type: \(device.power.battery.state.type),
                describes: \(device.power.battery.state.describes),
                Units: {
                    title: \(String(describing: device.power.battery.state.units?.title)),
                    PurpleConvert: {
                        by: \(String(describing: device.power.battery.state.units?.convert?.by)),
                        type: \(String(describing: device.power.battery.state.units?.convert?.type))
                    }
                },
                Values: {
                    all: [
                        \(String(describing: device.power.battery.state.values?.all.joined(separator: ",                         ")))
                    ],
                    warning: [
                            \(String(describing: device.power.battery.state.values?.warning.joined(separator: ",                         ")))
                    ],
                    healthy: [
                            \(String(describing: device.power.battery.state.values?.healthy.joined(separator: ",                         ")))
                    ]
                }
            },
            Charge: {
                title: \(device.power.battery.charge.title),
                type: \(device.power.battery.charge.type),
                priority: \(device.power.battery.charge.priority),
                Units: {
                    title: \(device.power.battery.charge.units.title),
                    FluffyConvert: {
                        type: \(device.power.battery.charge.units.convert.type)
                    }
                },
                Ranges: {
                    type: \(device.power.battery.charge.ranges.type),
                    warning: \(device.power.battery.charge.ranges.warning)
                }
                Messages: {
                    description: \(device.power.battery.charge.messages.cloudDescription),
                    healthy: \(device.power.battery.charge.messages.healthy),
                    warning: \(device.power.battery.charge.messages.warning)
                }
            }
        }
    }
}
"""
        }
        
        public let service: Service
        public let device: Device
        
        private enum CodingKeys: CodingKey {
            case service, device
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.service = try! container.decode(Service.self, forKey: .service)
            self.device = try! container.decode(Device.self, forKey: .device)
        }
    }
    
    // MARK: - Device
    public struct Device: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Device: {
    Network: {
        Signal: {
            Strength: {
                title: \(network.signal.strength.title),
                type: \(network.signal.strength.type),
                priority: \(network.signal.strength.priority),
                Units: {
                    title: \(network.signal.strength.units.title)
                },
                Ranges: {
                    type: \(network.signal.strength.ranges.type),
                    warning: \(network.signal.strength.ranges.warning)
                }
                Messages: {
                    description: \(network.signal.strength.messages.cloudDescription),
                    healthy: \(network.signal.strength.messages.healthy),
                    warning: \(network.signal.strength.messages.warning),
                }
            },
            Strengthv: {
                title: \(network.signal.strengthv.title),
                type: \(network.signal.strengthv.type),
                Units: {
                    title: \(String(describing: network.signal.strengthv.units?.title)),
                },
                Values: {
                    all: [
                        \(String(describing: network.signal.strengthv.values?.all.joined(separator: ",                            ")))
                    ],
                    warning: [
                            \(String(describing: network.signal.strengthv.values?.warning.joined(separator: ",                            ")))
                    ],
                    healthy: [
                            \(String(describing: network.signal.strengthv.values?.healthy.joined(separator: ",                            ")))
                    ]
                }
            }
        },
        System: {
            Memory: {
                used: \(system.memory.usage),
                total: \(system.memory.total)
            }
        },
        Power: {
            Battery: {
                State: {
                    title: \(power.battery.state.title),
                    type: \(power.battery.state.type),
                    describes: \(power.battery.state.describes),
                    Units: {
                        title: \(String(describing: power.battery.state.units?.title)),
                        PurpleConvert: {
                            by: \(String(describing: power.battery.state.units?.convert?.by)),
                            type: \(String(describing: power.battery.state.units?.convert?.type))
                        }
                    },
                    Values: {
                        all: [
                            \(String(describing: power.battery.state.values?.all.joined(separator: ",                           ")))
                        ],
                        warning: [
                                \(String(describing: power.battery.state.values?.warning.joined(separator: ",                          ")))
                        ],
                        healthy: [
                                \(String(describing: power.battery.state.values?.healthy.joined(separator: ",                          ")))
                        ]
        
                    }
                },
                Charge: {
                    title: \(power.battery.charge.title),
                    type: \(power.battery.charge.type),
                    priority: \(power.battery.charge.priority),
                    Units: {
                        title: \(power.battery.charge.units.title),
                        FluffyConvert: {
                            type: \(power.battery.charge.units.convert.type)
                        }
                    },
                    Ranges: {
                        type: \(power.battery.charge.ranges.type),
                        warning: \(power.battery.charge.ranges.warning)
                    }
                    Messages: {
                        description: \(power.battery.charge.messages.cloudDescription),
                        healthy: \(power.battery.charge.messages.healthy),
                        warning: \(power.battery.charge.messages.warning)
                    }
                }
            }
        }
    }
}
"""
        }
        
        public let network: Network
        public let system: System
        public let power: Power
        public let cloud: DeviceCloud
        
        private enum CodingKeys: CodingKey {
            case network, system, power, cloud
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.network = try! container.decode(Network.self, forKey: .network)
            self.system = try! container.decode(System.self, forKey: .system)
            self.power = try! container.decode(Power.self, forKey: .power)
            self.cloud = try! container.decode(DeviceCloud.self, forKey: .cloud)
        }
    }
    
    // MARK: - DeviceCloud
    public struct DeviceCloud: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
DeviceCloud: {
    PurplePublish: {
        RoundTrip: {
            title: \(publish.rateLimited.title),
            type: \(publish.rateLimited.type),
            priority: \(publish.rateLimited.priority),
            DisconnectRanges: {
                type: \(String(describing: publish.rateLimited.ranges?.type)),
                ratio: \(String(describing: publish.rateLimited.ranges?.ratio)),
                param1: \(String(describing: publish.rateLimited.ranges?.param1)),
                param2: \(String(describing: publish.rateLimited.ranges?.param2))
            },
            Units: {
                title: \(publish.rateLimited.units.title)
            },
            Messages: {
                description: \(publish.rateLimited.messages.cloudDescription),
                warning: \(publish.rateLimited.messages.warning),
                healthy: \(publish.rateLimited.messages.healthy)
            }
        }
    },
    Disconnects: {
        title: \(disconnects.title),
        type: \(disconnects.type),
        priority: \(disconnects.priority),
        units: \(disconnects.units),
        Ranges: {
            type: \(disconnects.ranges.type),
            ratio: \(disconnects.ranges.ratio),
            param1: \(disconnects.ranges.param1),
            param2: \(disconnects.ranges.param2)
        },
        Messages: {
            description: \(disconnects.messages.cloudDescription),
            warning: \(disconnects.messages.warning),
            healthy: \(disconnects.messages.healthy)
        }
    }
}
"""
        }
        
        public let disconnects: Disconnects
        public let publish: PurplePublish
        
        private enum CodingKeys: CodingKey {
            case disconnects, publish
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.disconnects = try! container.decode(Disconnects.self, forKey: .disconnects)
            self.publish = try! container.decode(PurplePublish.self, forKey: .publish)
        }
    }
    
    // MARK: - Disconnects
    public struct Disconnects: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Disconnects: {
    title: \(title),
    type: \(type),
    priority: \(priority),
    units: \(units),
    Ranges: {
        type: \(ranges.type),
        ratio: \(ranges.ratio),
        param1: \(ranges.param1),
        param2: \(ranges.param2)
    },
    Messages: {
        description: \(messages.cloudDescription),
        warning: \(messages.warning),
        healthy: \(messages.healthy)
    }
}
"""
        }
        
        public let title, type: String
        public let priority: Int
        public let units: String
        public let ranges: DisconnectRanges
        public let messages: Messages
        
        private enum CodingKeys: CodingKey {
            case title, type, priority, units, ranges, messages
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.type = try! container.decode(String.self, forKey: .type)
            self.priority = try! container.decode(Int.self, forKey: .priority)
            self.units = try! container.decode(String.self, forKey: .units)
            self.ranges = try! container.decode(DisconnectRanges.self, forKey: .ranges)
            self.messages = try! container.decode(Messages.self, forKey: .messages)
        }
    }
    
    // MARK: - Messages
    public struct Messages: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Messages: {
    description: \(cloudDescription),
    healthy: \(healthy),
    warning: \(warning)
}
"""
        }
        
        public let cloudDescription, healthy, warning: String
        
        private enum CodingKeys: String, CodingKey {
            case cloudDescription = "description"
            case healthy
            case warning
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.cloudDescription = try! container.decode(String.self, forKey: .cloudDescription)
            self.healthy = try! container.decode(String.self, forKey: .healthy)
            self.warning = try! container.decode(String.self, forKey: .warning)
        }
    }
    
    // MARK: - DisconnectsRanges
    public struct DisconnectRanges: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
DisconnectRanges: {
    type: \(type),
    ratio: \(ratio),
    param1: \(param1),
    param2: \(param2)
}
"""
        }
        
        public let type: String
        public let ratio: Double
        public let param1, param2: String
        
        private enum CodingKeys: CodingKey {
            case type, ratio, param1, param2
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try! container.decode(String.self, forKey: .type)
            self.ratio = try! container.decode(Double.self, forKey: .ratio)
            self.param1 = try! container.decode(String.self, forKey: .param1)
            self.param2 = try! container.decode(String.self, forKey: .param2)
        }
    }
    
    // MARK: - PurplePublish
    public struct PurplePublish: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
PurplePublish: {
    RoundTrip: {
        title: \(rateLimited.title),
        type: \(rateLimited.type),
        priority: \(rateLimited.priority),
        DisconnectRanges: {
            type: \(String(describing: rateLimited.ranges?.type)),
            ratio: \(String(describing: rateLimited.ranges?.ratio)),
            param1: \(String(describing: rateLimited.ranges?.param1)),
            param2: \(String(describing: rateLimited.ranges?.param2))
        },
        Units: {
            title: \(rateLimited.units.title)
        },
        Messages: {
            description: \(rateLimited.messages.cloudDescription),
            warning: \(rateLimited.messages.description),
            healthy: \(rateLimited.messages.description)
        }
    }
}
"""
        }
        
        public let rateLimited: RoundTrip
        
        private enum CodingKeys: String, CodingKey {
            case rateLimited = "rate_limited"
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.rateLimited = try! container.decode(RoundTrip.self, forKey: .rateLimited)
        }
    }
    
    // MARK: - RoundTrip
    public struct RoundTrip: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
        RoundTrip: {
                title: \(title),
                type: \(type),
                priority: \(priority),
            DisconnectRanges: {
                type: \(String(describing: ranges?.type)),
                ratio: \(String(describing: ranges?.ratio)),
                param1: \(String(describing: ranges?.param1)),
                param2: \(String(describing: ranges?.param2))
            },
            Units: {
                title: \(units.title)
            },
            Messages: {
                description: \(messages.cloudDescription),
                warning: \(messages.description),
                healthy: \(messages.description)
            }
        }
"""
        }
        
        public let title, type: String
        public let priority: Int
        public let units: RoundTripUnits
        public let ranges: DisconnectRanges?
        public let messages: Messages
        
        private enum CodingKeys: CodingKey {
            case title, type, priority, units, ranges, messages
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.type = try! container.decode(String.self, forKey: .type)
            self.priority = try! container.decode(Int.self, forKey: .priority)
            self.units = try! container.decode(RoundTripUnits.self, forKey: .units)
            self.ranges = try! container.decodeIfPresent(DisconnectRanges.self, forKey: .ranges)
            self.messages = try! container.decode(Messages.self, forKey: .messages)
        }
    }
    
    // MARK: - RoundTripUnits
    public struct RoundTripUnits: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
RoundTripUnits: {
    title: \(title)
}
"""
        }
        
        public let title: String
        
        private enum CodingKeys: CodingKey {
            case title
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
        }
    }
    
    // MARK: - Network
    public struct Network: Decodable {
        public let signal: Signal
        
        private enum CodingKeys: CodingKey {
            case signal
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.signal = try! container.decode(Signal.self, forKey: .signal)
        }
    }
    
    // MARK: - Signal
    public struct Signal: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
        Signal: {
            Strength: {
                title: \(strength.title),
                type: \(strength.type),
                priority: \(strength.priority),
                Units: {
                    title: \(strength.units.title)
                },
                Ranges: {
                    type: \(strength.ranges.type),
                    warning: \(strength.ranges.warning)
                }
                Messages: {
                    description: \(strength.messages.cloudDescription),
                    healthy: \(strength.messages.healthy),
                    warning: \(strength.messages.warning),
                }
            },
            Strengthv: {
                title: \(strengthv.title),
                type: \(strengthv.type),
                Units: {
                    title: \(String(describing: strengthv.units?.title)),
                },
                Values: {
                    all: [
                        \(String(describing: strengthv.values?.all.joined(separator: ",                        ")))
                    ],
                    warning: [
                            \(String(describing: strengthv.values?.warning.joined(separator: ",                        ")))
                    ],
                    healthy: [
                            \(String(describing: strengthv.values?.healthy.joined(separator: ",                        ")))
                    ]
                }
            }
        }
"""
        }
        
        public let strengthv: Strengthv
        public let strength: Strength
        
        private enum CodingKeys: CodingKey {
            case strengthv, strength
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.strengthv = try! container.decode(Strengthv.self, forKey: .strengthv)
            self.strength = try! container.decode(Strength.self, forKey: .strength)
        }
    }
    
    // MARK: - Strength
    public struct Strength: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Strength: {
    title: \(title),
    type: \(type),
    priority: \(priority),
    Units: {
        title: \(units.title)
    },
    Ranges: {
        type: \(ranges.type),
        warning: \(ranges.warning)
    }
    Messages: {
        description: \(messages.cloudDescription),
        healthy: \(messages.healthy),
        warning: \(messages.warning),
    }
}

"""        }

        public let title, type: String
        public let priority: Int
        public let units: RoundTripUnits
        public let ranges: StrengthRanges
        public let messages: Messages
        
        private enum CodingKeys: CodingKey {
            case title, type, priority, units, ranges, messages
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.type = try! container.decode(String.self, forKey: .type)
            self.priority = try! container.decode(Int.self, forKey: .priority)
            self.units = try! container.decode(RoundTripUnits.self, forKey: .units)
            self.ranges = try! container.decode(StrengthRanges.self, forKey: .ranges)
            self.messages = try! container.decode(Messages.self, forKey: .messages)
        }
    }
    
    // MARK: - StrengthRanges
    public struct StrengthRanges: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
StrengthRanges: {
    type: \(type),
    warning: \(warning)
}
"""
        }
        
        public let type: String
        public let warning: Int
        
        private enum CodingKeys: CodingKey {
            case type, warning
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try! container.decode(String.self, forKey: .type)
            self.warning = try! container.decode(Int.self, forKey: .warning)
        }
    }
    
    // MARK: - Strengthv
    public struct Strengthv: Decodable {
        public let title, type: String
        public let units: StrengthvUnits?
        public let describes: String
        public let values: Values?
        
        private enum CodingKeys: CodingKey {
            case title, type, units, describes, values
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.type = try! container.decode(String.self, forKey: .type)
            self.units = try! container.decodeIfPresent(StrengthvUnits.self, forKey: .units)
            self.describes = try! container.decode(String.self, forKey: .describes)
            self.values = try! container.decodeIfPresent(Values.self, forKey: .values)
        }
    }
    
    // MARK: - StrengthvUnits
    public struct StrengthvUnits: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
StrengthvUnits: {
    title: \(title),
    PurpleConvert: {
        by: \(String(describing: convert?.by)),
        type: \(String(describing: convert?.type))
    }
}
"""
        }
        
        public let title: String
        public let convert: PurpleConvert?
        
        private enum CodingKeys: CodingKey {
            case title, convert
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.convert = try! container.decodeIfPresent(PurpleConvert.self, forKey: .convert)
        }
    }
    
    // MARK: - PurpleConvert
    public struct PurpleConvert: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
PurpleConvert: {
    by: \(by),
    type: \(type)
}
"""
        }
        
        public let by: Int
        public let type: String

        private enum CodingKeys: CodingKey {
            case by, type
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.by = try! container.decode(Int.self, forKey: .by)
            self.type = try! container.decode(String.self, forKey: .type)
        }
    }
    
    // MARK: - Values
    public struct Values: Decodable, CustomStringConvertible {

        public var description: String{
"""
Values: {
    all: [
        \(String(describing: all.joined(separator: ",         ")))
    ],
    warning: [
         \(String(describing: warning.joined(separator: ",         ")))
    ],
    healthy: [
    \(String(describing: healthy.joined(separator: ",         ")))
    ]
}
"""
        }
        
        public let all, healthy, warning: [String]
        
        private enum CodingKeys: CodingKey {
            case all, healthy, warning
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
       public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.all = try! container.decode([String].self, forKey: .all)
            self.healthy = try! container.decode([String].self, forKey: .healthy)
            self.warning = try! container.decode([String].self, forKey: .warning)
        }
    }
    
    // MARK: - Power
    public struct Power: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Power: {
    Battery: {
        State: {
            title: \(battery.state.title),
            type: \(battery.state.type),
            describes: \(battery.state.describes),
            Units: {
                title: \(String(describing: battery.state.units?.title)),
                PurpleConvert: {
                    by: \(String(describing: battery.state.units?.convert?.by)),
                    type: \(String(describing: battery.state.units?.convert?.type))
                }
            },
            Values: {
                all: [
                    \(String(describing: battery.state.values?.all.joined(separator: ",                    ")))
                ],
                warning: [
                    \(String(describing: battery.state.values?.warning.joined(separator: ",                    ")))
                ],
                healthy: [
                \(String(describing: battery.state.values?.healthy.joined(separator: ",                    ")))
                ]
            }
        },
        Charge: {
            title: \(battery.charge.title),
            type: \(battery.charge.type),
            priority: \(battery.charge.priority),
            Units: {
                title: \(battery.charge.units.title),
                FluffyConvert: {
                    type: \(battery.charge.units.convert.type),
                }
            },
            Ranges: {
                description: \(battery.charge.ranges.description),
                type: \(battery.charge.ranges.type),
                warning: \(battery.charge.ranges.warning)
            },
            Messages: {
                description: \(battery.charge.messages.cloudDescription),
                healthy: \(battery.charge.messages.healthy),
                warning: \(battery.charge.messages.warning)
            }
        }
    }
}
"""
        }
        
        public let battery: Battery
        
        private enum CodingKeys: CodingKey {
            case battery
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.battery = try! container.decode(Battery.self, forKey: .battery)
        }
    }
    
    // MARK: - Battery
    public struct Battery: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Battery: {
    Charge: {
        title: \(charge.title),
        type: \(charge.type),
        title: \(charge.priority),
        Units: {
            title: \(charge.units.title),
            FluffyConvert:  {
                \(charge.units.convert.type)
            }
        },
        Ranges: {
            description: \(charge.ranges.description),
            type: \(charge.ranges.type),
            warning: \(charge.ranges.warning),
        },
        Messages: {
            description: \(charge.messages.cloudDescription),
            healthy: \(charge.messages.healthy),
            warning: \(charge.messages.warning)
        }
    },
    State: {
        title: \(state.title),
        type: \(state.type),
        describes: \(state.describes),
        Units: {
            title: \(String(describing: state.units?.title)),
            PurpleConvert: {
                by: \(String(describing: state.units?.convert?.by)),
                type: \(String(describing: state.units?.convert?.type))
            }
        },
        Values: {
            all: [
                \(String(describing: state.values?.all.joined(separator: ",                ")))
            ],
            warning: [
                \(String(describing: state.values?.warning.joined(separator: ",                ")))
            ],
            healthy: [
                \(String(describing: state.values?.healthy.joined(separator: ",                ")))
            ]
        }
    }
}
"""
        }
        
        public let charge: Charge
        public let state: Strengthv
        
        private enum CodingKeys: CodingKey {
            case charge, state
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.charge = try! container.decode(Charge.self, forKey: .charge)
            self.state = try! container.decode(Strengthv.self, forKey: .state)
        }
    }
    
    // MARK: - Charge
    public struct Charge: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Charge: {
    title: \(title),
    type: \(type),
    priority: \(priority),
    Units: {
        title: \(units.title),
        FluffyConvert: {
            type: \(units.convert.type)
        },
    },
    StrengthRanges: {
        type: \(ranges.type),
        warning: \(ranges.warning)
    },
    Messages: {
        description: \(messages.cloudDescription),
        healthy: \(messages.healthy),
        warning: \(messages.warning),
    }
}
"""
        }
        
        public let title, type: String
        public let priority: Int
        public let units: ChargeUnits
        public let ranges: StrengthRanges
        public let messages: Messages
        
        enum CodingKeys: CodingKey {
            case title, type, priority, units, ranges, messages
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.type = try! container.decode(String.self, forKey: .type)
            self.priority = try! container.decode(Int.self, forKey: .priority)
            self.units = try! container.decode(ChargeUnits.self, forKey: .units)
            self.ranges = try! container.decode(StrengthRanges.self, forKey: .ranges)
            self.messages = try! container.decode( Messages.self, forKey: .messages)
        }
    }
    
    // MARK: - ChargeUnits
    public struct ChargeUnits: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
ChargeUnits: {
    title: \(title),
    FluffyConvert: {
        type: \(convert.type)
    }
}
"""
        }
        
        public let title: String
        public let convert: FluffyConvert
        
        private enum CodingKeys: CodingKey {
            case title, convert
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.convert = try! container.decode(PCRemoteDiagnosticsMetaDataResponse.FluffyConvert.self, forKey: .convert)
        }
    }
    
    // MARK: - FluffyConvert
    public struct FluffyConvert: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
FluffyConvert: {
    type: \(type)
}
"""
        }
        
        public let type: String

        private enum CodingKeys: CodingKey {
            case type
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try! container.decode(String.self, forKey: .type)
        }
    }
    
    // MARK: - System
    public struct System: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
System: {
    MemoryUsage: {
        title: \(memory.usage.title),
        type: \(memory.usage.type),
        priority: \(memory.usage.priority),
        Units: {
            title: \(memory.usage.units.title),
            PurpleConvert: {
                by: \(String(describing: memory.usage.units.convert?.by)),
                type: \(String(describing: memory.usage.units.convert?.type))
            }
        },
        DiconnectRanges: {
            type: \(memory.usage.disconnectRanges.type),
            ratio: \(memory.usage.disconnectRanges.ratio),
            param1: \(memory.usage.disconnectRanges.param1),
            param2: \(memory.usage.disconnectRanges.param2)
        },
        Messages: {
            description: \(memory.usage.messages.cloudDescription),
            healthy: \(memory.usage.messages.healthy),
            warning: \(memory.usage.messages.warning)
        }
    },
    Total: {
        Strengthv: {
        title: \(memory.total.title),
        type: \(memory.total.type),
        describes: \(memory.total.describes)
        Units: {
            title: \(String(describing: memory.total.units?.title)),
            FluffyConvert: {
                by: \(String(describing: memory.total.units?.convert?.by)),
                type: \(String(describing: memory.total.units?.convert?.type))
            }

        },
        Values: {
            all: \(String(describing: memory.total.values?.all)),
            healthy: \(String(describing: memory.total.values?.healthy)),
            warning: \(String(describing: memory.total.values?.warning)),
        }
    }
}
"""
        }
        
        public let memory: Memory
        
        private enum CodingKeys: CodingKey {
            case memory
        }

        private init() {
            fatalError("Must use init with decoder.")
        }
                
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.memory = try! container.decode(PCRemoteDiagnosticsMetaDataResponse.Memory.self, forKey: .memory)
        }
    }
    
    // MARK: - Memory
    public struct Memory: Decodable {
        public let usage: MemoryUsage
        public let total: Strengthv
        
        public enum CodingKeys: String, CodingKey {
            case usage = "used"
            case total
        }

        private init() {
            fatalError("Must use init with decoder.")
        }
                
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.usage = try! container.decode(MemoryUsage.self, forKey: .usage)
            self.total = try! container.decode(Strengthv.self, forKey: .total)
        }
    }
    
    // MARK: - Used
    public struct MemoryUsage: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
MemoryUsage: {
    title: \(title),
    type: \(type),
    priority: \(priority),
    Units: {
        title: \(units.title),
        PurpleConvert: {
            by: \(String(describing: units.convert?.by)),
            type: \(String(describing: units.convert?.type))
        }
    },
    DiconnectRanges: {
        type: \(disconnectRanges.type),
        ratio: \(disconnectRanges.ratio),
        param1: \(disconnectRanges.param1),
        param2: \(disconnectRanges.param2)
    },
    Messages: {
        description: \(messages.cloudDescription),
        healthy: \(messages.healthy),
        warning: \(messages.warning)
    }
}
"""
        }
        
        public let title, type: String
        public let priority: Int
        public let units: StrengthvUnits
        public let disconnectRanges: DisconnectRanges
        public let messages: Messages
        
        public enum CodingKeys: String, CodingKey {
            case title, type, priority, units, disconnectRanges = "ranges", messages
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try! container.decode(String.self, forKey: .title)
            self.type = try! container.decode(String.self, forKey: .type)
            self.priority = try! container.decode(Int.self, forKey: .priority)
            self.units = try! container.decode(StrengthvUnits.self, forKey: .units)
            self.disconnectRanges = try! container.decode(DisconnectRanges.self, forKey: .disconnectRanges)
            self.messages = try! container.decode(Messages.self, forKey: .messages)
        }
    }
    
    // MARK: - Service
    public struct Service: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Service: {
    Coap: {
    
    },
    ServiceCloud: {
        FluffyPublish: {
            Strengthv: {
                title: \(cloud.publish.sent.title),
                type: \(cloud.publish.sent.type),
                describes: \(cloud.publish.sent.describes),
                Units: {
                    title: \(String(describing: cloud.publish.sent.units?.title))
                    PurpleConvert: {
                        by: \(String(describing: cloud.publish.sent.units?.convert?.by)),
                        type: \(String(describing: cloud.publish.sent.units?.convert?.type))
                    },
                }
                Values: {
                    all: \(String(describing: cloud.publish.sent.values?.all)),
                    healthy: \(String(describing: cloud.publish.sent.values?.healthy)),
                    warning: \(String(describing: cloud.publish.sent.values?.warning)),
                }
            }
        }
    }
}
"""
        }
        
        public let coap: Coap
        public let cloud: ServiceCloud
        
        private enum CodingKeys: CodingKey {
            case coap
            case cloud
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.coap = try! container.decode(Coap.self, forKey: .coap)
            self.cloud = try! container.decode(ServiceCloud.self, forKey: .cloud)
        }
    }
    
    // MARK: - ServiceCloud
    public struct ServiceCloud: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
ServiceCloud: {
    FluffyPublish: {
        Strengthv: {
            title: \(publish.sent.title),
            type: \(publish.sent.type),
            describes: \(publish.sent.describes),
            Units: {
                title: \(String(describing: publish.sent.units?.title))
                PurpleConvert: {
                    by: \(String(describing: publish.sent.units?.convert?.by)),
                    type: \(String(describing: publish.sent.units?.convert?.type))
                },
            }
            Values: {
                all: \(String(describing: publish.sent.values?.all)),
                healthy: \(String(describing: publish.sent.values?.healthy)),
                warning: \(String(describing: publish.sent.values?.warning)),
            }
        }
    }
}
"""
        }
        
        public let publish: FluffyPublish
        
        private enum CodingKeys: CodingKey {
            case publish
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.publish = try! container.decode(FluffyPublish.self, forKey: .publish)
        }
    }
    
    // MARK: - FluffyPublish
    public struct FluffyPublish: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
FluffyPublish: {
    Strengthv: {
        title: \(sent.title),
        type: \(sent.type),
        describes: \(sent.describes),
        Units: {
            title: \(String(describing: sent.units?.title))
            PurpleConvert: {
                by: \(String(describing: sent.units?.convert?.by)),
                type: \(String(describing: sent.units?.convert?.type))
            },
        }
        Values: {
            all: \(String(describing: sent.values?.all)),
            healthy: \(String(describing: sent.values?.healthy)),
            warning: \(String(describing: sent.values?.warning)),
        }
    }
}
"""
        }
        public let sent: Strengthv
        
        private enum CodingKeys: CodingKey {
            case sent
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.sent = try! container.decode(Strengthv.self, forKey: .sent)
        }
    }
    
    // MARK: - Coap
    public struct Coap: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
RoundTrip: {
    title: \(roundTrip.title),
    type: \(roundTrip.type),
    priority: \(roundTrip.priority),
    DisconnectRanges: {
        type: \(String(describing: roundTrip.ranges?.type)),
        ratio: \(String(describing: roundTrip.ranges?.ratio)),
        param1: \(String(describing: roundTrip.ranges?.param1)),
        param2: \(String(describing: roundTrip.ranges?.param2))
    },
    Units: {
        title: \(roundTrip.units.title)
    },
    Messages: {
        description: \(roundTrip.messages.cloudDescription),
        warning: \(roundTrip.messages.warning),
        healthy: \(roundTrip.messages.healthy)
    }
}
"""
        }
        
        public let roundTrip: RoundTrip
        
        private enum CodingKeys: String, CodingKey {
            case roundTrip = "round_trip"
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.roundTrip = try! container.decode(RoundTrip.self, forKey: .roundTrip)
        }
    }
    
}

// MARK: - PCRemoteDiagnosticsCellularNetworkStatusResponse
public struct PCRemoteDiagnosticsCellularNetworkStatusResponse: Decodable  {
    public let ok: Bool
    public let meta: Meta
    public let simStatus: SimStatus
    
    
    private enum CodingKeys: String, CodingKey {
        case ok, meta, simStatus
    }
    
    private init() {
        fatalError("Must use init with decoder.")
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.ok = try! container.decode(Bool.self, forKey: .ok)
        self.meta = try! container.decode(Meta.self, forKey: .meta)
        self.simStatus = try! container.decode(SimStatus.self, forKey: .simStatus)
    }
    
    // MARK: - Meta
    public struct Meta: Decodable  {
        public let createdAt, expiresAt, checkAgainAfter, state: String
        public let method, taskID: String
        
        private enum CodingKeys: CodingKey {
            case createdAt, expiresAt, checkAgainAfter, state, method, taskID
        }
        
        private init() {
            fatalError("Must use init with decoder.")
        }

        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.createdAt = try! container.decode(String.self, forKey: .createdAt)
            self.expiresAt = try! container.decode(String.self, forKey: .expiresAt)
            self.checkAgainAfter = try! container.decode(String.self, forKey: .checkAgainAfter)
            self.state = try! container.decode(String.self, forKey: .state)
            self.method = try! container.decode(String.self, forKey: .method)
            self.taskID = try! container.decode(String.self, forKey: .taskID)
        }
    }
    
    // MARK: - SimStatus
    public struct SimStatus: Decodable  {
        public let connected, gsmConnection, dataConnection: String
        
        private enum CodingKeys: CodingKey {
            case connected, gsmConnection, dataConnection
        }

        private init() {
            fatalError("Must use init with decoder.")
        }
                
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.connected = try! container.decode(String.self, forKey: .connected)
            self.gsmConnection = try! container.decode(String.self, forKey: .gsmConnection)
            self.dataConnection = try! container.decode(String.self, forKey: .dataConnection)
        }
    }
}


// MARK: - LastKnownDiagnosticsResponse
public struct LastKnownDiagnosticsResponse: Decodable, CustomStringConvertible {
    
    public var description: String {
        diagnostics.description
    }
    
    public let diagnostics: [Diagnostics]
    
    enum CodingKeys: String, CodingKey {
        case diagnostics = "diagnostics"
    }
    
    private init() {
        fatalError("Must use init with decoder.")
    }
}





// MARK: - HistoricalDiagnosticsResponse
public struct HistoricalDiagnosticsResponse: Decodable, CustomStringConvertible {
    
    public var description: String {
"""
HistoricalDiagnosticsResponse: {
    deviceId: \(diagnostics.deviceID),
    updatedAt: \(String(describing: try? Date.date(jSonDate: diagnostics.updatedAt))),
    Payload: {
        Device: {
            Network: {
                Signal: {
                    at: \(diagnostics.payload.device.network.signal.at),
                    strength: \(diagnostics.payload.device.network.signal.strength),
                    strengthUnits: \(diagnostics.payload.device.network.signal.strengthUnits),
                    strengthv: \(diagnostics.payload.device.network.signal.strengthv),
                    strengthUnits: \(diagnostics.payload.device.network.signal.strengthUnits),
                    strengthvType: \(diagnostics.payload.device.network.signal.strengthvType),
                    quality: \(diagnostics.payload.device.network.signal.quality),
                    qualityUnits: \(diagnostics.payload.device.network.signal.qualityUnits),
                    qualityv: \(diagnostics.payload.device.network.signal.qualityv),
                    qualityvUnits: \(diagnostics.payload.device.network.signal.qualityvUnits),
                    qualityvType: \(diagnostics.payload.device.network.signal.qualityvType)
                }
                Connection: {
                    status: \(diagnostics.payload.device.network.connection.status),
                    error: \(diagnostics.payload.device.network.connection.error),
                    attempts: \(diagnostics.payload.device.network.connection.attempts),
                    disconnects: \(diagnostics.payload.device.network.connection.disconnects),
                    disconnectReason: \(diagnostics.payload.device.network.connection.disconnectReason)
                }
            DeviceCloud: {
                Connection: {
                    status: \(diagnostics.payload.device.cloud.connection.status),
                    error: \(diagnostics.payload.device.cloud.connection.error),
                    attempts: \(diagnostics.payload.device.cloud.connection.attempts),
                    disconnects: \(diagnostics.payload.device.cloud.connection.disconnects),
                    disconnectReason: \(diagnostics.payload.device.cloud.connection.disconnectReason)
                }
                CloudCoap: {
                    transmit: \(diagnostics.payload.device.cloud.coap.transmit),
                    retransmit: \(diagnostics.payload.device.cloud.coap.retransmit),
                    unack: \(diagnostics.payload.device.cloud.coap.unack),
                    roundTrip: \(diagnostics.payload.device.cloud.coap.roundTrip)
                }
                PurplePublish: {
                    rateLimited: \(diagnostics.payload.device.cloud.publish.rateLimited)
                }
            }
            System: {
                uptime: \(diagnostics.payload.device.system.uptime),
                Memory: {
                    used: \(diagnostics.payload.device.system.memory.used),
                    total: \(diagnostics.payload.device.system.memory.total)
                }
            }
        }
        Service: {
            ServiceDevice: {
                status: \(diagnostics.payload.service.device.status)
            }
            ServiceCloud: {
                uptime: \(diagnostics.payload.service.cloud.uptime),
                FluffyPublish: {
                    sent: \(diagnostics.payload.service.cloud.publish.sent)
                }
            }
            ServiceCoap: {
                roundTrip: \(diagnostics.payload.service.coap.roundTrip)
            }
        }
    }
}
"""
    }
    
    public let diagnostics: Diagnostics
    
    enum CodingKeys: String, CodingKey {
        case diagnostics = "diagnostics"
    }
    
    private init() {
        fatalError("Requires init with decoder.")
    }
}
    
    // MARK: Diagnostics
    public struct Diagnostics: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Diagnostics: {
    deviceID: \(deviceID),
    updatedAt: \(String(describing: try? Date.date(jSonDate: updatedAt).description)),
    Payload: {
        Device: {
            Network: {
                Signal: {
                    at: \(payload.device.network.signal.at),
                    strength: \(payload.device.network.signal.strength),
                    strengthUnits: \(payload.device.network.signal.strengthUnits),
                    strengthv: \(payload.device.network.signal.strengthv),
                    strengthUnits: \(payload.device.network.signal.strengthUnits),
                    strengthvType: \(payload.device.network.signal.strengthvType),
                    quality: \(payload.device.network.signal.quality),
                    qualityUnits: \(payload.device.network.signal.qualityUnits),
                    qualityv: \(payload.device.network.signal.qualityv),
                    qualityvUnits: \(payload.device.network.signal.qualityvUnits),
                    qualityvType: \(payload.device.network.signal.qualityvType)
                }
                Connection: {
                    status: \(payload.device.network.connection.status),
                    error: \(payload.device.network.connection.error),
                    attempts: \(payload.device.network.connection.attempts),
                    disconnects: \(payload.device.network.connection.disconnects),
                    disconnectReason: \(payload.device.network.connection.disconnectReason)
                }
            DeviceCloud: {
                Connection: {
                    status: \(payload.device.cloud.connection.status),
                    error: \(payload.device.cloud.connection.error),
                    attempts: \(payload.device.cloud.connection.attempts),
                    disconnects: \(payload.device.cloud.connection.disconnects),
                    disconnectReason: \(payload.device.cloud.connection.disconnectReason)
                }
                CloudCoap: {
                    transmit: \(payload.device.cloud.coap.transmit),
                    retransmit: \(payload.device.cloud.coap.retransmit),
                    unack: \(payload.device.cloud.coap.unack),
                    roundTrip: \(payload.device.cloud.coap.roundTrip)
                }
                PurplePublish: {
                    rateLimited: \(payload.device.cloud.publish.rateLimited)
                }
            }
            System: {
                uptime: \(payload.device.system.uptime),
                Memory: {
                    used: \(payload.device.system.memory.used),
                    total: \(payload.device.system.memory.total)
                }
            }
        }
        Service: {
            ServiceDevice: {
                status: \(payload.service.device.status)
            }
            ServiceCloud: {
                uptime: \(payload.service.cloud.uptime),
                FluffyPublish: {
                    sent: \(payload.service.cloud.publish.sent)
                }
            }
            ServiceCoap: {
                roundTrip: \(payload.service.coap.roundTrip)
            }
        }
    }
}
"""
        }
        
        public let deviceID: String
        public let payload: Payload
        public let updatedAt: String
        
        private enum CodingKeys: String, CodingKey {
            case deviceID = "deviceID"
            case payload = "payload"
            case updatedAt = "updated_at"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.deviceID = try container.decode(String.self, forKey: .deviceID)
            self.payload = try container.decode(Payload.self, forKey: .payload)
            self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        }
    }
    
    // MARK: Payload
    public struct Payload: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Payload: {
    Device: {
        Network: {
            Signal: {
                at: \(device.network.signal.at),
                strength: \(device.network.signal.strength),
                strengthUnits: \(device.network.signal.strengthUnits),
                strengthv: \(device.network.signal.strengthv),
                strengthUnits: \(device.network.signal.strengthUnits),
                strengthvType: \(device.network.signal.strengthvType),
                quality: \(device.network.signal.quality),
                qualityUnits: \(device.network.signal.qualityUnits),
                qualityv: \(device.network.signal.qualityv),
                qualityvUnits: \(device.network.signal.qualityvUnits),
                qualityvType: \(device.network.signal.qualityvType)
            }
            Connection: {
                status: \(device.network.connection.status),
                error: \(device.network.connection.error),
                attempts: \(device.network.connection.attempts),
                disconnects: \(device.network.connection.disconnects),
                disconnectReason: \(device.network.connection.disconnectReason)
            }
        DeviceCloud: {
            Connection: {
                status: \(device.cloud.connection.status),
                error: \(device.cloud.connection.error),
                attempts: \(device.cloud.connection.attempts),
                disconnects: \(device.cloud.connection.disconnects),
                disconnectReason: \(device.cloud.connection.disconnectReason)
            }
            CloudCoap: {
                transmit: \(device.cloud.coap.transmit),
                retransmit: \(device.cloud.coap.retransmit),
                unack: \(device.cloud.coap.unack),
                roundTrip: \(device.cloud.coap.roundTrip)
            }
            PurplePublish: {
                rateLimited: \(device.cloud.publish.rateLimited)
            }
        }
        System: {
            uptime: \(device.system.uptime),
            Memory: {
                used: \(device.system.memory.used),
                total: \(device.system.memory.total)
            }
        }
    }
    Service: {
        ServiceDevice: {
            status: \(service.device.status)
        }
        ServiceCloud: {
            uptime: \(service.cloud.uptime),
            FluffyPublish: {
                sent: \(service.cloud.publish.sent)
            }
        }
        ServiceCoap: {
            roundTrip: \(service.coap.roundTrip)
        }
    }
}
"""
        }
        
        public let device: PayloadDevice
        public let service: Service
        
        private enum CodingKeys: String, CodingKey {
            case device = "device"
            case service = "service"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.device = try container.decode(PayloadDevice.self, forKey: .device)
            self.service = try container.decode(Service.self, forKey: .service)
        }
    }
    
    // MARK: PayloadDevice
    public struct PayloadDevice: Decodable, CustomStringConvertible {
        
        public var description: String {
            
"""
Network: {
    Signal: {
        at: \(network.signal.at),
        strength: \(network.signal.strength),
        strengthUnits: \(network.signal.strengthUnits),
        strengthv: \(network.signal.strengthv),
        strengthUnits: \(network.signal.strengthUnits),
        strengthvType: \(network.signal.strengthvType),
        quality: \(network.signal.quality),
        qualityUnits: \(network.signal.qualityUnits),
        qualityv: \(network.signal.qualityv),
        qualityvUnits: \(network.signal.qualityvUnits),
        qualityvType: \(network.signal.qualityvType)
    }
    Connection: {
        status: \(network.connection.status),
        error: \(network.connection.error),
        attempts: \(network.connection.attempts),
        disconnects: \(network.connection.disconnects),
        disconnectReason: \(network.connection.disconnectReason)
    }
    DeviceCloud: {
        Connection: {
            status: \(cloud.connection.status),
            error: \(cloud.connection.error),
            attempts: \(cloud.connection.attempts),
            disconnects: \(cloud.connection.disconnects),
            disconnectReason: \(cloud.connection.disconnectReason)
        }
        CloudCoap: {
            transmit: \(cloud.coap.transmit),
            retransmit: \(cloud.coap.retransmit),
            unack: \(cloud.coap.unack),
            roundTrip: \(cloud.coap.roundTrip)
        }
        PurplePublish: {
            rateLimited: \(cloud.publish.rateLimited)
        }
    }
    System: {
        uptime: \(system.uptime),
        Memory: {
            used: \(system.memory.used),
            total: \(system.memory.total)
        }
    }
}
"""
        }
        
        public let network: Network
        public let cloud: DeviceCloud
        public let system: System
        
        private enum CodingKeys: String, CodingKey {
            case network = "network"
            case cloud = "cloud"
            case system = "system"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.network = try container.decode(Network.self, forKey: .network)
            self.cloud = try container.decode(DeviceCloud.self, forKey: .cloud)
            self.system = try container.decode(System.self, forKey: .system)
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
    }
    CloudCoap: {
        transmit: \(coap.transmit),
        retransmit: \(coap.retransmit),
        unack: \(coap.unack),
        roundTrip: \(coap.roundTrip)
    }
    PurplePublish: {
        rateLimited: \(publish.rateLimited)
    }
}
"""
        }
        
        public let connection: Connection
        public let coap: CloudCoap
        public let publish: PurplePublish
        
        private enum CodingKeys: String, CodingKey {
            case connection = "connection"
            case coap = "coap"
            case publish = "publish"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.connection = try container.decode(Connection.self, forKey: .connection)
            self.coap = try container.decode(CloudCoap.self, forKey: .coap)
            self.publish = try container.decode(PurplePublish.self, forKey: .publish)
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
            case transmit = "transmit"
            case retransmit = "retransmit"
            case unack = "unack"
            case roundTrip = "round_trip"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.transmit = try container.decode(Int.self, forKey: .transmit)
            self.retransmit = try container.decode(Int.self, forKey: .retransmit)
            self.unack = try container.decode(Int.self, forKey: .unack)
            self.roundTrip = try container.decode(Int.self, forKey: .roundTrip)
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
        fatalError("Requires init with decoder.")
    }
    
    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.status = try! container.decode(String.self, forKey: .status)
        self.error = try! container.decode(Int.self, forKey: .error)
        self.attempts = try! container.decode(Int.self, forKey: .attempts)
        self.disconnects = try! container.decode(Int.self, forKey: .disconnects)
        self.disconnectReason = try! container.decode(String.self, forKey: .disconnectReason)
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
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.rateLimited = try! container.decode(Int.self, forKey: .rateLimited)
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
        strengthUnits: \(signal.strengthUnits),
        strengthvType: \(signal.strengthvType),
        quality: \(signal.quality),
        qualityUnits: \(signal.qualityUnits),
        qualityv: \(signal.qualityv),
        qualityvUnits: \(signal.qualityvUnits),
        qualityvType: \(signal.qualityvType)
    }
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
        
        private enum CodingKeys: String, CodingKey {
            case signal = "signal"
            case connection = "connection"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.signal = try! container.decode(Signal.self, forKey: .signal)
            self.connection = try! container.decode(Connection.self, forKey: .connection)
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
    strengthUnits: \(strengthUnits),
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
            case at, strength, strengthUnits = "strength_units", strengthv, strengthvUnits = "strengthv_units", strengthvType = "strengthv_type", quality, qualityUnits = "quality_units", qualityv, qualityvUnits = "qualityv_units", qualityvType = "qualityv_type"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.at = try! container.decode(String.self, forKey: .at)
            self.strength = try! container.decode(Int.self, forKey: .strength)
            self.strengthUnits = try! container.decode(String.self, forKey: .strengthUnits)
            self.strengthv = try! container.decode(Int.self, forKey: .strengthv)
            self.strengthvUnits = try! container.decode(String.self, forKey: .strengthvUnits)
            self.strengthvType = try! container.decode(String.self, forKey: .strengthvType)
            self.quality = try! container.decode(Double.self, forKey: .quality)
            self.qualityUnits = try! container.decode(String.self, forKey: .qualityUnits)
            self.qualityv = try! container.decode(Int.self, forKey: .qualityv)
            self.qualityvUnits = try! container.decode(String.self, forKey: .qualityvUnits)
            self.qualityvType = try! container.decode(String.self, forKey: .qualityvType)
        }
    }
    
    // MARK: System
    public struct System: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
System: {
    uptime: \(uptime),
    Memory: {
        used: \(memory.used),
        total: \(memory.total)
    }
}
"""
            
        }
        
        public let uptime: Int
        public let memory: Memory
        
        private enum CodingKeys: String, CodingKey {
            case uptime, memory
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.uptime = try! container.decode(Int.self, forKey: .uptime)
            self.memory = try! container.decode(Memory.self, forKey: .memory)
        }
    }
    
    // MARK: Memory
    public struct Memory: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Memory: {
    usage: \(used)
    total: \(total)
}
"""
        }
        
        public let used: Int
        public let total: Int
        
        private enum CodingKeys: String, CodingKey {
            case used, total
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.used = try! container.decode(Int.self, forKey: .used)
            self.total = try! container.decode(Int.self, forKey: .total)
        }
    }
    
    // MARK: Service
    public struct Service: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
Service: {
    ServiceDevice: {
        status: \(device.status)
    }
    ServiceCloud: {
        uptime: \(cloud.uptime),
        FluffyPublish: {
            sent: \(cloud.publish.sent)
        }
    }
    ServiceCoap: {
        roundTrip: \(coap.roundTrip)
    }
}
"""
        }
        
        public let device: ServiceDevice
        public let cloud: ServiceCloud
        public let coap: ServiceCoap
        
        private enum CodingKeys: String, CodingKey {
            case device, cloud, coap
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.device = try! container.decode(ServiceDevice.self, forKey: .device)
            self.cloud = try! container.decode(ServiceCloud.self, forKey: .cloud)
            self.coap = try! container.decode(ServiceCoap.self, forKey: .coap)
        }
    }
    
    // MARK: ServiceCloud
    public struct ServiceCloud: Decodable, CustomStringConvertible {
        
        public var description: String {
"""
ServiceCloud: {
    uptime: \(uptime),
    FluffyPublish: {
        sent: \(publish.sent)
    }
}

"""
        }
        
        public let uptime: Int
        public let publish: FluffyPublish
        
        private enum CodingKeys: String, CodingKey {
            case uptime, publish
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.uptime = try! container.decode(Int.self, forKey: .uptime)
            self.publish = try! container.decode(FluffyPublish.self, forKey: .publish)
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
        
        private enum CodingKeys: String, CodingKey {
            case sent = "sent"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.sent = try! container.decode(Int.self, forKey: .sent)
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
        
        public let roundTrip: Int
        
        private enum CodingKeys: String, CodingKey {
            case roundTrip = "round_trip"
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.roundTrip = try! container.decode(Int.self, forKey: .roundTrip)
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
        
        private enum CodingKeys: String, CodingKey {
            case status
        }
        
        private init() {
            fatalError("Requires init with decoder.")
        }
        
        public init(from decoder: Decoder) throws {
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            self.status = try! container.decode(String.self, forKey: .status)
        }
    }
    

