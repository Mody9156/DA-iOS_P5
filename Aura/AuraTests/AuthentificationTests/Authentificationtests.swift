//
//  AuthentificationTests.swift
//  Aura
//
//  Created by KEITA on 23/04/2024.
//

import XCTest
@testable import Aura

final class AuthentificationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let authentificatin = AuthenticationRequest()
        let teste = try authentificatin.getSessionRequest(username: "exemple", password: "exemple123")
        XCTAssertEqual(teste.url,"POST")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
