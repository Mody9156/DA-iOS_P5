////
////  TestAuthConnector.swift
////  Aura
////
////  Created by KEITA on 26/04/2024.
//
//
//import XCTest
//@testable import Aura
//
//final class TestAuthConnector: XCTestCase {
//
//
//    func testAuthConnector() throws {
//
//
//        let url =  URL(string: "http://exemple/auth")
//        let session = URLSession(configuration: .ephemeral)
//        let username = "first"
//        let password = "last"
//
//
//
//    enum AuthenticationError: Error {
//        case tokenInvalide
//    }
//
//        func getSessionRequest(username: String, password: String) throws -> URLRequest {
//
//            guard let urltest = URL(string: "http://exemple/auth") else{
//                throw NSError(domain: "Test", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL non valide"])
//
//            }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            let userData = AuthData(username: username, password: password)
//            let data = try JSONEncoder().encode(userData)
//            request.httpBody = data
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            return request
//
//        }
//
//        let getSessionRequest = try getSessionRequest(username: username, password: password)
//        XCTAssertNotNil(getSessionRequest.httpMethod)
//        XCTAssertNotNil(getSessionRequest.url)
//
//
//
//        func getToken(username: String, password: String) async throws -> String {
//            let (data, _) = try await session.data(for: getSessionRequest(username: username, password: password))
//            guard let responseJson = try? JSONDecoder().decode([String: String].self, from: data),
//                let token = responseJson["token"]
//            else {
//                throw AuthenticationError.tokenInvalide
//            }
//
//            return token
//        }
//
//        do{
//            let token = getToken(username: username, password: password)
//            XCTAssertNotNil(token)
//        }catch{
//            XCTFail("Le token n'est pas valide veuillez vérifier")
//        }
//
//
//    }
//
//   
//
//}
