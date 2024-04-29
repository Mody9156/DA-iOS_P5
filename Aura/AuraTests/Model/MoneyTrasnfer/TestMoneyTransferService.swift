//  TestMoneyTransferService.swift
//  AuraTests
//
//  Created by KEITA on 29/04/2024.

import XCTest
@testable import Aura

final class TestMoneyTransferService: XCTestCase {

    struct ExempleforMoneyTransferModel : Encodable {
        var recipient = "0758806696"
        var amount = 234.43
    }

    let moneyTransferService = MoneyTransferService()
    let recipient = "exemple@gmail.com"
    let amount  = 233.44
    let tokenforMoneyTransfer = "tokenforMoneyTransfer"

    func testmakeTransferURLRequest() throws {
        let url = URL(string: "http://127.0.0.1:8080/account/transfer")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        urlRequest.allHTTPHeaderFields = ["token":tokenforMoneyTransfer]

        let makeTransferURLRequest = moneyTransferService.makeTransferURLRequest(recipient: recipient, amount: amount, token: tokenforMoneyTransfer)

        XCTAssertEqual(makeTransferURLRequest.httpMethod, "POST")
        XCTAssertNotNil(makeTransferURLRequest.url)
        XCTAssertEqual(makeTransferURLRequest.value(forHTTPHeaderField: "content-type"), urlRequest.value(forHTTPHeaderField: "content-type"))
        XCTAssertEqual(makeTransferURLRequest.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(makeTransferURLRequest.value(forHTTPHeaderField: "token"), urlRequest.value(forHTTPHeaderField: "token"))
        XCTAssertNotNil(makeTransferURLRequest.httpBody)
    }

    func testfetchMoneyTransfer() async throws {
        enum TransferFailureReason: Error {
            case FailedTransferRequest, HTTPStatusCodeError
        }

        let testmoneyTransferService = moneyTransferService.makeTransferURLRequest(recipient: recipient, amount: amount, token: tokenforMoneyTransfer)

        func fetchMoneyTransfer(recipient: String, amount: Double, token: String) async throws {
            do {
                let (_, response) = try await URLSession(configuration: .ephemeral).data(for: testmoneyTransferService)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw TransferFailureReason.FailedTransferRequest
                }
                return
            } catch let error as MoneyTransferService.TransferFailureReason {
                switch error {
                case .FailedTransferRequest:
                    XCTFail("La requête de transfert d'argent a échoué")
                case .HTTPStatusCodeError:
                    XCTFail("Le serveur a renvoyé un code d'état HTTP différent de 200")
                }
            } catch {
                XCTFail("Une erreur inattendue s'est produite : \(error)")
            }
        }
    }
}
