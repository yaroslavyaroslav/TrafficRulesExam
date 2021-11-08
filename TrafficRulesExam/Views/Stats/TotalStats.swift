//
//  TotalStats.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct TotalStats: View {
    
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
        NavigationView {
            
            VStack {
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        Rectangle()
                            .frame(width: 200, height: 40)
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(width: 150, height: 40)
                            .foregroundColor(.red)
                        Rectangle()
                            .frame(width: 100, height: 40)
                            .foregroundColor(.green)
                    }
                    .cornerRadius(8)
                    VStack {
                        Text("20 Билетов")
                        Text("от 01.10.2021")
                    }
                }
                .frame(height: 180)
                let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
                HStack {
                    Text("Билеты")
                        .padding()
                        .font(.largeTitle)
                    Spacer()
                }
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach($results.items, id: \.id) { $result in
                            /*
                             Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                             Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                             метода @Environment(\.presentationMode) переменной dismiss()
                             */
                            NavigationLink {
                                ExamCardStats(cardResult: result)
                            } label: {
                                CardItem(card: cards.getElementById(id: result.id), results: result)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Stats_Previews: PreviewProvider {
    static var previews: some View {
        TotalStats(cards: cards)
    }
}
