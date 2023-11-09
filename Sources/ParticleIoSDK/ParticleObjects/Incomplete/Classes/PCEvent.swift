//
//  PCEvent.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/9/23.
//

import Foundation
import Combine


///The name of a particle event.
public struct EventName {
    
    ///The string value of the instance..
    public let rawValue: String
    
    ///Creates a new instance.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

///Simple cache of PCEvent to keep memory from growing out of control when a lot of events are recieved and stored over time.
public class EventCache: NSObject, ObservableObject {
    
    ///Human readable representation of the instance.
    public override var description: String {
"""
EventCache: (\(#dsohandle)) {
    data: {
        \(data.map({
            "name: \($0.key),\n\t\tdata: \($0.value.map({item in "{\n\t\t\tvalue: \(item.value),\n\t\t\tpublishedAt: \(item.publishedAt),\n\t\t\tcoreid: \(item.coreid),\n\t\t\tttl: \(item.ttl)\n\t\t}"}))"
        }).joined(separator: ",\n"))
    }
}
"""
    }
    
    ///Used to decide if an event should be evicted. This block is called when the event is about to be removed from memory and destroyed. If you wish to keep the event longer return false.
    public typealias AllowEveiction = (PCEvent) -> Bool
    
    public typealias EventName = String
    public typealias EventData = PCEvent.EventData
    
    private var evictionClosure: AllowEveiction?
    
    ///The maximum allowed number of events to keep. This number can change if you refuse eveiction of an event. using the shouldAllowEvictionOfEventData function.
    public var countLimit: Int {
        didSet {
            evictIfNeeded()
        }
    }
    
    private var internalData = Set<PCEvent>()
    
    ///The PCEvents in cache. These are sorted by the Date published.
    /// - note: These events may have been recieved out of order.
    public var data: [EventName : [EventData]] {
        internalData
            .map({($0.name, $0.data)})
            .sorted(by: {$0.1.publishedAt > $1.1.publishedAt})
            .reduce(into: [String: [PCEvent.EventData]]()) { partialResult, tuple in
            
                partialResult[tuple.0, default: [EventData]()].append(tuple.1)
        }
    }
    
    ///Used to insert an additional event into the cache.
    public func append(_ newItem: PCEvent) throws {
        
        DispatchQueue.main.async { [weak self] in
           
            guard let self else { return }
           
            self.objectWillChange.send()
            self.internalData.insert(newItem)
            self.evictIfNeeded()
        }
    }
    
    ///Create a new event cache with the preferred count limit. The default limit is 10.
    public init(countLimit: Int = 10) {
        self.countLimit = countLimit
    }
    
    private func evictIfNeeded() {
       
        while internalData.count > self.countLimit {
           
            if let last = internalData
                .sorted(by: {$0.data.publishedAt > $1.data.publishedAt})
                .last {
                
                //give user an opportunity to keep item from eviction.
                if evictionClosure?(last) ?? true {
                    DispatchQueue.main.async { [weak self] in
                        self?.objectWillChange.send()
                        self?.internalData.remove(last)
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.objectWillChange.send()
                        self?.countLimit += 1
                    }
                }
            }
        }
    }
    
    ///Use this function to prevent eviction of PCEvents you may wish to keep around.
    /// - Important: If you refuse eviction the cache limit will increase.
    public func shouldAllowEvictionOfEventData(_ evictionHandler: @escaping AllowEveiction) {
        self.evictionClosure = evictionHandler
    }
}


    // MARK: - PCEvent
public class PCEvent: NSObject, Codable { //}, Hashable, Equatable {
    
    
    public override var description: String {
"""
PCEvent: {
    uuid: \(uuid.uuidString),
    name: \(name),
    EventData: {
        value: \(data.value),
        publishedAt: \(descriptionDateString(jsonDate: data.publishedAt)),
        coreId: \(data.coreid),
        ttl: \(data.ttl)
    }
}
"""
    }
        
    public let uuid = UUID()
    public let name: String
    public let data: EventData
    
