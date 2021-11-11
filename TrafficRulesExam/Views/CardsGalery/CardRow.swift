//
//  CardRow.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.10.2021.
//

import SwiftUI

struct CardRow: View {
    
    @State
    var results: CardResults = {
        var object: CardResults!
        UserDefaults.standard.removeObject(forKey: "CardResults")
        do {
            object = try CardResults()
        } catch {
            UserDefaults.standard.removeObject(forKey: UDKeys.cardResults.rawValue)
            object = CardResults(items:{ (1...2).map { CardResult(id: $0, resultHistory: Results(items: [])) } }())
        }
        return object
    }()

    var cards: [ExamCard]
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach($results.items, id: \.id) { $result in
                    /*
                     Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                     Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                     метода @Environment(\.presentationMode) переменной dismiss()
                     */
                    NavigationLink {
                        Card(card: cards.getElementById(id: result.id), result: $result)
                    } label: {
                        CardItem(card: cards.getElementById(id: result.id), result: result)
                    }
                    .navigationTitle(Text("Билеты"))
                    .navigationBarTitleDisplayMode(.large)
                }
            }
        }
    }
}

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        CardRow(cards: cards)
    }
}
