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
        let fiat0 = YMMECommerceAmount(unit: "USD", value: 0)
        let zedoUSD = YMMECommercePrice(fiat: fiat0)

        let fiat1 = YMMECommerceAmount(unit: "USD", value: 1)
        let oneUSD = YMMECommercePrice(fiat: fiat1)

        print("\(conversion)")

        switch conversion {
        case .firstRun: SKAdNetwork.registerAppForAdNetworkAttribution()

        case let .completePurchase(revenueObject), let .refundPurchase(revenueObject):
            sendRevenueEvent(revenueObject)

        case .ticketStarted(let ticket):
            let product = YMMECommerceProduct(sku: "Билет \(ticket)")
            sendECommerceEvent(.showProductDetailsEvent(product: product, referrer: nil))

        case .ticketCompleted(let ticket, let success):
            let product = YMMECommerceProduct(sku: "Билет \(ticket)",
                                              name: "Билет \(ticket)",
                                              categoryComponents: nil,
                                              payload: nil,
                                              actualPrice: success ? zedoUSD : oneUSD,
                                              originalPrice: success ? zedoUSD : oneUSD,
                                              promoCodes: nil)

            let cartItem = YMMECommerceCartItem(product: product, quantity: 1, revenue: product.actualPrice ?? oneUSD, referrer: nil)
            let order = YMMECommerceOrder(identifier: "Билет \(ticket)", cartItems: [cartItem])
            sendECommerceEvent(.purchaseEvent(order: order))

        case let .questionShown(ticket, question):
            let product = YMMECommerceProduct(sku: "Билет \(ticket)")
            let screen = YMMECommerceScreen(name: "Вопрос \(question)")
            sendECommerceEvent(.showProductCardEvent(product: product, screen: screen))

        case let .hintTaken(ticket, question):
            let product = YMMECommerceProduct(sku: "\(ticket)_\(question)",
                                              name: "Подсказка \(ticket) \(question)",
                                              categoryComponents: nil,
                                              payload: nil,
                                              actualPrice: oneUSD,
                                              originalPrice: oneUSD,
                                              promoCodes: nil)

            let cartItem = YMMECommerceCartItem(product: product, quantity: 1, revenue: product.actualPrice ?? oneUSD, referrer: nil)
            let order = YMMECommerceOrder(identifier: "Подсказка_\(ticket)_\(question)", cartItems: [cartItem])
            sendECommerceEvent(.purchaseEvent(order: order))

            // FIXME: Make ticketCardShown to eCommerceCard event.
        case let .screenShown(name):
            let screen = YMMECommerceScreen(name: name)
            sendECommerceEvent(.showScreenEvent(screen: screen))
        }
    }

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
