//
//  TrafficRulesExamApp.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 11.10.2021.
//

import SwiftKeychainWrapper
import SwiftUI

@main
struct TrafficRulesExamApp: App {
    var coin: Coin = Coin()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainScreen()
//                    .environmentObject(cards)
//                    .environmentObject(results)
            }
            .environmentObject(coin)
            .environmentObject(CoinsTimer(coin))
        }
    }
}
