import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = "test@aura.app"
    @Published var password: String = "test123"
    
    private let authentification: AuthConnector
    private let keychain = KeychainSwift()
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (), authentification: AuthConnector = AuthConnector()) {
        self.onLoginSucceed = callback
        self.authentification = authentification
    }
    
    enum AuthViewModelFailure: Error {
        case tokenInvalide
    }
    
    func connectAuthenticationViewModel() async throws {
        let token = try await authentification.getToken(username: username, password: password)
        
        keychain.set(token, forKey: "token")
        if let getoken = keychain.get("token") {
            print("Token enregistré dans la keychain :", getoken)
        } else {
            print(AuthViewModelFailure.tokenInvalide)
        }
        
        onLoginSucceed()
    }
}
