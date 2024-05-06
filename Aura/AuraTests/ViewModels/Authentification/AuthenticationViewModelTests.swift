import XCTest
@testable import Aura

final class AuthenticationViewModelTests: XCTestCase {
  
    var authenticationViewModel: AuthenticationViewModel!
    
    override func setUp() {
        authenticationViewModel = AuthenticationViewModel({}, authentification: MockAuthConnector())
        super.setUp()
    }
    
    override func tearDown() {
        authenticationViewModel = nil
        super.tearDown()
    }
    
    func testOnLoginSucceed() async throws {
        //Given
        let expected = XCTestExpectation(description: "onLoginSucceed is true")
      
        let viewmodel = AuthenticationViewModel({
            expected.fulfill()
        })
        
        //When
        do {
            try await viewmodel.connectAuthenticationViewModel()
        }
        
        //Then
        wait(for: [expected], timeout: 1)
    }

    func testConnectAuthenticationViewModel() async throws {
        // Given
        let encodeToken = "token"
        (authenticationViewModel.authentification as! MockAuthConnector).getToken = encodeToken
        
        let keychain = MockKeychain()
        authenticationViewModel.keychain = keychain
        
        var isCall = false
        
        authenticationViewModel.onLoginSucceed = {
            isCall = true
        }
        
        // When
        let username = "test@aura.app"
        let password = "test123"
       
        // Then
        do {
            let connectAuthenticationViewModel = try await authenticationViewModel.connectAuthenticationViewModel()
            
            XCTAssertEqual(connectAuthenticationViewModel, encodeToken)
            XCTAssertEqual(authenticationViewModel.username, username)
            XCTAssertEqual(authenticationViewModel.password, password)
            XCTAssertEqual(keychain.get("token"), encodeToken)
            XCTAssertTrue(isCall)
            
        } catch let error as AuthenticationViewModel.AuthViewModelFailure {
            XCTAssertEqual(error, .tokenInvalide)
            XCTAssertFalse(isCall)

        } catch {
            XCTFail("Unexpected error: \(error)")
            XCTAssertFalse(isCall)

        }
    }

    class MockAuthConnector: AuthConnector {
        
        var getToken: String?
        
        override func getToken(username: String, password: String) async throws -> String {
            
            guard let result = getToken else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            return result
        }
    }
    
    class MockKeychain: KeychainSwift {
        
        private var keychain: [String:String] = [:]
        
        func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil, synchronizable: Bool = false, whenPrompt: String? = nil) -> Bool {
            keychain[key] = value
            return true
        }
        
        override func get(_ key: String) -> String? {
            return keychain[key]
        }
        func getValue(forKey key: String) -> String? {
            return keychain[key]
        }
    }
}
