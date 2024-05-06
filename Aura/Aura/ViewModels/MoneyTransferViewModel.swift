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
    
    private let moneyTransferModel: MoneyTransferService
    private  let keychain = KeychainSwift()

    init(moneyTransferModel: MoneyTransferService) {
        self.moneyTransferModel = moneyTransferModel
    }
    
    enum Failure : Error {
        case failAmount
        case tokenInvalide

    }
    
  @MainActor
    func sendMoney()  async throws {
        // Logic to send money - for now, we're just setting a success message.
        // You can later integrate actual logic.
        
      var stokeToken = ""
        var recupamount = 0.0
        if recipient.isEmpty && amount.isEmpty {
            transferMessage = "Please enter recipient and amount."
        } else if amount.isEmpty {
            transferMessage = "Please enter amount."
        } else if recipient.isEmpty  {
            transferMessage = "Please enter valid recipient."
        } else {
            do {
                if let getAmount = Double(amount)  {
                    recupamount = getAmount
                }else{
                    throw Failure.failAmount
                }
                if let getoken = keychain.get("token") {
                    stokeToken = getoken
                }
                    try await  moneyTransferModel.fetchMoneyTransfer(recipient: recipient, amount : recupamount, token: stokeToken)
                
                    self.moneyTransferModel.makeTransferURLRequest(recipient: recipient, amount: recupamount, token: stokeToken)
                    
                
                transferMessage = "Successfully transferred \( amount) to \( recipient)"
            } catch {
                transferMessage = "Failed to transfer \(amount) to \(recipient)"
                print(Failure.tokenInvalide)
            }
        }
    }
}
