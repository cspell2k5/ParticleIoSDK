    //
    //  PCLibrary.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/14/23.
    //

import Foundation
import Combine


public struct PCLibrary: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
    
    public var description: String {
"""
    type: \(type.rawValue),
    id: \(id),
    link: \(links.download),
    \(attributes.debugDescription)
"""
    }
    
    public var debugDescription: String {
"""
PCLibrary: {
    type: \(type.rawValue),
    id: \(id),
    link: \(links.download),
    \(attributes.debugDescription)
    }
}
"""
    }
    
    public let type: LibraryType
    public let id: String
    public let links: Links
    public let attributes: Attributes
    
    private init(type: LibraryType, id: String, links: Links, attributes: Attributes) {
        self.type = type
        self.id = id
        self.links = links
        self.attributes = attributes
    }
    
    public enum VersionFilter: String, CaseIterable {
        case all, official, `public`, mine, `private`
    }

    public enum SortFilter: String, CaseIterable {
        case name, installs, popularity, published, updated, created, official, verified
    }
    
    private enum CodingKeys: CodingKey {
        case data, type, id, links, attributes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let data = try container.decodeIfPresent([String:String].self, forKey: .data) {
            self.type = try JSONDecoder().decode(LibraryType.self, from: Data(data["type"]!.utf8))
            self.id = try JSONDecoder().decode(String.self, from: Data(data["id"]!.utf8))
            self.links = try JSONDecoder().decode(Links.self, from: Data(data["links"]!.utf8))
            self.attributes = try JSONDecoder().decode(PCLibrary.Attributes.self, from: Data(data["attributes"]!.utf8))
            
        } else {
            self.type = try container.decode(LibraryType.self, forKey: .type)
            self.id = try container.decode(String.self, forKey: .id)
            self.links = try container.decode(Links.self, forKey: .links)
            self.attributes = try container.decode(Attributes.self, forKey: .attributes)
        }
    }
}

extension PCLibrary {
    
        //MARK: - LibraryRequestArguments
    public struct LibraryListArguments: CustomStringConvertible, CustomDebugStringConvertible {
                
        
        public var description: String {
return """
    filter: \(String(describing: filter)),
    page: \(page),
    limit: \(limit),
    sort: \(sort.rawValue),
    sortOrder: \(sortOrder.description),
    scope: \(scope.rawValue)
    excludeScopes: \(String(describing: excludeScopes?.description))
    architectures: \(String(describing: architectures?.description))
"""
        }
        
        public var debugDescription: String {
return """
LibraryListArguments: {
    filter: \(String(describing: filter)),
    page: \(page),
    limit: \(limit),
    sort: \(sort.rawValue),
    sortOrder: \(sortOrder.description),
    scope: \(scope.rawValue)
    excludeScopes: \(String(describing: excludeScopes?.description))
    architectures: \(String(describing: architectures?.description))
}
"""
        }
        
        public enum SortOrder: String {
            
            var description: String { 
                switch self {
                    case .ascending: return "ascending"
                    case .descending: return "descending"
                }
            }
            
            case ascending = ""
            case descending = "-"
        }
            ///Search for libraries with this partial name
        public let filter: String?
        
            ///Page number
        public let page: Int
        
            ///Items per page (max 100)
        public let limit: Int
        
            ///What property to sort results by.
        public let sort: SortFilter
        
        ///Sort order for results.
        public let sortOrder: SortOrder
        
            ///Which subset of libraries to list.
            /// - `all` to retrieve public libraries and any private libraries belonging to the user
            /// - `official` to retrieve official public libraries
            /// - `public` to retrieve public libraries
            /// - `mine` to retrieve only public libraries belonging to the current user
            /// - `private` to retrieve only private libraries (belonging to the current user).
        public let scope: VersionFilter
        
            ///Which subsets of libraries to avoid listing, separated by comma. Same values as scope.
        public let excludeScopes: [VersionFilter]?
        
            ///Architectures to list, separated by comma. Missing means all architectures.
        public let architectures: [String]?
        
        public init(filter: String? = nil, page: Int = 1, limit: Int = 10, sort: SortFilter = .popularity, sortOrder: SortOrder = .ascending, scope: VersionFilter = .all, excludeScopes: [VersionFilter]? = nil, architectures: [String]? = nil) {
            self.filter = filter
            self.page = page
            self.limit = limit
            self.sort = sort
            self.sortOrder = sortOrder
            self.scope = scope
            self.excludeScopes = excludeScopes
            self.architectures = architectures
        }
    }

}
extension PCLibrary {
    public struct ListResponse: Decodable {
        
