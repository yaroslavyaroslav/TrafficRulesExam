//
//  TicketButtonStyle.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 23.02.2022.
//

import SwiftUI

struct TicketButtonStyle: ButtonStyle {

    enum State {
        case notAnswered
        case current
        case answered
    }

    let state: State

    init(state: State = .notAnswered) {
        self.state = state
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        var bgColor: Color
        var strokeColor: Color
        var shadowType: ShadowType
        switch state {
        case .notAnswered:
            bgColor = .DS.bgLightPrimary
            strokeColor = .DS.bgLightSecondary
            shadowType = .down
        case .current:
            bgColor = .DS.tintsPurpleDark
            strokeColor = .DS.tintsPurpleLight
            shadowType = .down
        case .answered:
            strokeColor = .DS.bgLightSecondary
            bgColor = .DS.bgLightSecondary
            shadowType = .inner
        }

        bgColor = configuration.isPressed ? bgColor.opacity(0.7) : bgColor.opacity(1)

        // order is important
        return configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(width: 46, height: 44, alignment: .center)
            .background(bgColor)
            .roundBorder(strokeColor, width: 1, cornerRadius: 12)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .defaultShadow(shadowType)
            .disabled(state != .notAnswered)
    }
}
