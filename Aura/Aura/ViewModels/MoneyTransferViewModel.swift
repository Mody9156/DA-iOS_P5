//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = "33 6 01 02 03 04"
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
        do{
            guard let getAmount = Double(amount) else {
               throw Failure.failAmount
            }
             try await  moneyTransferModel.fetchMoneyTransfer(recipient: recipient, amount : getAmount)
           
                transferMessage = "Successfully transferred \( self.amount) to \( self.recipient)"
          
           
        }
        catch {
                
              transferMessage = "Please enter recipient and amount."
                print(error)

        }

        }
    
    
   
        
    
}
