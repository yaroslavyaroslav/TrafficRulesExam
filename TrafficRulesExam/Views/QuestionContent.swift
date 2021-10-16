//
//  QuestionContent.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct QuestionContent: View {
    
    var question: Question
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("Вопрос \(question.id.description).")
            }
            .padding(10)
            Spacer()
            
            if let picture = question.picture {
                Text(picture.absoluteString).padding(10)
                Spacer()
            }
            
            if #available(iOS 15.0, *) {
                HStack(alignment: .top, spacing: 10) {
                    Text(question.text)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background {
                    Color(UIColor.green)
                }
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
