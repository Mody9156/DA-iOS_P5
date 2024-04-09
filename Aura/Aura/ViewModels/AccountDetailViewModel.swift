//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {
    
    @Published var totalAmount: String = "€12,345.67"
    @Published var recentTransactions: [Transaction] = [
        Transaction(description: "Starbucks", amount: "-€5.50"),
        Transaction(description: "Amazon Purchase", amount: "-€34.99"),
        Transaction(description: "Salary", amount: "+€2,500.00")
    ]
   
    let accountModel : AccountModel?
    
    struct Transaction {
        let description: String
        let amount: String
    }
    
    init(accountModel:AccountModel) {
        self.accountModel = accountModel
    }
    
    enum Failure :Error {
    case error
    }
    
    
    
    func callme() async throws {
            print("yess ")
        guard (try await accountModel?.fetchAccountDetails(username: "test@aura.app", password: "test123")) != nil
        else{
            throw Failure.error
        }
    }
    
}
