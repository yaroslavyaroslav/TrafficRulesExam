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
                                .foregroundColor(answer.id == selectedAnswer ? .DS.tintsPurpleLight : .DS.bgDarkBasePrimary)
                                .background(answer.id == correctAnswer ? Color.DS.tintsGreenLight : Color.DS.bgLightPrimary)
                                .roundBorder(answer.id == selectedAnswer ? Color.DS.tintsPurpleLight : Color.DS.greysGrey6Light, width: setBorderLine(answer), cornerRadius: 8)
                        }
                    }
                }
            }
        }
    }

    private func setTintColor(_ answer: Answer) -> Color {
        selectedAnswer.id == answer.id ? .DS.tintsPurpleLight : .DS.greysGrey6Light
    }

    private func setBorderLine(_ answer: Answer) -> CGFloat {
        selectedAnswer.id == answer.id ? 2 : 1
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
                    .foregroundColor(.DS.bgGroupedLightPrimary)
                Text(answer.id.stringValue)
                    .font(UIFont.sfCaption.asFont)
            }
            .frame(width: 24, height: 24, alignment: .center)

            Text(answer.text)
                .multilineTextAlignment(.leading)
                .font(UIFont.sfCallout.asFont)
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
