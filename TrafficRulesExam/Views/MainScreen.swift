//
//  MainScreen.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import SwiftUI

struct MainScreen: View {
    
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 8)
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
    }
    
    private enum Tabs {
        case cardGalery, totalStatsNavigation
    }
    
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
                    .padding()
                    .gesture(swipeGesture)
            case .totalStatsNavigation: TotalStatsNavigation(cards: cards)
                    .padding()
                    .gesture(swipeGesture)
            }
        }
        .gesture(swipeGesture)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
