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
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 50, idealHeight: 100, alignment: .leading)
            .background {
                Color(UIColor.green)
            }
            .cornerRadius(8)
        } else {
            fatalError()
        }
    }
}

struct Answers: View {
    
    var answers: [Answer]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(answers) { answer in
                Button {
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
        Answers(answers: cards[0].questions[0].answers)
    }
}
