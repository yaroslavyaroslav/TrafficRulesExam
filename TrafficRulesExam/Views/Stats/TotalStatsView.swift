//
//  TotalStatsView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import SwiftKeychainWrapper
import SwiftUI

struct TotalStatsView: View {
    let graphHeight: CGFloat = 40

    let maxWidth: CGFloat = 300

    let totalTickets: CGFloat = 20

    var results: CardResults

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var countdownString: String = ""

    @State var isModalViewPresented = false

    @EnvironmentObject var countdownTimer: CoinsTimer

    @EnvironmentObject var coins: Coin

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
        VStack {
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
                    .cornerRadius(8)
#if DEBUG
                    .onTapGesture(count: 2) {
                        print("drop to 0")
                        coins.amount = 0
                        KeychainWrapper.standard[.ticketUsed] = Date().timeIntervalSinceReferenceDate
                    }
#endif

                    HStack {
                        if successTickets > 0 {
                            Text("Правильно \(results.cardsSucceed)")
                                .foregroundColor(.green)
                            Spacer()
                        }
                        if triedTickets > 0 && triedTickets != successTickets {
                            Text("Решено \(results.cardsTried)/10")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        Text("Всего \(cards.count)")
                            .foregroundColor(.gray)
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

            let notEmptyResult = results.items.filter { !$0.resultHistory.items.isEmpty }
            List {
                ForEach(notEmptyResult, id: \.id) { result in
                    /*
                     Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                     Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                     метода @Environment(\.presentationMode) переменной dismiss()
                     */
                    NavigationLink {
                        ExamCardStatsView(cardResult: result)
                    } label: {
                        HStack {
                            ZStack(alignment: .center) {
                                Circle()
                                Text("\(cards.getElementById(result.id).id)")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)

                            Image(systemName: "info.circle")
                            Text("1")

                            Spacer()
                            Text("\(result.resultHistory.items.last!.mistakes.count)/20")

                            Spacer()
                            Text(result.resultHistory.items.last!.examDate.shortDate)
                        }
                    }
                    .disabled(result.resultHistory.items.isEmpty ? true : false)
                }
            }
        }
    }

    private func updateTimer() {
        countdownString = countdownTimer.calculateCoundownTimerText()
    }
}

struct TotalStats_Previews: PreviewProvider {
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
        TotalStatsView(results: results)
            .environmentObject(Coin())
    }
}
