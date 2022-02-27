//
//  Purchase.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 12.01.2022.
//

import Foundation
import StoreKit
import SwiftKeychainWrapper
import SwiftUI

class Coin: ObservableObject {
    var amount: UInt {
        set {
            DispatchQueue.main.async(flags: [.barrier]) { [weak self] in
                self?.objectWillChange.send()
                KeychainWrapper.standard[.coinsAmount] = Int(newValue)
            }
        }
        get { UInt(KeychainWrapper.standard.integer(forKey: .coinsAmount) ?? 0) }
    }

    private (set) var cardCost: UInt = 5

    private (set) var hintCost: UInt = 1
}

extension KeychainWrapper.Key {
    static let coinsAmount: KeychainWrapper.Key = "CoinsAmount"
    static let ticketUsed: KeychainWrapper.Key = "LastCoinSpentDateTime"
    static let profileId: KeychainWrapper.Key = "ProfileId"
    static let subscriptionStartDate: KeychainWrapper.Key = "SubscriptionStartDate"
    static let subscriptionLevel: KeychainWrapper.Key = "SubscriptionLevel"
    static let coinsDropDate: KeychainWrapper.Key = "CoinsDropDate"
}

extension KeychainWrapper {
    static var profileId: String {
        guard let profileId = KeychainWrapper.standard.string(forKey: .profileId) else {
            let newId = UUID().uuidString
            KeychainWrapper.standard[.profileId] = newId
            return newId
        }
        return profileId
    }
}


enum PurchasesID: String, CaseIterable, Comparable {
    case packMini = "ru.neatness.TrafficRulesExam.Mini"
    case packMiddle = "ru.neatness.TrafficRulesExam.Middle"
    case packMax = "ru.neatness.TrafficRulesExam.Max"

    case subscriptionOneMonth = "ru.neatness.TrafficRulesExam.OneMonthCoins"
    case subscriptionThreeMonths = "ru.neatness.TrafficRulesExam.ThreeMonthsCoins"
    case subscriptionSixMonths = "ru.neatness.TrafficRulesExam.SixMonthsCoins"

    public static func < (lhs: PurchasesID, rhs: PurchasesID) -> Bool {
        switch (lhs, rhs) {
        case (.subscriptionOneMonth, .subscriptionThreeMonths): return true
        case (.subscriptionOneMonth, .subscriptionSixMonths): return true
        case (.subscriptionThreeMonths, .subscriptionSixMonths): return true
        default: return false
        }
    }

    var isSubscription: Bool {
        switch self {
        case .subscriptionOneMonth, .subscriptionThreeMonths, .subscriptionSixMonths: return true
        default: return false
        }
    }

    var purchasedCoinsAmount: UInt {
        switch self {
        case .subscriptionOneMonth: return 40
        case .subscriptionThreeMonths: return 60
        case .subscriptionSixMonths: return 80
        case .packMini: return 10
        case .packMiddle: return 20
        case .packMax: return 40
        }
    }

    var subscriptionLength: Int {
        switch self {
        case .subscriptionOneMonth: return 1
        case .subscriptionThreeMonths: return 3
        case .subscriptionSixMonths: return 6
        default: return 0
        }
    }
}
