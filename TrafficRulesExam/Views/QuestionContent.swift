//
//  QuestionContent.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct QuestionContent: View {
    
    var question: Question
    
    var body: some View {
        VStack {
            Text(question.picture?.absoluteString ?? "this is link")
                .padding()
            Text("\(question.text) \((question.id + 1).description)")
                .padding()
            Answers(answers: question.answers)
        }
    }
}

struct QuestionContent_Previews: PreviewProvider {
    static var previews: some View {
        QuestionContent(question: cards[0].questions[0])
    }
}
