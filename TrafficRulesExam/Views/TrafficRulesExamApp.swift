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
//    private var cards = cards

//    @StateObject
//    private var results = CardResults()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainScreen()
//                    .environmentObject(cards)
//                    .environmentObject(results)
            }
            .environmentObject(Coin())
        }
    }
}
