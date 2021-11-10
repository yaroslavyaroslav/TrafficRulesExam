//
//  TotalStats.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import SwiftUI

struct TotalStats: View {
    
    var results: CardResults
    
    let graphHeight: CGFloat = 40
    
    let maxWidth: CGFloat = 300
    
    let totalTickets: CGFloat = 20
    
    var triedTickets: CGFloat {
        // 20 билетов - 300px
        // решеноБилетов - х px.
        (CGFloat(results.cardsTried) * maxWidth) / totalTickets
    }
    
    var successTickets: CGFloat {
        (CGFloat(results.cardsSucceed) * maxWidth) / totalTickets
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .frame(width: maxWidth, height: graphHeight)
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(width: triedTickets, height: graphHeight)
                            .foregroundColor(.red)
                        Rectangle()
                            .frame(width: successTickets, height: graphHeight)
                            .foregroundColor(.green)
                    }
                    .cornerRadius(8)
                    .padding()
                    
                    HStack {
                        if successTickets > 0 {
                            Text("Правильно \(results.cardsSucceed)")
                                .foregroundColor(.green)
                            Spacer()
                        }
                        if triedTickets > 0 && triedTickets != successTickets {
                            Text("Решено \(results.cardsTried)")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        Text("Всего \(cards.count)")
                            .foregroundColor(.gray)
                        if successTickets == 0 && triedTickets == 0 {
                            Spacer()
                        }
                    }
                    Text("\(results.items.count.description) билетов от 01.10.2021")
                        .padding()
                }
            }
            .frame(width: maxWidth)
            
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
            HStack {
                Text("Билеты")
                    .padding()
                    .font(.largeTitle)
                Spacer()
            }
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(results.items, id: \.id) { result in
                        /*
                         Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                         Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                         метода @Environment(\.presentationMode) переменной dismiss()
                         */
                        NavigationLink {
                            ExamCardStats(cardResult: result)
                        } label: {
                            CardItem(card: cards.getElementById(id: result.id), result: result)
                        }
                    }
                }
            }
        }
    }
}


struct TotalStats_Previews: PreviewProvider {
    
    private static var results: CardResults = {
        var object: CardResults!
        do {
            object = try CardResults()
        } catch {
            object = CardResults(items:{ (1...2).map { CardResult(id: $0, resultHistory: Results(items: [])) } }())
        }
        return object
    }()
    
    static var previews: some View {
        TotalStats(results: results)
    }
}
