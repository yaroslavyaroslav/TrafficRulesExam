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
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                if let image = question.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                }

                Text(question.text)
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .font(UIFont.sfHeadline.asFont)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.DS.bgLightSecondary)
            }
            .padding(.top, 10)
            .background(Color.DS.bgLightPrimary)
            .zIndex(1)
            .defaultShadow()

            AnswersView(answers: question.answers, correctAnswer: correctAnswer, selectedAnswer: $selectedAnswer)
                .padding(.horizontal, 16)
                .background(Color.DS.bgLightPrimary)
        }
    }
}

struct QuestionContent_Previews: PreviewProvider {
    @State
    static var answer = AnswerID.a

    static var previews: some View {
        QuestionContentView(question: cards[1].questions[2], selectedAnswer: $answer, correctAnswer: .c)
    }
}
