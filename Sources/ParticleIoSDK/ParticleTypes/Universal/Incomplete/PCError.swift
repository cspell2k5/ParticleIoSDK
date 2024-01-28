    //
    //  PCError.swift
    //  Particle2
    //
    //  Created by Craig Spell on 11/12/19.
    //  Copyright © 2019 Spell Software Inc. All rights reserved.
    //

import Foundation

public let PCErrorDomain = "Spell_Software_Particle_Error_Domain"

    //Representable by Particle Json Response

public enum PCErrorCode: Int, CustomStringConvertible {
    case unauthenticated = -1
    case badData = -2
    case jSonDataMismatch = -3
    case networkError = -4
    case itemNotFound = -5
    case undelyingError = -6
    case networkFailure = -7
    case deviceNotResponding = -8
    case incorrectCredentials = -9
    case invalidArguments = -10
    case failedToParseJsonDate = -11
    case failedToGetTokenInfo = -12
    case connectionClosed = -13
    case notAvailableOnPlatform = -14

        //MARK: Server Response Errors
    case badRequestFromServer = 400
    case unauthorizedFromServer = 401
    case forbiddenFromServer = 403
    case notFoundFromServer = 404
    case timedOutFromServer = 408
    case tooManyRequestsFromServer = 429
    case errorsOnServer = 500
    
    
    case deinitializedObject = -1000
    case networkConnectionLost = -1005
    case unknown = -9999
    
    case particleAPIChange

    
    public init?(rawValue: String) {
        switch rawValue {
                #warning("Add cases and find available values. Contacted particle for a comprehensive list of errors on Nov. 5 2023 waiting on a response.")
            case "unauthorized":
                self.init(rawValue: PCErrorCode.unauthorizedFromServer.rawValue)
            default:
                self.init(rawValue: -9999)
        }
    }
    
    public var description: String {
        switch self {
                
            case .failedToGetTokenInfo:
                return "Failed to get the current token info from the server an unknown error seems to have occurred."
            case .failedToParseJsonDate:
                return "Failed to use the date formatter to properly format the json date provided from the server."
            case .invalidArguments:
                return "One or more arguments provided is invalid. Check the arguments passed to the method call."
            case .incorrectCredentials:
                return "User credentials are invalid"
            case .unauthenticated:
                return ""
            case .badData:
                return ""
            case .jSonDataMismatch:
                return ""
            case .networkError:
                return ""
            case .itemNotFound:
                return ""
            case .undelyingError:
                return ""
            case .networkFailure:
                return ""
            case .deviceNotResponding:
                return "The device you requested is not currently connected to the cloud."
            case .badRequestFromServer:
                return "Bad Request - Your request is not understood by the device, or the requested subresource (variable/function) has not been exposed."
            case .unauthorizedFromServer:
                return "Unauthorized - Your access token is not valid."
            case .forbiddenFromServer:
                return "Forbidden - Your access token is not authorized to interface with this device."
            case .notFoundFromServer:
                return "404 Not Found - The device you requested is not currently connected to the cloud."
            case .timedOutFromServer:
                return "Timed Out - The cloud experienced a significant delay when trying to reach the device."
            case .tooManyRequestsFromServer:
                return "Too Many Requests - You are either making requests too often or too many at the same time. Please slow down."
            case .errorsOnServer:
                return "Server errors - Try again or check cloud server status."
            case .deinitializedObject:
                return "Weak reference was deinitialized before block was called.\n"
            case .unknown:
                return "Something very unexpected happened. Please file a bug report.\n"
            case .networkConnectionLost:
                return " The network connection was lost.\n"
            case .connectionClosed:
                return "The network connection was closed.\n"
            case .notAvailableOnPlatform:
                return "The requested resource is not allowed on the current platform."
        case .particleAPIChange:
            return "Particle has changed the available attributes, or the attribute otherwise could not be found."
        }
    }
}

