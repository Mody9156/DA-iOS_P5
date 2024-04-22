//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {

    @Published var totalAmount: String = "€12,345.67"
    @Published var recentTransactions: [Transactions] = [
        Transactions(description: "Starbucks", amount: "-€5.50"),
        Transactions(description: "Amazon Purchase", amount: "-€34.99"),
        Transactions(description: "Salary", amount: "+€2,500.00")
    ]
   @Published var transactionDetailsShown : Bool = false
    var accountModel : AccountModel

    init(accountModel:AccountModel) {
        self.accountModel = accountModel
    }

    enum Failure :Error {
    case error
    }
    @MainActor
    func callme() async {

        do{
            let data = try await accountModel.fetchAccountDetails()
            let dataTransactions = data.transactions
            let transactions = dataTransactions.map {
                
                Transactions(description: $0.label, amount: String($0.value))
            }
            recentTransactions.append(contentsOf: transactions)
            
            if transactionDetailsShown {
                LoopForcallme()
            }
        }
        catch{
            print(error)
        }
        
        
    }
    
    func LoopForcallme(){
        let amounts = recentTransactions.compactMap { Transactions in
            Double(Transactions.amount.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "-", with: "-€").replacingOccurrences(of: "+", with: "+€"))
        }
        let total = amounts.reduce(0, +)
        totalAmount = String("€\(total)")
    }// function for totalAmount
}

