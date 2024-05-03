import XCTest
@testable import Aura

final class MoneyTransferViewModelTests: XCTestCase {
    let moneyTransferViewModel = MoneyTransferViewModel(moneyTransferModel: MoneyTransferServiceTests())
    let tesKeychain = TesKeychain()
   
    func testsendAllEmpty() async throws {
        // When
        moneyTransferViewModel.recipient = ""
        moneyTransferViewModel.amount = ""
        
        do {
            try await moneyTransferViewModel.sendMoney()

            // Then
            XCTAssertEqual(moneyTransferViewModel.transferMessage, "Please enter recipient and amount.")
        } catch {
            XCTFail("Failed to transfer \(moneyTransferViewModel.amount) to \(moneyTransferViewModel.recipient)")
        }
    }
    
    func testAmountEmpty() async throws {
        // When
        moneyTransferViewModel.recipient = "exemple@gmail.com"
        moneyTransferViewModel.amount = ""
        
        do {
            try await moneyTransferViewModel.sendMoney()

            // Then
            XCTAssertEqual(moneyTransferViewModel.transferMessage, "Please enter amount.")
        } catch {
            XCTFail("Failed to transfer \(moneyTransferViewModel.amount) to \(moneyTransferViewModel.recipient)")
        }
    }
    
    func testRecipientEmpty() async throws {
        //Given
        
        // When
        moneyTransferViewModel.recipient = ""
        moneyTransferViewModel.amount = "33.33"
        
        do {
            try await moneyTransferViewModel.sendMoney()

            // Then
            XCTAssertEqual(moneyTransferViewModel.transferMessage, "Please enter valid recipient.")
        } catch {
            XCTFail("Failed to transfer \(moneyTransferViewModel.amount) to \(moneyTransferViewModel.recipient)")
        }
    }
    
    class MoneyTransferServiceTests : MoneyTransferService {
        let amount: String = "22"
        let token = "token"
        
        enum TransferFailureReason: Error {
            case FailedTransferRequest, HTTPStatusCodeError
        }
        
         func fetchMoneyTransfer(recipient: String, amount: Double, token: String) async throws {
            do {
                let (_, response) = try await URLSession(configuration: .ephemeral).data(for: makeTransferURLRequest(recipient: recipient, amount: amount, token: token))
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw TransferFailureReason.HTTPStatusCodeError
                }
                
                return
            } catch {
                throw TransferFailureReason.FailedTransferRequest
            }
        }
    }
    
    class TesKeychain : KeychainSwift {
        override func get(_ key: String) -> String? {
            return "keys"
        }
    }
}
