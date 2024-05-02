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
//    func testfetchAccountDetails() async throws {
//        // Given
//        struct TransactionDisplayModel: Decodable {
//            var currentBalance: Double = 22.33
//            let transactions: [Transaction]
//        }
//
//        // MARK: - Transaction
//        struct Transaction: Decodable {
//            var value: Double = 22.44
//            var label: String = "Apple"
//        }
//
//        enum TransactionDetailsRetrievalFailure: Error {
//            case FetchAccountDetailsDecodingFailure
//        }
//
//        let tokenoforAccount = "token"
//
//        let makeMultiTransactionDetailsURLRequest = displayTransactionDetails.makeMultiTransactionDetailsURLRequest(tokenoforAccount)
//        // When
//
//        func getFetchAccountDetails() async throws -> TransactionDisplayModel {
//            let (data, _) = try await URLSession(configuration: .ephemeral).data(for: makeMultiTransactionDetailsURLRequest)
//
//            guard let jsonDecode = try? JSONDecoder().decode(TransactionDisplayModel.self, from: data) else {
//                throw TransactionDetailsRetrievalFailure.FetchAccountDetailsDecodingFailure
//            }
//            XCTAssertNotNil(jsonDecode)
//            do {
//                let jsondecode = try await displayTransactionDetails.fetchAccountDetails(tokenoforAccount)
//
//                XCTAssertEqual(jsondecode.currentBalance, 23.33)
//                XCTAssertEqual(jsondecode.transactions.count, 1)
//                XCTAssertEqual(jsondecode.transactions[0].value, 22.44)
//                XCTAssertEqual(jsondecode.transactions[0].label, "Apple")
//
//            } catch {
//                XCTFail("Une erreur s'est produite lors de la récupération des détails du compte : \(error)")
//            }
//
//            return jsonDecode
//        }
//    }
    
    
    func testfetchAccountDetails() async throws {
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
        
        var data : (Data,URLResponse)? = nil
        
         func request(_ request : URLRequest) async throws -> (Data,URLResponse){
            
             guard let result = data else {
                 throw NSError(domain: "", code: 0,userInfo: nil)
             }
             return result
                  
        }
    }
}
