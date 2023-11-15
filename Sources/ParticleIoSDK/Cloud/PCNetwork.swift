    //
    //  PCNetwork.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 11/11/19.
    //  Copyright © 2019 Spell Software Inc. All rights reserved.
    //

import Foundation
import Combine

public typealias EventBlock = (PCEvent) -> Void
public typealias CompletionBlock = (PCError?) -> Void


final internal class PCNetwork: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    internal static let shared = PCNetwork()
    
    private var eventDelegate = EventDelegate()
    
    internal var cancellables = Set<AnyCancellable>()
    
    private lazy var session = URLSession(configuration: self.configurationForUrlSession)
        
    fileprivate var configurationForUrlSession: URLSessionConfiguration = {
        
        let configuration = URLSessionConfiguration.default
        
        configuration.waitsForConnectivity = true
        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.networkServiceType = .responsiveData
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil
        
        return configuration
    }()
}

    //MARK: - Events
extension PCNetwork {
    
    
    private func subscribe(request: URLRequest, token: PCAccessToken, onEvent: EventBlock?, completion: CompletionBlock?) {
        
        let task = session.dataTask(with: request)
        task.delegate = self.eventDelegate
        eventDelegate.connectionTasks[task] = (event: onEvent, completion: completion)
        task.resume()
    }
    
    
    internal func subscribe(eventName: EventName?, deviceId: DeviceID, token: PCAccessToken, onEvent: EventBlock? = nil, completion: CompletionBlock?) {
        
        var request = CloudResource.requestForResource(.getDeviceEventStream(eventName: eventName, deviceID: deviceId, token: token))
        request.timeoutInterval = .infinity
        
        return self.subscribe(request: request, token: token, onEvent: onEvent, completion: completion)
    }
    
    
    internal func subscribe(eventName: EventName?, productId: ProductID, token: PCAccessToken, onEvent: EventBlock?, completion: CompletionBlock?) {
        
        var request = CloudResource.requestForResource(.getProductEventStream(eventName: eventName, productIdOrSlug: productId, token: token))
        request.timeoutInterval = .infinity
        
        return self.subscribe(request: request, token: token, onEvent: onEvent, completion: completion)
    }

    
    internal func subscribe(eventName: EventName, token:PCAccessToken, onEvent: EventBlock?, completion: CompletionBlock?) {
        
        var request = CloudResource.requestForResource(.getEventStream(eventName: eventName, token: token))
        request.timeoutInterval = .infinity
        
        return self.subscribe(request: request, token: token, onEvent: onEvent, completion: completion)
    }
}



    //MARK: - Cloud Requests aka api calls
extension PCNetwork {
    
        //MARK: CurrentValueSubject
    internal func cloudRequest<T: Decodable>(_ resource: CloudResource, type: T.Type) -> CurrentValueSubject<T?, PCError> {
                
        let request = CloudResource.requestForResource(resource)
        let subject = CurrentValueSubject<T?, PCError>(nil)
        
        self.session.dataTask(with: request) { [weak self] data, response, error in
            
            guard let self = self else {
                subject.send(completion:
                        .failure(
                            PCError(
                                code: .deinitializedObject,
                                description: "Deinitialized object for request: \(request)\n")
                        )
                )
                return
            }
            
            let result = self.decodeParticleResponse(resource: resource, request: request,type: type, data: data, response: response, error: error)
            
            switch result {
                case .success(let decodable):
                    subject.send(decodable)
                case .failure(let error):
                    subject.send(completion: .failure(error))
            }
        }.resume()
        
        return subject
    }

        //MARK: Async
    internal func cloudRequest<T: Decodable>(_ resource: CloudResource, type: T.Type) async throws-> T {
        
        let request = CloudResource.requestForResource(resource)
        
        let taskResult = try await self.session.data(for: request)
        let outcome = self.decodeParticleResponse(resource: resource, request: request, type: type, data: taskResult.0, response: taskResult.1)
        
        switch outcome {
                
            case .success(let decodable):
                return decodable
                
            case .failure(let error):
                throw error
        }
    }
    
    
    //MARK: Futures
    internal func cloudRequest<T: Decodable>(_ resource: CloudResource, type: T.Type) -> Future<T, PCError> {
                
        return Future { promise in
            let request = CloudResource.requestForResource(resource)
            
            self.session.dataTask(with: request) { [weak self] data, response, error in
                
                guard let self = self else {
                    promise(.failure(
                        PCError(
                            code: .deinitializedObject,
                            description: "Deinitialized object for request: \(request)\n")
                        )
                    )
                    return
                }
                
                let result = self.decodeParticleResponse(resource: resource, request: request,type: type, data: data, response: response, error: error)
                
                promise(result)
            }.resume()
        }
    }
    
    
        // MARK: Completion Handlers
    internal func cloudRequest<T: Decodable>(_ resource: CloudResource, type: T.Type, completion: ( (Result<T,PCError>) -> Void)? ) {
        
        let request = CloudResource.requestForResource(resource)
        
        let task = self.session.dataTask(with: request) { [weak self] data, response, error in
            
            guard let self = self else {
                completion?(
                    .failure(
                        PCError(code: .deinitializedObject, description: PCErrorCode.deinitializedObject.description ) 
                    )
                )
                return
            }
            
            let outcome = self.decodeParticleResponse(resource: resource, request: request, type: type, data: data, response: response, error: error)
            completion?(outcome)
        }
        
        task.resume()
    }
}

    //MARK: - Decoding and Error Handling
extension PCNetwork {
    
    private func decodeParticleResponse<T: Decodable>(resource: CloudResource, request: URLRequest, type: T.Type, data: Data?, response: URLResponse?, error: Error? = nil) -> Result<T, PCError> {
                
        
        if type == ServerResponses.NoResponse.self,
           let data = data,
           let code = (response as? HTTPURLResponse)?.statusCode,
           String(data: data, encoding: .utf8) == "",
            code > 199 && code < 299 {
            
            if let error = error {
                
                return .failure(PCError(code: .undelyingError, description: "\((error as NSError).localizedDescription)", underlyingError: error))
            } else {
                
                return .success(ServerResponses.NoResponse(ok: true) as! T)
            }
        }
        
        if let data = data {
            
            if let result = try? JSONDecoder().decode(type, from: data ) {
                
                return .success( result )
                
            } else {
                return .failure(PCError.handleError(error: error, resource: resource, request: request, response: response, data: data) )
            }
        }
        return .failure( PCError.handleError(error: error, resource: resource, request: request, response: response, data: data) )
    }
}

internal class EventDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    
    internal var connectionTasks = [URLSessionDataTask : (event: EventBlock?, completion: CompletionBlock?)]()

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        
        if response.url?.host == "api.particle.io",
           response.expectedContentLength < 1024,
           response.mimeType == HTTPContentType.events.rawValue {
            
            return .becomeStream
        }
        
        return .cancel
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let request = task.currentRequest else {return}
        let replacement = session.dataTask(with: request)
        self.connectionTasks[replacement] = self.connectionTasks[task as! URLSessionDataTask]
        self.connectionTasks[task as! URLSessionDataTask] = nil
    }
        
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        
        Task {
            
            while dataTask.state == .running {
               
                if let data = try await streamTask.readData(ofMinLength: 1, maxLength: 128, timeout: 60).0,
                   let event = PCEvent(serverData: data),
                   let block = self.connectionTasks[dataTask]?.event {
                    
                    block(event)
                    sleep(30)
                }
            }
        }
    }
}
