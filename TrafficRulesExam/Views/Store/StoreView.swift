//
//  StoreView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//

import StoreKit
import SwiftUI

struct StoreView: View {
    @EnvironmentObject var store: Store

    @Binding var isPresented: Bool
    
    @Environment(\.colorScheme) var colorScheme

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
                        .foregroundColor(colorScheme == .light ? .DS.labelLightSecondary : .DS.greysGrey2Light)
                        .opacity(0.7)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 18)

            VStack(spacing: 8) {
                ForEach(store.availableCoinPacks, id: \.id) { coinPack in
                    ProductCellView(product: coinPack, isPresented: $isPresented)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background()
    }
}
