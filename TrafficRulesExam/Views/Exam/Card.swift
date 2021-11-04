//
//  Card.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct Card: View {

    var card: ExamCard
    
    @Binding
    var result: CardResult
    
    @Binding
    var isShowingExamCard: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            QuestionCard(questions: card.questions, questionDetails: card.questions[0], historyRes: $result.resultHistory, isShowingExamCard: $isShowingExamCard)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct Card_Previews: PreviewProvider {
//    static var previews: some View {
////        Card(card: cards[0], result: CardResult(1, Results([])))
//    }
//}
