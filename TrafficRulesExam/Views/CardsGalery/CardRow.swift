//
//  CardRow.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.10.2021.
//

import SwiftUI

struct CardRow: View {
    
    @AppStorage("ResultData")
    var results: [CardResult] = {
        (1...20).map { CardResult(id: $0, resultHistory: [Result]()) }
    }()
    
    var cards: [ExamCard]
    
    var body: some View {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(cards, id: \.id) { card in
                    NavigationLink {
                        Card(card: card)
                    } label: {
                        CardItem(card: card, results: results[0])
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
