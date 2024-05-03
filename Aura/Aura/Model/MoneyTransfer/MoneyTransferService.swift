import Foundation

class MoneyTransferService {
    let httpservice: HTTPService

    init(httpservice: HTTPService = BasicHTTPClient()) {
        self.httpservice = httpservice
    }

    enum TransferFailureReason: Error {
        case failedTransferRequest
        case httpStatusCodeError
    }

    func makeTransferURLRequest(recipient: String, amount: Double, token: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/account/transfer")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyencode = MoneyTransferModel(recipient: recipient, amount: amount)
        let data = try? JSONEncoder().encode(bodyencode)
        request.httpBody = data
        
        request.allHTTPHeaderFields = ["token": token]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        
        print("token : n °\(token)")

        return request
    }

    func fetchMoneyTransfer(recipient: String, amount: Double, token: String) async throws -> HTTPURLResponse {
        do {
            let (_, response) = try await httpservice.request(makeTransferURLRequest(recipient: recipient, amount: amount, token: token))
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw TransferFailureReason.httpStatusCodeError
            }
            print("response :\(httpResponse)")
            return httpResponse
         
        } catch {
            throw TransferFailureReason.failedTransferRequest
        }
    }
}
