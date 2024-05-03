import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = "test@aura.app"
    @Published var password: String = "test123"
    
     let authentification: AuthConnector
     var keychain = KeychainSwift()
     var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (), authentification: AuthConnector = AuthConnector()) {
        self.onLoginSucceed = callback
        self.authentification = authentification
    }
    
    enum AuthViewModelFailure: Error {
        case tokenInvalide
    }
    
    func connectAuthenticationViewModel() async throws -> String{
        let token = try await authentification.getToken(username: username, password: password)
        
        keychain.set(token, forKey: "token")
        
        guard let getoken = keychain.get("token") else{
          
            throw AuthViewModelFailure.tokenInvalide
        }
        print("token : \(getoken)")
        
        onLoginSucceed()
        
        return token
    }
}
