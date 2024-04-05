//
//  AccountModel.swift
//  Aura
//
//  Created by KEITA on 03/04/2024.
//

import Foundation

final class accountModel {
    let url = URL(string: "http://127.0.0.1:8080/account")!
    let session : URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getRequest() -> URLRequest{
        let request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
}

// terminer l'appel reseau à l'aide de postname et reorganiser le code de manère structuré
