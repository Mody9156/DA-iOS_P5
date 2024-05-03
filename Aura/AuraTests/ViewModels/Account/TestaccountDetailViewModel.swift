import XCTest
@testable import Aura

final class TestAccountDetailViewModel: XCTestCase {
    
    var accountDetailViewModel : AccountDetailViewModel!
    
    override func setUp() {
        accountDetailViewModel = AccountDetailViewModel(accountModel: MockArray())
        super.setUp()
    }
    override func tearDown() {
        accountDetailViewModel = nil
        super.tearDown()
    }
   
  
    
    func testDisplayNewTransactions() async throws {
        // Given
        let displayNewTransactions =  accountDetailViewModel.displayNewTransactions
        
        // When
        
        // Then
        
        do{
            try await displayNewTransactions()

            XCTAssertNoThrow(accountDetailViewModel.recentTransactions.count > 3)
            XCTAssertTrue(accountDetailViewModel.recentTransactions.contains { $0.description == "Amazon Purchase" })
            XCTAssertFalse(accountDetailViewModel.recentTransactions.isEmpty)
        } catch let error as AccountDetailViewModel.Failure {
            XCTAssertEqual(error, .tokenInvalide)
        }catch{
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    class MockArray : DisplayTransactionDetails {
//        var exempleforArray : [Transaction]?
//        
//        override func fetchAccountDetails(_ token: String) async throws -> TransactionDisplayModel {
//            
//            guard let result =  exempleforArray else{
//                throw NSError(domain: "", code: 0,userInfo: nil)
//            }
//            return TransactionDisplayModel(from:result)
//        }
    }
    
    class Mockkeychain: KeychainSwift {
        
        var keychain : String?
       
        func getValue(forKey key: String) -> String? {
            
            return keychain
            
        }
    }
   
}
