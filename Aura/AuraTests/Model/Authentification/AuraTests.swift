import XCTest
@testable import Aura

final class AuthConnectorTests: XCTestCase {
    
  
        var authConnector: AuthConnector!
        
        override func setUp() {
            super.setUp()
            // Initialisation de votre AuthConnector avec un HTTPService fictif pour les tests
            authConnector = AuthConnector(httpservice: MockHTTPService())
        }
        
        override func tearDown() {
            // Nettoyage après chaque test si nécessaire
            authConnector = nil
            super.tearDown()
        }
    
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
        
        // Test de la fonction getToken avec une réponse HTTP valide et un JSON valide
        func testSuccessfulTokenDecoding() async {
            // Given
            let validTokenData = "{\"token\": \"validToken\"}".data(using: .utf8)!
            let mockResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let mockResult: (Data, HTTPURLResponse) = (validTokenData, mockResponse)
            (authConnector.httpservice as! MockHTTPService).mockResult = mockResult
            
            // When
            do {
                let token = try await authConnector.getToken(username: "validUsername", password: "validPassword")
                
                // Then
                XCTAssertEqual(token, "validToken")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        // Test de la fonction getToken avec une réponse HTTP invalide
        func testInvalidHTTPResponse() async {
            // Given
            let mockResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let mockResult: (Data, HTTPURLResponse) = (Data(), mockResponse)
            (authConnector.httpservice as! MockHTTPService).mockResult = mockResult
            
            // When
            do {
                _ = try await authConnector.getToken(username: "validUsername", password: "validPassword")
                
                // Then
                XCTFail("Expected invalid response error")
            } catch let error as AuthConnector.AuthenticationError {
                XCTAssertEqual(error, .invalidResponse)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        // Test de la fonction getToken avec un JSON invalide
        func testInvalidJSONResponse() async {
            // Given
            let invalidJSONData = "{\"invalid\": \"json\"}".data(using: .utf8)!
            let mockResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let mockResult: (Data, HTTPURLResponse) = (invalidJSONData, mockResponse)
            (authConnector.httpservice as! MockHTTPService).mockResult = mockResult
            
            // When
            do {
                _ = try await authConnector.getToken(username: "validUsername", password: "validPassword")
                
                // Then
                XCTFail("Expected decoding error")
            } catch let error as AuthConnector.AuthenticationError {
                XCTAssertEqual(error, .tokenInvalide)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        // Mock HTTPService utilisé pour simuler les réponses HTTP
        class MockHTTPService : HTTPService {
            var mockResult: (Data, HTTPURLResponse)?
            
             func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
                guard let result = mockResult else {
                    throw NSError(domain: "", code: 0, userInfo: nil) // Une erreur fictive si le résultat n'est pas défini
                }
                return result
            }
        }
    }
