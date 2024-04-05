//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//
import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = "test@aura.app"
    @Published var password: String = "test123"
     let authentification = AuthenticationRequest()
    var keychain = KeychainSwift()

    
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
    }

    func login() async throws {
        let token = try await authentification.getToken(username: username, password: password)
        print(token)
        
        onLoginSucceed()
  
        
    }
        
    }
    

