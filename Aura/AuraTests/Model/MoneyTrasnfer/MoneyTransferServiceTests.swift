import XCTest
@testable import Aura

final class MoneyTransferServiceTests: XCTestCase {
    
    // Given
    struct ExempleforMoneyTransferModel : Encodable {
        var recipient = "0758806696"
        var amount = 234.43
    }

    let moneyTransferService = MoneyTransferService(httpservice: MockHTTPService())
    let recipient = "exemple@gmail.com"
    let amount  = 233.44
    let tokenforMoneyTransfer = "tokenforMoneyTransfer"

    func testmakeTransferURLRequest() throws {
        // Given
        let url = URL(string: "http://exemple/account/transfer")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        urlRequest.allHTTPHeaderFields = ["token":tokenforMoneyTransfer]

        // When
        let makeTransferURLRequest = moneyTransferService.makeTransferURLRequest(recipient: recipient, amount: amount, token: tokenforMoneyTransfer)

        // Then
        XCTAssertEqual(makeTransferURLRequest.httpMethod, "POST")
        XCTAssertNotNil(makeTransferURLRequest.url)
        XCTAssertEqual(makeTransferURLRequest.value(forHTTPHeaderField: "content-type"), urlRequest.value(forHTTPHeaderField: "content-type"))
        XCTAssertEqual(makeTransferURLRequest.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(makeTransferURLRequest.value(forHTTPHeaderField: "token"), urlRequest.value(forHTTPHeaderField: "token"))
        XCTAssertNotNil(makeTransferURLRequest.httpBody)
    }

    func testfetchMoneyTransfer() async throws {
        // Given
        enum TransferFailureReason: Error {
            case FailedTransferRequest, HTTPStatusCodeError
        }

        let testmoneyTransferService = moneyTransferService.makeTransferURLRequest(recipient: recipient, amount: amount, token: tokenforMoneyTransfer)
        
        // When
        func fetchMoneyTransfer(recipient: String, amount: Double, token: String) async throws {
            do {
                let (_, response) = try await URLSession(configuration: .ephemeral).data(for: testmoneyTransferService)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw TransferFailureReason.FailedTransferRequest
                }
                return
            } catch let error as MoneyTransferService.TransferFailureReason {
                switch error {
                case .failedTransferRequest:
                    XCTFail("La requête de transfert d'argent a échoué")
                case .httpStatusCodeError:
                    XCTFail("Le serveur a renvoyé un code d'état HTTP différent de 200")
                }
            } catch {
                XCTFail("Une erreur inattendue s'est produite : \(error)")
            }
        }
    }
    
    class MockHTTPService : HTTPService {
         func request(_ request : URLRequest) async throws -> (Data,URLResponse){
             let tokenData = try JSONEncoder().encode(["token": "validToken"])
             let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                    return (tokenData, response)
        }
    }
}
