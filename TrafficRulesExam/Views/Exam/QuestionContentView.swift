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
            VStack {
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
            }
            .padding(.top, 10)
            .background(Color.clear)

            ZStack(alignment: .bottom) {
                AnswersView(answers: question.answers, correctAnswer: correctAnswer, selectedAnswer: $selectedAnswer)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                Button {
                    print("ScrollToDown")
                } label: {
                    ZStack(alignment: .center) {
                        Circle()
                        Image(systemName: "arrow.down")
                            .foregroundColor(.black)
                    }
                    .frame(width: 24, height: 24, alignment: .top)
                    .padding(12)
                }
            }
            .background(Color.white)


//            Spacer()
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
