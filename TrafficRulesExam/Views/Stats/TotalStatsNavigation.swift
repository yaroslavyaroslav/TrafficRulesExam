//
//  TotalStatsNavigation.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct TotalStatsNavigation: View {
    
    @State
    var results: CardResults = {
        var object: CardResults!
        do {
            object = try CardResults()
        } catch {
            object = CardResults(items:{ (1...2).map { CardResult(id: $0, resultHistory: Results(items: [])) } }())
        }
        return object
    }()
    
    
    
    var cards: [ExamCard]
    
    var body: some View {
        NavigationView {
            TotalStats(results: results)
        }
    }
}

struct Stats_Previews: PreviewProvider {
    static var previews: some View {
        TotalStatsNavigation(cards: cards)
    }
}

