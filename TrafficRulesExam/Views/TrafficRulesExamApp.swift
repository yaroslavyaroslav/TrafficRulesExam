//
//  TrafficRulesExamApp.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 11.10.2021.
//

import SwiftUI

@main
struct TrafficRulesExamApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CardsGalery(cards: cards)
                    .tabItem {
                        Text("Решать")
                    }
                TotalStatsNavigation(cards: cards)
                    .tabItem {
                        Text("Статистика")
                    }
            }
        }
    }
}
