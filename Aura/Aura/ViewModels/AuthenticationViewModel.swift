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
    var AutentificationUrl = URL(string: "http://127.0.0.1:8080/auth")!
    
    private let session : URLSession
    
    
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (),session:URLSession = URLSession(configuration: .ephemeral)){
        self.session = session
        self.onLoginSucceed = callback
    }
    
    private func Autentification() async throws -> AuthenticationRequest {
        let (data,_) = try await session.data(for: geturl())
        
        guard let Jsonresponse = try? JSONDecoder().decode([String:String].self, from: data),
           let username = Jsonresponse["est@aura.app"],
           let password = Jsonresponse["test123"] else {
            return  AuthenticationRequest(username: username, password: password)
        }
        
        return AuthenticationRequest(username: username, password: password)
    }
    
    
    
    private func geturl() -> URLRequest{
        var request = URLRequest(url: AutentificationUrl)
        request.httpMethod = "POST"
        
        let parameter = "username=test@aura.app&password=test123"
        request.httpBody = parameter.data(using: .utf8)
        return request
    }
    
    

    func login() {
        print("login with \(username) and \(password)")
        onLoginSucceed()
      
        
    }
}
