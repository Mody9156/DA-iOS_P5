import XCTest
@testable import Aura

final class TestAuthenticationViewModel: XCTestCase {
  
    var authenticationViewModel : AuthenticationViewModel!
    
    override func setUp()  {
        authenticationViewModel = AuthenticationViewModel({},authentification: MockAuthConnector())
        super.setUp()
    }
    override func tearDown(){
        authenticationViewModel = nil
        super.tearDown()
    }
    
    func testonLoginSucceed()async throws {
        let expected = XCTestExpectation(description: "onLoginSucceed is true")
        
        let viewmodel = AuthenticationViewModel ({
            expected.fulfill()
        })
        
        do{
            try await viewmodel.connectAuthenticationViewModel()
        }
        
        wait(for: [expected], timeout: 1)
    }

    func testConnectAuthenticationViewModel() async throws {
        // Given
       
        let encodeToken  = "token"
        (authenticationViewModel.authentification as! MockAuthConnector ).getToken = encodeToken
        
        let keychain = Mockkeychain()
        authenticationViewModel.keychain = keychain
        
        var iscall = false
        
        authenticationViewModel.onLoginSucceed = {
            iscall = true
        }
        // When
        let username = "test@aura.app"
        let password = "test123"
       
        // Then
        
        do{
            let connectAuthenticationViewModel =  try await authenticationViewModel.connectAuthenticationViewModel()
            
            XCTAssertEqual(connectAuthenticationViewModel, encodeToken)
            XCTAssertEqual(authenticationViewModel.username,username)
            XCTAssertEqual(authenticationViewModel.password,password)
            XCTAssertEqual(keychain.get("token"), encodeToken)
            XCTAssertTrue(iscall)
            
        }catch let error as AuthenticationViewModel.AuthViewModelFailure{
            XCTAssertEqual(error, .tokenInvalide)
            XCTAssertFalse(iscall)

        }catch{
            XCTFail("Unexpected error: \(error)")
            XCTAssertFalse(iscall)

        }
        
    }

    class MockAuthConnector: AuthConnector {
        
        var getToken : String?
        
        override func getToken(username: String, password: String) async throws -> String {
            
            guard let result = getToken else{
                throw NSError(domain: "", code: 0,userInfo: nil)
            }
            return result
        }
    }
    
    class Mockkeychain: KeychainSwift {
        
        private var keychain : [String:String] = [:]
        
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
