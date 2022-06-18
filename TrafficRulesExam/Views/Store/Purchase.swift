//
//  Purchase.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.01.2022.
//

import SwiftUI
import os.log

struct Purchase: View {

    lazy var iAPHelper: IAPHelper = .init()

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
                        os_log("purchase Unilimted")
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
                        os_log("purchase second")
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
                        os_log("purchase third")
                    }
                }
                .border(Color.blue)
            }
            Spacer()
        }
    }
}

struct Purchase_Previews: PreviewProvider {
    @State
    static var isPresentedPreview = true

    static var previews: some View {
        Purchase(isPresented: $isPresentedPreview)
    }
}
