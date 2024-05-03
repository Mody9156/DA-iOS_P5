//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {

    @Published var totalAmount: String = "€12,345.67"
    @Published var recentTransactions: [TransactionsModel] = [
        TransactionsModel(description: "Starbucks", amount: "-€5.50"),
        TransactionsModel(description: "Amazon Purchase", amount: "-€34.99"),
        TransactionsModel(description: "Salary", amount: "+€2,500.00")
    ]
    @Published var transactionDetailsShown : Bool = false
    private var accountModel : DisplayTransactionDetails
    private let keychain = KeychainSwift()

    init(accountModel: DisplayTransactionDetails) {
        self.accountModel = accountModel
    }

    enum Failure :Error {
        case tokenInvalide
    }
   

    @MainActor
    func displayNewTransactions() async throws {
        
        do {
            if let getoken = keychain.get("token") {
                let makeMultiTransactionDetailsURLRequest = accountModel.makeMultiTransactionDetailsURLRequest(getoken)

                let data = try await accountModel.fetchAccountDetails(getoken)
                let dataTransactions = data.transactions
                let transactions = dataTransactions.map {
                    TransactionsModel(description: $0.label, amount: String($0.value))
                }
                recentTransactions.append(contentsOf: transactions)

            }
            
        }
        catch {
             throw Failure.tokenInvalide
        }
    }

}
