//
//  AccountModel.swift
//  Aura
//
//  Created by KEITA on 03/04/2024.
//
import Foundation

final class AccountModel {
    let url = URL(string: "http://127.0.0.1:8080/account")!
    let session: URLSession
    let authenticationRequest: AuthenticationRequest
    
    init(session: URLSession = URLSession(configuration: .ephemeral), authenticationRequest: AuthenticationRequest) {
        self.session = session
        self.authenticationRequest = authenticationRequest
    }
    
    enum Failure: Error {
        case tokenInvalid
    }
    
    func fetchAccountDetails(username: String, password: String) async throws -> (value: String, label: String) {
        let token = try await authenticationRequest.getToken(username: username, password: password)
        let (data, _) = try await session.data(for: getRequest(token: token))

        guard let json = try? JSONDecoder().decode([String: String].self, from: data),
              let value = json["value"] ,
              let label = json["label"] else {
            throw Failure.tokenInvalid
        }

       
        return (value,label)
       
    }
    
    private func getRequest(token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "token")//headers
        return request
    }
}
