import XCTest
@testable import ParticleIoSDK


extension PCCredentials {
    static let testCase = PCCredentials(username: "", password: "")
}

extension PCClient {
    static let testCase = PCClient(id: "", secret: "")
}

extension ProductID {
    static let testCase = ProductID("")
}

extension DeviceID {
    static let testCase = DeviceID("")
}

extension EventName {
    static let testCase = EventName("")
}


final class ParticleIoSDKTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //FIXME: ("Add importDevicesInto && importAndActivateProductSIMs tests")
    func testSDK() async throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
        
        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        let token = try await PCAccessToken.generateAccessToken(credentials: .testCase)
        XCTAssertNotNil(token)
        
        let list = try await PCAccessToken.listAccessToken(credentials: .testCase)
                
        XCTAssert(list.count >= 1)
        
        let valid = try await token.isValid()
        XCTAssertTrue(valid)
        
        let tokenListResponse = try await PCAccessToken.listAccessToken(credentials: .testCase)
        XCTAssertNotNil(tokenListResponse)
        
        let userResponse = try await PCAPIUser.createAn_API_User(type: .product(name: .testCase), parameters: .init(friendlyName: "friend", permissions: [.clients_create]), token: token)
        XCTAssertNotNil(userResponse)
        
        let listResponse = try await PCAPIUser.list_API_Users(type: .product(name: .testCase), token: token)
        XCTAssertNotNil(listResponse)
        
        let updateResponse = try? await PCAPIUser.updateAn_API_User(type: .product(name: .testCase), parameters: .init(friendlyName: userResponse.user!.username, permissions: [UserPermissions.clients_list]), token: token)
        XCTAssertNotNil(updateResponse)
        
        let deletionResponse = try await PCAPIUser.deleteAn_API_User(type: .product(name: .testCase), username: userResponse.user!.username, token: token)
        XCTAssert(deletionResponse.ok)
        
        let clientCreationResponse = try await PCClient.createClient(appName: "client_name", productId: .testCase, type: .installed, token: token)
        XCTAssertNotNil(clientCreationResponse.clients.first)
        
        let clientUpdateResponse = try await PCClient.updateClient(client: clientCreationResponse.clients.first!, newName: nil, newScope: .fullControl, productId: .testCase, token: token)
        XCTAssertNotNil(clientUpdateResponse)
        
        let clientListResponse = try await PCClient.listClients(productId: .testCase, token: token)
        XCTAssertNotNil(clientListResponse)
        
        let clientDeletionResponse = try await PCClient.deleteClient(clientCreationResponse.clients.first!, productId: .testCase, token: token)
        XCTAssertNotNil(clientDeletionResponse)
        
        let deviceListResponse = try await PCDevice.listDevices(arguments: nil, token: token)
        XCTAssertNotNil(deviceListResponse.first?.name)
        
        let device = try await PCDevice.getDevice(deviceID: .testCase, token: token)
        XCTAssertNoThrow(device.subscribeToEvents(eventName: .testCase, onEvent: nil, completion: nil))
        
        let pingSuccess = try await device.ping()
        XCTAssert(pingSuccess.ok)
        
        let signalOnResponse = try await device.signal(rainbowState: .on)
        XCTAssert(signalOnResponse.isSignaling)
        
        let signalOffResponse = try await device.signal(rainbowState: .off)
        XCTAssertFalse(signalOffResponse.isSignaling)
        
        let productList = try await PCProduct.listProducts(token: token)
        XCTAssertNotNil(productList)
        
        let product = try await PCProduct.getProduct(productIdOrSlug: .testCase, token: token)
        XCTAssertNotNil(product)
        
        let deleted = try await token.delete().ok
        XCTAssert(deleted)
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