        public var description: String {
            return "Libraries: [\n\(libraries.map({$0.description}).joined(separator: ", \n\n"))]\n"
        }
        
        public var debugDescription: String {
            return description
        }
        
        private enum CodingKeys: String, CodingKey {
            case libraries = "data"
        }
        
        public let libraries: [PCLibrary]
        
        private init(libraries: [PCLibrary]) {
            self.libraries = libraries
        }
    }
    
    
        // MARK: - Attributes
    public struct Attributes: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
        
        private var architecturesDescription: String {
            if architectures.isEmpty {
                return "[]"
            }
            return """
[
            \(architectures.joined(separator: "\n"))
        ]
"""
        }
        
        public var description: String {
            debugDescription
        }
        
        public var debugDescription: String {
"""
Attributes: {
        name: \(name),
        version: \(version),
        installs:\(installs),
        license: \(String(describing: license)),
        author: \(author),
        sentence: \(String(describing: sentence)),
        url: \(String(describing: url)),
        repository: \(String(describing: repository)),
        visibility: \(visibility),
        official: \(String(describing: official)),
        mine: \(mine),
        maintainer: \(String(describing: maintainer)),
        category: \(String(describing: category)),
        paragraph: \(String(describing: paragraph)),
        dependencies: \(String(describing: dependencies?.debugDescription)),
        architectures: \(architecturesDescription)
"""
        }
        
        public let name, version: String
        public let installs: Int
        public let license: String?
        public let author: String
        public let sentence: String?
        public let url: String?
        public let repository: String?
        public let architectures: [String]
        public let visibility: String
        public let mine: Bool
        public let verified, official: Bool?
        public let maintainer, category, paragraph: String?
        public let dependencies: [String : String]?
        
        
        private init(name: String, version: String, installs: Int, license: String?, author: String, sentence: String?, url: String?, repository: String?, architectures: [String], visibility: String, mine: Bool, verified: Bool?, official: Bool?, maintainer: String?, category: String?, paragraph: String?, dependencies: [String : String]?) {
            self.name = name
            self.version = version
            self.installs = installs
            self.license = license
            self.author = author
            self.sentence = sentence
            self.url = url
            self.repository = repository
            self.architectures = architectures
            self.visibility = visibility
            self.mine = mine
            self.verified = verified
            self.official = official
            self.maintainer = maintainer
            self.category = category
            self.paragraph = paragraph
            self.dependencies = dependencies
        }
    }
    
        // MARK: - Links
    public struct Links: Decodable, CustomDebugStringConvertible, CustomStringConvertible {
        
        
        public var description: String { debugDescription }
        
        public var debugDescription: String {
"""
Link: {
        download: \(download)
    }
"""
        }
        
        public let download: String
        
        private init(download: String) {
            self.download = download
        }
    }
    
    public enum LibraryType: String, Decodable {
        case libraries = "libraries"
    }
}


extension PCLibrary {
        
    public struct DetailArguments {
        
        public let libraryName: String
        public let version: VersionFilter
        
        public init(libraryName: String, version: VersionFilter = .all) {
            self.libraryName = libraryName
            self.version = version
        }
    }
    
    public struct DetailResponse: Decodable {
        
        //TODO: contact particle about the error and message being sent intermittently
        //TODO: move to PCLibrary and make a init with decoder method instead of a separate response. Throw the error if it is present.
            ///The requested library or nil if a match cannot be found. If this constant is nil an error and message should be provided.
        public let library: PCLibrary?
            /// An error that occured trying to find the library. This property will be nil unless a library is not provided. Sometimes it is provided by the server sometimes it is not.
        public let error: String?
            /// A message explaining the error. This property will be nil unless a library is not provided. Sometimes it is provided by the server sometimes it is not.
        public let message: String?
        
        private init(error: String?, message: String?, library: PCLibrary) {
            self.error = error
            self.message = message
            self.library = library
        }
        
        private enum CodingKeys: CodingKey {
            case data, error, message
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.library = try container.decodeIfPresent(PCLibrary.self, forKey: .data)

            self.error = try container.decodeIfPresent(String.self, forKey: .error)
            self.message = try container.decodeIfPresent(String.self, forKey: .message)
        }
    }
}

    //MARK: - Type Methods
    //MARK: CurrentValueSubjects
