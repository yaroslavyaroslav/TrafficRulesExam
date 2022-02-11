//
//  Purchase.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.01.2022.
//

import SwiftUI

@available(swift, obsoleted: 15.0, message: "Please use iOS 15 API.")
struct Purchase: View {

    lazy var iAPHelper: IAPHelper = .init(productIds: [
        "ru.neatness.TrafficRulesExam.10",
        "ru.neatness.TrafficRulesExam.20",
        "ru.neatness.TrafficRulesExam.40",
        "ru.neatness.TrafficRulesExam.OneMonthCoins",
        "ru.neatness.TrafficRulesExam.ThreeMonthsCoins",
        "ru.neatness.TrafficRulesExam.SixMonthsCoins"
    ])

    @Binding
    var isPresented: Bool

    @EnvironmentObject
    var coins: Coin

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("X") { isPresented = false }
                .padding()
            }

            Spacer()

            VStack(spacing: 10) {
                VStack {
                    Text("Безлимитный тариф")
                    Text("This is some more text with unlimited tariffs about this one")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Button("Buy") {
                        
                        coins.amount += 10
                        isPresented = false
                        print("purchase Unilimted")
                    }
                }
                .border(Color.blue)

                VStack {
                    Text("Тариф второй")
                    Text("This is some еще один текст о чем жить more text with unlimited tariffs about this one")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Button("Buy") {
                        coins.amount += 15
                        isPresented = false
                        print("purchase second")
                    }
                }
                .border(Color.blue)

                VStack {
                    Text("Третий тариф")
                    Text("Текст и текст и еще один текст, много всякого текста")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Button("Buy") {
                        coins.amount += 20
                        isPresented = false
                        print("purchase third")
                    }
                }
                .border(Color.blue)
            }
            Spacer()
        }
    }
}

@available(swift, obsoleted: 15.0, message: "Please use iOS 15 API.")
struct Purchase_Previews: PreviewProvider {
    @State
    static var isPresentedPreview = true

    static var previews: some View {
        Purchase(isPresented: $isPresentedPreview)
    }
}
