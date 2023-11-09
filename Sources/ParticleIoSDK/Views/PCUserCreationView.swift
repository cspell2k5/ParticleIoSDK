    //
    //  UserCreationView.swift
    //  ParticleSDK
    //
    //  Created by Craig Spell on 9/25/23.
    //

import SwiftUI

public struct PCUserCreationView: View {
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var username = ""
    @State private var password = ""
    
    @State private var credentials: PCCredentials
    
    @Binding var creatingUser: Bool
    
    private let productID: ProductID
    private var client: PCClient

    private let authManager: PCAuthenticationManager
    
    
    public init(creatingUser: Binding<Bool>, credentials: PCCredentials, client: PCClient, productID: ProductID) {
        self._creatingUser = creatingUser
        self.productID = productID
        self.authManager = PCAuthenticationManager.shared
        
        self.credentials = credentials
        self.client = client
    }
    
    
    public var body: some View {
        
        VStack {
            
            VStack {
                TextField("Email Address", text: $username)
                    .font(.largeTitle)
                    .padding()
                
                SecureField("Password", text: $password, prompt: Text("Password"))
                    .font(.largeTitle)
                    .padding()
            }.padding()
            
            HStack {
                Button {
                    creatingUser = false
                } label: {
                    
                    Label {
                        Text("Cancel")
                    } icon: {
                        EmptyView()
                    }
                }
                .padding()
                Spacer()
                Button {
                    Task {
                        do {
                            
                            let token = try await PCAccessToken.generateAccessToken(client: client, credentials: credentials)
                            
                            let existing =  try await PCCustomer.listCustomers(for: productID, token: token)
                            
                            print("existing:\n\(existing.debugDescription)\nfunction: \(#function) in \(#file)")
                            
                            if !existing.customers.compactMap({$0}).filter({$0.username == username}).isEmpty {
                                alertMessage = "The username is already taken."
                                showAlert = true
                            } else {
                                creatingUser = try await createCustomer(productID,
                                                                        client: client,
                                                                        username: credentials.username,
                                                                        password: credentials.password) == false
                                
                            }
                            
                        } catch {
                            print("error:\n\(error.localizedDescription)\nfunction: \(#function) in \(#file)")
                            alertMessage = "Something went wrong."
                            showAlert = true
                        }
                    }
                    
                } label: {
                    Label {
                        Text("Create")
                    } icon: {
                        EmptyView()
                    }
                }
                .foregroundColor(.blue)
                .padding()
            }
        }
        .padding()
        .alert("Something seems to have gone wrong.", isPresented: $showAlert) {
            
        } message: {
            Text(alertMessage)
        }
    }
    
    private func createCustomer(_ productIDorSlug: ProductID, client: PCClient, username: String, password: String) async throws -> Bool {
        
        do {
            let token = try await PCCustomer.createCustomer(with: client,
                                                            productID: productIDorSlug,
                                                            username: username,
                                                            password: password)
            print("customer create token:\(token)")
            try await authManager.login(token: token)
            
            return true
        } catch {
            throw PCAuthError.underlyingError(error)
        }
    }
}
