//
//  InExamButtonStyle.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 24.02.2022.
//

import SwiftUI

struct InExamButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? .DS.tintsPurpleLight : .DS.greysGrey6Light)
    }
}
