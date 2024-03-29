//
//  ProductCellView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//
import StoreKit
import SwiftUI
import SwiftKeychainWrapper
import os.log

struct ProductCellView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var coinsTimer: CoinsTimer
    @EnvironmentObject var coins: Coin
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    @Binding var isPresented: Bool

    let product: Product
    let purchasingEnabled: Bool

    init(product: Product, isPresented: Binding<Bool>, purchasingEnabled: Bool = true) {
        self.product = product
        self._isPresented = isPresented
        self.purchasingEnabled = purchasingEnabled
    }

    var body: some View {
        HStack(spacing: 0) {
            if purchasingEnabled {
                CoinsStackView(.init(rawValue: product.id) ?? .one)
                    .padding(.init(top: 21, leading: 10, bottom: 21, trailing: 10))
                productDetail
                Spacer()
                buyButton
                    .buttonStyle(BuyButtonStyle(isPurchased: isPurchased))
                    .padding(.trailing, 16)
            } else {
                productDetail
                    .padding(.init(top: 21, leading: 21, bottom: 21, trailing: 16))
            }
        }
        .roundBorder(Color.DS.bgLightSecondary, cornerRadius: 12)
        .shadow(color: .DS.shadowLight, radius: 8, x: 0, y: 4)
        .alert(isPresented: $isShowingError) {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Ok")))
        }
    }

    @ViewBuilder
    var productDetail: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.description)
                .font(UIFont.sfBody.asFont)
            Text(product.displayName)
                .font(UIFont.sfFootnote.asFont)
                .foregroundColor(.DS.greysGreyDark)
        }
    }

    var buyButton: some View {
        Button {
            Task { await buy() }
        } label: {
            if let subscription = product.subscription {
                subscribeButton(subscription)
            } else {
                Text(product.displayPrice)
                    .foregroundColor(.white)
                    .font(UIFont.sfCallout.asFont)
            }
        }
    }

    func subscribeButton(_ subscription: Product.SubscriptionInfo) -> some View {
        let unit: String
        let plural = subscription.subscriptionPeriod.value > 1
        switch subscription.subscriptionPeriod.unit {
        case .day:
            unit = plural ? "\(subscription.subscriptionPeriod.value) days" : "day"
        case .week:
            unit = plural ? "\(subscription.subscriptionPeriod.value) weeks" : "week"
        case .month:
            unit = plural ? "\(subscription.subscriptionPeriod.value) months" : "month"
        case .year:
            unit = plural ? "\(subscription.subscriptionPeriod.value) years" : "year"
        @unknown default:
            unit = "period"
        }

        return VStack {
            Text(product.displayPrice)
                .foregroundColor(.white)
                .bold()
                .padding(EdgeInsets(top: -4.0, leading: 0.0, bottom: -8.0, trailing: 0.0))
            Divider()
                .background(Color.white)
            Text(unit)
                .foregroundColor(.white)
                .font(.system(size: 12))
                .padding(EdgeInsets(top: -8.0, leading: 0.0, bottom: -4.0, trailing: 0.0))
        }
    }

    func buy() async {
        do {
            if let transaction = try await store.purchase(product) {
                guard let purchaseId = PurchasesID(rawValue: transaction.productID) else { throw StoreError.wrongPurchaseId(id: transaction.productID) }
                if purchaseId.isSubscription {

                    var mostSubscription: PurchasesID

                    if let currentSubscriptionString = KeychainWrapper.standard.string(forKey: .subscriptionLevel),
                        let currentSubscription = PurchasesID(rawValue: currentSubscriptionString) {
                        mostSubscription = currentSubscription > purchaseId ? currentSubscription : purchaseId
                    } else {
                        mostSubscription = purchaseId
                    }

                    CoinsTimer.setSubscriptionKeychainValues(Date(), Date(), mostSubscription.rawValue)

                    withAnimation {
                        if coins.amount < mostSubscription.purchasedCoinsAmount {
                            coins.amount = mostSubscription.purchasedCoinsAmount
                        } else {
                            coinsTimer.checkSubscriptionAmount()
                        }
                        isPresented = false
                    }
                } else {
                    withAnimation {
                        coins.amount += purchaseId.purchasedCoinsAmount
                        isPresented = false
                    }
                }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch let StoreError.wrongPurchaseId(productId) {
            errorTitle = "Could not provide coins with such amount as: \(productId)"
            isShowingError = true
        } catch {
            os_log("Failed purchase for \(product.id.description): \(error.localizedDescription)")
        }
    }
}
