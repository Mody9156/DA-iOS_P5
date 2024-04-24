//
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
    let moneyTransferModel : MoneyTransferModel
    
    init(moneyTransferModel: MoneyTransferModel) {
       
        self.moneyTransferModel = moneyTransferModel
    }
    enum Failure : Error{
        case failAmount
    }
    
    
   
    
    
    func sendMoney()  async throws {
        // Logic to send money - for now, we're just setting a success message.
        // You can later integrate actual logic.
            
        if recipient.isEmpty && amount.isEmpty {
            transferMessage = "Please enter recipient and amount."
        }
        else if amount.isEmpty {
            
            transferMessage = "Please enter amount ."
        }
        else if recipient.isEmpty{
            transferMessage = "Please enter recipient ."
        }
        else{
           
            do{
                guard let getAmount = Double(amount) else {
                    throw Failure.failAmount
                }
                try await  moneyTransferModel.fetchMoneyTransfer(recipient: recipient, amount : getAmount)
                
                transferMessage = "Successfully transferred \( self.amount) to \( self.recipient)"
                
                
            }
            catch {
                
                transferMessage = "Failed to transfer \(amount) to \(recipient)"
                print(error)
                
                }
      
            }

        }
    
    
   
        
    
}
