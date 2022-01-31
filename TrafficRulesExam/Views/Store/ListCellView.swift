//
//  ListCellView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//
import StoreKit
import SwiftUI

@available(iOS 15.0, *)
struct ListCellView: View {
    @EnvironmentObject var store: Store
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    @EnvironmentObject var coins: Coin

    let product: Product
    let purchasingEnabled: Bool

    var emoji: String {
        store.emoji(for: product.id)
    }

    init(product: Product, purchasingEnabled: Bool = true) {
        self.product = product
        self.purchasingEnabled = purchasingEnabled
    }

    var body: some View {
        HStack {
            Text(emoji)
                .font(.system(size: 50))
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.trailing, 20)
            if purchasingEnabled {
                productDetail
                Spacer()
                buyButton
                    .buttonStyle(BuyButtonStyle(isPurchased: isPurchased))
                    .disabled(isPurchased)
            } else {
                productDetail
            }
        }
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
    }

    @ViewBuilder
    var productDetail: some View {
        if product.type == .autoRenewable {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .bold()
                Text(product.description)
            }
        } else {
            Text(product.description)
                .frame(alignment: .leading)
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

    var buyButton: some View {
        Button(action: {
            Task {
                await buy()
            }
        }) {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .foregroundColor(.white)
            } else {
                if let subscription = product.subscription {
                    subscribeButton(subscription)
                } else {
                    Text(product.displayPrice)
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
    }

    func buy() async {
        do {
            if let transaction = try await store.purchase(product) {
                guard let coinsString = transaction.productID.split(separator: ".").last,
                      let coinsAmount = Int(coinsString) else { throw StoreError.wrongPurchaseId(id: transaction.productID) }

                withAnimation { coins.amount += coinsAmount }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch let StoreError.wrongPurchaseId(productId) {
            errorTitle = "Could not provide coins with such amount as: \(productId)"
            isShowingError = true
        } catch {
            print("Failed purchase for \(product.id): \(error)")
        }
    }
}