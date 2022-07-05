//
//  AppMetricaAnalytics.swift
//  TrafficRulesExam
//
//  Created by Yaroslav Yashin on 10.06.2022.
//

import Foundation
import YandexMobileMetrica
import StoreKit
import SwiftKeychainWrapper
import os.log

class AppMetrikaAnalytics {
    class func initAppMetrika() -> Bool {
#if DEBUG
        let configuration = YMMYandexMetricaConfiguration(apiKey: "d1bdcdf9-e810-4052-8631-c99702f002b2")
#else
        let configuration = YMMYandexMetricaConfiguration(apiKey: "bf58c573-1e85-4e45-9917-ac4d94f1c8bc")
#endif
        configuration?.userProfileID = KeychainWrapper.profileId
        guard let configuration = configuration else { return false }
        // FIXME: Crashing on Xcode preview
        YMMYandexMetrica.activate(with: configuration)

        Analytics.shared.fire(.firstRun)
        return true
    }
    
    class func fire(_ conversion: Analytics.Conversion) {
        // TODO: Add conversion debugDescription
        print("\(conversion)")

        switch conversion {
        case .firstRun: SKAdNetwork.registerAppForAdNetworkAttribution()

        case let .completePurchase(product, result), let .refundPurchase(product, result):
            if let revenueObject = AppMetrikaAnalytics.createRevenueObject(for: product, result) {
                sendRevenueEvent(revenueObject)
            } else {
                os_log("revenueObject is nil with ")
            }

        case let .ticketStarted(ticket):
            let userId = KeychainWrapper.profileId
            sendEvent(Event.TicketStared.rawValue, parameters: [userId: ticket])

        case let .ticketCompleted(ticket, success):
            let userId = KeychainWrapper.profileId
            let dict = ["\(ticket)": success]
            sendEvent(Event.TicketCompleted.rawValue, parameters: [userId: dict])

        case let .questionShown(ticket, question):
            let userId = KeychainWrapper.profileId
            let dict = ["\(ticket)": question]
            sendEvent(Event.QuestionShown.rawValue, parameters: [userId: dict])

        case let .hintTaken(ticket, question):
            let userId = KeychainWrapper.profileId
            let dict = ["\(ticket)": question]
            sendEvent(Event.HintTaken.rawValue, parameters: [userId: dict])

        // FIXME: Make ticketCardShown to eCommerceCard event.
        case let .screenShown(name):
            let userId = KeychainWrapper.profileId
            sendEvent(Event.ScreenShown.rawValue, parameters: [userId: name])
        }
    }
    
    private static func sendEvent(_ message: String, parameters: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(message, parameters: parameters) { error in os_log("Metrica failed with error: \(error.localizedDescription)") }
    }
    
    private static func sendECommerceEvent(_ event: YMMECommerce) {
        YMMYandexMetrica.report(eCommerce: event) { error in os_log("Metrica failed with error: \(error.localizedDescription)") }
    }

    private static func sendRevenueEvent(_ event: YMMRevenueInfo) {
        YMMYandexMetrica.reportRevenue(event) { error in os_log("Metrica failed with error: \(error.localizedDescription)") }
    }
}

extension AppMetrikaAnalytics {
    class func createRevenueObject(for product: Product, _ result: VerificationResult<Transaction>) -> YMMRevenueInfo? {
        guard case let .verified(transaction) = result else { return nil }

        let revenueInfo = YMMMutableRevenueInfo(priceDecimal: product.price as NSDecimalNumber, currency: "RUB")
        revenueInfo.productID = product.displayName
        revenueInfo.quantity = UInt(transaction.purchasedQuantity)

        // TODO: Send sign of transaction with StoreKit 2 to validate on AppMetrica side.
        return revenueInfo
    }
}


extension AppMetrikaAnalytics {
    enum Event: String {
        case TicketStared
        case TicketCompleted
        case HintTaken
        case QuestionShown
        case ScreenShown
    }
}
