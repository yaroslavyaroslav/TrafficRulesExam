//
//  AnswerButton.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 31.10.2021.
//

import SwiftUI

struct AnswerButton<Content: View>: View {
        
    var action: () -> Void
    
    var label: () -> Content
    
    var tapped = false
    
    init(tapped: Bool = false, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.tapped = tapped
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(AnswerButtonStyle(tapped: tapped))
    }
}

struct AnswerButtonStyle: ButtonStyle {
    
    let tapped: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .foregroundColor(Color.white)
            .opacity(tapped ? 0.7 : (configuration.isPressed ? 0.7 : 1))
            .scaleEffect(tapped ? 0.8 : (configuration.isPressed ? 0.8 : 1))
            .animation(.easeInOut(duration: 0.2))
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(tapped: false) {
            print("this")
        } label: {
            AnswerHStack(answer: cards[0].questions[1].answers[0])
        }
    }
}
