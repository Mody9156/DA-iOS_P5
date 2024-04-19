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
    let keychain = KeychainSwift()
    let authenticationViewModel : AuthenticationViewModel
    
    init(session: URLSession = URLSession(configuration: .ephemeral),authenticationViewModel : AuthenticationViewModel) {
        self.session = session
        self.authenticationViewModel = authenticationViewModel
    }

    enum Failure: Error {
        case Fail
    }
    func getRequest() -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["token":authenticationViewModel.storedKey]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        print("token : n °\(authenticationViewModel.storedKey)")

        return request
    }
    
    func fetchAccountDetails() async throws -> AccountData {
        let (data, _) = try await session.data(for: getRequest())
        guard let json = try? JSONDecoder().decode(AccountData.self, from: data) else {
        throw Failure.Fail
        }
        return json
    }
    
}
    
   
