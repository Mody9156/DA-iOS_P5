//
//  AuthenticationRequest.swift
//  Aura
//
//  Created by KEITA on 28/03/2024.
//
import Foundation

final class AuthenticationRequest {
  
    let url = URL(string:"http://127.0.0.1:8080/auth")!
    var token = "A1450BC5-64E4-4828-8C3C-BEE93F710D3H"
    let session: URLSession
   
    
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
            return token
    }
    struct AuthRequest : Encodable {
        let username : String
        let password : String
    }
    
    
    func getSessionRequest(username: String, password: String)  throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let userData = AuthRequest(username: username, password: password)
        let data = try JSONEncoder().encode(userData)
        request.httpBody = data
//        let body = "username=\(username)&password=\(password)"
//        request.httpBody = body.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
