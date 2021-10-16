//
//  Answers.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftUI

struct Answers: View {
    
    var answers: [Answer]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(answers) { answer in
                if #available(iOS 15.0, *) {
                    HStack(alignment: .top, spacing: 10) {
                        Text(answer.id.stringValue)
                        Text(answer.text)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .background {
                        Color(UIColor.green)
                    }
                } else {
                    fatalError()
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
