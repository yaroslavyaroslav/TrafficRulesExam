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
                            Spacer()
                            Text("Билет \(card.id)")
                                .font(.system(size: 30))
                            Spacer()
                            Text("\(20 - card.result.mistakes)/20")
                                .font(.system(size: 25))
                            Spacer()
                            if let date = card.result.examDate {
//                                Text(date.formatted(date: .numeric, time: .omitted))
                                Text(date.description(with: .current))
                                    .font(.system(size: 12))
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 170, height: 200, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.green)
                        )
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
