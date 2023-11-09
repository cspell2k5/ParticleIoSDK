//
//  PCLoginView.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/7/23.
//

import SwiftUI
import Combine


class LoginViewModel: ObservableObject {
    
    let authManager = PCAuthenticationManager.shared
    
    @Published var productID: ProductID
    @Published var client: PCClient
    
    @Published var credentials = PCCredentials(username: "", password: "")
    
    @Published var cancellables = Set<AnyCancellable>()
        
    @Published var alertMessage: String?
    @Published var isLoading = false
    
    @Published var loadingProgress = Progress(totalUnitCount: 0)
    
    init(
        productID: ProductID,
        client: PCClient,
        alertMessage: String? = nil
    ) {
        self.productID = productID
        self.client = client
        self.alertMessage = alertMessage
    }
    
    func login() {
        
        newProgress()
        authManager.login(credentials: credentials) { [weak self] result in
            switch result {
                case .success: break //AuthMan & @main take it from here.
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.37) {
                        self?.alertMessage = error.description
                    }
            }
            self?.decrementProgress()
        }
    }
    
    func logout() {
        
        newProgress()
        authManager.logout { [weak self] result in
            switch result {
                case .success: break
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.37) {
                        self?.alertMessage = error.description
                    }
            }
            self?.decrementProgress()
        }
    }
    
    private func newProgress(_ count: Int64 = 1) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.objectWillChange.send()
            self?.isLoading = true
            self?.loadingProgress = Progress(totalUnitCount: count)
        }
    }
    
    private func incrementProgress(_ by: Int64 = 1) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.objectWillChange.send()
            self?.loadingProgress.increment(by)
        }
    }
    
    private func decrementProgress(_ by: Int64 = 1) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.objectWillChange.send()
            self.loadingProgress.decrement(by)
            print("loading progress: \(String(describing: self.loadingProgress.fractionCompleted))")
            
            if self.loadingProgress.isFinished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.objectWillChange.send()
                    self.isLoading = false
                }
            }
        }
    }
    
    
    private func cancelProgress() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.objectWillChange.send()
            self?.loadingProgress.cancel()
            self?.isLoading = false
        }
    }
}


public struct PCLoginView<Content: View>: View {
    
    @StateObject var model: LoginViewModel

    @State private var creatingUser: Bool = false
    
    private var background: Content
    
    public init (
        productID: ProductID,
        client: PCClient,
        background: Content = LinearGradient(gradient: Gradient(colors: [.red, .white, .blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    ) {
        self.background = background
        self._model = StateObject(wrappedValue: LoginViewModel(productID: productID, client: client))
    }
    
    private var usernameTextField: some View {
        
        TextField(
            "User name (email address)",
            text: $model.credentials.username
        )
        .textContentType(.email)
        .background(.background)
        .opacity(1)
        .autocorrectionDisabled()
#if !os(watchOS) && !os(tvOS)
        .textFieldStyle(.roundedBorder)
#endif
    }
    
    private var passwordTextField: some View {
        
        SecureField(
            "Password",
            text: $model.credentials.password
        ) {}
            .background(.background)
            .opacity(1)
            .autocorrectionDisabled()
#if !os(watchOS) && !os(tvOS)
            .textFieldStyle(.roundedBorder)
#endif
    }
    
    private var signinButton: some View {
        
        HStack {
            Spacer(minLength: 1)
            Button(action: {
                model.login()
            }, label: {
                
                Label {
                    Text("Sign In")
                    
                } icon: {
                    
                    EmptyView()
                }
                .font(.largeTitle)
                .opacity(1)
            })
            .buttonStyle(.borderedProminent)
            .tint(.gray)
            Spacer(minLength: 1)
        }
    }

    private var createUserButton: some View {
       
        HStack {
            Spacer(minLength: 1)
            Button(action: {
                creatingUser.toggle()
            }, label: {
                
                Label {
                    Text("Create Account")
                    
                } icon: {
                    EmptyView()
                }
                .multilineTextAlignment(.center)
                .font(.largeTitle)
            })
            .buttonStyle(.borderedProminent)
            .tint(.gray)
            Spacer(minLength: 1)
        }
    }

          
    private var creationView: some View {
       
        PCUserCreationView(creatingUser: $creatingUser,
                           credentials: model.credentials,
                           client: model.client,
                           productID: model.productID)
    }
    
    public var body: some View {
       
        ZStack {
            
            background

            VStack {
                if model.isLoading {
                    
                    ProgressView("Loading...", value: model.loadingProgress.fractionCompleted)
                } else {
                    
                    Spacer()
                    
                    usernameTextField
                    
                    passwordTextField

                    signinButton

                    Spacer()
                    
                    createUserButton
                }
            }
            .sheet(isPresented: $creatingUser, content: {
                creationView
            })
            .alert(isPresented: .init(get: { model.alertMessage != nil }, set: { _ in }), content: {
               
                Alert(title: Text(model.alertMessage ?? ""),
                      dismissButton: .default(Text("Ok"), action: {
                    model.alertMessage = nil
                }))
            })
            .foregroundStyle(.primary)
            .padding()
        }
    }
}
