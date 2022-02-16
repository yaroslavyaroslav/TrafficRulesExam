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

    let cardHeight: CGFloat = 200

    let insideHorisontalPadding: CGFloat = 10

    var body: some View {
        let succeed = result.resultHistory.items.last?.succeed ?? false

        if result.resultHistory.items.isEmpty {
            emptyItem
        } else if succeed {
            succeedItem
        } else {
            failedItem
        }
    }

    var succeedItem: some View {
        HStack {
            VStack {
                HStack {
                    Text("Билет \(card.id)")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                }
                .padding(.top)
                .padding(.horizontal, insideHorisontalPadding)

                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.blue)
                        Image(systemName: "info.circle")
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, insideHorisontalPadding * 2)
                .padding(.bottom, 20)

                HStack {
                    Image(systemName: "info.circle")
                    Text("1")
                    Spacer()
                    Text("Вчера")
                }
                .padding(.horizontal, insideHorisontalPadding)

                Spacer()
            }
            .foregroundColor(.white)
            .frame(height: cardHeight, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.green)
            )
        }
    }

    var failedItem: some View {
        HStack {
            VStack {
                HStack {
                    Text("Билет \(card.id)")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
                .padding(.top)
                .padding(.horizontal, insideHorisontalPadding)

                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.red)
                        Text("\(result.resultHistory.items.last?.mistakes.count.description ?? "")/20")
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, insideHorisontalPadding * 2)
                .padding(.bottom, 20)

                HStack {
                    Image(systemName: "info.circle")
                    Text("1")
                    Spacer()
                    Text("Вчера")
                }
                .foregroundColor(.black)
                .padding(.horizontal, insideHorisontalPadding)

                Spacer()
            }
            .foregroundColor(.white)
            .frame(height: cardHeight, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
            )
        }
    }

    var emptyItem: some View {
        HStack {
            VStack {
                HStack {
                    Text("Билет \(card.id)")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                        .hidden()
                }
                .padding(.top)
                .padding(.horizontal, insideHorisontalPadding)

                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.purple)
                        Text("Начать")
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, insideHorisontalPadding * 2)
                .padding(.bottom, 20)

                HStack {
                    Image(systemName: "info.circle")
                    Text("1")
                    Spacer()
                }
                .foregroundColor(.black)
                .padding(.horizontal, insideHorisontalPadding)

                Spacer()
            }
            .foregroundColor(.white)
            .frame(height: cardHeight, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
            )
        }
    }
}

struct CardItem_Previews: PreviewProvider {
    private static var results: CardResults = {
        var object = CardResults(items: (1...3).map { CardResult(id: $0, resultHistory: Results(items: [])) })

        let resultSuccess = Result(mistakes: [], examDate: Date())
        let resultFailed = Result(mistakes: [
            Mistake(id: 2, wrongAnswer: .a),
            Mistake(id: 3, wrongAnswer: .a),
            Mistake(id: 4, wrongAnswer: .a)
        ], examDate: Date())

        object.items[1].resultHistory.items.append(resultSuccess)
        object.items[2].resultHistory.items.append(resultFailed)

        return object
    }()

    static var previews: some View {
        VStack {
            HStack {
                CardItem(card: cards[0], result: results.items[0])
                CardItem(card: cards[1], result: results.items[1])
            }

            HStack {
                CardItem(card: cards[2], result: results.items[2])
                CardItem(card: cards[2], result: results.items[2])
            }
        }
    }
}
