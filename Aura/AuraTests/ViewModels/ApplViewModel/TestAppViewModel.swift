import XCTest
@testable import Aura

final class TestAppViewModel: XCTestCase {

    let appViewModel = AppViewModel()
  
    func testIsLogged() throws {
       // Given
        let isLogged = appViewModel.isLogged
        // Then
        XCTAssertFalse(isLogged)
    }
    
    func testAuthenticationViewModel() {
        // Given
        let authenticationViewModel = appViewModel.authenticationViewModel
        // When
       
        // Then
        XCTAssertNotNil(authenticationViewModel)
        XCTAssertNoThrow(authenticationViewModel)
    }
    
    func testAccountDetailViewModel() {
        // Given
        let accountDetailViewModel = appViewModel.accountDetailViewModel
        // When
        
        // Then
        XCTAssertNotNil(accountDetailViewModel)
        XCTAssertNoThrow(accountDetailViewModel)
    }
    
    func testMoneyTransferViewModel() {
        // Given
        let moneyTransferViewModel = appViewModel.moneyTransferViewModel
        // When
        
        // Then
        XCTAssertNotNil(moneyTransferViewModel)
        XCTAssertNoThrow(moneyTransferViewModel)
    }
}
