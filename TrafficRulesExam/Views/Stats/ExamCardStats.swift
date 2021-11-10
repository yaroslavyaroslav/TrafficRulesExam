//
//  ExamCardStats.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct ExamCardStats: View {
    
    var cardResult: CardResult
    
    var body: some View {
        List(cardResult.resultHistory.items.reversed()) { result in
            NavigationLink {
                ExamStats(result: result)
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Результат: \(result.succeed ? "Успешно" : "Не успешно") (\(20 - result.mistakes.count) из 20)")
                        Spacer()
                    }
                    HStack {
                        Text("Дата: \(result.examDate.prettyPrint)")
                        Spacer()
                    }
                }
            }
            .listRowBackground(result.succeed ? Color.green : Color.red)
        }
    }
}

struct ExamCardStats_Previews: PreviewProvider {
    static var results: CardResults = {
        let results = (1...2).map { id -> CardResult in
            let mistakes = [1: AnswerID.b, 10: AnswerID.c, 15: AnswerID.a]
            let results = (1...3).map { idx -> Result in
                if idx == 2 {
                    return Result(mistakes: [:], examDate: Date())
                } else {
                    return Result(mistakes: mistakes, examDate: Date())
                }
            }
            return CardResult(id: id, resultHistory: Results(items: results))
        }
        
        return CardResults(items: results)
    }()
    
    static var previews: some View {
        ExamCardStats(cardResult: results.items[0])
    }
}
