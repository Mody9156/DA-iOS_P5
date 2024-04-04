////
////  AccountModel.swift
////  Aura
////
////  Created by KEITA on 03/04/2024.
////
//
//import Foundation
//
//class accountModel {
//    let url = URL(string:"http://127.0.0.1:8080/account")!
//    let session : URLSession
//    let token = "326E3DA8-8BF6-48A0-B846-89705678A179"
//    
//    init(session:URLSession = URLSession(configuration: .ephemeral)){
//        self.session = session
//    }
//    
//    enum Failure: Error {
//        case tokenInvalide
//    }
//    
//    func getaccountModel(currentBalance:Double,transactions:[Double:String]) async throws ->aura{
//        let (data,_) = try await  session.data(for: getaccountModel())
//        guard let responseJson = try? JSONDecoder().decode([String:String].self, from: data),
//        let currentBalance = responseJson["currentBalance"],
//        let transactions = responseJson["transactions[]"]
//        else{
//            throw Failure.tokenInvalide
//        }
//        
//        return aura(token: token)
//    }
//    
//    func getaccountModel()->URLRequest{
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
//        return request
//    }
//}
