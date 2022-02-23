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

    let cardHeight: CGFloat = 172

    let insideHorisontalPadding: CGFloat = 10

    var body: some View {
        let succeed = result.resultHistory.items.last?.succeed ?? false

        if result.resultHistory.items.isEmpty {
            emptyItem
                .defaultShadow()
        } else if succeed {
            succeedItem
                .defaultShadow()
        } else {
            failedItem
                .defaultShadow()
        }
    }

    var succeedItem: some View {
        HStack {
            VStack {
                HStack {
                    Text("Билет \(card.id)")
                        .font(UIFont.sfBodySemibold.asFont)
                        .foregroundColor(.DS.bgLightPrimary)

                    Spacer()
                    statsButton
                        .font(.system(size: 22))
                }
                .padding(.top)
                .padding(.horizontal, insideHorisontalPadding)

                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.DS.bgLightPrimary)
                            .opacity(0.1)
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 24))
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, insideHorisontalPadding * 2)
                .padding(.bottom, 20)

                HStack {
                    Image("Coin")
                    Text("1")
                        .font(UIFont.sfFootnote.asFont)
                    Spacer()
                    Text("Вчера")
                        .font(UIFont.sfFootnote.asFont)
                        .opacity(0.8)
                }
                .padding(.horizontal, insideHorisontalPadding)

                Spacer()
            }
            .foregroundColor(.DS.bgLightPrimary)
            .frame(height: cardHeight, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.DS.tintsGreenLight)
            )
        }
    }

    var failedItem: some View {
        HStack {
            VStack {
                HStack {
                    Text("Билет \(card.id)")
                        .font(UIFont.sfBodySemibold.asFont)
                        .foregroundColor(.DS.greysGrey3Dark)
                    Spacer()
                    statsButton
                        .font(.system(size: 22))
                        .foregroundColor(.DS.tintsPurpleLight)
                }
                .padding(.top)
                .padding(.horizontal, insideHorisontalPadding)

                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.DS.tintsPinkLight)
                            .opacity(0.08)
                        Text("\(result.resultHistory.items.last!.mistakes.count.description)/20")
                            .foregroundColor(.DS.tintsPinkLight)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, insideHorisontalPadding * 2)
                .padding(.bottom, 20)

                HStack {
                    Image("Coin")
                    Text("1")
                        .font(UIFont.sfFootnote.asFont)
                    Spacer()
                    Text("Вчера")
                        .font(UIFont.sfFootnote.asFont)
                        .opacity(0.8)
                }
                .foregroundColor(.DS.bgDarkBasePrimary)
                .padding(.horizontal, insideHorisontalPadding)

                Spacer()
            }
            .foregroundColor(.white)
            .frame(height: cardHeight, alignment: .center)
            .roundBorder(Color.DS.bgLightSecondary, width: 1, cornerRadius: 12)
            .background(Color.DS.bgLightPrimary)
        }
    }

    var emptyItem: some View {
        HStack {
            VStack {
                HStack {
                    Text("Билет \(card.id)")
                        .font(UIFont.sfBodySemibold.asFont)
                        .foregroundColor(.DS.greysGrey3Dark)
                    Spacer()
                    Image("Coin")
                        .font(.system(size: 22))
                        .hidden()
                }
                .padding(.top)
                .padding(.horizontal, insideHorisontalPadding)

                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.DS.tintsPurpleLight, lineWidth: 2)

                        Text("Начать")
                            .foregroundColor(.DS.tintsPurpleLight)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, insideHorisontalPadding * 2)
                .padding(.bottom, 20)

                HStack {
                    Image("Coin")
                    Text("1")
                        .font(UIFont.sfFootnote.asFont)
                    Spacer()
                }
                .foregroundColor(.DS.bgDarkBasePrimary)
                .padding(.horizontal, insideHorisontalPadding)

                Spacer()
            }
            .foregroundColor(.white)
            .frame(height: cardHeight, alignment: .center)
            .roundBorder(Color.DS.bgLightSecondary, width: 1, cornerRadius: 12)
            .background(Color.DS.bgLightPrimary)
        }
    }

    var statsButton: some View {
        NavigationLink {
            ExamCardStatsView(cardResult: result)
        } label: {
            Image(systemName: "info.circle")
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
