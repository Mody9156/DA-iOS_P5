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
        let authentification = AuthConnector(session: URLSession.shared)
        return AuthenticationViewModel({ [weak self] in
            DispatchQueue.main.async {
                self?.isLogged = true
            }
        }, authentification: authentification, storedKey: "")
    }
    
    var accountDetailViewModel: AccountDetailViewModel {
        let accountModel = DisplayTransactionDetails(session: URLSession.shared)
        return AccountDetailViewModel(accountModel: accountModel, storedKey: "")
    }
    
    var moneyTransferViewModel : MoneyTransferViewModel {
        let moneyTransferModel = MoneyTransferService(authenticationViewModel: authenticationViewModel)
        return MoneyTransferViewModel(moneyTransferModel: moneyTransferModel, storedKey: "")
    }
}
