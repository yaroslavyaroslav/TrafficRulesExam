//
//  CardResultCell.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 24.02.2022.
//

import SwiftUI

struct CardResultCell: View {

    let cardId: Int
    
    let result: Result

    var body: some View {
        if result.succeed {
            succeessCell(result: result)
        } else {
            failedCell(result: result)
        }
    }

    private func succeessCell(result: Result) -> some View {
        HStack(alignment: .center) {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.DS.tintsGreenLight, lineWidth: 1)
                    .foregroundColor(.clear)
                Text("\(cardId)")
                    .font(UIFont.sfBody.asFont)
                    .foregroundColor(.DS.tintsGreenLight)
            }
            .frame(width: 44, height: 44)

            Spacer()

            Image("SuccessSign")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)

            Spacer()
            Text(result.examDate.relativeDate)
                .font(UIFont.sfFootnote.asFont)
        }
    }

    private func failedCell(result: Result) -> some View {
        HStack {
            ZStack(alignment: .center) {
                Circle()
                Text("\(cardId)")
                    .font(UIFont.sfBody.asFont)
                    .foregroundColor(.white)
            }
            .foregroundColor(.DS.tintsPinkLight)
            .frame(width: 44, height: 44)

            Spacer()
            Text("\(result.mistakes.count)/20")
                .font(UIFont.sfTitle1.asFont)
                .foregroundColor(.DS.tintsPinkDark)

            Spacer()
            Text(result.examDate.relativeDate)
                .font(UIFont.sfFootnote.asFont)
        }
    }
}

struct CardResultCell_Previews: PreviewProvider {
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
        CardResultCell(cardId: 1, result: results.items[1].resultHistory.items[1])
        CardResultCell(cardId: 2, result: results.items[1].resultHistory.items[0])
    }
}
