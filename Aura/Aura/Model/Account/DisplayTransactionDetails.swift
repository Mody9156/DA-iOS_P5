import Foundation

class DisplayTransactionDetails {
    let httpservice: HTTPService

    init(httpservice: HTTPService = BasicHTTPClient()) {
        self.httpservice = httpservice
    }

    enum TransactionDetailsRetrievalFailure: Error {
        case fetchAccountDetailsDecodingFailure,fetchAccountDetailsResponseFailure
    }

    func makeMultiTransactionDetailsURLRequest(_ token: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/account")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["token": token]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        print("token : n °\(token)")

        return request
    }

    func fetchAccountDetails(_ token: String) async throws -> TransactionDisplayModel {
        let (data,_) = try await httpservice.request(makeMultiTransactionDetailsURLRequest(token))
        
      
        guard let json = try? JSONDecoder().decode(TransactionDisplayModel.self, from: data) else {
            throw TransactionDetailsRetrievalFailure.fetchAccountDetailsDecodingFailure
        }
        return json
    }
}
