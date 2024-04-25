//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = "test@aura.app"
    @Published var password: String = "test123"
    
    let authentification: AuthConnector
    let keychain = KeychainSwift()
    var storedKey: String
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (), authentification: AuthConnector = AuthConnector(),storedKey: String) {
        self.onLoginSucceed = callback
        self.authentification = authentification
        self.storedKey = storedKey
    }
    
    enum AuthViewModelFailure: Error {
        case tokenInvalide
    }
    
    func connectAuthenticationViewModel() async throws {
        let token = try await authentification.getToken(username: username, password: password)
        
        keychain.set(token, forKey: "token")
        
        if let getoken = keychain.get("token") {
            print("Token enregistré dans la keychain :", getoken)
            storedKey = getoken
            print(storedKey)
        } else {
            storedKey = "token is empty"

            print("\(AuthViewModelFailure.tokenInvalide)")
        }
       
        onLoginSucceed()
    }
}
