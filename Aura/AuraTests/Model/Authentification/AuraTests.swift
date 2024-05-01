import XCTest
@testable import Aura

final class TestsAuthConnector: XCTestCase {
    
    let authConnector: AuthConnector = AuthConnector(httpservice: MockHTTPService())
    
    func testgetSessionRequest() throws {
        // Given
        struct EncodeAuth: Encodable {
            let username: String
            let password: String
        }
        
        let username = "exemple"
        let password = "test111"
        
        let encodeAuth = EncodeAuth(username: username, password: password)
        let data = try? JSONEncoder().encode(encodeAuth)
        
        let useExpectedURL = URL(string: "http://exemple/auh)")!
        
        var request = URLRequest(url: useExpectedURL)
        request.httpBody = data
        
        // When
        let useauthConnector = try authConnector.getSessionRequest(username: username, password: password)
        // Then
        XCTAssertEqual(useauthConnector.httpMethod, "POST")
        XCTAssertNotNil(useauthConnector.url)
        XCTAssertEqual(useauthConnector.httpBody, request.httpBody)
        XCTAssertNotNil(useauthConnector.allHTTPHeaderFields)
    }
    
    func testgetToken() async throws {
        
        // Given
        let username = "exemple"
        let password = "test111"
        let getToken = "tokenisvalide"
     
        // When
        do {
            let useAuthConnector = try await authConnector.getToken(username: username, password: password)
        } catch {
            XCTFail("Error retrieving token: \(error)")
        }
    }
    
    class MockHTTPService : HTTPService {
         func request(_ request : URLRequest) async throws -> (Data,URLResponse) {
             let tokenData = try JSONEncoder().encode(["token": "validToken"])
             let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
             return (tokenData, response)
        }
    }
}
