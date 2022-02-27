//
//  StatsDiagram.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 18.02.2022.
//

import SwiftKeychainWrapper
import SwiftUI

struct StatsDiagram: View {

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var results: CardResults

    let maxWidth: CGFloat = 300

    let graphHeight: CGFloat = 20

    let totalTickets: CGFloat = 20

    @State var countdownString: String = ""

    @EnvironmentObject var coins: Coin

    @EnvironmentObject var countdownTimer: CoinsTimer


    var triedTickets: CGFloat {
        // swiftformat:disable --indent --spaceInsideComments

        // 20 билетов - 300px
        // решеноБилетов - х px.
            (CGFloat(results.cardsTried) * maxWidth) /
        //------------------------------------------
                        totalTickets
        // swiftformat:enable --indent
    }

    var successTickets: CGFloat {
        // swiftformat:disable --indent --spaceInsideComments
        // 20 билетов - 300px
        // успешныхБилетов - х px.
            (CGFloat(results.cardsSucceed) * maxWidth) /
        //--------------------------------------------
                        totalTickets
        // swiftformat:enable --indent --spaceAroundComments
    }

    var body: some View {
        HStack {
            VStack(spacing: 15) {
                HStack {
                    Text("Монет: \(coins.amount)")
                        .font(UIFont.sfTitle3.asFont)
                        .foregroundColor(.DS.greysGrey3Dark)
                    
                    Spacer()

                    // Прогрессивная шкала плюсования монет: 10:00 -> 20:00 -> 30:00 -> 40:00
                    if !countdownString.isEmpty {
                        Spacer()
                        Image("Coin")
                        Text("+1: \(countdownString)")
                            .font(UIFont.sfCaption.asFont)
                    } else {
                        EmptyView()
                    }
                }

                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .frame(width: maxWidth, height: graphHeight)
                        .foregroundColor(.DS.greysGrey6Light)
                    Rectangle()
                        .frame(width: triedTickets, height: graphHeight)
                        .foregroundColor(.DS.tintsPinkLight)
                    Rectangle()
                        .frame(width: successTickets, height: graphHeight)
                        .foregroundColor(.DS.tintsGreenLight)
                }
                .cornerRadius(16)
#if DEBUG
                .onTapGesture(count: 2) {
                    print("drop to 0")
                    coins.amount = 0
                    KeychainWrapper.standard[.ticketUsed] = Date().timeIntervalSinceReferenceDate
                }
#endif

                HStack {
                    if successTickets > 0 {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Правильно")
                                .font(UIFont.sfCaption.asFont)
                            Text("\(results.cardsSucceed)")
                                .font(UIFont.sfCallout.asFont)
                                .foregroundColor(.DS.tintsGreenLight)
                        }
                        Spacer()

                    }
                    if triedTickets > 0 && triedTickets != successTickets {
                        VStack(alignment: .center, spacing: 2) {
                            Text("Решено")
                                .font(UIFont.sfCaption.asFont)
                            Text("\(results.cardsTried)")
                                .font(UIFont.sfCallout.asFont)
                                .foregroundColor(.DS.tintsPinkLight)
                        }
                        Spacer()
                    }
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Всего")
                            .font(UIFont.sfCaption.asFont)
                        Text(" \(cards.count)")
                            .font(UIFont.sfCallout.asFont)
                            .foregroundColor(.DS.greysGrey2Dark)
                    }
                    if successTickets == 0 && triedTickets == 0 {
                        Spacer()
                    }
                }
            }
            .onReceive(timer) { _ in
                withAnimation {
                    updateTimer()
                }
            }
        }
        .frame(width: maxWidth)
    }

    private func updateTimer() {
        countdownString = countdownTimer.calculateCoundownTimerText()
    }
}

struct StatsDiagram_Previews: PreviewProvider {
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
        StatsDiagram(results: results)
            .environmentObject(Coin())
    }
}
