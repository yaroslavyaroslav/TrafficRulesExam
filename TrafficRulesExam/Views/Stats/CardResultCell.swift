//
//  CardResultCell.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 24.02.2022.
//

import SwiftUI

struct CardResultCell: View {

    let result: CardResult

    var body: some View {
        if result.resultHistory.items.last!.succeed {
            succeessCell(result: result)
        } else {
            failedCell(result: result)
        }
    }

    private func succeessCell(result: CardResult) -> some View {
        HStack(alignment: .center) {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.DS.tintsGreenLight, lineWidth: 1)
                    .foregroundColor(.clear)
                Text("\(cards.getElementById(result.id).id)")
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
            Text(result.resultHistory.items.last!.examDate.relativeDate)
                .font(UIFont.sfFootnote.asFont)
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
            .foregroundColor(.DS.tintsPinkLight)
            .frame(width: 44, height: 44)

            Spacer()
            Text("\(result.resultHistory.items.last!.mistakes.count)/20")
                .font(UIFont.sfTitle1.asFont)
                .foregroundColor(.DS.tintsPinkDark)

            Spacer()
            Text(result.resultHistory.items.last!.examDate.relativeDate)
                .font(UIFont.sfFootnote.asFont)
        }
    }
}

//struct CardResultCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CardResultCell(result: <#T##CardResult#>)
//    }
//}
