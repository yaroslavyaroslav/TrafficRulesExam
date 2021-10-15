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
        ForEach(answers) { answer in
            Text(answer.text)
        }
    }
}

struct Answers_Previews: PreviewProvider {
    static var previews: some View {
        Answers(answers: cards[0].questions[0].answers)
    }
}
