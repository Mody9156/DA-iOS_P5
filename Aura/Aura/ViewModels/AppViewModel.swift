//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//
import Foundation

class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    let keychain = KeychainSwift()
    var storedKey: String

    init() {
        isLogged = false

        if let tokenvalue = keychain.get("token") {
            storedKey = tokenvalue
            print("tu as bien le token :", tokenvalue)
        } else {
            storedKey = "token is empty"
        }

    }
    
    var authenticationViewModel: AuthenticationViewModel {
        let authentification = AuthenticationRequest(session: URLSession.shared)
        return AuthenticationViewModel({ [weak self] in
            DispatchQueue.main.async {
                self?.isLogged = true

            }
        }, authentification: authentification)
    }
    
    var accountDetailViewModel: AccountDetailViewModel {
        let accountModel = AccountModel(session: URLSession.shared, authenticationViewModel: authenticationViewModel)
        return AccountDetailViewModel(accountModel: accountModel)
    }
    
    var moneyTransferViewModel : MoneyTransferViewModel {
        
        let moneyTransferModel = MoneyTransferModel( authenticationViewModel: authenticationViewModel)
        
        return MoneyTransferViewModel(moneyTransferModel: moneyTransferModel)
    }
}
