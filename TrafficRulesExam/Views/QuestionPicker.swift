//
//  QuestionPicker.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct QuestionPicker: View {
    
    var questions: [Question]
    
    @State
    var questionDetails: Question
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(questions) { question in
                    Button((question.id + 1).description) {
                        questionDetails = question
                    }
                    .padding()
                }
            }
        }
        QuestionDetail(question: questionDetails)
    }
}

struct QuestionPicker_Previews: PreviewProvider {
    static var previews: some View {
        QuestionPicker(questions: cards[0].questions, questionDetails: cards[0].questions[0])
    }
}
