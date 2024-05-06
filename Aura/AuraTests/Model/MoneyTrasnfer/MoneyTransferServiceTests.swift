import XCTest
@testable import Aura

final class MoneyTransferServiceTests: XCTestCase {
    
    var moneyTransferService : MoneyTransferService!
    
    override func setUp()  {
        // Given
        moneyTransferService = MoneyTransferService(httpservice: MockHTTPService())
        super.setUp()
    }
                                        
    override func tearDown() {
        // Nettoyage après chaque test si nécessaire
        moneyTransferService = nil
        super.tearDown()
    }
    

    func testmakeTransferURLRequest() throws {
        // Given
        let recipient = "exemple@gmail.com"
        let amount  = 233.44
        let tokenforMoneyTransfer = "tokenforMoneyTransfer"
        
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
    
    func testFailfetchMoneyTransfer() async throws {
        // Given
        var moneyTransferModel = """
        {
        "recipient":"0768807796",
        "amount":22.33
        
        }
""".data(using: .utf8)!
        
        let urlRequest = HTTPURLResponse(url: URL(string: "http://exemple/account/transfer")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        let usingdata : (Data,HTTPURLResponse) = (moneyTransferModel,urlRequest)
        (moneyTransferService.httpservice as! MockHTTPService).mocksesult = usingdata
        
        // When/Then
        do{
            _ = try await moneyTransferService.fetchMoneyTransfer(recipient: "exemple@gmail.com", amount: 11, token: "token")
            
            XCTAssertThrowsError(MoneyTransferService.TransferFailureReason.httpStatusCodeError)
        }catch let error as MoneyTransferService.TransferFailureReason {
            XCTAssertEqual(error, .failedTransferRequest)
        }catch{
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testfetchMoneyTransfer() async throws {
        // Given
        var moneyTransferModel = """
        {
        "recipient":"0768807796",
        "amount":22.33
        
        }
""".data(using: .utf8)!
        
        let urlRequest = HTTPURLResponse(url: URL(string: "http://exemple/account/transfer")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let usingdata : (Data,HTTPURLResponse) = (moneyTransferModel,urlRequest)
        (moneyTransferService.httpservice as! MockHTTPService).mocksesult = usingdata
        
        // When/Then
        do{
           let response = try await moneyTransferService.fetchMoneyTransfer(recipient: "exemple@gmail.com", amount: 11, token: "token")
            XCTAssertEqual(response.statusCode,200)
            
        }catch let error as MoneyTransferService.TransferFailureReason {
            XCTAssertEqual(error, .failedTransferRequest)
        }catch{
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    class MockHTTPService : HTTPService {
        
        var mocksesult : (Data,URLResponse)?
        
        func request(_ request : URLRequest) async throws -> (Data,URLResponse){
             
             guard let result = mocksesult else {
                 throw NSError(domain: "", code: 0,userInfo: nil)
             }
            return result
                    
        }
    }
}
