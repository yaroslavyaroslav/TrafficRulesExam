//
//  StoreView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.01.2022.
//

import StoreKit
import SwiftUI

@available(iOS 15.0, *)
struct StoreView: View {
    @EnvironmentObject var store: Store

    @Binding var isPresented: Bool

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