//
//  ProductCellView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//
import StoreKit
import SwiftUI

@available(iOS 15.0, *)
struct ProductCellView: View {
    @EnvironmentObject var store: Store
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    @Binding var isPresented: Bool
    @EnvironmentObject var coins: Coin

    let product: Product
    let purchasingEnabled: Bool

    init(product: Product, isPresented: Binding<Bool>, purchasingEnabled: Bool = true) {
        self.product = product
        self._isPresented = isPresented
        self.purchasingEnabled = purchasingEnabled
    }

    var body: some View {
        HStack {
            Image(systemName: "coloncurrencysign.circle.fill")
//                .font(.system(size: 50))
                .frame(width: 34)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.trailing, 20)
            if purchasingEnabled {
                productDetail
                Spacer()
                buyButton
                    .buttonStyle(BuyButtonStyle(isPurchased: isPurchased))
            } else {
                productDetail
            }
        }
        .alert(isPresented: $isShowingError) {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        }
    }

    @ViewBuilder
    var productDetail: some View {
        VStack(alignment: .leading) {
            Text(product.description)
                .bold()
            Text(product.displayName)
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
        Button {
            Task { await buy() }
        } label: {
            if let subscription = product.subscription {
                subscribeButton(subscription)
            } else {
                Text(product.displayPrice)
                    .foregroundColor(.white)
                    .bold()
            }
        }
    }

    func buy() async {
        do {
            if let transaction = try await store.purchase(product) {
                // FIXME: Working only with coins purchase, not working with subscription.
                guard let coinsString = transaction.productID.split(separator: ".").last,
                      let coinsAmount = UInt(coinsString) else { throw StoreError.wrongPurchaseId(id: transaction.productID) }

                withAnimation {
                    coins.amount += coinsAmount
                    isPresented = false
                }
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
