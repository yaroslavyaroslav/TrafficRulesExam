//
//  CardView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct CardView: View {
    var card: ExamCard

    @Binding var result: CardResult

    @EnvironmentObject var coins: Coin

    var body: some View {
        VStack(alignment: .leading) {
            QuestionCardView(questions: card.questions, questionDetails: card.questions[0], resultsHistory: $result.resultHistory)
        }
        .navigationBarItems(leading: EmptyView(), trailing: Text("\(coins.amount)"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Билет \(card.id)")
    }
}

struct Card_Previews: PreviewProvider {
    @State
    static var cardResult: CardResult = {
        let result = Result(mistakes: [], examDate: Date())
        let results = Results(items: [result])
        return CardResult(id: 1, resultHistory: results)
    }()

    static var previews: some View {
        CardView(card: cards[0], result: $cardResult)
    }
}
