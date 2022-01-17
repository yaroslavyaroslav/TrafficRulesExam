//
//  RepeatingTimer.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 13.01.2022.
//

import Foundation
import SwiftKeychainWrapper


/// Timer that implements coins adding logic
class CoinsTimer: ObservableObject {

    private var coins: Coin

    private var coinsLimit: Int

    private var timeLimit: TimeInterval

    private var updateFrequency: TimeInterval

    /// Computed property that provides time that lasts to next free Coin drop
    /// If free coins linit reached returns nil
    var secondsLasts: String { calculateCoundownTimerText() }

    /// Free coins timer initializer
    /// - Parameters:
    ///   - coins: Coin object wich are stores actual coins amount status in runtime
    ///   - coinsLimit: Maximum amount of a free coins
    ///   - timerLimit: Time amount until a next free coin drops in seconds
    init(_ coins: Coin, coinsLimit: Int = 5, timeLimit: TimeInterval = 600, update frequency: TimeInterval = 1) {
        self.coins = coins
        self.coinsLimit = coinsLimit
        self.timeLimit = timeLimit
        self.updateFrequency = frequency
    }

    func calculateCoundownTimerText() -> String {
        guard let initTimeInterval = KeychainWrapper.standard.double(forKey: .ticketUsed) else { return "" }
        guard coins.amount < coinsLimit else { return "" }

        let ticketUsage = Date(timeIntervalSinceReferenceDate: initTimeInterval)
        let currentDate = Date()
        let coinDrop = ticketUsage.addingTimeInterval(timeLimit)

        if currentDate > coinDrop {
            let distance = coinDrop.distance(to: currentDate)
            var multiplier = 1
            multiplier += Int(distance) / Int(timeLimit)

            multiplier += coins.amount

            if multiplier > coinsLimit { coins.amount = coinsLimit; return "" }

            // Add one coin if currentDate pass ticketArrive date
            // Add more coins if currentDate pass ticketArrive date more than 10 minutes.
            coins.amount = multiplier

            // Multiplyer is not 1 here, it's arithmetic progression.
            // Since timerAmount multiplies on all available coins.
            let newTicketUsageDate = coinDrop + TimeInterval(multiplier) * timeLimit
            KeychainWrapper.standard[.ticketUsed] = newTicketUsageDate.timeIntervalSinceReferenceDate
        }

        let countdownValue = Date().secondsLasts(to: coinDrop)

        return countdownValue
    }
}


extension Date {
    func secondsLasts(to nextDate: Date) -> String {
        let newDateSeconds = nextDate.timeIntervalSinceReferenceDate
        let difference = newDateSeconds - self.timeIntervalSinceReferenceDate

        let intervalFormatter = DateComponentsFormatter()
        intervalFormatter.zeroFormattingBehavior = .pad
        intervalFormatter.allowedUnits = [.minute, .second]
        intervalFormatter.unitsStyle = .positional
        return difference >= 0 ? intervalFormatter.string(from: difference)! : "10:00"
    }
}
