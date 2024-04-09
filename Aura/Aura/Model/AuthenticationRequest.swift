//
//  AuthenticationRequest.swift
//  Aura
//
//  Created by KEITA on 28/03/2024.
//
import Foundation

final class AuthenticationRequest {
  
    let url = URL(string:"http://127.0.0.1:8080/auth")!
    let session: URLSession
    var keychain = KeychainSwift()
    
    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
    
    enum Failure: Error {
        case tokenInvalide
    }
    
    
    func getToken(username: String, password: String) async throws -> String{
        let (data, _) = try await session.data(for: getSessionRequest(username: username, password: password))
        guard let responseJson = try? JSONDecoder().decode([String: String].self, from: data),
                let token = responseJson["token"]
                
        else {
            throw Failure.tokenInvalide
        }
        
        let tokenTime : TimeInterval = 60 * 5
        _ = Date().addingTimeInterval(tokenTime)
        
        keychain.synchronizable = true
        keychain.set(token, forKey: "token",withAccess: .accessibleAfterFirstUnlockThisDeviceOnly)
       
        if let getoken = keychain.get("token"){
            print("Token :",getoken)
            let _ = keychain.delete("token")
            print("token delete")
        }else{
            print("\(Failure.tokenInvalide)")
        }
        
            return token
    }
    
    
    
    func getSessionRequest(username: String, password: String)  throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let userData = AuthRequest(username: username, password: password)
        let data = try JSONEncoder().encode(userData)
        request.httpBody = data

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
