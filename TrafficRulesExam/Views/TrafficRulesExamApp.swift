//
//  TrafficRulesExamApp.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 11.10.2021.
//

import SwiftUI

@main
struct TrafficRulesExamApp: App {
    
//    let tabs = [CardsGalery(cards: cards), TotalStatsNavigation(cards: cards)]
    let cardGalery = CardsGalery(cards: cards)
    let totalStatsNavigation = TotalStatsNavigation(cards: cards)
    
    @State
    private var selectedIndex = 0
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    Picker("Tab", selection: $selectedIndex) {
                        Text("Решать").tag(0)
                        Text("Статистика").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if selectedIndex == 0 {
                        CardsGalery(cards: cards)
                    } else if selectedIndex == 1 {
                        TotalStatsNavigation(cards: cards).tag(1)
                    }
                }
            }
//            TabView {
//                CardsGalery(cards: cards)
//                    .tabItem {
//                        Text("Решать")
//                    }
//                TotalStatsNavigation(cards: cards)
//                    .tabItem {
//                        Text("Статистика")
//                    }
//            }
        }
    }
}
