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
    var coin: Coin = .init()

    var body: some Scene {
        WindowGroup {
            if #available(iOS 15, *) {
                NavigationView {
                    MainScreen()
                }
                .environmentObject(coin)
                .environmentObject(CoinsTimer(coin))
                .environmentObject(Store())
            } else {
                NavigationView {
                    MainScreen()
                }
                .environmentObject(coin)
                .environmentObject(CoinsTimer(coin))
            }
        }
    }
}
