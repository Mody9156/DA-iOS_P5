//
//  AccountModel.swift
//  Aura
//
//  Created by KEITA on 03/04/2024.
//

import Foundation

final class DisplayTransactionDetails {
    let url = URL(string: "http://127.0.0.1:8080/account")!//copier
    let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .ephemeral) ) {
        self.session = session
    }

    enum TransactionDetailsRetrievalFailure: Error {
        case FetchAccountDetailsDecodingFailure
    }
    func makeMultiTransactionDetailsURLRequest(_ token:String) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["token":token]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        print("token : n °\(token)")

        return request
    }
    
    func fetchAccountDetails(_ token : String ) async throws -> TransactionDisplayModel {
        let (data, _) = try await session.data(for: makeMultiTransactionDetailsURLRequest(token))
        guard let json = try? JSONDecoder().decode(TransactionDisplayModel.self, from: data) else {
        throw TransactionDetailsRetrievalFailure.FetchAccountDetailsDecodingFailure
        }
        return json
    }
    
}
    
   