extension PCLibrary {
    
        ///List Libraries
        ///
        ///List firmware libraries. This includes private libraries visibile only to the user.
        ///
        ///Example:
        ///
        ///````swift
        ///
        ///      import SwiftUI
        ///      import Combine
        ///
        ///      struct DocumentationView: View {
        ///
        ///          @ObservedObject private var authManager = PCAuthenticationManager.shared
        ///          @State private var libraries = ""
        ///          @State private var cancellables = Set<AnyCancellable>()
        ///
        ///          var body: some View {
        ///
        ///              if authManager.isLoading {
        ///                  ProgressView("Loading..", value: authManager.loadingProgress.fractionCompleted)
        ///              } else {
        ///                  ScrollView {
        ///                      Text(libraries).padding()
        ///                  }
        ///                  .frame(width: 400, height: 400)
        ///                  .padding()
        ///                  .onAppear {
        ///                      if let token = authManager.token {
        ///
        ///                          PCLibrary.listLibraries(arguments: .init(filter: "particle", limit: 4), token: token)
        ///                               .mapError({
        ///                                   print("error:\n\($0)\nfunction: \(#function) in \(#file)")
        ///                                   return $0
        ///                               })
        ///                              .replaceError(with: nil)
        ///                              .receive(on: RunLoop.main)
        ///                              .compactMap { $0?.libraries }
        ///                              .map {$0.description}
        ///                              .assign(to: \.libraries, on: self)
        ///                              .store(in: &cancellables)
        ///
        ///                      } else {
        ///                              //Maybe try again later
        ///                      }
        ///                  }
        ///              }
        ///          }
        ///      }
        ///
        ///      #Preview {
        ///          DocumentationView()
        ///      }
        ///
        ///
        ///
        ///
        ///````
        ///
        /// - Parameter arguments: The arguments used to filter the libraries.
        /// - Parameter token: The PCAccessToken to perform the request with.
        /// - Returns: A `CurrentValueSubject<PCLibrary.ListResponse?, PCError>` The list response when available contains an array of libraries filtered by the arguments or an empty array if a suitable match could not be found.
    public static func listLibraries(arguments: LibraryListArguments, token: PCAccessToken) -> CurrentValueSubject<PCLibrary.ListResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.listLibraries(arguments: arguments, token: token), type: PCLibrary.ListResponse.self)
    }
    
        ///Get a Library
        ///
        ///Get a firmware library. This includes private libraries visibile only to the user.
        ///
        ///Example:
        ///
        ///````swift
        ///
        ///          import SwiftUI
        ///          import Combine
        ///
        ///          struct DocumentationView: View {
        ///
        ///              @ObservedObject private var authManager = PCAuthenticationManager.shared
        ///              @State private var selectedLibrary: PCLibrary?
        ///              @State private var cancellables = Set<AnyCancellable>()
        ///
        ///              var body: some View {
        ///
        ///                  if authManager.isLoading {
        ///                      ProgressView("Loading..", value: authManager.loadingProgress.fractionCompleted)
        ///                  } else {
        ///                      VStack {
        ///                          ScrollView {
        ///                              Text(selectedLibrary?.debugDescription ?? "")
        ///                                  .padding()
        ///                          }
        ///                          .frame(width: 400, height: 400)
        ///                          .padding()
        ///                          .onAppear {
        ///                              if let token = authManager.token {
        ///
        ///                                  PCLibrary.getLibraryDetails(arguments: .init(libraryName: "neopixel"), token: token)
        ///                                      .mapError { error in
        ///                                          print("error:\n\(error)\nfunction: \(#function) in \(#file)")
        ///                                          return error
        ///                                      }
        ///                                      .replaceError(with: nil)
        ///                                      .compactMap {$0?.library}
        ///                                      .receive(on: RunLoop.main)
        ///                                      .assign(to: \.selectedLibrary, on: self)
        ///                                      .store(in: &self.cancellables)
        ///
        ///
        ///                              } else {
        ///                                      //Maybe try again later
        ///                              }
        ///                          }
        ///                      }
        ///                  }
        ///              }
        ///          }
        ///
        ///          #Preview {
        ///              DocumentationView()
        ///          }
        ///
        ///
        ///````
        ///
        /// - Parameter arguments: The arguments used to filter the libraries.
        /// - Parameter token: The PCAccessToken to perform the request with.
        /// - Returns: A `CurrentValueSubject<PCLibrary.DetailResponse?, PCError>` The detail response contains the requested library or nil if a suitable match could not be found.
    public static func getLibraryDetails(arguments: DetailArguments, token: PCAccessToken) -> CurrentValueSubject<PCLibrary.DetailResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.getLibraryDetails(arguments: arguments, token: token), type: PCLibrary.DetailResponse.self)
    }
    
    @available(*, deprecated, renamed: "getLibraryDetails", message: "This REST call has problems with shady server responses when errors occur. Use `public static func getLibraryDetails(arguments: DetailArguments, token: PCAccessToken) async throws -> PCLibrary.DetailResponse` instead.")
    public static func getLibraryVersions(libraryName: String, version: VersionFilter, token: PCAccessToken) -> CurrentValueSubject<ListResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.getLibraryVersions(libraryName: libraryName, version: version, token: token), type: PCLibrary.ListResponse.self)
    }
    
    public static func uploadLibraryVersion(libraryName: String, filePath: String, token: PCAccessToken) -> CurrentValueSubject<PCLibrary?, PCError> {
        PCNetwork.shared.cloudRequest(.uploadLibraryVersion(libraryName: libraryName, filePath: filePath, token: token), type: PCLibrary.self)
    }

    
    public static func makeLibraryVersionPublic(libraryName: String, visibility: String = "public", token: PCAccessToken) -> CurrentValueSubject<ListResponse?, PCError> {
        PCNetwork.shared.cloudRequest(.makeLibraryVersionPublic(libraryName: libraryName, visibility: visibility, token: token), type: PCLibrary.ListResponse.self)
    }
}

    //MARK: Async
