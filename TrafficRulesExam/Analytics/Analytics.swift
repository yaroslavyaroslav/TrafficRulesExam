//
//  Analytics.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.01.2022.
//

import Foundation
import os.log
import StoreKit
import SwiftKeychainWrapper

extension Analytics {
    enum Conversion {
        // MARK: - Conversions

        case firstRun

        // MARK: - Purchases

        case completePurchase(product: Product, _ result: VerificationResult<Transaction>)
        case refundPurchase(product: Product, _ result: VerificationResult<Transaction>)

        // MARK: - Exam Actions

        case ticketStarted(ticketId: UInt)
        case ticketCompleted(ticketId: UInt, success: Bool)
        case questionShown(ticket: UInt, question: UInt)
        case hintTaken(ticket: UInt, question: UInt)

        // MARK: - Navigation

        case screenShown(name: String)
    }
}

class Analytics {
    struct Payload: Encodable {
        let coinsAmount: UInt
        let solvedTickets: Set<UInt>
        let succedTickets: Set<UInt>
        let purchases: [String]
    }

    @discardableResult
    class func initAnalytics(_ system: System = .appMetrica) -> Bool {
        switch system {
        case .appMetrica:
#if !DEBUG
            return AppMetrikaAnalytics.initAppMetrika()
#else
            return false
#endif
        case .segment: return false
        }
    }

    class func fire(_ conversion: Conversion) {
#if !DEBUG
        AppMetrikaAnalytics.fire(conversion)
#endif
    }
}

extension Analytics {
    enum System {
        case appMetrica
        case segment
    }
}
