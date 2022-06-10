//
//  Store.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//

import Foundation
import os.log
import StoreKit
import SwiftKeychainWrapper

@available(iOS 15.0, *)
typealias Transaction = StoreKit.Transaction

@available(iOS 15.0, *)
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo

@available(iOS 15.0, *)
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

struct AppStore {
    static let products: Set<PurchasesID> = Set(PurchasesID.allCases)
}

public enum StoreError: Error {
    case failedVerification
    case wrongPurchaseId(id: String)
}

public enum SubscriptionTime: Int, Comparable {
    case none = 0
    case month = 1
    case quater = 3
    case halfYear = 6

    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

@available(iOS 15.0, *)
class Store: ObservableObject {
    @Published private(set) var availableCoinPacks: [Product]

    @Published private(set) var availableSubscriptions: [Product]

    @Published private(set) var currentSubscriptions = Set<String>()

    var updateListenerTask: Task<Void, Error>?

    init() {
        Analytics.initAnalytics()

        // Initialize empty products then do a product request asynchronously to fill them in.
        self.availableCoinPacks = []
        self.availableSubscriptions = []
        self.currentSubscriptions = []

        // Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        self.updateListenerTask = listenForTransactions()

        Task {
            // Initialize the store by starting a product request.
            await requestProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            // Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    await self.updateSubscriptionStatus(transaction)

                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }

    @MainActor
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: Set(AppStore.products.map { $0.rawValue }))

            var newCoins: [Product] = []
            var newSubscriptions: [Product] = []

            // Filter the products into different categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .consumable: newCoins.append(product)
                case .nonRenewable: newSubscriptions.append(product)
                // Ignore another products
                default: os_log("Unknown product \(product.id)")
                }
            }

            // Sort each product category by price, lowest to highest, to update the store.
            availableCoinPacks = newCoins.sorted { $0.price < $1.price }
            availableSubscriptions = newSubscriptions.sorted { $0.price < $1.price }
        } catch {
            print("Failed product request: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        // Begin a purchase.
        let result = try await product.purchase()

        guard case let .success(verification) = result else { return nil }

        let transaction = try checkVerified(verification)

        await updateSubscriptionStatus(transaction)

        Analytics.fire(.completePurchase(product: product, verification))

        // Always finish a transaction.
        await transaction.finish()

        return transaction
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case let .verified(safe):
            // If the transaction is verified, unwrap and return it.
            return safe
        }
    }

    @MainActor
    /// Updates subscriptions purchased or refunded by user
    /// - Parameter transaction: StoreKit 2 nonRenewable transaction (all other types will be ignored).
    private func updateSubscriptionStatus(_ transaction: Transaction) async {
        guard case .nonRenewable = transaction.productType else { return }

        // TODO: Move Purchase and refund analytics here.
        if transaction.revocationDate == nil {
            // If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
            currentSubscriptions.insert(transaction.productID)
        } else {
            // If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
            currentSubscriptions.remove(transaction.productID)
        }
    }

    func tier(for productId: String) -> SubscriptionTime {
        switch productId {
        case "ru.neatness.TrafficRulesExam.OneMonthCoins": return .month
        case "ru.neatness.TrafficRulesExam.ThreeMonthCoins": return .quater
        case "ru.neatness.TrafficRulesExam.SixMonthCoins": return .halfYear
        default: return .none
        }
    }
}
