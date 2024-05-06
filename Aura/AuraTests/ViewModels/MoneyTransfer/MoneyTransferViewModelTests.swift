import XCTest
@testable import Aura

final class MoneyTransferViewModelTests: XCTestCase {
    
    var moneyTransferViewModel: MoneyTransferViewModel!
    var mockHTTPServiceTransactionDetails: MockHTTPServiceTransactionDetails!
    
    override func setUp() {
        moneyTransferViewModel = MoneyTransferViewModel(moneyTransferModel: MoneyTransferService(httpservice: MockHTTPServiceTransactionDetails()))
        mockHTTPServiceTransactionDetails = MockHTTPServiceTransactionDetails()
        super.setUp()
    }
    
    override func tearDown() {
        moneyTransferViewModel = nil
        mockHTTPServiceTransactionDetails = nil
        super.tearDown()
    }
    
    let tesKeychain = TesKeychain()
   
    func testsendAllEmpty() async throws {
        // Given
        
        // When
        moneyTransferViewModel.recipient = ""
        moneyTransferViewModel.amount = ""
        
        do {
            try await moneyTransferViewModel.sendMoney()

            // Then
            XCTAssertEqual(moneyTransferViewModel.transferMessage, "Please enter recipient and amount.")
        } catch let error as MoneyTransferViewModel.Failure {
            XCTAssertEqual(error, .tokenInvalide)
            XCTAssertEqual(error, .failAmount)
        } catch {
            XCTFail("Failed to transfer \(moneyTransferViewModel.amount) to \(moneyTransferViewModel.recipient)")
        }
    }
    
    func testAmountEmpty() async throws {
        // Given
        
        // When
        moneyTransferViewModel.recipient = "exemple@gmail.com"
        moneyTransferViewModel.amount = ""
        
        do {
            try await moneyTransferViewModel.sendMoney()

            // Then
            XCTAssertEqual(moneyTransferViewModel.transferMessage, "Please enter amount.")
        } catch let error as MoneyTransferViewModel.Failure {
            XCTAssertEqual(error, .tokenInvalide)
            XCTAssertEqual(error, .failAmount)
        } catch {
            XCTFail("Failed to transfer \(moneyTransferViewModel.amount) to \(moneyTransferViewModel.recipient)")
        }
    }
    
    func testRecipientEmpty() async throws {
        // Given
        
        // When
        moneyTransferViewModel.recipient = "exemple@gmail.com"
        moneyTransferViewModel.amount = "33.33"
        
        do {
            try await moneyTransferViewModel.sendMoney()
            print("Actual transfer message:", moneyTransferViewModel.transferMessage)

            // Then
            XCTAssertNotNil(moneyTransferViewModel.transferMessage)

        } catch {
            XCTFail("Failed to transfer \(moneyTransferViewModel.amount) to \(moneyTransferViewModel.recipient)")
        }
    }
    
    func testisTrue() async throws {
        // Given
        
        // When
        moneyTransferViewModel.recipient = ""
        moneyTransferViewModel.amount = "33.33"
        
        do {
            try await moneyTransferViewModel.sendMoney()
            print("Actual transfer message:", moneyTransferViewModel.transferMessage)

            // Then
            XCTAssertNotNil(moneyTransferViewModel.transferMessage)

        } catch let error as MoneyTransferViewModel.Failure {
            XCTAssertEqual(error, .tokenInvalide)
            XCTAssertEqual(error, .failAmount)
        } catch {
            XCTFail("Failed to transfer \(moneyTransferViewModel.amount) to \(moneyTransferViewModel.recipient)")
            XCTAssertEqual(moneyTransferViewModel.transferMessage, "Please enter valid recipient.")
        }
        
    }
   
    class MockHTTPServiceTransactionDetails: HTTPService {
        var data: (Data,URLResponse)?
        
        func request(_ request: URLRequest) async throws -> (Data,URLResponse) {
            guard let result = data else {
                throw NSError(domain: "", code: 0,userInfo: nil)
            }
            return result
        }
    }
    
    class TesKeychain: KeychainSwift {
        override func get(_ key: String) -> String? {
            return "keys"
        }
    }
}
