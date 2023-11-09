#  PariticleIO SDK


## NOTE This software is to be considered untested at this point. Though some functionality seems to be working well it is an extensive framework and as such has not been thoroughly tested. Please submit requests for improvements or make a pull request to help chase down issues.

## Known issues: 
 1. The event subscriptions can only be done through deprecated APIs a bug report has been submitted to address the issue.
 2. The OTP is not implemented for use with two factor authentication.
 3. Device claiming and wifi setup is not yet implemented.
 4. The example app is not very well thoughtout it is just a quick example of what the sdk can do and how it works.


## Available on platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8), .macCatalyst(.v15), .tvOS(.v15), .visionOS(.v1)]

How to login to the Particleio sdk.
There are two ways to login to the cloud.

1. Login with a token. If you already have a token provided perhaps through a login server or webhook, you can simply create a PCAccessToken and pass it to the PCAuthenticationManager or the PCContainer.

 - Example: 
 
 
 
```` swift

        
            import SwiftUI
            import ParticleIoSDK
            
            class SomeViewModel: ObservableObject {
                @ObservedObject var container = PCContainer.shared
                @ObservedObject var authMan = PCAuthenticationManager.shared
                
                var name = ""
                var password = ""
            }
            
            struct DocumentationView: View {
                
                @ObservedObject private var model = SomeViewModel()
                
                var body: some View {
                    
                    if model.container.authenticationManager.isLoading {
                        ProgressView(value: model.container.authenticationManager.loadingProgress.fractionCompleted)
                        // or ProgressView(value: model.authMan.loadingProgress.fractionCompleted)
                    } else if model.container.userIsAuthenticated { // or model.authMan.userIsAuthenticated
                        Text("Logged In")
                        //get a device or something..
                        
                        
                        Button {
                            
                            model.container.logout() { result in // or  model.authMan.logout()
                                switch result {
                                    case .success(let bool):
                                        //bool should be true from server if no error exists
                                        break
                                    case .failure(let error):
                                        //handle error
                                        break
                                }
                            }
                        } label: {
                            Text("Log Out")
                        }
                    } else {
                        
                        TextField("Username", text: $model.name)
                        TextField("Password", text: $model.password)
            
                        Button {
                            
                            model.container.login(token: PCAccessToken(accessToken: "your_token") { result in
                            //or model.authMan.login...
                                switch result {
                                    case .success(let bool):
                                        //bool should be true from server if no error exists
                                        break
                                    case .failure(let error):
                                        //handle error
                                        break
                                }
                            }
                        } label: {
                            Text("Login")
                        }
                    }
                }
            }
            
            #Preview {
                DocumentationView()
            }


````


2. Get a login with your credentials.



````swift 
    
    
          Button {
              
              model.container.login(credentials: PCCredentials(username: model.name, password: model.password)) { result in
              //or model.authMan.login...
                  switch result {
                      case .success(let bool):
                          //bool should be true from server if no error exists
                          break
                      case .failure(let error):
                          //handle error
                          break
                  }
              }
          } label: {
              Text("Login")
          }
            
    
