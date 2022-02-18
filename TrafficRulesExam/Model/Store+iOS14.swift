//
//  IAPHelper.swift
//  BabyEvolution
//
//  Created by Yaroslav on 17/09/2018.
//  Copyright © 2018 Yaroslav. All rights reserved.
//

import os.log
import StoreKit
import SwiftKeychainWrapper

@available(swift, obsoleted: 15.0, message: "Please use iOS 15 API.")
open class IAPHelper: NSObject {
    private let productIdentifiers = AppStore.products
    private(set) var purchasedSubscriptions: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productPurchaseCompletionHandler: ProductPurchaseCompletionHandler?
    private var purchasesRestorationCompletionHandler: PurchasesRestorationCompletionHandler?

    public typealias ProductIdentifier = String
    public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
    public typealias ProductPurchaseCompletionHandler = (_ success: Bool) -> Void

    public typealias PurchasesRestorationCompletionHandler = (_ productIds: [String]) -> Void

    private var didRestoreSuccessful = false

    override public init() {
        productIdentifiers.forEach { os_log("IAPHelper.init productId: %@", $0) }

        // Filter subscription from all available purchases.
        let subscriptions = productIdentifiers.filter { $0.split(separator: ".").last?.contains(_: "Month") ?? false }

        // if there's record in UserDefaults with subscription ID — it's purchased.
        self.purchasedSubscriptions = subscriptions.filter { UserDefaults.standard.bool(forKey: $0) }

        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - Async client methods

@available(swift, obsoleted: 15.0, message: "Please use iOS 15 API.")
extension IAPHelper {
    func requestProducts() async -> [SKProduct]? {
        await withCheckedContinuation { (continuation: CheckedContinuation<[SKProduct]?, Never>) in
            requestProducts { _, products in continuation.resume(returning: products) }
        }
    }

    func purchase(product: SKProduct) async throws -> Bool {
        guard SKPaymentQueue.canMakePayments() else { throw PurchaseError.PurchasesAreLocked }

        return await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
            purchaseProduct(product) { succeess in
                if succeess {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }

    func restoreProduct() async -> [String] {
        await withCheckedContinuation { (continuation: CheckedContinuation<[String], Never>) in
            restorePurchases { productIds in
                continuation.resume(returning: productIds)
            }
        }
    }

    private func purchaseProduct(_ product: SKProduct, with completionHandler: @escaping ProductPurchaseCompletionHandler) {
        productPurchaseCompletionHandler = completionHandler
        let payment = SKPayment(product: product)

        SKPaymentQueue.default().add(payment)
    }
}

// MARK: - SKProductsRequestDelegate

@available(swift, obsoleted: 15.0, message: "Please use iOS 15 API.")
extension IAPHelper: SKProductsRequestDelegate {
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        productIdentifiers.forEach { os_log(OSLogType.info, "IAPHelper product to request: %@", $0) }

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)

        os_log(OSLogType.info, "IAPHelper requested product: %@", productsRequest ?? "none")

        productsRequest!.delegate = self
        productsRequest!.start()
    }

    public func restorePurchases(_ completionHandler: @escaping PurchasesRestorationCompletionHandler) {
        purchasesRestorationCompletionHandler = completionHandler
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        os_log(OSLogType.info,
               "IAPHelper.SKProductsRequestDelegate.response call, products.length: %d",
               response.products.count)
        response.products.forEach { product in
            os_log(OSLogType.info,
                   "IAPHelper.SKProductsRequestDelegate.response.product.productIdentifier: %@",
                   product.productIdentifier)
        }
        if !products.isEmpty {
            productsRequestCompletionHandler?(true, products)
        } else {
            productsRequestCompletionHandler?(false, products)
        }

        clearRequestAndHandler()
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        os_log(OSLogType.error, "IAPHelper.SKProductsRequestDelegate.request.failed.error: %@", error.localizedDescription)
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        os_log(OSLogType.info, "IAPHelper.SKProductsRequestDelegate.clearRequestAndHandler call")
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

@available(swift, obsoleted: 15.0, message: "Please use iOS 15 API.")
extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            if let identifier = transaction.transactionIdentifier {
                os_log(OSLogType.info, "IAPHelper.SKPaymentTransactionObserver.transaction", identifier)
            }
            switch transaction.transactionState {
            case .purchased: purchased(transaction)
            case .failed: failed(transaction)
            case .restored: restored(transaction)
            case .deferred, .purchasing: break
            @unknown default: fatalError()
            }
        }
    }

    private func purchased(_ transaction: SKPaymentTransaction) {
        os_log("%@ purchased", transaction.payment.productIdentifier)

        SKPaymentQueue.default().finishTransaction(transaction)
        productPurchaseCompletionHandler?(true)
    }

    private func purchasing(_ transaction: SKPaymentTransaction) {
        os_log(.info, "IAPHelper.SKPaymentTransactionObserver.purchasing")
    }

    private func failed(_ transaction: SKPaymentTransaction) {
        os_log("%@ failed", transaction.payment.productIdentifier)
        productPurchaseCompletionHandler?(false)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        os_log(.error, "IAPHelper.SKPaymentTransactionObserver.paymentQueue.error %@", error.localizedDescription)
        purchasesRestorationCompletionHandler?([])
    }

    private func restored(_ transaction: SKPaymentTransaction) {
        os_log("%@ restored", transaction.payment.productIdentifier)

        // FIXME: This returns only one ID not all.
        purchasesRestorationCompletionHandler?([transaction.payment.productIdentifier])
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

@available(swift, obsoleted: 15.0, message: "Please use iOS 15 API.")
enum PurchaseError: Error {
    case PurchasesAreLocked
}
