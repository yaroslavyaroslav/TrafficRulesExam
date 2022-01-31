//
//  Analytics.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.01.2022.
//

import Foundation
import StoreKit
import SwiftKeychainWrapper
import YandexMobileMetrica


class Analytics {
    class func register(_ conversion: Conversion) {
        switch conversion {
        case .firstRun:
            SKAdNetwork.registerAppForAdNetworkAttribution()
        case .initPurchase(let string):
            SKAdNetwork.updateConversionValue(conversion.appStoreValue)
//        case .completePurchase(let string):
//            <#code#>
//        case .cancelPurchase(let string):
//            <#code#>
//        case .initSubscription(let string):
//            <#code#>
//        case .completeSubscription(let string):
//            <#code#>
//        case .cancelSubscription(let string):
//            <#code#>
//        case .ticketStarted(let id):
//            <#code#>
//        case .ticketCompleted(let id):
//            <#code#>
//        case .ticketCanceled(let id, let answers):
//            <#code#>
//        case .hintTaken(let ticket, let question):
//            <#code#>
        default:
            SKAdNetwork.updateConversionValue(conversion.appStoreValue)
        }
    }
}


extension Analytics {
    enum Conversion {
        // MARK: - Conversions
        case firstRun

        // MARK: - Purchases
        case initPurchase(String)
        case completePurchase(String)
        case cancelPurchase(String)

        // MARK: - Subscriptions
        case initSubscription(String)
        case completeSubscription(String)
        case cancelSubscription(String)

        // MARK: - Inapp Actions
        case ticketStarted(id: Int)
        case ticketCompleted(id: Int)
        case ticketCanceled(id: Int, answers: Int)
        case hintTaken(ticket: Int, question: Int)
    }
}

extension Analytics.Conversion {
    var appStoreValue: Int {
        switch self {
        default: return 1
        }
    }
}