````
See docs for more info:
[PCContainer](doc://com.apple.documentation/documentation/particleiosdk/pccontainer?context=ZmlsZTovLy9Vc2Vycy9jc3BlbGwvTGlicmFyeS9EZXZlbG9wZXIvWGNvZGUvRGVyaXZlZERhdGEvUGFydGljbGVfRXhhbXBsZS1oZWNxanBmY2V1aGdoYWNya2JteXNob2FtamF2L0J1aWxkL1Byb2R1Y3RzL0RlYnVnLWlwaG9uZXNpbXVsYXRvci9QYXJ0aWNsZUlvU0RLLmRvY2NhcmNoaXZlLw==)
[PCDevice](doc://com.apple.documentation/documentation/particleiosdk/pcdevice?context=ZmlsZTovLy9Vc2Vycy9jc3BlbGwvTGlicmFyeS9EZXZlbG9wZXIvWGNvZGUvRGVyaXZlZERhdGEvUGFydGljbGVfRXhhbXBsZS1oZWNxanBmY2V1aGdoYWNya2JteXNob2FtamF2L0J1aWxkL1Byb2R1Y3RzL0RlYnVnLWlwaG9uZXNpbXVsYXRvci9QYXJ0aWNsZUlvU0RLLmRvY2NhcmNoaXZlLw==)

How to get a device.

The easiest way to get a device after logging in is to call on the container to get one.

You can also call a static func on PCDevice such as getDevice or getProductDevice.

static public func getProductDevice(deviceID: DeviceID?, productIdOrSlug: ProductID, token: PCAccessToken) async throws -> PCDevice

or list devices from PCContainer or PCDevice.

after you have a device you can manipulate it by using instance function calls

- Example: 



````swift

        //prefered use

        //somewhere in the model
        extension DeviceID {
             static let myDevice = DeviceID("your_device_id")
        }

        Task {
              let device = try await model.container.getDevice(deviceID: DeviceID.myDevice)
        }

        //alternative use
        Task {
              let device = try await model.container.getDevice(deviceID: DeviceID("Your_DeviceID"))
        }
        
        device.callFunction...
        
        device.getVariable...
        
        device.ping...
        
        device.signal...
        
        device.subscribe....
        
        etc.
        
        
 //These stub outs maybe helpful
 //These are optional to open easier and less error prone functionality.
 //Although these can all be initialized directly, it is more useful to make static instances in order to keep loose string constants out of your app.
 
extension OrganizationName {
    public static let <#sandbox#> = OrganizationName("<#Sandbox#>")
}

extension ProductID {
    public static let <#name#> = ProductID("<#your_product_id_or_slug#>")
}

extension DeviceID {
    public static let <#name#>  = DeviceID("<#your_device_id#>")
}

extension VariableName {
    public static let <#name#> = VariableName("<#your_particle_program_defined_variable_name#>")
}

extension DeviceName {
    public static let <#name#>  = DeviceName("<#your_device_name#>")
}

extension EventName {
    public static let <#name#> = EventName("<#your_particle_program_defined_event_name#>")
}

extension FunctionName {
    public static let <#name#> = FunctionName("<#your_particle_program_defined_function_name#>")
}

extension FunctionArgument {
    public static let <#name#> = FunctionArgument("<#your_particle_program_defined_argument#>")
}

extension ICCIDNumber {
    static public let <#name#> = ICCIDNumber("<#your_iccic_number#>")
}

extension SerialNumber {
    public static let <#name#> = SerialNumber("<#your_serial_number#>")
}
*/


````


#You can also interact with the following:

## [PCAPIUser](doc://com.apple.documentation/documentation/particleiosdk/pcapiuser?context=ZmlsZTovLy9Vc2Vycy9jc3BlbGwvTGlicmFyeS9EZXZlbG9wZXIvWGNvZGUvRGVyaXZlZERhdGEvUGFydGljbGVfRXhhbXBsZS1oZWNxanBmY2V1aGdoYWNya2JteXNob2FtamF2L0J1aWxkL1Byb2R1Y3RzL0RlYnVnLWlwaG9uZXNpbXVsYXRvci9QYXJ0aWNsZUlvU0RLLmRvY2NhcmNoaXZlLw==)
This type allows

1. [Creating an API user](https://docs.particle.io/reference/cloud-apis/api/#creating-an-api-user)
2. [Updating an API user](https://docs.particle.io/reference/cloud-apis/api/#updating-an-api-user)
3. [Listing API users](https://docs.particle.io/reference/cloud-apis/api/#listing-api-users)
4. [Deleting an API user](https://docs.particle.io/reference/cloud-apis/api/#deleting-an-api-user)

## [PCUser](doc://com.apple.documentation/documentation/particleiosdk/pcuser?context=ZmlsZTovLy9Vc2Vycy9jc3BlbGwvTGlicmFyeS9EZXZlbG9wZXIvWGNvZGUvRGVyaXZlZERhdGEvUGFydGljbGVfRXhhbXBsZS1oZWNxanBmY2V1aGdoYWNya2JteXNob2FtamF2L0J1aWxkL1Byb2R1Y3RzL0RlYnVnLWlwaG9uZXNpbXVsYXRvci9QYXJ0aWNsZUlvU0RLLmRvY2NhcmNoaXZlLw==)
This type allows

1. [Get User (Returning the representation of the currently authenticated user.)](https://docs.particle.io/reference/cloud-apis/api/#get-user)
2. [Update user](https://docs.particle.io/reference/cloud-apis/api/#update-user)
3. [Delete user](https://docs.particle.io/reference/cloud-apis/api/#delete-user)
4. [Or Making a forgot password call.](https://docs.particle.io/reference/cloud-apis/api/#forgot-password)

When creating an API User or an User you can limit the scope of the user by assigning UserScopes.
For a complete listing of available scope see the documentation of [UserScopes](doc://com.apple.documentation/documentation/particleiosdk/userscopes?context=ZmlsZTovLy9Vc2Vycy9jc3BlbGwvTGlicmFyeS9EZXZlbG9wZXIvWGNvZGUvRGVyaXZlZERhdGEvUGFydGljbGVfRXhhbXBsZS1oZWNxanBmY2V1aGdoYWNya2JteXNob2FtamF2L0J1aWxkL1Byb2R1Y3RzL0RlYnVnLWlwaG9uZXNpbXVsYXRvci9QYXJ0aWNsZUlvU0RLLmRvY2NhcmNoaXZlLw==)

## [PCSimCard](doc://com.apple.documentation/documentation/particleiosdk/pcsimcard?context=ZmlsZTovLy9Vc2Vycy9jc3BlbGwvTGlicmFyeS9EZXZlbG9wZXIvWGNvZGUvRGVyaXZlZERhdGEvUGFydGljbGVfRXhhbXBsZS1oZWNxanBmY2V1aGdoYWNya2JteXNob2FtamF2L0J1aWxkL1Byb2R1Y3RzL0RlYnVnLWlwaG9uZXNpbXVsYXRvci9QYXJ0aWNsZUlvU0RLLmRvY2NhcmNoaXZlLw==)

This type is used for interacting with sims

1. [List SIM cards](https://docs.particle.io/reference/cloud-apis/api/#list-sim-cards)
2. [Get Sim Card Repredentation](https://docs.particle.io/reference/cloud-apis/api/#get-sim-information)
3. [Get data usage](https://docs.particle.io/reference/cloud-apis/api/#get-data-usage)
4. [Get data usage for product fleet](https://docs.particle.io/reference/cloud-apis/api/#get-data-usage-for-product-fleet)
5. [Activate SIM](https://docs.particle.io/reference/cloud-apis/api/#activate-sim)
6. [Import and activate product SIMs](https://docs.particle.io/reference/cloud-apis/api/#import-and-activate-product-sims)
7. [Deactivate SIM](https://docs.particle.io/reference/cloud-apis/api/#deactivate-sim)
8. [Reactivate SIM](https://docs.particle.io/reference/cloud-apis/api/#reactivate-sim)
9. [Release SIM from account](https://docs.particle.io/reference/cloud-apis/api/#release-sim-from-account)
