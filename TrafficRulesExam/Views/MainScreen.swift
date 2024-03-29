//
//  MainScreen.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import SwiftKeychainWrapper
import SwiftUI

struct MainScreen: View {
    @GestureState
    var isDetectingSwipe = false

    @EnvironmentObject
    var coins: Coin

    private enum Tabs {
        case cardGalery, totalStatsNavigation
    }

    @State
    private var selectedIndex: Tabs = .cardGalery

    var body: some View {
        VStack {
            // FIXME: Переписать из двух экранов выезжающих сбоку на
            // один экран, а плашка решать/статистика включает в том вью только блок статистики (и меняет линки с билета на историю).
            switch selectedIndex {
            // Анимация перезаписывается при отработке свитча.
            // Поэтому вьюха въезжает слева и уезжает вправо.
            case .cardGalery:
                CardsGalery(cards: cards)
                    .transition(.move(edge: .leading))
            case .totalStatsNavigation:
                TotalStatsNavigationView(cards: cards)
                    .transition(.move(edge: .trailing))
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background()
        .navigationBarItems(leading: modeToggleButton, trailing: CoinAmountView(coinsAmount: coins.amount))
    }


    var modeToggleButton: some View {
        Button {
            if case .cardGalery = selectedIndex {
                selectedIndex = .totalStatsNavigation
            } else if case .totalStatsNavigation = selectedIndex {
                selectedIndex = .cardGalery
            }
        } label: {
            switch selectedIndex {
            case .cardGalery: Text("Статистика")
            case .totalStatsNavigation: Text("Билеты")
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainScreen()
                .environmentObject(Coin())
                .background(Color.DS.bgLightPrimary)
        }
    }
}
