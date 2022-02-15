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
            VStack {
                let horisontalPadding: CGFloat = 10
                HStack {
                    Text("Билет \(card.id)")
                        .font(.system(size: 17))
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                }
                .padding(.top)
                .padding(.horizontal, horisontalPadding)
                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.green)
                        Image(systemName: "info.circle")
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, horisontalPadding * 2)
                .padding(.bottom, 20)

                HStack {
                    Image(systemName: "info.circle")
                    Text("1")
                    Spacer()
                    Text(result.resultHistory.items.last?.examDate.prettyPrint ?? "Вчера")
                }
                .padding(.horizontal, horisontalPadding)

                Spacer()

//                Text(result.resultHistory.items.isEmpty ? "Начать" : "\(20 - result.resultHistory.items.last!.mistakes.count)/20")
//                    .font(.system(size: 25))
//                Spacer()
//
//                if let date = result.resultHistory.items.last?.examDate {
//                    Text(date.prettyPrint)
//                        .font(.system(size: 20))
//                    Spacer()
//                }
            }
            .foregroundColor(.white)
            .frame(height: 200, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    // if there's no result — .gray
                    // if there is and it's good — .green
                    // if there is and it is no go-o-od — .red
                    .foregroundColor(result.resultHistory.items.isEmpty
                        ? .gray
                        : (result.resultHistory.items.last!.succeed
                            ? .green
                            : .red
                        )
                    )
            )
        }
    }
}

struct CardItem_Previews: PreviewProvider {
    private static var results: CardResults = {
        var object: CardResults!
        do {
            object = try CardResults()
        } catch {
            object = CardResults(items: (1...2).map { CardResult(id: $0, resultHistory: Results(items: [])) })
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
