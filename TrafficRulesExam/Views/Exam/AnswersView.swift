//
//  AnswersView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct AnswersView: View {
    var answers: [Answer]

    @Binding
    var selectedAnswer: AnswerID

    let correctAnswer: AnswerID?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(answers) { answer in
                AnswerButton(isSelected: selectedAnswer == answer.id) {
                    selectedAnswer = answer.id
                    UIImpactFeedbackGenerator(style: .soft)
                        .impactOccurred()
                } label: {
                    AnswerHStack(answer: answer)
                        .padding(10)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, idealHeight: 200, alignment: .leading)
                        .background(answer.id == correctAnswer?.id ? Color.green : Color.yellow)
                        .cornerRadius(4)
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
    }
}

struct Answers_Previews: PreviewProvider {
    @State
    static var selAnswer = AnswerID.a

    static var previews: some View {
        AnswersView(answers: cards[1].questions[16].answers, selectedAnswer: $selAnswer, correctAnswer: .b)
    }
}
