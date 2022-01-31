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
    class func initAnalytics(_ system: System = .appMetrica) -> Bool {
        switch system {
        case .appMetrica:
            let configuration = YMMYandexMetricaConfiguration(apiKey: "d1bdcdf9-e810-4052-8631-c99702f002b2")
            configuration?.userProfileID = KeychainWrapper.profileId
            guard let configuration = configuration else { return false }
            YMMYandexMetrica.activate(with: configuration)

            Analytics.register(.firstRun)

            return true
        case .sigment: return false
        }
    }

    class func register(_ conversion: Conversion) {
        switch conversion {
        case .firstRun:
            SKAdNetwork.registerAppForAdNetworkAttribution()
        case .initPurchase(let productID):
            let purchaseIdentifier = UUID().uuidString
//            YMMYandexMetrica.report(eCommerce: <#T##YMMECommerce#>, onFailure: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
//            YMMYandexMetrica.reportEvent(<#T##message: String##String#>, onFailure: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
//            YMMYandexMetrica.reportRevenue(<#T##revenueInfo: YMMRevenueInfo##YMMRevenueInfo#>, onFailure: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)

            SKAdNetwork.updateConversionValue(conversion.appStoreValue)
        case .completePurchase(let string):
            SKAdNetwork.updateConversionValue(conversion.appStoreValue)
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
        case initPurchase(product: String)
        case completePurchase(product: String)
        case cancelPurchase(product: String)

        // MARK: - Subscriptions
        case initSubscription(product: String)
        case completeSubscription(product: String)
        case cancelSubscription(product: String)

        // MARK: - Inapp Actions
        case ticketStarted(id: Int)
        case questionShown(id: Int)
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

extension Analytics {
    enum System {
        case appMetrica
        case sigment
    }
}
