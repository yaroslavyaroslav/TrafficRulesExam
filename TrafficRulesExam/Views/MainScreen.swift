//
//  MainScreen.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import SwiftUI

struct MainScreen: View {
    
    private enum Tabs {
        case cardGalery, totalStatsNavigation
    }
    
    let cardGalery = CardsGalery(cards: cards)
    let totalStatsNavigation = TotalStatsNavigation(cards: cards)
    
    @State
    private var selectedIndex: Tabs = .cardGalery
    
    var body: some View {
        VStack {
            Picker("Tab", selection: $selectedIndex.animation(.default)) {
                Text("Решать").tag(Tabs.cardGalery)
                Text("Статистика").tag(Tabs.totalStatsNavigation)
            }
            .pickerStyle(SegmentedPickerStyle())

            switch selectedIndex {
            case .cardGalery: CardsGalery(cards: cards)
            case .totalStatsNavigation: TotalStatsNavigation(cards: cards)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 8, coordinateSpace: .global)
                .onChanged {
                    if $0.translation.width > 100 {
                        withAnimation {
                            selectedIndex = .cardGalery
                        }
                    } else if $0.translation.width < -100 {
                        withAnimation {
                            selectedIndex = .totalStatsNavigation
                        }
                    }
                }
        )
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
