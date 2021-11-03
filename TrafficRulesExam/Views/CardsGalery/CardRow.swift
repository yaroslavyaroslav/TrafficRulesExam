//
//  CardRow.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.10.2021.
//

import SwiftUI

struct CardRow: View {
    
    @AppStorage("ResultData")
    var results: [CardResult] = { (1...2).map { CardResult($0, Results([])) } }()
    
    var cards: [ExamCard]
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(results, id: \.id) { result in
                    NavigationLink {
                        Card(card: cards[0], result: result)
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
