import XCTest
@testable import Aura

final class TestAuthenticationViewModel: XCTestCase {
  
    var authenticationViewModel: AuthenticationViewModel!

    func testConnectAuthenticationViewModel() async throws {
        // Given
        authenticationViewModel = AuthenticationViewModel({}, authentification: MockAuthConnector())
        let onLoginSucceed = authenticationViewModel
       
        // When
        try await authenticationViewModel.connectAuthenticationViewModel()
        let username = "exemple"
        let password = "exemple123"
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(onLoginSucceed)
            XCTAssertNotNil(self.authenticationViewModel.username)
            XCTAssertNotNil(self.authenticationViewModel.password)
        }
    }

    class MockAuthConnector: AuthConnector {
        override func getToken(username: String, password: String) async throws -> String {
            return "mockedToken"
        }
    }
}
