//
//  TicketView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct TicketView: View {
    var card: ExamCard

    @Binding var result: CardResult

    @EnvironmentObject var coins: Coin

    @EnvironmentObject var currentTicket: CurrentValues

    var body: some View {
        VStack(alignment: .leading) {
            QuestionCardView(questions: card.questions, questionDetails: card.questions[0], resultsHistory: $result.resultHistory)
                .onAppear {
                    currentTicket.ticket = UInt(card.id)
                    Analytics.fire(.ticketStarted(ticketId: UInt(card.id)))
                }
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
        TicketView(card: cards[0], result: $cardResult)
            .environmentObject(Coin())
    }
}
