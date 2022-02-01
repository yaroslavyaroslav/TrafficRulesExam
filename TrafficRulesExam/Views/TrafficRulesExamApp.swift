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
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            if #available(iOS 15, *) {
                NavigationView {
                    MainScreen()
                }
                .environmentObject(appDelegate.coin)
                .environmentObject(appDelegate.coinsTimer)
                .environmentObject(appDelegate.store)
            } else {
                NavigationView {
                    MainScreen()
                }
                .environmentObject(appDelegate.coin)
                .environmentObject(appDelegate.coinsTimer)
            }
        }
    }
}
