//
//  UrlModel.swift
//  Aura
//
//  Created by KEITA on 28/03/2024.
//

import Foundation
//créer une struct 
enum Connection {
    case authentification
    
    func url(connect:URL) -> URL {
        var components = URLComponents()
        components.scheme = connect.scheme
        components.host = connect.host
        
        components.path = "/auth"
        
        return components.url!
    }
    
    
    
}

let authentification = URL(string: "http://127.0.0.1:8080/auth")!
let add = Connection.authentification.url(connect: authentification)
