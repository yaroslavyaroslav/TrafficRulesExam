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
        VStack(spacing: 0) {
            StatsDiagram(results: results)
                .padding(16)
                .background(Color.DesignSystem.bgLightPrimary)
                .cornerRadius(16)

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
                        if result.resultHistory.items.last!.succeed {
                            succeessCell(result: result)
                        } else {
                            failedCell(result: result)
                        }
                    }

                }
            }
            .listStyle(DefaultListStyle())
        }
        .background(Color.DesignSystem.defaultLightBackground.ignoresSafeArea())
    }



    private func succeessCell(result: CardResult) -> some View {
        HStack(alignment: .center) {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.DesignSystem.tintsGreenLight, lineWidth: 1)
                    .foregroundColor(.clear)
                Text("\(cards.getElementById(result.id).id)")
                    .font(UIFont.sfBody.asFont)
                    .foregroundColor(.DesignSystem.tintsGreenLight)
            }
            .frame(width: 44, height: 44)

            Spacer()

            Image("SuccessSign")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)

            Spacer()
            Text(result.resultHistory.items.last!.examDate.shortDate)
                .font(UIFont.sfFootnote.asFont)
                .foregroundColor(.DesignSystem.greysGrey3Dark)
        }
    }

    private func failedCell(result: CardResult) -> some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                Text("\(cards.getElementById(result.id).id)")
                    .font(UIFont.sfBody.asFont)
                    .foregroundColor(.white)
            }
            .foregroundColor(.DesignSystem.tintsPinkLight)
            .frame(width: 44, height: 44)

            Spacer()
            Text("\(result.resultHistory.items.last!.mistakes.count)/20")
                .font(UIFont.sfTitle1.asFont)
                .foregroundColor(.DesignSystem.tintsPinkDark)

            Spacer()
            Text(result.resultHistory.items.last!.examDate.shortDate)
                .font(UIFont.sfFootnote.asFont)
                .foregroundColor(.DesignSystem.greysGrey3Dark)
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
