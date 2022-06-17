//
//  AppDelegate.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 31.01.2022.
//

import SwiftKeychainWrapper
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var coin: Coin = {
        /// If there's no such record in UserDefaults — app is running in the first time.
        if !UserDefaults.standard.bool(forKey: UDKeys.didRan.rawValue) {
            DispatchQueue.global().async(flags: [.barrier]) {
                UserDefaults.standard.set(true, forKey: UDKeys.didRan.rawValue)
                /// First time running app Coins amount
                KeychainWrapper.standard[.coinsAmount] = 20
                KeychainWrapper.standard[.ticketUsed] = Date().timeIntervalSinceReferenceDate
            }
        }
        return Coin()
    }()

    lazy var coinsTimer: CoinsTimer = .init(coin)

    lazy var store: Store = .init()

    var currentTicket = CurrentValues()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        DispatchQueue.global().sync { [weak self] in
            guard let self = self else { return }

            if self.store.currentSubscriptions.isEmpty {
                CoinsTimer.setSubscriptionKeychainValues(nil, nil, nil)
            }

            coinsTimer.checkSubscriptionAmount()
        }

        UITableView.appearance().backgroundColor = UIColor.clear
        return true
    }
}

class CurrentValues: ObservableObject {
    var ticket: UInt = 0
    var question: UInt = 0
}
