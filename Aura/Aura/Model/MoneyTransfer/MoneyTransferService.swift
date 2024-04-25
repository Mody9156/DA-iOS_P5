//
//  MoneyTransferModel.swift
//  Aura
//
//  Created by KEITA on 18/04/2024.
//

import Foundation

final class MoneyTransferService {

    let url = URL(string: "http://127.0.0.1:8080/account/transfer")!
    let session : URLSession
    let authenticationViewModel : AuthenticationViewModel

    init(session: URLSession = URLSession(configuration: .ephemeral),authenticationViewModel : AuthenticationViewModel) {
        self.session = session
        self.authenticationViewModel = authenticationViewModel
    }

    enum TransferFailureReason: Error {
        case FailedTransferRequest,HTTPStatusCodeError
        
    }

    func makeTransferURLRequest(recipient:String,amount : Double,token:String) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyencode = MoneyTransferModel(recipient: recipient, amount: amount)
        let data = try? JSONEncoder().encode(bodyencode)
        request.httpBody = data
        
        request.allHTTPHeaderFields = ["token":token]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        
        print("token : n °\(token)")

        return request
    }

    func fetchMoneyTransfer(recipient: String,amount:Double,token:String) async throws  {
        do {
            let (_,response) = try await session.data(for: makeTransferURLRequest(recipient: recipient, amount: amount,token: token))
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                throw TransferFailureReason.HTTPStatusCodeError
            }
           return
        }
        
        catch{
            throw TransferFailureReason.FailedTransferRequest
        }
    }
    

}


