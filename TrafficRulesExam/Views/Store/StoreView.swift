//
//  StoreView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//

import SwiftUI
import StoreKit

@available (iOS 15.0, *)
struct StoreView: View {
    @StateObject
    var store: Store = Store()

    var body: some View {
        List {
            Section(header: Text("Cars")) {
                ForEach(store.fuel, id: \.id) { car in
                    ListCellView(product: car)
                }
            }
            .listStyle(GroupedListStyle())

            SubscriptionsView()
        }
        .environmentObject(store)
    }
}
