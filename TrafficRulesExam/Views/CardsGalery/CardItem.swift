//
//  CardItem.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import SwiftUI

struct CardItem: View {
    
    var card: ExamCard
    
    // FIXME: Результаты из массива должны стать объектом с ID (билета) и массивом результатов.
    @AppStorage("ResultData") var results: [Result] = [Result]()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Билет \(card.id)")
                .font(.system(size: 30))
            Spacer()
            
            Text(results.isEmpty ? "Начать" : "\(20 - results.last!.mistakes.count)/20")
                .font(.system(size: 25))
            Spacer()
            
            if let date = results.last?.examDate {
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
                .foregroundColor(results.isEmpty ? .gray : (results.last!.succeed ? .green : .red))
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
