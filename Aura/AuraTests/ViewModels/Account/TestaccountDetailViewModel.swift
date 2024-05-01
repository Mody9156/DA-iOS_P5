import XCTest
@testable import Aura

final class TestAccountDetailViewModel: XCTestCase {
    
    let accountDetailViewModel = AccountDetailViewModel(accountModel: TestDisplayTransactionDetails())
   
    
    func testBeforInit() async  {
        // Given
        
        // When
        let totalAmount = "€12,345.67"
        
        // Then
        XCTAssertEqual(accountDetailViewModel.totalAmount, totalAmount)
        XCTAssertEqual(accountDetailViewModel.recentTransactions.count, 3)
    }
    
    
    func testDisplayNewTransactions() async {
        // Given
        let displayNewTransactions =  accountDetailViewModel.displayNewTransactions
        
        // When
         await displayNewTransactions()
        
        // Then
        XCTAssertNoThrow(accountDetailViewModel.recentTransactions.count > 3)
        XCTAssertTrue(accountDetailViewModel.recentTransactions.contains { $0.description == "Amazon Purchase" })
        XCTAssertFalse(accountDetailViewModel.recentTransactions.isEmpty)

    }
    
    
    class TestDisplayTransactionDetails : DisplayTransactionDetails {
        
        
        override func makeMultiTransactionDetailsURLRequest(_ token:String) -> URLRequest {
            let url = URL(string: "http://127.0.0.1:8080/account")!
            let request = URLRequest(url: url)
            
            return request
        }
        
        override func fetchAccountDetails(_ token : String ) async throws -> TransactionDisplayModel {
            let (data, _) = try await URLSession(configuration: .ephemeral).data(for: makeMultiTransactionDetailsURLRequest(token))
            guard let json = try? JSONDecoder().decode(TransactionDisplayModel.self, from: data) else {
                throw TransactionDetailsRetrievalFailure.FetchAccountDetailsDecodingFailure
            }
            return json
        }
    }

}