public struct PCError: Error, CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "PCError:\ncode:\(code.rawValue)\ndescription:\(String(describing: description))\nunderlyingError:\(String(describing: underlyingError))\ndomain:\(domain)\nretryAfter:\(String(describing: retryAfter))\n"
    }
    
    
    public static let unauthenticated = PCError(code: .unauthenticated, description: "You must be authenticated to access this resource.")
    
    public static let apiChange = PCError(code: .particleAPIChange, description: "The selected atttribute was not found")

    
    public let code: PCErrorCode
    public let description: String?
    public let underlyingError : Error?
    public let domain = PCErrorDomain
    public var retryAfter: DispatchTime?
    
    public init(code: PCErrorCode, description: String? = nil, underlyingError: Error? = nil, retryAfter: DispatchTime? = nil) {
        self.code = code
        self.description = description
        self.underlyingError = underlyingError
        self.retryAfter = retryAfter
    }
    
    public struct ServerVersionRequestError: Error, Decodable, CustomStringConvertible {
        
        public var description: String {
            "errors:\(error.map({$0.description}).joined(separator: "\n"))"
        }
        
        public let error: [ErrorData]
        
        public struct ErrorData: Decodable, CustomStringConvertible {
            public var description: String {
                "status: \(status)\ntitle:\(title)\ndetails:\(detail)"
            }
            
            public let status: String
            
            public let title : String
            public let detail : String
            
        }
    }
    
    public struct ServerOKResponse: Error, Decodable {
        
        public let ok: Bool
        public let error: String?
    }
    
    public struct ServerErrorResponse: Error, Decodable {
        
        public let error: String
        public let error_description: String
    }


    ///Error response sent from from Particle Server if present.
    public struct ServerErrorsResponse: Error, Decodable {
        ///The machine readable code identifying the error.
        public let errors: [Message]
        ///The human readable reason for the error.
        public let description : String?
        
        public let info: String?
        ///The two-factor authentication state code that must be sent back with the one-time password.
        public let mfaToken : String?
        
        private enum CodingKeys: String, CodingKey {
            case errors, description = "error_description", mfaToken = "mfa_token", info
        }
        
        public struct Message: Decodable {
            public let message: String
            
            private init(message: String) {
                self.message = message
            }
        }
        
        public var debugDescription : String {
                "errors = [\(String(describing: errors.map({$0.message}).joined(separator: "\n")))]\ndescription = \(String(describing: description))\ninfo = \(String(describing: info))\nmfa_token = \(String(describing: mfaToken))\n"
        }
        
        public var localizedDescription : String {
            debugDescription
        }

        /// Private init to hide access from final users.
        private init(errors: [Message], description: String, info: String?, mfaToken: String?) {
            self.errors = errors; self.description = description; self.info = info; self.mfaToken = mfaToken
        }
    }
    
        //MARK: Server Error Response Codes
    public enum ServerErrorResponseCode: Int {
        case responseOk = 200, badRequest = 400, unauthorized = 401, forbidden = 403, notFound = 404, timedOut = 408, tooManyRequests = 429, serverError = 500
        
        var description: String {
            
            switch self {
                case .responseOk:
                    return "200 OK - API call successfully delivered to the device and executed."
                case .badRequest:
                    return "400 Bad Request - Your request is not understood by the device, or the requested subresource (variable/function) has not been exposed."
                case .unauthorized:
                    return "401 Unauthorized - Your access token is not valid."
                case .forbidden:
                    return "403 Forbidden - Your access token is not authorized to interface with this device."
                case .notFound:
                    return "404 Not Found - The device you requested is not currently connected to the cloud."
                case .timedOut:
                    return "408 Timed Out - The cloud experienced a significant delay when trying to reach the device."
                case .tooManyRequests:
                    return "429 Too Many Requests - You are either making requests too often or too many at the same time. Please slow down."
                case .serverError:
                    return "500 Server errors - Fail whale. Something's wrong on our end."
            }
        }
    }
}


extension PCError {
    
    internal static func handleError(error: Error?,
                                     resource: CloudResource? = nil,
                                     request: URLRequest? = nil,
                                     response: URLResponse? = nil,
                                     data: Data? = nil) -> PCError {
        if let error = error {
            var pError = PCError(code: .undelyingError, description: "An underlying error occured", underlyingError: error)
            
            switch error.localizedDescription {
                case "The request timed out.":
                    pError.retryAfter = .now() + 3
                default:
                    break
            }
            return pError
            
        } else if let data = data {
            
            if let pError = try? JSONDecoder().decode(PCError.ServerErrorResponse.self, from: data) {
                
                return PCError(code: .errorsOnServer, description: "Server responded with error", underlyingError: pError)
                
            } else if let pError = try? JSONDecoder().decode(PCError.ServerErrorsResponse.self, from: data) {
                
                return PCError(code: .errorsOnServer, description: "Server responded with error", underlyingError: pError)
           
            } else if let item = try? JSONDecoder().decode(ServerOKResponse.self, from: data) {
                
                let retry = item.error == "Timed out." ? DispatchTime.now() + 5 : nil
               
                return PCError(code: .undelyingError, description: item.error, retryAfter: retry)
                
            } else if let item = try? JSONSerialization.jsonObject(with: data) {

                return PCError(code: .jSonDataMismatch, description: "Wrong Json decoded from data. Type mismatch: json received as:\n\(item)\n")
            } else {
                
                return PCError(code: .badData,
                               description: "error with data value: \(String(describing: String(data: data, encoding: .utf8)))\n for request: \(String(describing: request))")
            }
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  let code = PCError.ServerErrorResponseCode(rawValue: statusCode) {
            
            return PCError(code: PCErrorCode(rawValue: code.rawValue) ?? .unknown,
                           description: code.description)
            
        } else {
            
            return PCError(code: .unknown, description: "something unexpected happened with the server response: \(String(describing: response))\n")
        }
    }
}

    //200 OK - API call successfully delivered to the device and executed.
    //
    //400 Bad Request - Your request is not understood by the device, or the requested subresource (variable/function) has not been exposed.
    //
    //401 Unauthorized - Your access token is not valid.
    //
    //403 Forbidden - Your access token is not authorized to interface with this device.
    //
    //404 Not Found - The device you requested is not currently connected to the cloud.
    //
    //408 Timed Out - The cloud experienced a significant delay when trying to reach the device.
    //
    //429 Too Many Requests - You are either making requests too often or too many at the same time. Please slow down.
    //
    //500 Server errors - Fail whale. Something's wrong on our end.

