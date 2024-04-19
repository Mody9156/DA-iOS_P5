//
//  AllTransactionsViewModel.swift
//  Aura
//
//  Created by KEITA on 17/04/2024.
//

import Foundation

class AllTransactionsViewModel : ObservableObject{
    @Published var array : [Transactions] = []
    let accountDetailViewModel : AccountDetailViewModel
    
    init(accountDetailViewModel: AccountDetailViewModel) {
        self.accountDetailViewModel = accountDetailViewModel
    }
    enum Failure :Error {
    case error
    }
    
    func callOtherFunction() async {
     await accountDetailViewModel.callme()
       
    }
    
    
}
