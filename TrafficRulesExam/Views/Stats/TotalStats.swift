//
//  TotalStats.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import SwiftKeychainWrapper
import SwiftUI

struct TotalStats: View {
    var results: CardResults

    @State
    var countdownString: String = ""

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State
    var isModalViewPresented = false

    @EnvironmentObject
    var countdownTimer: CoinsTimer

    @EnvironmentObject
    var coins: Coin

    let graphHeight: CGFloat = 40

    let maxWidth: CGFloat = 300

    let totalTickets: CGFloat = 20

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

                        Button {
                            self.isModalViewPresented = true
                        } label: {
                            Text("Купить")
                                .frame(width: 80)
                        }
                        .sheet(isPresented: $isModalViewPresented) {
                            Purchase(isPresented: $isModalViewPresented)
                        }


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

            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(results.items, id: \.id) { result in
                        /*
                         Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                         Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                         метода @Environment(\.presentationMode) переменной dismiss()
                         */
                        NavigationLink {
                            ExamCardStats(cardResult: result)
                        } label: {
                            CardItem(card: cards.getElementById(result.id), result: result)
                        }
                        .disabled(result.resultHistory.items.isEmpty ? true : false)
                    }
                }
            }
        }
    }

    private func updateTimer() {
        self.countdownString = countdownTimer.calculateCoundownTimerText()
    }
}

struct TotalStats_Previews: PreviewProvider {
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
        TotalStats(results: results)
            .environmentObject(Coin())
    }
}
