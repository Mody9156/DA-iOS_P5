import Foundation

class BasicHTTPClient: HTTPService {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    enum Failure: Swift.Error {
        case requestInvalid
    }
    
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Failure.requestInvalid
        }
        
        return (data, httpResponse)
    }
}
