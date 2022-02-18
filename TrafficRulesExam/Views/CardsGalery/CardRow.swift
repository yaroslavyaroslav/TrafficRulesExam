//
//  CardRow.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.10.2021.
//

import SwiftUI

struct CardRow: View {
    @EnvironmentObject
    var coins: Coin

    @State
    var results: CardResults = {
        var object: CardResults!

        do {
            object = try CardResults()
        } catch {
            UserDefaults.standard.removeObject(forKey: UDKeys.cardResults.rawValue)
            object = CardResults(items: (1...(cards.count)).map { CardResult(id: $0, resultHistory: Results(items: [])) })
        }
        return object
    }()

    var locCards: [ExamCard]

    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 160, maximum: 170)), count: 2)

        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach($results.items, id: \.id) { $result in
                    /*
                     Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                     Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                     метода @Environment(\.presentationMode) переменной dismiss()
                     */
                    NavigationLink {
                        TicketView(card: locCards.getElementById(result.id), result: $result)
                    } label: {
                        CardItem(card: locCards.getElementById(result.id), result: result)
                    }
                    .navigationTitle(Text("Билеты"))
                    .navigationBarTitleDisplayMode(.large)
                    // TODO: Make views blurred or transparent.
                    .disabled(coins.amount <= 0 ? true : false)
                }
            }
            .background(Color.DesignSystem.defaultLightBackground)
        }
    }
}

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        CardRow(locCards: cards)
            .environmentObject(Coin())
    }
}
