//
//  CardItem.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import SwiftUI

struct CardItem: View {

    let card: ExamCard

    let result: CardResult

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Билет \(card.id)")
                        .font(.system(size: 30))
                    Spacer()
                }
                Spacer()

                // swiftlint:disable force_unwrap
                Text(result.resultHistory.items.isEmpty ? "Начать" : "\(20 - result.resultHistory.items.last!.mistakes.count)/20")
                    .font(.system(size: 25))
                // swiftlint:enable force_unwrap
                Spacer()

                if let date = result.resultHistory.items.last?.examDate {
                    Text(date.prettyPrint)
                        .font(.system(size: 20))
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .frame(height: 200, alignment: .center)
            // swiftlint:disable force_unwrap
            .background(
                RoundedRectangle(cornerRadius: 10)
                // if there's no result — .gray
                // if there is and it's good — .green
                // if there is and it is no go-o-od — .red
                    .foregroundColor(result.resultHistory.items.isEmpty ? .gray : (result.resultHistory.items.last!.succeed ? .green : .red))
            )
            // swiftlint:enable force_unwrap
            Spacer()
        }
    }
}

struct CardItem_Previews: PreviewProvider {

    private static var results: CardResults = {
        var object: CardResults!
        do {
            object = try CardResults()
        } catch {
            object = CardResults(items: { (1...2).map { CardResult(id: $0, resultHistory: Results(items: [])) } }())
        }
        return object
    }()

    static var previews: some View {
        HStack {
            CardItem(card: cards[0], result: results.items[0])
            CardItem(card: cards[1], result: results.items[1])
        }
    }
}
