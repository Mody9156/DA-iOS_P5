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
    private let urlLogin = URL(string: "http://127.0.0.1:8080/auth")!
    
    private let session : URLSession
    
    let onLoginSucceed: (() -> ())
    
    
    init(_ callback: @escaping () -> (),session:URLSession = URLSession(configuration: .ephemeral)) {
        self.onLoginSucceed = callback
        self.session = session
    }
    
    func Login() async throws {
        let (data,_) = try await session.data(for: buildRequest())
        guard let responseJson = try? JSONDecoder().decode([String:String].self, from: data),
              
        let _ = responseJson["username"],
        let _ = responseJson["password"] else{
            return
        }
    }

    private func buildRequest()->URLRequest{
        var request = URLRequest(url:urlLogin)
        request.httpMethod = "POST"
        
        let body = ""
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
    
    func login() {
        print("login with \(username) and \(password)")
        onLoginSucceed()
    }
}
