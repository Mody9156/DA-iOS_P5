//
//  BasicHTTPClient.swift
//  Aura
//
//  Created by KEITA on 26/04/2024.
//

import Foundation

final class BasicHTTPClient: HTTPService {
    
    private let session : URLSession
    
    init(session : URLSession = URLSession.shared){
        self.session = session
    }
    enum failure : Error {
        case requestInvalid
    }
    
    func request(_ request : URLRequest) async throws -> (Data,URLResponse){
        
        let (data,response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else{
            throw failure.requestInvalid
        }
        
        return(data,response)
    }
}
