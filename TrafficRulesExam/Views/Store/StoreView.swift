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
            HStack {
                Text("Купить монеты")
                    .font(UIFont.sfTitle2Bold.asFont)
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.DS.labelLightSecondary)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 18)

            VStack(spacing: 8) {
                ForEach(store.availableCoinPacks, id: \.id) { coinPack in
                    ProductCellView(product: coinPack, isPresented: $isPresented)
                }

                HStack {
                    Text("Абонементы")
                        .font(UIFont.sfTitle2Bold.asFont)
                    Spacer()
                }
                .padding(.top, 32)
                .padding(.bottom, 8)
                SubscriptionsView(isPresented: $isPresented)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.DS.bgLightPrimary)
    }
}
