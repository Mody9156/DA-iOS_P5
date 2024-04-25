//
//  Account.swift
//  Aura
//
//  Created by KEITA on 25/04/2024.
//

import Foundation

struct TransactionDisplayModel: Decodable {
    let currentBalance: Double
    let transactions: [Transaction]
}

// MARK: - Transaction
struct Transaction: Decodable {
    let value: Double
    let label: String
}
