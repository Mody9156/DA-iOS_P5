import XCTest
@testable import Aura

final class AccountDetailViewModelTests: XCTestCase {
    
    var viewModelUnderTest: AccountDetailViewModel!
    var mockKeychain: MockKeychain!
    var mockArray: MockArray!
    
    override func setUp() {
        viewModelUnderTest = AccountDetailViewModel(accountModel: MockArray())
        mockKeychain = MockKeychain()
        mockArray = MockArray()
        super.setUp()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        mockKeychain = nil
        mockArray = nil
        super.tearDown()
    }
   
    func testDisplayNewTransactions() async throws {
        // Given
        let expectedToken = "token"
        mockKeychain.keychain = expectedToken
        
        do {
            // When
            try await viewModelUnderTest.displayNewTransactions()

            // Then
            XCTAssertNoThrow(viewModelUnderTest.recentTransactions.count > 3)
            XCTAssertTrue(viewModelUnderTest.recentTransactions.contains { $0.description == "Amazon Purchase" })
            XCTAssertEqual(viewModelUnderTest.recentTransactions.count, 4)
            XCTAssertTrue(viewModelUnderTest.recentTransactions.contains { $0.description == "Apple" })
            XCTAssertEqual(viewModelUnderTest.recentTransactions.first?.description, "Starbucks")
            XCTAssertEqual(viewModelUnderTest.recentTransactions.last?.description, "Pear")
            XCTAssertNotNil(viewModelUnderTest.displayNewTransactions)

        } catch let error as AccountDetailViewModel.Failure {
            XCTAssertEqual(error, .tokenInvalide)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
  
    func testDisplayNewTransactionsWithInvalidToken() async throws {
        // Given
        mockKeychain.keychain = nil
        
        // When/Then
        do {
            try await viewModelUnderTest.displayNewTransactions()
            XCTFail("Expected an error but got none")
        } catch let error as AccountDetailViewModel.Failure {
            XCTAssertEqual(error, .tokenInvalide)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testTransactionMapping() async throws {
        // Given
        let mockAccountModel = MockArray()
        let viewModel = AccountDetailViewModel(accountModel: mockAccountModel)
        let mockKey = "exemple"
        let expectedTransactions = [
            Transaction(value: 10.0, label: "Transaction 1"),
            Transaction(value: 20.0, label: "Transaction 2")]

        mockAccountModel.exampleTransactions = expectedTransactions
        let mockKeychain = MockKeychain()
        mockKeychain.keychain = mockKey
        
        // When
        do {
            try await viewModel.displayNewTransactions()
                 
            let mappedTransactions = expectedTransactions.map {
                TransactionsModel(description: $0.label, amount: "\($0.value)")
            }
            
            // Then
            
        } catch let error as  AccountDetailViewModel.Failure {
            XCTAssertEqual(error, .tokenInvalide)
        } catch {
            XCTFail("Failed to display new transactions")
        }
    }

    class MockArray: DisplayTransactionDetails {
        var exampleTransactions: [Transaction]?
        
        override func fetchAccountDetails(_ token: String) async throws -> TransactionDisplayModel {
            
            guard let result =  exampleTransactions else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }

            let transactionDisplay = TransactionDisplayModel(currentBalance: 0, transactions: result)
            return transactionDisplay
        }
    }
    
    class MockKeychain: KeychainSwift {
        var keychain: String?
       
        func getValue(forKey key: String) -> String? {
            return keychain
        }
    }
}
