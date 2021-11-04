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
        do {
            object = try CardResults()
        } catch {
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
                    NavigationLink {
                        Card(card: cards[0], result: $result)
                    } label: {
                        CardItem(card: cards[0], results: result)
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
