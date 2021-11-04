//
//  QuestionContent.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct QuestionContent: View {
    
    var question: Question
    
    @ObservedObject
    var selectedAnswer: SelectedAnswer
    
    var body: some View {
        VStack {
            Text("Вопрос \(question.id.description).")
                .padding(10)
                .background(Color.green)
                .cornerRadius(8)
            Spacer()
            
            
            if let picture = question.picture {
                Text(picture.absoluteString).padding(10)
                    .padding(10)
                    .background(Color.green)
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
            
            Answers(answers: question.answers, selectedAnswer: selectedAnswer)
            Spacer()
        }
    }
}

struct QuestionContent_Previews: PreviewProvider {
    static var previews: some View {
        QuestionContent(question: cards[0].questions[0], selectedAnswer: SelectedAnswer())
    }
}
