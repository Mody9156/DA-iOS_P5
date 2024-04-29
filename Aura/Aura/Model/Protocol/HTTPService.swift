//
//  HTTPService.swift
//  Aura
//
//  Created by KEITA on 26/04/2024.
//

import Foundation

protocol HTTPService {
    func request(_ request : URLRequest) async throws -> (Data,URLResponse)
}
