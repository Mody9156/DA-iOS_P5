import XCTest
@testable import Aura

final class DisplayTransactionDetailsTests: XCTestCase {
    // Given
    var displayTransactionDetails : DisplayTransactionDetails!
    
    override func setUp()  {
        displayTransactionDetails = DisplayTransactionDetails(httpservice: MockHTTPServiceTransactionDetails())
        super.setUp()
    }
    
    override func tearDown() {
        displayTransactionDetails = nil
        super.tearDown()
    }
    
    
    func testmakeMultiTransactionDetailsURLRequest() throws {
        // Given
        let tokenoforAccount = "token"
        let url = URL(string: "http://exemple/account")!
        var expectedRequest = URLRequest(url: url)
        expectedRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        // When
        let makeMultiTransactionDetailsURLRequest = displayTransactionDetails.makeMultiTransactionDetailsURLRequest(tokenoforAccount)
        // Then
        XCTAssertEqual(makeMultiTransactionDetailsURLRequest.httpMethod, "GET")
        XCTAssertNotNil(makeMultiTransactionDetailsURLRequest.allHTTPHeaderFields?["token"], tokenoforAccount)
        XCTAssertNotNil(makeMultiTransactionDetailsURLRequest.url)
        XCTAssertNil(makeMultiTransactionDetailsURLRequest.httpBody)
        XCTAssertEqual(makeMultiTransactionDetailsURLRequest.value(forHTTPHeaderField: "content-type"), expectedRequest.value(forHTTPHeaderField: "content-type"))
    }
//
    func testfetchAccountDetails() async throws {
        let jsonData = """
                {
                    "currentBalance": 100.0,
                    "transactions": [
                        {
                            "value": 50.0,
                            "label": "Transaction 1"
                        },
                        {
                            "value": 75.0,
                            "label": "Transaction 2"
                        }
                    ]
                }
                """.data(using: .utf8)!
        let urlresponse = HTTPURLResponse(url: URL(string: "https//exemple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let data : (Data,HTTPURLResponse) = (jsonData,urlresponse)
        (displayTransactionDetails.httpservice as! MockHTTPServiceTransactionDetails).data = data
        

        do{
            let recupdata = try await displayTransactionDetails.fetchAccountDetails("token")
           
            XCTAssertNoThrow(recupdata)
            XCTAssertEqual(recupdata.currentBalance, 100.0)
            XCTAssertEqual(recupdata.transactions.count, 2)
            XCTAssertEqual(recupdata.transactions[0].value, 50.0)
            XCTAssertEqual(recupdata.transactions[1].value, 75.0)
            XCTAssertEqual(recupdata.transactions[0].label, "Transaction 1")
            XCTAssertEqual(recupdata.transactions[1].label, "Transaction 2")
        }catch let error as DisplayTransactionDetails.TransactionDetailsRetrievalFailure{
            XCTAssertEqual(error, .fetchAccountDetailsDecodingFailure)
        }catch{
            XCTFail("Unexpected error: \(error)")
            XCTAssertNil(data)
        }
    }
    
    
    func testfetchAccountDetail() async throws {
        let jsondecode = "{\"test\":\"exempl\"}".data(using: .utf8)!
        let urlresponse = HTTPURLResponse(url: URL(string: "https//exemple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data : (Data,HTTPURLResponse) = (jsondecode,urlresponse)
        (displayTransactionDetails.httpservice as! MockHTTPServiceTransactionDetails).data = data
        
        do{
            let decodeAccount = try await displayTransactionDetails.fetchAccountDetails("token")
            XCTFail("Expected decoding error")
            XCTAssertEqual(decodeAccount.currentBalance, 20,"bien")
        }catch let error as DisplayTransactionDetails.TransactionDetailsRetrievalFailure{
            XCTAssertEqual(error, .fetchAccountDetailsDecodingFailure)
        }catch{
            XCTFail("Unexpected error: \(error)")
        }
         
    }
   
    
    class MockHTTPServiceTransactionDetails : HTTPService {
        
        var data : (Data,URLResponse)?
        
         func request(_ request : URLRequest) async throws -> (Data,URLResponse){
            
             guard let result = data else {
                 throw NSError(domain: "", code: 0,userInfo: nil)
             }
             return result
                  
        }
    }
}
