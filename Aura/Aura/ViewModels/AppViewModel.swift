//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//
import Foundation
import SwiftUI
class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    var keychain = KeychainSwift()
    var storedKey: String
    
    init() {
      
        if let tokenvalue = keychain.get("token") {
            storedKey = tokenvalue
        } else {
            storedKey = ""
        }
        isLogged = false
    }
    
    var authenticationViewModel: AuthenticationViewModel {
        let authentification = AuthenticationRequest(session: URLSession.shared, getToken: TokenForAura(token: storedKey))
        return AuthenticationViewModel({ [weak self] in
            self?.isLogged = true
            
        }, authentification: authentification)
    }
    
    var accountDetailViewModel: AccountDetailViewModel {
        let accountModel = AccountModel(token: TokenForAura(token: storedKey))
        return AccountDetailViewModel(accountModel: accountModel)
    }
}
