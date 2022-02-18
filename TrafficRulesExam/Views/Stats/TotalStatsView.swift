//
//  TotalStatsView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import SwiftKeychainWrapper
import SwiftUI

struct TotalStatsView: View {

    var results: CardResults

    var body: some View {
        VStack {
            StatsDiagram(results: results)

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
