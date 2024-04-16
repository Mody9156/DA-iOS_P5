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
    var token : TokenForAura
    
    init(session: URLSession = URLSession(configuration: .default),token : TokenForAura) {
        self.session = session
        self.token = token
        
    }

    enum Failure: Error {
        case Fail
    }
  
    func getRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token.token, forHTTPHeaderField: "token") // headers
        return request
    }
    
    func fetchAccountDetails() async throws -> AccountData {
        let (data, _) = try await session.data(for: getRequest())
        guard let json = try? JSONDecoder().decode(AccountData.self, from: data) else {
            throw Failure.Fail
        }
        print("\(token.token)")
        return json
    }
}
