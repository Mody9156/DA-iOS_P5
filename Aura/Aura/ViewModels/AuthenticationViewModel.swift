//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//
import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
     let authentification = AuthenticationRequest()
    
    
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
//        self.authentification = authentification
    }
    enum Failure: Error {
        case UsernameInvalide,PassewordInvalide,Invalide
    }
    func login() async throws -> aura {
        print("login with \(username) and \(password)")

        if  username == "test@aura.app" && password == "test123" {
            onLoginSucceed()
            print("login with \(username) and \(password)")
            let result  =  try await authentification.getUrl(username: username, password: password)
            return result
        }else if username == "test@aura.app" && password != "test123"{
            print("login with \(username) invalide")
            throw Failure.PassewordInvalide
          
        }else if username != "test@aura.app" && password == "test123"{
            print("login with \(username) invalide")
            throw Failure.UsernameInvalide
        }else{
            print("login with \(username) and \(password) invalide")
            throw Failure.Invalide
        }
       
   
        
    }
    
}
