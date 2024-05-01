import Foundation
import SwiftUI

class AuthConnector {
    let httpservice: HTTPService
    
    init(httpservice: HTTPService = BasicHTTPClient()) {
        self.httpservice = httpservice
    }

    enum AuthenticationError: Error {
        case tokenInvalide
        case invalidResponse
    }
    
    func getSessionRequest(username: String, password: String) throws -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let userData = AuthData(username: username, password: password)
        let data = try JSONEncoder().encode(userData)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getToken(username: String, password: String) async throws -> String {
        let (data, response) = try await httpservice.request(getSessionRequest(username: username, password: password))
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AuthenticationError.invalidResponse
        }
        
        guard let responseJson = try? JSONDecoder().decode([String: String].self, from: data),
              let token = responseJson["token"]
        else {
            throw AuthenticationError.tokenInvalide
        }
        
        return token
    }
}
