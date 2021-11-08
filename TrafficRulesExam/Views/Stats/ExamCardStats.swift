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
                VStack {
                    Text("\(result.examDate)")
                    Text("\(20 - result.mistakes.count)/20")
                }
            }
        }
    }
}

struct ExamCardStats_Previews: PreviewProvider {
    static var results: CardResults = {
        var object: CardResults!
        do {
            object = try CardResults()
        } catch {
            object = CardResults(items:{ (1...2).map { CardResult(id: $0, resultHistory: Results(items: [])) } }())
        }
        return object
    }()
    
    static var previews: some View {
        ExamCardStats(cardResult: results.items[0])
    }
}
