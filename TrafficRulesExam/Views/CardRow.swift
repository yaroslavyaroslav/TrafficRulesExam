//
//  CardRow.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.10.2021.
//

import SwiftUI

struct CardRow: View {
    
    var cards: [ExamCard]
    
    var body: some View {
    
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(cards, id: \.self) { card in
                    NavigationLink {
                        Card(card: card)
                    } label: {
                        VStack {
                            Text("1/20")
                            Text("10.09.2021")
                            Text("Билет \(card.id)")
                        }
                        .frame(width: 170, height: 200, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue)
                                        .foregroundColor(.green))
                    }

                }
            }.font(.largeTitle)
        }
    }
}

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        CardRow(cards: cards)
    }
}
