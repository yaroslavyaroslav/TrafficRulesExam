//
//  IAPHelper.swift
//  BabyEvolution
//
//  Created by Yaroslav on 17/09/2018.
//  Copyright © 2018 Yaroslav. All rights reserved.
//

import StoreKit
import SwiftKeychainWrapper
import os.log

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
public typealias ProductPurchaseCompletionHandler = (_ success: Bool) -> Void

public typealias PurchasesRestorationCompletionHandler = (_ success: Bool) -> Void


extension Notification.Name {
    static let PGIAPHelperPurchaseNotification = Notification.Name("PGIAPHelperPurchaseNotification")
    static let PGIAPHelperProductsInfoDeliveredNotification = Notification.Name("PGIAPHelperProductsInfoDeliveredNotification")
    static let PGShortTrialPeriodTimerFireNotification = Notification.Name("PGShortTrialPeriodStateNotification")
    static let PGLongTrialPeriodTimerFireNotification = Notification.Name("PGLongTrialPeriodStateNotification")
    static let PGPromoTimerFireNotification = Notification.Name("PGPromoTimerFireNotification")
    static let PGRateUsTimerFireNotification = Notification.Name("PGRateUsTimerFireNotification")
}


open class IAPHelper: NSObject  {
    private let productIdentifiers: Set<ProductIdentifier>
    private(set) var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productPurchaseCompletionHandler: ProductPurchaseCompletionHandler?
    private var purchasesRestorationCompletionHandler: PurchasesRestorationCompletionHandler?

    private var didRestoreSuccessful = false

    public init(productIds: Set<ProductIdentifier>) {
        productIds.forEach { (id) in
            os_log("IAPHelper.init productId: %@", id)
        }
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
            } else {
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }

    @objc func handlePaymentNotification(_ notification: Notification) {
//        guard customKeychainInstance.set(ApplicaitonState.purchased.rawValue, forKey: KeychainKeys.applicationState.rawValue) else { fatalError("ApplicationState key isn't stored") }
        os_log("purchasedProductIdentifiers contains: %@", purchasedProductIdentifiers)
    }
}


// MARK: - StoreKit API

extension IAPHelper {

    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productIdentifiers.forEach { (id) in
            os_log(OSLogType.info, "IAPHelper product to request: %@", id)
        }
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        os_log(OSLogType.info, "IAPHelper requested product: %@", productsRequest ?? "none")
        productsRequest!.delegate = self
        productsRequest!.start()
    }

    public func buyProduct(_ product: SKProduct, with completionHandler: @escaping ProductPurchaseCompletionHandler) {
        productPurchaseCompletionHandler = completionHandler
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }

    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    public func restorePurchases(_ completionHandler: @escaping PurchasesRestorationCompletionHandler ) {
        purchasesRestorationCompletionHandler = completionHandler
        SKPaymentQueue.default().restoreCompletedTransactions()
    }


}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        os_log(OSLogType.info,
               "IAPHelper.SKProductsRequestDelegate.response call, products.length: %d", response.products.count)
        response.products.forEach { (product) in
            os_log(OSLogType.info,
                   "IAPHelper.SKProductsRequestDelegate.response.product.productIdentifier: %@",
                   product.productIdentifier)
        }
        if products.count > 0 {
            productsRequestCompletionHandler?(true, products)
        } else {
            productsRequestCompletionHandler?(false, products)
        }

        clearRequestAndHandler()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePaymentNotification(_:)),
                                               name: .PGIAPHelperPurchaseNotification,
                                               object: nil)
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


extension IAPHelper: SKPaymentTransactionObserver {

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            if let identifier = transaction.transactionIdentifier {
                os_log(OSLogType.info, "IAPHelper.SKPaymentTransactionObserver.transaction", identifier)
            }
        }
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased: purchased(transaction)
            case .failed: failed(transaction)
            case .restored: restored(transaction)
            case .deferred, .purchasing: break
            }
        }
    }


    private func purchased(_ transaction: SKPaymentTransaction) {
        os_log("%@ purchased", transaction.payment.productIdentifier)

//        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        productPurchaseCompletionHandler?(true)
    }

    private func purchasing(_ transaction: SKPaymentTransaction) {
        os_log(OSLogType.info, "IAPHelper.SKPaymentTransactionObserver.purchasing")
    }

    private func failed(_ transaction: SKPaymentTransaction) {
        os_log("%@ failed", transaction.payment.productIdentifier)
        if let transactionError = transaction.error as NSError?,
            let _ = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
        }
        productPurchaseCompletionHandler?(false)
        SKPaymentQueue.default().finishTransaction(transaction)

    }

    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        os_log("paymentQueueRestoreCompletedTransactionsFinished")
        if didRestoreSuccessful {
            purchasesRestorationCompletionHandler?(true)
        } else {
            purchasesRestorationCompletionHandler?(false)
        }
    }

    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        os_log(OSLogType.error, "IAPHelper.SKPaymentTransactionObserver.paymentQueue.error %@", error.localizedDescription)
        purchasesRestorationCompletionHandler?(false)
    }

    private func restored(_ transaction: SKPaymentTransaction) {
        os_log("%@ restored", transaction.payment.productIdentifier)
//        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        didRestoreSuccessful = true
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func deferred(_ transaction: SKPaymentTransaction) {

    }
}
