//
//  CardsGalery.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 11.10.2021.
//

import SwiftUI

struct CardsGalery: View {
    var cards: [ExamCard]

    var body: some View {
        CardRow(locCards: cards)
            .onAppear {
                Analytics.shared.fire(.screenShown(name: "Билеты"))
            }
    }
}

struct CardsGalery_Previews: PreviewProvider {
    static var previews: some View {
        CardsGalery(cards: cards)
            .environmentObject(Coin())
    }
}
