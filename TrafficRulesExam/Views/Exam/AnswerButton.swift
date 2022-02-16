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

    var isSelected = false

    init(isSelected: Bool = false, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.isSelected = isSelected
        self.label = label
        self.action = action
    }

    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(AnswerButtonStyle(isSelected: isSelected))
    }
}

struct AnswerButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
//            .opacity(isSelected ? 0.7 : (configuration.isPressed ? 0.7 : 1))
//            .scaleEffect(isSelected ? 0.8 : (configuration.isPressed ? 0.8 : 1))
            .animation(.easeInOut(duration: 0.2))
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(isSelected: false) {
            print("this")
        } label: {
            AnswerHStack(answer: cards[0].questions[1].answers[0])
        }
    }
}
