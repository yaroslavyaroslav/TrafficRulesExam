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
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            StatsDiagram(results: results)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background()
                .roundBorder(colorScheme == .light ? Color.DS.bgLightSecondary : Color.DS.greysGrey4Dark, width: 1, cornerRadius: 12)
                .defaultShadow()
            
            let notEmptyResult = results.items.filter { !$0.resultHistory.items.isEmpty }
            
            List(notEmptyResult, id: \.id) { result in
                /*
                 Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                 Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                 метода @Environment(\.presentationMode) переменной dismiss()
                 */
                NavigationLink {
                    ExamCardStatsView(cardResult: result)
                } label: {
                    CardResultCell(result: result)
                }
                .listRowBackground(Color.clear)
            }
            .listSectionSeparator(.hidden, edges: .all)
            .listStyle(.inset)
            
        }
        .background()
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
