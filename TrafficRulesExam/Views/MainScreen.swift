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
            // FIXME: Переписать из двух экранов выезжающих сбоку на
            // один экран, а плашка решать/статистика включает в том вью только блок статистики (и меняет линки с билета на историю).
            switch selectedIndex {
            // Анимация перезаписывается при отработке свитча.
            // Поэтому вьюха въезжает слева и уезжает вправо.
            case .cardGalery:
                CardsGalery(cards: cards)
                    .padding()
                    .highPriorityGesture(swipeGesture)
                    .transition(.move(edge: .leading))
            case .totalStatsNavigation:
                TotalStatsNavigationView(cards: cards)
                    .padding()
                    .highPriorityGesture(swipeGesture)
                    .transition(.move(edge: .trailing))
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.DesignSystem.defaultLightBackground.ignoresSafeArea())
        .navigationBarItems(leading: button, trailing: CoinAmountView(coinsAmount: coins.amount))
    }


    var button: some View {
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

struct CoinAmountView: View {
    var coinsAmount: UInt

    @State var isModalViewPresented = false

    var body: some View {
        Button {
            self.isModalViewPresented = true
            Analytics.fire(.screenShown(name: "Покупки"))
        } label: {
            HStack {
                Image("Coin")
                    .padding(.trailing, 0)
                Text("\(coinsAmount)")
                    .padding(.leading, 0)
                Text("+")
            }
            .font(UIFont.sfSubheadline.asFont)
            .foregroundColor(.DesignSystem.bgLightPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(minWidth: 90, maxWidth: 150, maxHeight: 36, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .foregroundColor(.DesignSystem.tintsPurpleLight)
            )
        }
        .sheet(isPresented: $isModalViewPresented) {
            if #available(iOS 15.0, *) {
                StoreView(isPresented: $isModalViewPresented)
            } else {
                Purchase(isPresented: $isModalViewPresented)
                // Fallback on earlier versions
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainScreen()
                .environmentObject(Coin())
                .background(Color.DesignSystem.defaultLightBackground)
        }
    }
}
