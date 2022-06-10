//
//  CoinsAmountView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 23.02.2022.
//

import SwiftUI

struct CoinAmountView: View {
    var coinsAmount: UInt

    @State var isModalViewPresented = false

    var body: some View {
        Button {
            self.isModalViewPresented = true
            Analytics.shared.fire(.screenShown(name: "Покупки"))
        } label: {
            HStack {
                Image("Coin")
                    .padding(.trailing, 0)
                Text("\(coinsAmount)")
                    .padding(.leading, 0)
                Text("+")
            }
            .font(UIFont.sfSubheadline.asFont)
            .foregroundColor(.DS.bgLightPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(minWidth: 90, maxWidth: 150, maxHeight: 36, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .foregroundColor(.DS.tintsPurpleLight)
            )
        }
        .sheet(isPresented: $isModalViewPresented) {
            if #available(iOS 15.0, *) {
                StoreView(isPresented: $isModalViewPresented)
            } else {
                Purchase(isPresented: $isModalViewPresented)
                // Fallback on earlier versions
            }
        }
    }
}
