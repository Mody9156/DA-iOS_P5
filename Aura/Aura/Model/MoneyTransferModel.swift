//
//  MoneyTransferModel.swift
//  Aura
//
//  Created by KEITA on 18/04/2024.
//

import Foundation

final class MoneyTransferModel {

    let url = URL(string: "http://127.0.0.1:8080/account/transfer")!
    let session : URLSession
    let authenticationViewModel : AuthenticationViewModel

    init(session: URLSession = URLSession(configuration: .ephemeral),authenticationViewModel : AuthenticationViewModel) {
        self.session = session
        self.authenticationViewModel = authenticationViewModel
    }

    enum Failure: Error {
        case Fail,failJSONDecoder
        
    }

    func getRequest(recipient:String,amount : Double) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyencode = MoneyTransfer(recipient: recipient, amount: amount)
        let data = try? JSONEncoder().encode(bodyencode)
        request.httpBody = data
        
        request.allHTTPHeaderFields = ["token":authenticationViewModel.storedKey]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        
        print("token : n °\(authenticationViewModel.storedKey)")

        return request
    }

    func fetchMoneyTransfer(recipient: String,amount:Double) async throws  {
        do {
            let (_,response) = try await session.data(for: getRequest(recipient: recipient, amount: amount))
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                throw Failure.Fail
            }
           return
        }
        
        catch{
            throw Failure.Fail
        }
    }
    

}


