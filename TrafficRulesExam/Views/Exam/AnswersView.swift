//
//  AnswersView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct AnswersView: View {
    var answers: [Answer]

    let correctAnswer: AnswerID?

    @Binding var selectedAnswer: AnswerID

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(answers) { answer in
                        AnswerButton(isSelected: selectedAnswer == answer.id) {
                            selectedAnswer = answer.id
                            UIImpactFeedbackGenerator(style: .soft)
                                .impactOccurred()
                        } label: {
                            AnswerHStack(answer: answer)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .roundBorder(selectedAnswer.id == answer.id ? Color.purple : Color.black, cornerRadius: 8)
                        }
                    }
                }
            }
        }
    }
}


extension View {
    public func roundBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

struct AnswerHStack: View {
    var answer: Answer

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .foregroundColor(.gray)
                Text(answer.id.stringValue)
                    .font(.system(size: 16))
            }
            .frame(width: 24, height: 24, alignment: .center)

            Text(answer.text)
                .multilineTextAlignment(.leading)
                .font(.system(size: 16))
        }
        .padding(12)
    }
}

struct Answers_Previews: PreviewProvider {
    @State
    static var selAnswer = AnswerID.a

    static var previews: some View {
        AnswersView(answers: cards[1].questions[4].answers, correctAnswer: .b, selectedAnswer: $selAnswer)
    }
}
