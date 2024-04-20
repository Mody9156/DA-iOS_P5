//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//
import Foundation

class AppViewModel: ObservableObject {
    @Published var isLogged: Bool

    init() {
        isLogged = false

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
