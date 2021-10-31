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
                AnswerButton(didTap: (answer.id == self.answer)) {
                    self.answer = answer.id
                    print("This is answer \(answer.id)")
                } label: {
                    AnswerHStack(answer: answer)
                }
            }
        }
    }
}


struct AnswerButton<Content: View>: View {
        
    var action: () -> Void
    
    var label: () -> Content
    
    var didTap = false
    
    init(didTap: Bool, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.didTap = didTap
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(AnswerButtonStyle(didTap: didTap))
    }
}

struct AnswerButtonStyle: ButtonStyle {
    
    let didTap: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(Color.white)
            .opacity(didTap ? 0.7 : (configuration.isPressed ? 0.7 : 1))
            .scaleEffect(didTap ? 0.8 : (configuration.isPressed ? 0.8 : 1))
            .animation(.easeInOut(duration: 0.2))
    }
}

struct Answers_Previews: PreviewProvider {
    static var previews: some View {
        Answers(answers: cards[0].questions[1].answers)
    }
}
