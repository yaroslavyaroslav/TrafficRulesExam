//
//  AppDelegate.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 31.01.2022.
//

import UIKit
import YandexMobileMetrica

class AppDelegate: UIResponder, UIApplicationDelegate {
    var coin = Coin()

    lazy var coinsTimer: CoinsTimer = { CoinsTimer(coin) }()

    @available(iOS 15.0, *)
    lazy var store: Store = { Store() }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }

}
