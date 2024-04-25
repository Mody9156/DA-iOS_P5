//
//  AuthenticationRequest.swift
//  Aura
//
//  Created by KEITA on 28/03/2024.
import Foundation
import SwiftUI

final class AuthConnector {
    let url = URL(string:"http://127.0.0.1:8080/auth")!
    let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
    
    enum AuthenticationError: Error {
        case tokenInvalide
    }
    
    func getSessionRequest(username: String, password: String) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let userData = AuthData(username: username, password: password)
        let data = try JSONEncoder().encode(userData)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getToken(username: String, password: String) async throws -> String {
        let (data, _) = try await session.data(for: getSessionRequest(username: username, password: password))
        guard let responseJson = try? JSONDecoder().decode([String: String].self, from: data),
            let token = responseJson["token"]

        else {
            throw AuthenticationError.tokenInvalide
        }
 
        return token
    }
}
