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

    let updateUITimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State
    var isModalViewPresented = false

    @EnvironmentObject
    var coins: Coin

    var timer: String? {
        guard let initTimeInterval = KeychainWrapper.standard.double(forKey: .ticketUsed) else { return nil }
        guard coins.amount < 5 else { return nil }

        let timerAmount: TimeInterval = 600

        let ticketUsage = Date(timeIntervalSinceReferenceDate: initTimeInterval)
        let currentDate = Date()
        let ticketArrive = ticketUsage.addingTimeInterval(timerAmount)

        if currentDate > ticketArrive {
            let distance = ticketArrive.distance(to: currentDate)
            var multiplyer = 1
            multiplyer += Int(distance) / Int(timerAmount)

            multiplyer += coins.amount

            if multiplyer > 5 { coins.amount = 5; return nil }

            // Add one coin if currentDate pass ticketArrive date
            // Add more coins if currentDate pass ticketArrive date more than 10 minutes.
            coins.amount = multiplyer

            // Multiplyer is not 1 here, it's arithmetic progression.
            // Since timerAmount multiplies on all available coins.
            let newTicketUsageDate = ticketArrive + TimeInterval(multiplyer) * timerAmount
            KeychainWrapper.standard[.ticketUsed] = newTicketUsageDate.timeIntervalSinceReferenceDate
        }
        return Date().secondsLasts(to: ticketArrive)
    }

    let graphHeight: CGFloat = 40

    let maxWidth: CGFloat = 300

    let totalTickets: CGFloat = 20

    var triedTickets: CGFloat {
        // swiftformat:disable --indent --spaceInsideComments

        // 20 билетов - 300px
        // решеноБилетов - х px.
            (CGFloat(results.cardsTried) * maxWidth)
        / //----------------------------------------
                        totalTickets
        // swiftformat:enable --indent
    }

    var successTickets: CGFloat {
        // swiftformat:disable --indent --spaceInsideComments
        // 20 билетов - 300px
        // успешныхБилетов - х px.
            (CGFloat(results.cardsSucceed) * maxWidth)
        / //------------------------------------------
                        totalTickets
        // swiftformat:enable --indent --spaceAroundComments
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text("Монет: \(coins.amount)")

                        Spacer()

                        Button {
                            self.isModalViewPresented = true
                        } label: {
                            Text("Купить")
                        }
                        .sheet(isPresented: $isModalViewPresented) {
                            Purchase(isPresented: $isModalViewPresented)
                        }

                        Spacer()

                        // Прогрессивная шкала плюсования монет: 10:00 -> 20:00 -> 30:00 -> 40:00
                        if let timer = timer {
                            Text("+1: \(timer)")
//                                .onReceive(updateUITimer) { _ in
//
//                                }
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
                    }
                }
            }
        }
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


extension Date {
    func secondsLasts(to nextDate: Date) -> String {
        let newDateSeconds = nextDate.timeIntervalSinceReferenceDate
        let difference = newDateSeconds - self.timeIntervalSinceReferenceDate

        let intervalFormatter = DateComponentsFormatter()
        intervalFormatter.zeroFormattingBehavior = .pad
        intervalFormatter.allowedUnits = [.minute, .second]
        intervalFormatter.unitsStyle = .positional
        return difference >= 0 ? intervalFormatter.string(from: difference)! : "10:00"
    }
}