    private enum CodingKeys: CodingKey {
        case uuid, event, data
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PCEvent.CodingKeys.self)
        try container.encode(name, forKey: .event)
        try container.encodeIfPresent(data, forKey: .data)

    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .event)
        self.data = try container.decode(PCEvent.EventData.self, forKey: .data)
    }
    
    
    public init?(serverData: Data) {
        
        guard let string = String(data: serverData, encoding: .utf8),
              !string.isEmpty
        else {
            return nil
        }

        var dataString = ""
        let scanner = Scanner(string: string)
        _ = scanner.scanString("event:")
        guard let eventString = scanner.scanUpToCharacters(from: CharacterSet.newlines),
        eventString != ":ok" else { return nil }
        self.name = eventString
        
        _ = scanner.scanString("data:")
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            if let char = scanner.scanCharacter() {
                dataString.append( String(char))
            }
        }
        
        if !dataString.isEmpty,
           let data = try? JSONDecoder().decode(EventData.self, from: dataString.data(using: .utf8)!) {
            self.data = data
            
        } else {
            return nil
        }
    }
    
    private override init() {
        fatalError("Must use init with server data")
    }
    
    public struct EventData: Codable, Hashable, Equatable, CustomDebugStringConvertible, CustomStringConvertible {
        
        public var description: String {
"""
EventData: {
    value: \(value),
    publishedAt: \(descriptionDateString(jsonDate: publishedAt)),
    coreId: \(coreid),
    ttl: \(ttl)
}
"""
        }
        
        public var debugDescription: String {
            "value: \(value), publishedAt: \(descriptionDateString(jsonDate: publishedAt)), coreId: \(coreid), ttl: \(ttl)"
        }
        
        public let value: String
        public let publishedAt: String
        public let coreid: String
        public let ttl: Int
        
        private enum CodingKeys: String, CodingKey {
            case data, publishedAt = "published_at", coreid, ttl
        }
        
        private init(value: String, publishedAt: String, coreid: String, ttl: Int) {
            self.value = value; self.publishedAt = publishedAt; self.coreid = coreid; self.ttl = ttl
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: PCEvent.EventData.CodingKeys.self)
            try container.encode(value, forKey: .data)
            try container.encode(publishedAt, forKey: .publishedAt)
            try container.encode(coreid, forKey: .coreid)
            try container.encode(ttl, forKey: .ttl)
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<PCEvent.EventData.CodingKeys> = try! decoder.container(keyedBy: PCEvent.EventData.CodingKeys.self)
            self.value = try container.decode(String.self, forKey: PCEvent.EventData.CodingKeys.data)
            self.publishedAt = try container.decode(String.self, forKey: PCEvent.EventData.CodingKeys.publishedAt)
            self.coreid = try container.decode(String.self, forKey: PCEvent.EventData.CodingKeys.coreid)
            self.ttl = try container.decode(Int.self, forKey: PCEvent.EventData.CodingKeys.ttl)
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(value)
            hasher.combine(publishedAt)
            hasher.combine(coreid)
            hasher.combine(ttl)
        }
        
        public static func == (lhs: EventData, rhs: EventData) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }

    public static func == (lhs: PCEvent, rhs: PCEvent) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension PCEvent {
   
    public struct PublishResponse: Decodable {
        public let ok: Bool
        public let error: String?
    }
}



extension PCEvent {
    
    
    ///Subscribe to Events
    ///
    ///Subscribes to server sent events. [See publishing events from a device](https://docs.particle.io/reference/device-os/firmware/#particle-publish-) [and also](https://docs.particle.io/reference/cloud-apis/api/#events) for information on particle events.
    /// - note: There is no guarantee on recieving an event. Even when a connection is open events may not make it through.
    /// - Requires: Scope of events:get
    /// - Parameter eventName: The name of the event to subscribe to.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Parameter onEvent: Closure that is called when an event by that name is recieved.
    /// - Parameter completion: Closure that is called when the connection is closed. This will contain an PCError indicating the subscription failure.
    public func subscribeToEventsFor(eventName: EventName, token: PCAccessToken, onEvent: @escaping (PCEvent) -> Void, completion: ((PCError?) -> Void)?) {
        
        guard !eventName.rawValue.isEmpty else {
            completion?(PCError(code: .invalidArguments, description: "event name cannot be nil."))
            return
        }
        
        PCNetwork.shared.subscribe(eventName: eventName, token: token, onEvent: onEvent, completion: completion)
    }

    
    
