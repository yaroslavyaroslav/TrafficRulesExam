//
//  CardItem.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import SwiftUI

struct CardItem: View {
    
    var card: ExamCard
        
    var body: some View {
        VStack {
            Spacer()
            Text("Билет \(card.id)")
                .font(.system(size: 30))
            Spacer()
            
            if let result = card.results.last {
                Text("\(20 - result.mistakes)/20")
                    .font(.system(size: 25))
                Spacer()
                
                if let date = result.examDate {
                    Text(self.prettyDate(date))
                        .font(.system(size: 20))
                    Spacer()
                }
            } else {
                Text("0/20")
                    .font(.system(size: 25))
            }
        }
        .foregroundColor(.white)
        .frame(width: 170, height: 200, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(card.results[0].succeed ? .green : .red)
        )
    }
}


extension CardItem {
    private func prettyDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "RU_ru")
        return dateFormatter.string(from: date)
    }
}

struct CardItem_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CardItem(card: cards[0])
            CardItem(card: cards[1])
        }
    }
}
