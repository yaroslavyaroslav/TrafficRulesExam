//
//  QuestionContentView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct QuestionContentView: View {
    var question: Question

    @Binding var selectedAnswer: AnswerID

    let correctAnswer: AnswerID?

    var body: some View {
        VStack {
            if let image = question.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                Spacer()
            }

            Text(question.text)
                .multilineTextAlignment(.leading)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green)
                .cornerRadius(8)
            Spacer()

            AnswersView(answers: question.answers, correctAnswer: correctAnswer, selectedAnswer: $selectedAnswer)

            Spacer()
        }
        .padding(8)
    }
}

struct QuestionContent_Previews: PreviewProvider {
    @State
    static var answer = AnswerID.a

    static var previews: some View {
        QuestionContentView(question: cards[1].questions[2], selectedAnswer: $answer, correctAnswer: .c)
    }
}