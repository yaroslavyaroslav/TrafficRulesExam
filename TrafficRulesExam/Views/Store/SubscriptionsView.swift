//
//  SubscriptionsView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//

import StoreKit
import SwiftUI

@available(iOS 15.0, *)
struct SubscriptionsView: View {
    @EnvironmentObject var store: Store

    @State var currentSubscription: Product?
    @State var status: Product.SubscriptionInfo.Status?
    @Binding var isPresented: Bool

    var availableSubscriptions: [Product] { store.availableSubscriptions.filter { $0.id != currentSubscription?.id } }

    var body: some View {
        Group {
            if let currentSubscription = currentSubscription {
                Section(header: Text("Абонемент")) {
                    ProductCellView(product: currentSubscription, isPresented: $isPresented, purchasingEnabled: false)

                    if let status = status {
                        StatusInfoView(product: currentSubscription,
                                       status: status)
                    }
                }
                .listStyle(GroupedListStyle())
            }

            Section(header: Text("Абонементы (не подписка)")) {
                ForEach(availableSubscriptions, id: \.id) { product in
                    ProductCellView(product: product, isPresented: $isPresented)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear {
            Task {
                // When this view appears, get the latest subscription status.
                await updateSubscriptionStatus()
            }
        }
        .onChange(of: store.currentSubscriptions) { _ in
            Task {
                // When `purchasedIdentifiers` changes, get the latest subscription status.
                await updateSubscriptionStatus()
            }
        }
    }

    @MainActor
    func updateSubscriptionStatus() async {
        do {
            // This app has only one subscription group so products in the subscriptions
            // array all belong to the same group. The statuses returned by
            // `product.subscription.status` apply to the entire subscription group.
            guard let product = store.availableSubscriptions.first,
                  let statuses = try await product.subscription?.status else {
                return
            }

            var highestStatus: Product.SubscriptionInfo.Status?
            var highestProduct: Product?

            // Iterate through `statuses` for this subscription group and find
            // the `Status` with the highest level of service which isn't
            // expired or revoked.
            for status in statuses {
                switch status.state {
                case .expired, .revoked:
                    continue
                default:
                    let renewalInfo = try store.checkVerified(status.renewalInfo)

                    guard let newSubscription = store.availableSubscriptions.first(where: { $0.id == renewalInfo.currentProductID }) else {
                        continue
                    }

                    guard let currentProduct = highestProduct else {
                        highestStatus = status
                        highestProduct = newSubscription
                        continue
                    }

                    let highestTier = store.tier(for: currentProduct.id)
                    let newTier = store.tier(for: renewalInfo.currentProductID)

                    if newTier > highestTier {
                        highestStatus = status
                        highestProduct = newSubscription
                    }
                }
            }

            status = highestStatus
            currentSubscription = highestProduct
        } catch {
            print("Could not update subscription status \(error)")
        }
    }
}