extension PCLibrary {
    
        ///List Libraries
        ///
        ///List firmware libraries. This includes private libraries visibile only to the user.
        ///
        ///Example:
        ///
        ///````swift
        ///
        ///         import SwiftUI
        ///
        ///         struct DocumentationView: View {
        ///
        ///             @ObservedObject private var authManager = PCAuthenticationManager.shared
        ///             @State private var libraries = ""
        ///
        ///             var body: some View {
        ///
        ///                 if authManager.isLoading {
        ///                     ProgressView("Loading..", value: authManager.loadingProgress.fractionCompleted)
        ///                 } else {
        ///                     ScrollView {
        ///                         Text(libraries)
        ///                             .padding()
        ///                     }
        ///                     .frame(width: 400, height: 400)
        ///                     .padding()
        ///                     .onAppear {
        ///                         if let token = authManager.token {
        ///                             Task {
        ///                                 do {
        ///
        ///                                     self.libraries = try await PCLibrary.listLibraries(arguments: PCLibrary.LibraryListArguments(filter: "particle"), token: token).description
        ///
        ///                                 } catch {
        ///                                         print("error:\n\(error)\nfunction: \(#function) in \(#file)")
        ///                                 }
        ///                             }
        ///
        ///                         } else {
        ///                                 //Maybe try again later
        ///                         }
        ///                     }
        ///                 }
        ///             }
        ///         }
        ///
        ///         #Preview {
        ///             DocumentationView()
        ///         }
        ///
        ///
        ///
        ///
        ///````
        ///
        /// - Parameter arguments: The arguments used to filter the libraries.
        /// - Parameter token: The PCAccessToken to perform the request with.
        /// - Returns: A `PCLibrary.ListResponse` The list response contains an array of libraries filtered by the arguments or an empty array if a suitable match could not be found.
        /// - Throws: PCError
    public static func listLibraries(arguments: LibraryListArguments, token: PCAccessToken) async throws -> PCLibrary.ListResponse {
        try await PCNetwork.shared.cloudRequest(.listLibraries(arguments: arguments, token: token), type: PCLibrary.ListResponse.self)
    }
    
