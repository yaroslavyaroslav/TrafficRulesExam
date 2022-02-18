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
            VStack {
                HStack {
                    Text("Монет: \(coins.amount)")
                        .frame(width: 80)

                    Spacer()

                    // Прогрессивная шкала плюсования монет: 10:00 -> 20:00 -> 30:00 -> 40:00
                    if !countdownString.isEmpty {
                        Spacer()
                        Text("+1: \(countdownString)")
                            .frame(width: 80)
                    } else {
                        EmptyView()
                    }
                }
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
                .cornerRadius(16)
                .padding(.bottom, 15)
#if DEBUG
                .onTapGesture(count: 2) {
                    print("drop to 0")
                    coins.amount = 0
                    KeychainWrapper.standard[.ticketUsed] = Date().timeIntervalSinceReferenceDate
                }
#endif

                HStack {
                    if successTickets > 0 {
                        VStack(alignment: .leading) {
                            Text("Правильно")
                                .padding(.bottom, 5)
                            Text("\(results.cardsSucceed)")
                                .foregroundColor(.green)
                        }
                        Spacer()

                    }
                    if triedTickets > 0 && triedTickets != successTickets {
                        VStack(alignment: .center) {
                            Text("Решено")
                                .padding(.bottom, 5)
                            Text("\(results.cardsTried)")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    VStack(alignment: .trailing) {
                        Text("Всего")
                            .padding(.bottom, 5)
                        Text(" \(cards.count)")
                            .foregroundColor(.gray)
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
