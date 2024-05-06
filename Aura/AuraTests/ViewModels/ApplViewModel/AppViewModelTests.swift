import XCTest
@testable import Aura

final class AppViewModelTests: XCTestCase {

    let appViewModel = AppViewModel()
  
    func testIsLoggedInitiallyFalse() throws {
        // Given
        let isLogged = appViewModel.isLogged
        
        // Then
        XCTAssertFalse(isLogged)
    }
    
    func testAuthenticationViewModelInitialization() {
        // Given
        
        // When
        let authenticationViewModel = appViewModel.authenticationViewModel
        
        // Then
        XCTAssertNotNil(authenticationViewModel)
        XCTAssertNoThrow(authenticationViewModel)
    }
    
    func testAccountDetailViewModelInitialization() {
        // Given
        
        // When
        let accountDetailViewModel = appViewModel.accountDetailViewModel
        
        // Then
        XCTAssertNotNil(accountDetailViewModel)
        XCTAssertNoThrow(accountDetailViewModel)
    }
    
    func testMoneyTransferViewModelInitialization() {
        // Given
        
        // When
        let moneyTransferViewModel = appViewModel.moneyTransferViewModel
        
        // Then
        XCTAssertNotNil(moneyTransferViewModel)
        XCTAssertNoThrow(moneyTransferViewModel)
    }
}
