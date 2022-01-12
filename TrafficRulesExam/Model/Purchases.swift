//
//  Purchase.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 12.01.2022.
//

import Foundation
import SwiftUI
import SwiftKeychainWrapper
import StoreKit


class Coin: ObservableObject {
    var amount: Int {
        set {
            objectWillChange.send()
            KeychainWrapper.standard[.coinsAmount] = newValue
        }
        get { KeychainWrapper.standard.integer(forKey: .coinsAmount) ?? 0 }
    }
}

struct Purchases {
    /// Store purchases log.
//    static var log: [Date: Int] {
//        set { KeychainWrapper.standard[.purchases] = newValue }
//        get { KeychainWrapper.standard. }
//    }
}

extension KeychainWrapper.Key {
    static let coinsAmount: KeychainWrapper.Key = "CoinsAmount"
    static let purchases: KeychainWrapper.Key = "Purchases"
}
