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
    var accountModel : DisplayTransactionDetails
    let keychain = KeychainSwift()
    var storedKey: String

    init(accountModel: DisplayTransactionDetails,storedKey: String) {
        self.accountModel = accountModel
        self.storedKey = storedKey
    }

    enum Failure :Error {
        case error
    }

    @MainActor
    func displayNewTransactions() async {
        
        do {
            if let getoken = keychain.get("token") {
                self.storedKey = getoken

            } else {
                self.storedKey = ""

            }
            _ = accountModel.makeMultiTransactionDetailsURLRequest(storedKey)

            let data = try await accountModel.fetchAccountDetails(storedKey)
            let dataTransactions = data.transactions
            let transactions = dataTransactions.map {
                TransactionsModel(description: $0.label, amount: String($0.value))
            }
            recentTransactions.append(contentsOf: transactions)
            
            if transactionDetailsShown {
                adjustTransactionPresentationInAccountDetailViewModel()
            }
        } catch {
            print(error)
        }
    }
//
    func adjustTransactionPresentationInAccountDetailViewModel() {
        let amounts = recentTransactions.compactMap { Transactions in // transformations de collection
            Double(Transactions.amount.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "-", with: "-€").replacingOccurrences(of: "+", with: "+€")) // configuration
        }
        
        

    }
}
