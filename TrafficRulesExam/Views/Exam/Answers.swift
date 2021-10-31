//
//  Answers.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct Answers: View {
    
    var answers: [Answer]
    
    @ObservedObject
    var selectedAnswer: SelectedAnswer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(answers, id: \.id) { answer in
                AnswerButton(tapped: selectedAnswer.answer == answer.id) {
                    selectedAnswer.answer = answer.id
                } label: {
                    AnswerHStack(answer: answer)
                }
            }
        }
    }
}

struct AnswerHStack: View {
    var answer: Answer
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(answer.id.stringValue)
            Text(answer.text)
                .multilineTextAlignment(.leading)
        }
        .padding(10)
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, minHeight: 50, idealHeight: 100, alignment: .leading)
        .background(Color.yellow)
        .cornerRadius(8)
    }
}

struct Answers_Previews: PreviewProvider {
    static var previews: some View {
        Answers(answers: cards[0].questions[1].answers, selectedAnswer: SelectedAnswer())
    }
}