        ///Get a Library
        ///
        ///Get a firmware library. This includes private libraries visibile only to the user.
        ///
        ///Example:
        ///
        ///````swift
        ///
        ///
        ///
        ///         import SwiftUI
        ///
        ///         struct DocumentationView: View {
        ///
        ///             @ObservedObject private var authManager = PCAuthenticationManager.shared
        ///             @State private var selectedLibrary: PCLibrary?
        ///
        ///             var body: some View {
        ///
        ///                 if authManager.isLoading {
        ///                     ProgressView("Loading..", value: authManager.loadingProgress.fractionCompleted)
        ///                 } else {
        ///                     VStack {
        ///                         ScrollView {
        ///                             Text(selectedLibrary?.debugDescription ?? "")
        ///                                 .padding()
        ///                         }
        ///                         .frame(width: 400, height: 400)
        ///                         .padding()
        ///                         .onAppear {
        ///                             if let token = authManager.token {
        ///                                 Task {
        ///                                     do {
        ///
        ///                                         let response = try await PCLibrary.getLibraryDetails(arguments: .init(libraryName: "neopixel"), token: token)
        ///
        ///                                         if let library = response.library {
        ///                                             self.selectedLibrary = library
        ///                                         } else {
        ///                                             print("error:\(String(describing: response.error))\nmessage:\(String(describing: response.message))\nfunction: \(#function) in \(#file)")
        ///
        ///                                         }
        ///                                     } catch {
        ///
        ///                                         print("error:\n\(error)\nfunction: \(#function) in \(#file)")
        ///
        ///                                     }
        ///
        ///                                 }
        ///                             } else {
        ///                                     //Maybe try again later
        ///                             }
        ///                         }
        ///                     }
        ///                 }
        ///             }
        ///         }
        ///
        ///         #Preview {
        ///             DocumentationView()
        ///         }
        ///
        ///
        ///
        ///
        ///````
        ///
        /// - Parameter arguments: The arguments used to filter the libraries.
        /// - Parameter token: The PCAccessToken to perform the request with.
        /// - Returns: A `PCLibrary.DetailResponse` The detail response contains the requested library nil if a suitable match could not be found.
        /// - Throws: PCError
    public static func getLibraryDetails(arguments: DetailArguments, token: PCAccessToken) async throws -> PCLibrary.DetailResponse {
        try await PCNetwork.shared.cloudRequest(.getLibraryDetails(arguments: arguments, token: token), type: PCLibrary.DetailResponse.self)
    }
    
    @available(*, deprecated, renamed: "getLibraryDetails", message: "This REST call has problems with shady server responses when errors occur. Use `public static func getLibraryDetails(arguments: DetailArguments, token: PCAccessToken) async throws -> PCLibrary.DetailResponse` instead.")
    
    public static func getLibraryVersions(libraryName: String, version: VersionFilter, token: PCAccessToken) async throws -> PCLibrary.ListResponse {
        let resourse = CloudResource.getLibraryVersions(libraryName: libraryName, version: version, token: token)
        print(CloudResource.requestForResource(resourse))
        return try await PCNetwork.shared.cloudRequest(resourse, type: PCLibrary.ListResponse.self)
    }
    
    public static func uploadLibraryVersion(libraryName: String, filePath: String, token: PCAccessToken) async throws -> PCLibrary {
        try await PCNetwork.shared.cloudRequest(.uploadLibraryVersion(libraryName: libraryName, filePath: filePath, token: token), type: PCLibrary.self)
    }

    
    public static func makeLibraryVersionPublic(libraryName: String, visibility: String = "public", token: PCAccessToken) async throws -> PCLibrary.ListResponse {
        try await PCNetwork.shared.cloudRequest(.makeLibraryVersionPublic(libraryName: libraryName, visibility: visibility, token: token), type: PCLibrary.ListResponse.self)
    }
}

    //MARK: Completion Handlers
extension PCLibrary {
    
        ///List Libraries
        ///
        ///List firmware libraries. This includes private libraries visibile only to the user.
        ///
        ///Example:
        ///
        ///```` swift
        ///
        ///
        ///
        ///           import SwiftUI
        ///           import Combine
        ///
        ///           struct DocumentationView: View {
        ///
        ///               @ObservedObject private var authManager = PCAuthenticationManager.shared
        ///               @State private var libraries = ""
        ///
        ///               var body: some View {
        ///
        ///                   if authManager.isLoading {
        ///                       ProgressView("Loading..", value: authManager.loadingProgress.fractionCompleted)
        ///                   } else {
        ///                       ScrollView {
        ///                           Text(libraries)
        ///                               .padding()
        ///                       }
        ///                       .frame(width: 400, height: 400)
        ///                       .padding()
        ///                       .onAppear {
        ///                           if let token = authManager.token {
        ///                               PCLibrary.listLibraries(arguments: .init(), token: token) { response in
        ///                                   switch response {
        ///                                       case .success(let listResponse):
        ///                                           self.libraries = listResponse.description
        ///                                       case .failure(let error):
        ///                                           print("error:\n\(error)\nfunction: \(#function) in \(#file)")
        ///                                           break
        ///                                   }
        ///                               }
        ///                           } else {
        ///                                   //Maybe try again later
        ///                           }
        ///                       }
        ///                   }
        ///               }
        ///           }
        ///
        ///           #Preview {
        ///               DocumentationView()
        ///           }
        ///
        ///
        ///
        ///
        /// ````
        ///
        /// - Parameter arguments: The arguments used to filter the libraries.
        /// - Parameter token: The PCAccessToken to perform the request with.
        /// - Parameter completion: A completion closure supplying an Result with containing a list response or a PCError
    public static func listLibraries(arguments: LibraryListArguments, token: PCAccessToken, completion: @escaping (Result<ListResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.listLibraries(arguments: arguments, token: token), type: PCLibrary.ListResponse.self, completion: completion)
    }
    
