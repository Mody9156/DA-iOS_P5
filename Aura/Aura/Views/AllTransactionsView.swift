//
//  AllTransactionsView.swift
//  Aura
//
//  Created by KEITA on 17/04/2024.
//

import SwiftUI

struct AllTransactionsView: View {
    @State  var array : [Transactions]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10){
               
                Text("Transactions").font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(hex: "#94A684"))

                ForEach(array, id: \.description) { items in
                        HStack {
                            Image(systemName: items.amount.contains("+") ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                                .foregroundColor(items.amount.contains("+") ? .green : .red)
                            Text(items.description)
                            Spacer()
                            Text(items.amount)
                                .fontWeight(.bold)
                                .foregroundColor(items.amount.contains("+") ? .green : .red)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding([.horizontal])
                    }
                
            }
        }
    }
}


