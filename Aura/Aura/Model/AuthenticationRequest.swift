//
//  AuthenticationRequest.swift
//  Aura
//
//  Created by KEITA on 28/03/2024.
//
import Foundation

final class AuthenticationRequest {
  
    let url = URL(string: "http://127.0.0.1:8080/auth")!
    var token = "A1450BC5-64E4-4828-8C3C-BEE93F710D31"
    let session: URLSession
   
    
    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
    
    enum Failure: Error {
        case tokenInvalide
    }
    
    
    func getUrl(username: String, password: String) async throws -> aura{
        let (data, _) = try await session.data(for: getSessionRequest())
        guard let responseJson = try? JSONDecoder().decode([String: String].self, from: data),
                username == responseJson["test@aura.app"],
                password == responseJson["test123"],
                let token = responseJson["token"]
        else {
            throw Failure.tokenInvalide
        }
       
        self.token = token
        print("\(token)")
        return aura(token: token)
    }
    
    func getSessionRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "username=test@aura.app&password=test123"
        request.httpBody = body.data(using: .utf8)
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
