//
//  Answers.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct AnswerHStack: View {
    var answer: Answer
    
    var body: some View {
        if #available(iOS 15.0, *) {
            HStack(alignment: .top, spacing: 10) {
                Text(answer.id.stringValue)
                Text(answer.text)
                    .multilineTextAlignment(.leading)
            }
            .padding(10)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, minHeight: 50, idealHeight: 100, alignment: .leading)
            .background {
                Color(.yellow)
            }
            .cornerRadius(8)
        } else {
            fatalError()
        }
    }
}

struct Answers: View {
    
    var answers: [Answer]
    
    @State
    var answer: AnswerID?
    
    @State
    private var didTap = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(answers, id: \.id) { answer in
                AnswerButton(tapped: self.answer == answer.id) {
                    self.answer = answer.id
                    print("This is answer \(answer.id)")
                } label: {
                    AnswerHStack(answer: answer)
                }
            }
        }
    }
}

struct Answers_Previews: PreviewProvider {
    static var previews: some View {
        Answers(answers: cards[0].questions[1].answers)
    }
}
