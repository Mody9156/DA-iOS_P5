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
    
    
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
//        self.authentification = authentification
    }
//    enum Failure: Error {
//        case UsernameInvalide,PassewordInvalide,Invalide
//    }
    func login() async throws {
//        print("login with \(username) and \(password)")
        let token = try await authentification.getToken(username: username, password: password)
       //utilisation du key chain pour sauvegarder le token
        print(token)
        onLoginSucceed()
       
        //        if  username == "test@aura.app" && password == "test123" {
        //            onLoginSucceed()
        //            print("login with \(username) and \(password)")
        //            let result  =  try await authentification.getUrl(username: username, password: password)
        //            return result
        //        }else if username == "test@aura.app" && password != "test123"{
        //            print("login with \(username) invalide")
        //            throw Failure.PassewordInvalide
        //
        //        }else if username != "test@aura.app" && password == "test123"{
        //            print("login with \(username) invalide")
        //            throw Failure.UsernameInvalide
        //        }else{
        //            print("login with \(username) and \(password) invalide")
        //            throw Failure.Invalide
        //        }
        
    }
        
    }
    

