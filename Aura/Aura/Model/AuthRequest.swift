//
//  File.swift
//  Aura
//
//  Created by KEITA on 03/04/2024.
//

import Foundation

struct AuthRequest : Encodable {
    let username : String
    let password : String
}

struct AccountData: Decodable {
    let currentBalance: Double
    let transactions: [Transaction]
}

// MARK: - Transaction
struct Transaction: Decodable {
    let value: Double
    let label: String
}


