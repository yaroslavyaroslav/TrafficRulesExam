//
//  TotalStatsNavigationView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct TotalStatsNavigationView: View {
    @State var results: CardResults = {
        var object: CardResults!
        do {
            object = try CardResults()
        } catch {
            object = CardResults(items: (1...2).map { CardResult(id: $0, resultHistory: Results(items: [])) })
        }
        return object
    }()

    var cards: [ExamCard]

    var body: some View {
        TotalStatsView(results: results)
            .navigationTitle(Text("Статистика"))
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Analytics.fire(.screenShown(name: "Статистика"))
            }
    }
}

struct Stats_Previews: PreviewProvider {
    static var previews: some View {
        TotalStatsNavigationView(cards: cards)
    }
}
