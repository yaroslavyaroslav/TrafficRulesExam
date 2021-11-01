//
//  Result.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import Foundation
import SwiftUI


struct Result {
    
    private(set) var mistakes: [Int: AnswerID]
    
    let examDate: Date
    
    var additionalQuestionsFired: Bool { mistakes.count > 0 ? true : false }
    
    var succeed: Bool {
        guard mistakes.count > 0 else { return true }
        
        return mistakes.count > 2 ? false : true
    }
}

extension Result {
    mutating func addMistake(mistake: (Int, AnswerID)) {
        let (questionID, wrongAnswerID) = mistake
        mistakes[questionID] = wrongAnswerID
    }
}

extension Result: Codable { }

struct CardResult {
    let id: Int
    private(set) var resultHistory: [Result]
}

extension CardResult: Codable { }

enum ResultState {
    case undefined, succeed, failed
}
