//
//  RepeatingTimer.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 13.01.2022.
//

import Foundation
import SwiftKeychainWrapper
import os.log

/// Timer that implements coins adding logic
class CoinsTimer: ObservableObject {
    private var coins: Coin

    private var coinsLimit: UInt

    private var timeLimit: TimeInterval

    private var updateFrequency: TimeInterval

    /// Computed property that provides time that lasts to next free Coin drop
    /// If free coins limit reached returns nil
    var secondsLasts: String { calculateCoundownTimerText() }

    /// Free coins timer initializer
    /// - Parameters:
    ///   - coins: Coin object wich are stores actual coins amount status in runtime
    ///   - coinsLimit: Maximum amount of a free coins
    ///   - timerLimit: Time amount until a next free coin drops in seconds
    init(_ coins: Coin, coinsLimit: UInt = 5, timeLimit: TimeInterval = 600, update frequency: TimeInterval = 1) {
        self.coins = coins
        self.coinsLimit = coinsLimit
        self.timeLimit = timeLimit
        self.updateFrequency = frequency
    }

    /// Computed property that provides time that lasts to next free Coin drop
    /// If free coins limit reached returns nil
    func calculateCoundownTimerText() -> String {
        guard let initTimeInterval = KeychainWrapper.standard.double(forKey: .ticketUsed) else { return "" }
        guard coins.amount < coinsLimit else { return "" }

        let ticketUsage = Date(timeIntervalSinceReferenceDate: initTimeInterval)
        let currentDate = Date()
        let coinDrop = ticketUsage.addingTimeInterval(timeLimit)

        /// If current time (`currentDistance`) > than time of the last coin drop time (`coinDrop`)
        if currentDate > coinDrop {
            /// `distance` always > 0
            let distance = coinDrop.distance(to: currentDate)
            /// How much times `timelimit` (default 10:00) stores in `distance`
            var multiplier: UInt = 1
            multiplier += UInt(distance) / UInt(timeLimit)

            /// Add coins that user have yet to `multiplier`
            multiplier += coins.amount

            /// `multiplier` should not be greater than `coinsLimit`
            if multiplier > coinsLimit { coins.amount = coinsLimit; return "" }

            /// Add one coin if `currentDate` pass `ticketArrive` date
            /// Add more coins if `currentDate` pass `ticketArrive` date more than 10 minutes.
            coins.amount = multiplier

            /// `multiplyer` is not 1 here, it's arithmetic progression.
            /// Since `timerAmount` multiplies on all available coins.
            let newTicketUsageDate = coinDrop + TimeInterval(multiplier) * timeLimit
            KeychainWrapper.standard[.ticketUsed] = newTicketUsageDate.timeIntervalSinceReferenceDate
        }

        return Date().secondsLasts(to: coinDrop)
    }


    class func setSubscriptionKeychainValues(_ subscriptionStartDate: Date?, _ lastRunDate: Date?, _ subscriptionLevelString: String?) {
        DispatchQueue.main.async(flags: .barrier) {
            KeychainWrapper.standard[.subscriptionStartDate] = subscriptionStartDate?.timeIntervalSinceReferenceDate ?? 0
            KeychainWrapper.standard[.coinsDropDate] = lastRunDate?.timeIntervalSinceReferenceDate ?? 0
            KeychainWrapper.standard[.subscriptionLevel] = subscriptionLevelString ?? ""
        }
    }

    func checkSubscriptionAmount() {

        // FIXME: Delete all debug print when cover with unit tests.
        /// Get todays date and time
        let currentDate = Date()

        os_log("\(self.coins.amount.description)")
        /// Checking if all values in Keychain are set and valid
        /// If there's not full set (3) subscription records in Keychain - return.
        /// All of it (3) must be set on purchase.
        guard let subscriptionStartTimeInterval = KeychainWrapper.standard.double(forKey: .subscriptionStartDate),
              let lastRunDateInterval = KeychainWrapper.standard.double(forKey: .coinsDropDate),
              let subscriptionLevelString = KeychainWrapper.standard.string(forKey: .subscriptionLevel),
              let subscriptionLevel = PurchasesID(rawValue: subscriptionLevelString) else { return }

        let subscriptionStartDate = Date(timeIntervalSinceReferenceDate: subscriptionStartTimeInterval)

        /// Get subscription period ends date
        guard let subscriptionEndDate = Calendar.current.date(byAdding: .month, value: subscriptionLevel.subscriptionLength, to: subscriptionStartDate) else { return  }

        /// Continue only if today is the day when the subscription are still active
        guard Calendar.current.isLowerOrEqual(currentDate, to: subscriptionEndDate, toGranularity: .day) else { return  }

        let lastRunDate = Date(timeIntervalSinceReferenceDate: lastRunDateInterval)

        /// Continue only if we didn't give subscription coins to the user today, otherwise return his amount
        guard !Calendar.current.isDateInToday(lastRunDate) else { return }

        /// Giving coins to a user
        switch subscriptionLevel {
        case .subscriptionOneMonth, .subscriptionThreeMonths, .subscriptionSixMonths:
            /// Check that user have less coins than comes by his subscription
            guard coins.amount < subscriptionLevel.purchasedCoinsAmount else { return  }

            /// Give user exact coins amount
            KeychainWrapper.standard[.coinsDropDate] = currentDate.timeIntervalSinceReferenceDate

            #if DEBUG
            let someTimeInterval = KeychainWrapper.standard.double(forKey: .coinsDropDate)
            let someDate = Date(timeIntervalSinceReferenceDate: someTimeInterval ?? 0)
            os_log("\(someDate.prettyPrint)")
            #endif
            coins.amount = subscriptionLevel.purchasedCoinsAmount
//            return subscriptionLevel.purchasedCoinsAmount
        default: return
        }

        /// Set new timestamp on the time when coins were provided to the user
        /// This should happened on each new day when app runs.
        /// It stores in the end to avoid providing coins on purchase event
    }

    func spendCoin(_ amount: UInt = 1) throws {
        // This will restart timer only when user spend first coin which less then coinsLimit
        // Without this condition timer will restart on each not success result.
        if coins.amount == coinsLimit {
            KeychainWrapper.standard[.ticketUsed] = Date().timeIntervalSinceReferenceDate
        }
        if coins.amount <= amount {
            coins.amount = 0
            throw CoinsError.NegativeCoinsAmount
        } else {
            coins.amount -= amount
        }
    }

    func rewardCoin(_ amount: UInt = 1) {
        coins.amount += amount
    }
}

extension Date {
    func secondsLasts(to nextDate: Date) -> String {
        let newDateSeconds = nextDate.timeIntervalSinceReferenceDate
        let difference = newDateSeconds - timeIntervalSinceReferenceDate

        let intervalFormatter = DateComponentsFormatter()
        intervalFormatter.zeroFormattingBehavior = .pad
        intervalFormatter.allowedUnits = [.minute, .second]
        intervalFormatter.unitsStyle = .positional
        return difference >= 0 ? intervalFormatter.string(from: difference)! : "10:00"
    }
}

extension Calendar {
    func isLowerOrEqual(_ date1: Date, to date2: Date, toGranularity: Calendar.Component) -> Bool {
        let answer = self.compare(date1, to: date2, toGranularity: toGranularity)
        switch answer {
        case .orderedSame: return true
        case .orderedAscending: return true
        case .orderedDescending: return false
        }
    }
}

enum CoinsError: Error {
    case NegativeCoinsAmount
}
