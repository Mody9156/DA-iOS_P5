////
////  Authentificationtest.swift
////  AuraTests
////
////  Created by KEITA on 23/04/2024.
////
//
//import XCTest
//@testable import Aura
//
//final class Authentificationtest: XCTestCase {
//    
//    func testeAuthentification() async throws {
//        let authenticationRequest = AuthenticationRequest()
//
//        enum Failure : Error{
//            case BadToken
//        }
//        
//        func getRequest(username : String,passeword : String ) async throws ->String{
//            let data = try JSONEncoder().encode(["token":"newyoken"])
//            guard let json = try? JSONDecoder().decode([String:String].self , from: data), let token  =  json["token"] else{
//                throw Failure.BadToken
//            }
//            XCTAssertFalse(token.isEmpty,"Token is not be empty")
//            XCTAssertEqual(authenticationRequest.getToken(username: <#T##String#>, password: <#T##String#>), <#T##expression2: FloatingPoint##FloatingPoint#>, accuracy: <#T##FloatingPoint#>)
//            return token
//        }
//      
//    }//end
//}
//a
