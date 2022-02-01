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
import os.log


extension Analytics {
    enum Conversion {
        // MARK: - Conversions
        case firstRun

        // MARK: - Purchases
        case completePurchase(revenue: YMMRevenueInfo)
        case refundPurchase(revenue: YMMRevenueInfo)

        // MARK: - Exam Actions
        case ticketStarted(ticketId: UInt)
        case ticketCompleted(ticketId: UInt)
        case questionAnswered(product: YMMECommerceProduct)
        case hintTaken(product: YMMECommerceProduct)

        // MARK: - Navigation
        case screenShown(name: String)
        case ticketCardShown(name: String)
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
            let configuration = YMMYandexMetricaConfiguration(apiKey: "d1bdcdf9-e810-4052-8631-c99702f002b2")
            configuration?.userProfileID = KeychainWrapper.profileId
            guard let configuration = configuration else { return false }
            YMMYandexMetrica.activate(with: configuration)

            Analytics.fire(.firstRun)

            return true
        case .segment: return false
        }
    }

    class func fire(_ conversion: Conversion) {
        let fiat0 = YMMECommerceAmount(unit: "coin", value: 0)
        let fiat1 = YMMECommerceAmount(unit: "coin", value: 1)
        let price0 = YMMECommercePrice(fiat: fiat0)
        let price1 = YMMECommercePrice(fiat: fiat1)

        print("\(conversion)")

        switch conversion {
        case .firstRun: SKAdNetwork.registerAppForAdNetworkAttribution()

        case let .completePurchase(revenueObject), let .refundPurchase(revenueObject):
            sendRevenueEvent(revenueObject)

        case .ticketStarted(let ticket):
            let order = YMMECommerceOrder(identifier: "Билет \(ticket)", cartItems: [])
            sendECommerceEvent(YMMECommerce.beginCheckoutEvent(order: order))

        case .ticketCompleted(let ticket):
            let order = YMMECommerceOrder(identifier: "Билет \(ticket)", cartItems: [])
            sendECommerceEvent(YMMECommerce.purchaseEvent(order: order))

        case let .questionAnswered(question):
            let cartItem = YMMECommerceCartItem(product: question, quantity: 1, revenue: price0, referrer: nil)
            sendECommerceEvent(YMMECommerce.addCartItemEvent(cartItem: cartItem))

        case let .hintTaken(hint):
            let cartItem = YMMECommerceCartItem(product: hint, quantity: 1, revenue: price1, referrer: nil)
            sendECommerceEvent(YMMECommerce.addCartItemEvent(cartItem: cartItem))

            // FIXME: Make ticketCardShown to eCommerceCard event.
        case let .screenShown(name):
            let screen = YMMECommerceScreen(name: name)
            sendECommerceEvent(.showScreenEvent(screen: screen))
        case let .ticketCardShown(name):
            let product = YMMECommerceProduct(sku: name)
            let screen = YMMECommerceScreen(name: "Решать")
            sendECommerceEvent(.showProductCardEvent(product: product, screen: screen))
        }
    }

    // FIXME: Make me universal send method.
    private static func sendECommerceEvent(_ event: YMMECommerce) {
        YMMYandexMetrica.report(eCommerce: event) { error in os_log("Metrica failed with error: \(error.localizedDescription)") }
    }

    private static func sendRevenueEvent(_ event: YMMRevenueInfo) {
        YMMYandexMetrica.reportRevenue(event) { error in os_log("Metrica failed with error: \(error.localizedDescription)") }
    }
}

extension Analytics {
    enum System {
        case appMetrica
        case segment
    }
}

extension Analytics {
    @available(iOS 15, *)
    class func createRevenueObject(for product: Product, _ result: VerificationResult<Transaction>) -> YMMRevenueInfo? {
        guard case let .verified(transaction) = result else { return nil }

        let revenueInfo = YMMMutableRevenueInfo(priceDecimal: product.price as NSDecimalNumber, currency: "RUB")
        revenueInfo.productID = product.displayName
        revenueInfo.quantity = UInt(transaction.purchasedQuantity)

        // Todo: Send sign of transaction with StoreKit 2 to validate on AppMetrica side.
        return revenueInfo
    }
}
