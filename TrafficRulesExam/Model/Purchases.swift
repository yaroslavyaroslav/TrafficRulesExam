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
    var amount: Int {
        set {
            DispatchQueue.main.async(flags: [.barrier]) { [weak self] in self?.objectWillChange.send() }
            KeychainWrapper.standard[.coinsAmount] = newValue
        }
        get { KeychainWrapper.standard.integer(forKey: .coinsAmount) ?? 0 }
    }
}

extension KeychainWrapper.Key {
    static let coinsAmount: KeychainWrapper.Key = "CoinsAmount"
    static let ticketUsed: KeychainWrapper.Key = "LastCoinSpentDateTime"
    static let profileId: KeychainWrapper.Key = "ProfileId"
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
