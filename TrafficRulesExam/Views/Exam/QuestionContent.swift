//
//  QuestionContent.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct QuestionContent: View {
    
    var question: Question
    
    var answer: AnswerID?
    
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                
                VStack(alignment: .center) {
                    Text("Вопрос \(question.id.description).")
                }
                .padding(10)
                .background {
                    Color(UIColor.green)
                }
                .cornerRadius(8)
                
                Spacer()
                
                
                if let picture = question.picture {
                    Text(picture.absoluteString).padding(10)
                        .padding(10)
                        .background {
                            Color(UIColor.green)
                        }
                        .cornerRadius(8)
                    Spacer()
                }
                
                
                HStack(alignment: .top, spacing: 10) {
                    Text(question.text)
                        .multilineTextAlignment(.leading)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    Color(UIColor.green)
                }
                .cornerRadius(8)
            } else {
                fatalError()
            }
            
            Spacer()
            Answers(answers: question.answers)
            Spacer()
        }
    }
}

struct QuestionContent_Previews: PreviewProvider {
    static var previews: some View {
        QuestionContent(question: cards[0].questions[0])
    }
}
