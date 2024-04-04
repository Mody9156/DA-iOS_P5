//
//  AccountModel.swift
//  Aura
//
//  Created by KEITA on 03/04/2024.
//

import Foundation

class accountModel {
    let url = URL(string:"http://127.0.0.1:8080/account")!
    let session : URLSession
    let token = "326E3DA8-8BF6-48A0-B846-89705678A179"
    
    init(session:URLSession = URLSession(configuration: .ephemeral)){
        self.session = session
    }
    func getaccountModel() async throws ->aura{
        return aura(token: token)
    }
    
    func getaccountModel()->URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
