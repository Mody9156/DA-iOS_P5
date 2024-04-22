//
//  AllTransactionsView.swift
//  Aura
//
//  Created by KEITA on 17/04/2024.
//

import SwiftUI

struct AllTransactionsView: View {
   let recentTransactions : [Transactions]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10){
               
                Text("Transactions").font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(hex: "#94A684"))

                ForEach(recentTransactions, id:\.description ) { transaction in
                    TransactionsForAura(transaction: transaction)
                    }
            }
        }
    }
}



struct TransactionsForAura: View {
    let transaction : Transactions
    var body: some View {
        HStack {
            Image(systemName: transaction.amount.contains("+") ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                .foregroundColor(transaction.amount.contains("+") ? .green : .red)
            Text(transaction.description)
            Spacer()
            Text(transaction.amount)
                .fontWeight(.bold)
                .foregroundColor(transaction.amount.contains("+") ? .green : .red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding([.horizontal])
    }
}
