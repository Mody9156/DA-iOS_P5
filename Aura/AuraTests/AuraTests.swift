//
//  AuraTests.swift
//  AuraTests
//
//  Created by KEITA on 26/03/2024.
//

import XCTest
@testable import Aura

final class AuraTests: XCTestCase {

    func testAuthentification() throws {
        let authenticationRequest = AuthenticationRequest()

        let testForAuthentification = try authenticationRequest.getSessionRequest(username: "exemple", password: "exemple1")
        
        XCTAssertEqual(testForAuthentification.httpMethod, "POST")
        XCTAssertEqual(testForAuthentification.allHTTPHeaderFields?.isEmpty, false)
        XCTAssertNotNil(testForAuthentification)
    }
    
    func testAccountModel()  async throws{
//
        
       
        let appViewModel = AppViewModel()
        let testeAccountModel = AccountModel(authenticationViewModel: appViewModel.authenticationViewModel)
        
        XCTAssertEqual(testeAccountModel.getRequest().httpMethod, "GET")
        XCTAssertNotNil(testeAccountModel.url)
        
//
//                let url = URL(string: "http://127.0.0.1:8080/account")!
//                let token = "testNewtoken"
//                let allHTTPHeaderFields = ["token":token]
//
//                enum Failure: Error {
//                    case Fail
//                }
//
//        struct TestAccountData: Decodable {
//            let currentBalance: Double
//            let transactions: [Transaction]
//        }
//
//        // MARK: - Transaction
//        struct Transaction: Decodable {
//            var value: Double = 2.34
//            var label: String = "apple"
//        }
//
//                func getRequest() -> URLRequest {
//
//                    var request = URLRequest(url: url)
//                    request.httpMethod = "GET"
//                    request.allHTTPHeaderFields = allHTTPHeaderFields
//                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
//
//                    return request
//                }
//
//
//                let (data,_)  = try await testeAccountModel.session.data(for: getRequest())
//
//
//        guard let json  = try? JSONDecoder().decode(TestAccountData.self, from: data)  else{
//            throw Failure.Fail
//        }
//        XCTAssertEqual(json.currentBalance,20.33)
//
//
    }
    
    func testMoneyTransferModel() throws {
        
        let recipient =  "apple"
        let amount = 2.2
        
        
        let appViewModel = AppViewModel()
        let  moneyTransferModel = MoneyTransferModel(authenticationViewModel: appViewModel.authenticationViewModel)
        XCTAssertNotNil(moneyTransferModel.getRequest(recipient: recipient, amount: amount).url)
        XCTAssertEqual(moneyTransferModel.getRequest(recipient: recipient, amount: amount).httpMethod, "POST")
             
            
    }
}