    ///Subscribe to Events
    ///
    ///Subscribes to server sent events. [See publishing events from a device](https://docs.particle.io/reference/device-os/firmware/#particle-publish-) [and also](https://docs.particle.io/reference/cloud-apis/api/#events) for information on particle events.
    /// - note: There is no guarantee on recieving an event. Even when a connection is open events may not make it through.
    /// - Requires: Scope of events:get
    /// - Parameter eventName: The name of the event to subscribe to.
    /// - Parameter token: The representation of a particle access token with appropriate permissions.
    /// - Parameter onEvent: Closure that is called when an event by that name is recieved.
    /// - Parameter completion: Closure that is called when the connection is closed. This will contain an PCError indicating the subscription failure.
    static public func subscribeToEventsFor(eventName: EventName, token: PCAccessToken, onEvent: @escaping (PCEvent) -> Void, completion: ((PCError?) -> Void)?) {
        
        guard !eventName.rawValue.isEmpty else {
            completion?(PCError(code: .invalidArguments, description: "event name cannot be nil."))
            return
        }
        
        PCNetwork.shared.subscribe(eventName: eventName, token: token, onEvent: onEvent, completion: completion)
    }

    
    ///Publish an event
    ///
    ///Used to publish an event from the API.
    ///
    /// - Requires: Scope of events:send
    /// - Parameter productIdOrSlug: The id of the product to limit the publish to.
    /// - Parameter eventName: The name of the event published.
    /// - Parameter data: The content of the publish.
    /// - Parameter private: If you wish this event to be publicly visible.
    /// - Parameter ttl: How long the event should persist in seconds.
    static public func publishEvent(productIdOrSlug: ProductID? = nil, eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void)  {
        
        guard !eventName.rawValue.isEmpty
        else {
            completion(.failure( PCError(code: .invalidArguments,
                                         description: "eventName parameters cannot be an empty string when publishing to events.\n")))
            return
        }
        
        PCNetwork.shared.cloudRequest(.publishEvent(eventName: eventName, productIDorSlug: productIdOrSlug, data: data, private: isPrivate, ttl: ttl, token: token), type: PCEvent.PublishResponse.self, completion: { response in
            do {
                let result = try handlePublishResponse(response)
                completion(result)
            } catch {
                completion(.failure(error as! PCError))
            }
        })
    }
    
    
    ///Publish an event
    ///
    ///Used to publish an event from the API.
    ///
    /// - Requires: Scope of events:send
    /// - Parameter productIdOrSlug: The id of the product to limit the publish to.
    /// - Parameter eventName: The name of the event published.
    /// - Parameter data: The content of the publish.
    /// - Parameter private: If you wish this event to be publicly visible.
    /// - Parameter ttl: How long the event should persist in seconds.
    static public func publishEvent(productIdOrSlug: ProductID? = nil, eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, token: PCAccessToken) async throws -> Bool {
        
        guard !eventName.rawValue.isEmpty
        else {
            throw PCError(code: .invalidArguments,
                          description: "eventName parameters cannot be an empty string when publishing to events.\n")
        }
        
        let response = try await PCNetwork.shared.cloudRequest(.publishEvent(eventName: eventName, productIDorSlug: productIdOrSlug, data: data, private: isPrivate, ttl: ttl, token: token), type: PCEvent.PublishResponse.self)
        
        return try handlePublishResponse(.success(response)).get()
    }
    
    //Simply change response to a Bool
    static internal func handlePublishResponse(_ response: Result<PCEvent.PublishResponse, PCError>) throws -> Result<Bool, PCError> {
       
        do {
            
            if try response.get().ok {
                return .success(true)
            }
            throw PCError(code: .unknown, description: "The server reports an error but did not give a description.")
            
        } catch {
            throw PCError(code: .undelyingError, description: error.localizedDescription, underlyingError: error)
        }
    }
}



extension PCProduct {

    ///Publish an event
    ///
    ///Used to publish an event from the API.
    ///
    /// - Requires: Scope of events:send
    /// - Parameter eventName: The name of the event published.
    /// - Parameter data: The content of the publish.
    /// - Parameter private: If you wish this event to be publicly visible.
    /// - Parameter ttl: How long the event should persist in seconds.
    public func publishEvent(eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void)  {
        
        PCEvent.publishEvent(productIdOrSlug: ProductID(String(self.id)), eventName: eventName, data: data, isPrivate: isPrivate, ttl: ttl, token: token, completion:completion)
    }
    
    
    ///Publish an event
    ///
    ///Used to publish an event from the API.
    ///
    /// - Requires: Scope of events:send
    /// - Parameter eventName: The name of the event published.
    /// - Parameter data: The content of the publish.
    /// - Parameter private: If you wish this event to be publicly visible.
    /// - Parameter ttl: How long the event should persist in seconds.
    public func publishEvent(eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, token: PCAccessToken) async throws -> Bool {
        
        try await PCEvent.publishEvent(productIdOrSlug: ProductID(String(self.id)), eventName: eventName, data: data, isPrivate: isPrivate, ttl: ttl, token: token)
    }
    
    
    ///Publish an event
    ///
    ///Used to publish an event from the API.
    ///
    /// - Requires: Scope of events:send
    /// - Parameter productIdOrSlug: The id of the product to limit the publish to.
    /// - Parameter eventName: The name of the event published.
    /// - Parameter data: The content of the publish.
    /// - Parameter private: If you wish this event to be publicly visible.
    /// - Parameter ttl: How long the event should persist in seconds.
    static public func publishEvent(productIdOrSlug: ProductID? = nil, eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, token: PCAccessToken, completion: @escaping (Result<Bool, PCError>) -> Void)  {
        
        PCEvent.publishEvent(productIdOrSlug: productIdOrSlug, eventName: eventName, data: data, isPrivate: isPrivate, ttl: ttl, token: token, completion: completion)
        
    }
    
    
    ///Publish an event
    ///
    ///Used to publish an event from the API.
    ///
    /// - Requires: Scope of events:send
    /// - Parameter productIdOrSlug: The id of the product to limit the publish to.
    /// - Parameter eventName: The name of the event published.
    /// - Parameter data: The content of the publish.
    /// - Parameter private: If you wish this event to be publicly visible.
    /// - Parameter ttl: How long the event should persist in seconds.
    static public func publishEvent(productIdOrSlug: ProductID? = nil, eventName: EventName, data: String?, isPrivate: Bool? = nil, ttl: Int? = nil, token: PCAccessToken) async throws -> Bool {
        
        try await PCEvent.publishEvent(productIdOrSlug: productIdOrSlug, eventName: eventName, data: data, isPrivate: isPrivate, ttl: ttl, token: token)
    }
}
