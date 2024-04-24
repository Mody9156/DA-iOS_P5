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
    let authentification : AuthenticationRequest
    let keychain = KeychainSwift()
    var storedKey: String
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (),authentification : AuthenticationRequest = AuthenticationRequest()) {
        self.onLoginSucceed = callback
        self.authentification =  authentification
        
        if let tokenvalue = keychain.get("token") {
            storedKey = tokenvalue
        } else {
            storedKey = "token is empty"
        }
    }
    enum Failure: Error {
                case tokenInvalide
            }

    func login() async throws {
        let token  = try await authentification.getToken(username: username, password: password)
        
            keychain.set(token, forKey: "token")

        if let getoken = keychain.get("token") {
                    print("Token enregistré dans la keychain :", getoken)
                    
                } else {
                    print("\(Failure.tokenInvalide)")
                }
       
        onLoginSucceed()
        
    }
        
    }
