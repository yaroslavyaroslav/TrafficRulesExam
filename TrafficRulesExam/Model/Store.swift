//
//  Store.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//

import Foundation
import StoreKit

@available(iOS 15.0, *)
typealias Transaction = StoreKit.Transaction

@available(iOS 15.0, *)
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo

@available(iOS 15.0, *)
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
    case wrongPurchaseId(id: String)
}

public enum SubscriptionTier: Int, Comparable {
    case none = 0
    case standard = 1
    case premium = 2
    case pro = 3

    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

@available(iOS 15.0, *)
class Store: ObservableObject {
    @Published
    private(set) var fuel: [Product]
    @Published
    private(set) var subscriptions: [Product]

    @Published
    private(set) var purchasedIdentifiers = Set<String>()

    var updateListenerTask: Task<Void, Error>?

    private let productIdToEmoji: [String: String]

    private static let subscriptionTier: [String: SubscriptionTier] = [
        "subscription.standard": .standard,
        "subscription.premium": .premium,
        "subscription.pro": .pro
    ]

    init() {
        if let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: path) {
            self.productIdToEmoji = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
        } else {
            self.productIdToEmoji = [:]
        }

        // Initialize empty products then do a product request asynchronously to fill them in.
        self.fuel = []
        self.subscriptions = []

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

                    // Deliver content to the user.
                    await self.updatePurchasedIdentifiers(transaction)

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
            // Request products from the App Store using the identifiers defined in the Products.plist file.
            let storeProducts = try await Product.products(for: productIdToEmoji.keys)

            var newFuel: [Product] = []
            var newSubscriptions: [Product] = []

            // Filter the products into different categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newFuel.append(product)
                case .nonRenewable:
                    newSubscriptions.append(product)
                default:
                    // Ignore this product.
                    print("Unknown product")
                }
            }

            // Sort each product category by price, lowest to highest, to update the store.
            fuel = sortByPrice(newFuel)
            subscriptions = sortByPrice(newSubscriptions)
        } catch {
            print("Failed product request: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        // Begin a purchase.
        let result = try await product.purchase()

        switch result {
        case let .success(verification):
            let transaction = try checkVerified(verification)

            // Deliver content to the user.
            await updatePurchasedIdentifiers(transaction)

            // Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        // Get the most recent transaction receipt for this `productIdentifier`.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            // If there is no latest transaction, the product has not been purchased.
            return false
        }

        let transaction = try checkVerified(result)

        // Ignore revoked transactions, they're no longer purchased.

        // For subscriptions, a user can upgrade in the middle of their subscription period. The lower service
        // tier will then have the `isUpgraded` flag set and there will be a new transaction for the higher service
        // tier. Ignore the lower service tier transactions which have been upgraded.
        return transaction.revocationDate == nil && !transaction.isUpgraded
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
    func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        if transaction.revocationDate == nil {
            // If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
            purchasedIdentifiers.insert(transaction.productID)
        } else {
            // If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
            purchasedIdentifiers.remove(transaction.productID)
        }
    }

    func emoji(for productId: String) -> String {
        productIdToEmoji[productId]!
    }

    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { $0.price < $1.price })
    }

    func tier(for productId: String) -> SubscriptionTier {
        switch productId {
        case "subscription.standard":
            return .standard
        case "subscription.premium":
            return .premium
        case "subscription.pro":
            return .pro
        default:
            return .none
        }
    }
}
