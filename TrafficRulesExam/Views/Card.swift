//
//  Card.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct Card: View {
    
    var card: ExamCard
    
    var body: some View {
        VStack{
            QuestionPicker(questions: card.questions, questionDetails: card.questions[0])
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(card: cards[0])
    }
}
