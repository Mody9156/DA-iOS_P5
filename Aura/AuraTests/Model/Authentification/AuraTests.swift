import XCTest
@testable import Aura

final class TestAuthConnector: XCTestCase {
    
    func testgetSessionRequest() throws {
        struct EncodeAuth: Encodable {
            let username: String
            let password: String
        }
        
        let username = "exemple"
        let password = "test111"
        
        let encodeAuth = EncodeAuth(username: username, password: password)
        let data = try? JSONEncoder().encode(encodeAuth)
        
        let useExpectedURL = URL(string: "http://127.0.0.1:8080/auth)")!
        
        var request = URLRequest(url: useExpectedURL)
        request.httpBody = data
        
        let authConnector = AuthConnector(session: URLSession.shared)
        let useauthConnector = try authConnector.getSessionRequest(username: username, password: password)
        
        XCTAssertEqual(useauthConnector.httpMethod, "POST")
        XCTAssertNotNil(useauthConnector.url)
        XCTAssertEqual(useauthConnector.httpBody, request.httpBody)
        XCTAssertNotNil(useauthConnector.allHTTPHeaderFields)
    }
    
    func testgetToken() async throws {
        
        enum AuthenticationError: Error {
            case tokenInvalide
        }
        
        let authConnector = AuthConnector()
        let username = "exemple"
        let password = "test111"
        let token = "tokenforAuth"
        
        let getToken = try? await authConnector.getToken(username: username, password: password)
        let useauthConnector = try authConnector.getSessionRequest(username: username, password: password)
             
        func getToken(username: String, password: String) async throws -> String {
            let (data, _) = try await URLSession(configuration: .ephemeral).data(for: useauthConnector)
            guard let responseJson = try? JSONDecoder().decode([String: String].self, from: data),
                  let token = responseJson[token]
            else {
                throw AuthenticationError.tokenInvalide
            }
            
            return token
        }
        
        XCTAssertEqual(getToken, getToken)
    }
}
