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
        return AuthenticationViewModel { [weak self] in // éviter les références fortes et donc les fuites de mémoire
            self?.isLogged = true
        }
    }
    
    var accountDetailViewModel: AccountDetailViewModel {
        
        let AccountModel =  AccountModel(session: URLSession.shared, authenticationRequest: AuthenticationRequest())
        
        return AccountDetailViewModel(accountModel: AccountModel)
    }
}
