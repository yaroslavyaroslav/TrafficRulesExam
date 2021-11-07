//
//  CardItem.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import SwiftUI

struct CardItem: View {
    
    let card: ExamCard
    
    let results: CardResult
    
    var body: some View {
        VStack {
            Spacer()
            Text("Билет \(card.id)")
                .font(.system(size: 30))
            Spacer()
            
            Text(results.resultHistory.items.isEmpty ? "Начать" : "\(20 - results.resultHistory.items.last!.mistakes.count)/20")
                .font(.system(size: 25))
            Spacer()
            
            if let date = results.resultHistory.items.last?.examDate {
                Text(self.prettyDate(date))
                    .font(.system(size: 20))
                Spacer()
            }
        }
        .foregroundColor(.white)
        .frame(width: 170, height: 200, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                // if there's no result — .gray
                // if there is and it's good — .green
                // if there is and it is no go-o-od — .red
                .foregroundColor(results.resultHistory.items.isEmpty ? .gray : (results.resultHistory.items.last!.succeed ? .green : .red))
        )
    }
}

extension CardItem {
    private func prettyDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "RU_ru")
        return dateFormatter.string(from: date)
    }
}

struct CardItem_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
//            CardItem(card: cards[0])
//            CardItem(card: cards[1])
        }
    }
}