        ///Get library details
        ///
        ///Get details for a firmware library.
        ///
        ///````swift
        ///         import SwiftUI
        ///         import Combine
        ///
        ///         struct DocumentationView: View {
        ///
        ///             @ObservedObject private var authManager = PCAuthenticationManager.shared
        ///             @State private var selectedLibrary: PCLibrary?
        ///
        ///             var body: some View {
        ///
        ///                 if authManager.isLoading {
        ///                     ProgressView("Loading..", value: authManager.loadingProgress.fractionCompleted)
        ///                 } else {
        ///                     VStack {
        ///                         ScrollView {
        ///                             Text(selectedLibrary?.debugDescription ?? "")
        ///                                 .padding()
        ///                         }
        ///                         .frame(width: 400, height: 400)
        ///                         .padding()
        ///                         .onAppear {
        ///                             if let token = authManager.token {
        ///                                 PCLibrary.getLibraryDetails(arguments: .init(libraryName: "neopixel"), token: token) { result in
        ///                                     switch result {
        ///                                         case .success(let response):
        ///                                            if let library = response.library {
        ///                                                 self.selectedLibrary = library
        ///                                            } else {
        ///
        ///                                            }
        ///                                         case .failure(let error):
        ///                                             print("error:\n\(error)\nfunction: \(#function) in \(#file)")
        ///                                             break
        ///                                     }
        ///                                 }
        ///                             } else {
        ///                                     //Maybe try again later
        ///                             }
        ///                         }
        ///                     }
        ///                 }
        ///             }
        ///         }
        ///
        ///         #Preview {
        ///             DocumentationView()
        ///         }
        ///
        ///
        ///````
        /// - Parameter arguments: The arguments used to filter the library.
        /// - Parameter token: The PCAccessToken to perform the request with.
        /// - Parameter completion: A completion closure supplying an Result with containing a detail response or a PCError
    public static func getLibraryDetails(arguments: DetailArguments, token: PCAccessToken, completion: @escaping (Result<PCLibrary.DetailResponse, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.getLibraryDetails(arguments: arguments, token: token), type: PCLibrary.DetailResponse.self, completion: completion)
    }
    
    
    @available(*, deprecated, renamed: "getLibraryDetails", message: "This REST call has problems with shady server responses when errors occur. Use `public static func getLibraryDetails(arguments: DetailArguments, token: PCAccessToken) async throws -> PCLibrary.DetailResponse` instead.")
    public static func getLibraryVersions(libraryName: String, version: VersionFilter, token: PCAccessToken, completion: @escaping (Result<PCLibrary.ListResponse, PCError>) -> Void)  {
        
        PCNetwork.shared.cloudRequest(.getLibraryVersions(libraryName: libraryName, version: version, token: token), type: PCLibrary.ListResponse.self, completion: completion)
    }
    
    public static func uploadLibraryVersion(libraryName: String, filePath: String, token: PCAccessToken, completion: @escaping (Result<PCLibrary, PCError>) -> Void) {
        PCNetwork.shared.cloudRequest(.uploadLibraryVersion(libraryName: libraryName, filePath: filePath, token: token), type: PCLibrary.self, completion: completion)
    }

    
    public static func makeLibraryVersionPublic(libraryName: String, visibility: String = "public", token: PCAccessToken, completion: @escaping (Result<PCLibrary.ListResponse, PCError>) -> Void ) {
        PCNetwork.shared.cloudRequest(.makeLibraryVersionPublic(libraryName: libraryName, visibility: visibility, token: token), type: PCLibrary.ListResponse.self, completion: completion)
    }

}
