//
//  QuestionDetail.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct QuestionDetail: View {
    
    var question: Question
    
    var body: some View {
        VStack {
            Text(question.picture?.absoluteString ?? "this is link")
            Text("\(question.text) \((question.id + 1).description)")
            Answers(answers: question.answers)
            Text("Hello, world!")
                .padding()
        }
    }
}

struct QuestionDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuestionDetail(question: cards[0].questions[0])
    }
}
