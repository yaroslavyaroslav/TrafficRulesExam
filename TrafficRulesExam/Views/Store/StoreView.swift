//
//  StoreView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//

import StoreKit
import SwiftUI

@available(iOS 15.0, *)
struct StoreView: View {
    @EnvironmentObject var store: Store

    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 22))
            }
            .padding()
            List {
                Section(header: Text("Купить монеты")) {
                    ForEach(store.availableCoinPacks, id: \.id) { coinPack in
                        ProductCellView(product: coinPack, isPresented: $isPresented)
                    }
                }
                .listStyle(GroupedListStyle())

                SubscriptionsView(isPresented: $isPresented)
            }
        }
        .background(Color.DS.bgLightPrimary)
    }
}
