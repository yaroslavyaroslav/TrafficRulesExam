//
//  Answers.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct Answers: View {
    
    var answers: [Answer]
    
    @Binding
    var selectedAnswer: AnswerID
    
    let correctAnswer: AnswerID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(answers, id: \.id) { answer in
                AnswerButton(isSelected: selectedAnswer == answer.id) {
                    selectedAnswer = answer.id
                    
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                } label: {
                    AnswerHStack(answer: answer)
                        .background(answer.id == correctAnswer?.id ? Color.green : Color.yellow)
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
        .cornerRadius(8)
    }
}

struct Answers_Previews: PreviewProvider {
    
    @State
    static var selAnswer = AnswerID.a
    
    static var previews: some View {
        Answers(answers: cards[0].questions[6].answers, selectedAnswer: $selAnswer, correctAnswer: nil)
    }
}
