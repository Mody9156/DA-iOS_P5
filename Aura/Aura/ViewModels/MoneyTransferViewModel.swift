//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    let moneyTransferModel: MoneyTransferService
    var storedKey: String
    let keychain = KeychainSwift()

    init(moneyTransferModel: MoneyTransferService,storedKey: String) {
        self.moneyTransferModel = moneyTransferModel
        self.storedKey = storedKey

    }
    
    enum Failure : Error {
        case failAmount
    }
    
    // Regex (A regular expression)
//    func isValidEmail(_ email: String) -> Bool {
//        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
//        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: email)
//    }
//
//    func valideNumber(_ number: String) -> Bool {
//        let regexForNumber = #"^\d{10}$"#
//        return NSPredicate(format: "SELF MATCHES %@", regexForNumber).evaluate(with: number)
//    }
  @MainActor
    func sendMoney()  async throws {
        // Logic to send money - for now, we're just setting a success message.
        // You can later integrate actual logic.
        
        if let getoken = keychain.get("token") {
            self.storedKey = getoken
            
        } else {
            self.storedKey = ""

        }
        
        
        if recipient.isEmpty && amount.isEmpty {
            transferMessage = "Please enter recipient and amount."
        } else if amount.isEmpty {
            transferMessage = "Please enter amount ."
        } else if recipient.isEmpty  {
            transferMessage = "Please enter valid recipient."
        } else {
            do {
                guard let getAmount = Double(amount) else {
                    throw Failure.failAmount
                }
                try await  moneyTransferModel.fetchMoneyTransfer(recipient: recipient, amount : getAmount, token: storedKey)
                self.moneyTransferModel.makeTransferURLRequest(recipient: recipient, amount: getAmount, token: storedKey)
                transferMessage = "Successfully transferred \( self.amount) to \( self.recipient)"
            } catch {
                transferMessage = "Failed to transfer \(amount) to \(recipient)"
                print(error)
            }
        }
    }
}
