//  AuraTests.swift
//  AuraTests
//
//  Created by KEITA on 26/03/2024.
//

import XCTest
@testable import Aura

final class AuraTests: XCTestCase {

    func testAuthentification() throws {
        let authenticationRequest = AuthConnector()

        let testForAuthentification = try authenticationRequest.getSessionRequest(username: "exemple", password: "exemple1")
        
        XCTAssertEqual(testForAuthentification.httpMethod, "POST")
        XCTAssertEqual(testForAuthentification.allHTTPHeaderFields?.isEmpty, false)
        XCTAssertNotNil(testForAuthentification)
    }
    
    func testAccountModel()  async throws {
        let appViewModel = AppViewModel()
        let testeAccountModel = DisplayTransactionDetails(authenticationViewModel: appViewModel.authenticationViewModel)
        
        XCTAssertEqual(testeAccountModel.makeMultiTransactionDetailsURLRequest().httpMethod, "GET")
        XCTAssertNotNil(testeAccountModel.url)
    }
    
    func testMoneyTransferModel() throws {
        let recipient =  "apple"
        let amount = 2.2
        
        let appViewModel = AppViewModel()
        let moneyTransferModel = MoneyTransferService(authenticationViewModel: appViewModel.authenticationViewModel)
        
        XCTAssertNotNil(moneyTransferModel.makeTransferURLRequest(recipient: recipient, amount: amount).url)
        XCTAssertEqual(moneyTransferModel.makeTransferURLRequest(recipient: recipient, amount: amount).httpMethod, "POST")
    }
}
