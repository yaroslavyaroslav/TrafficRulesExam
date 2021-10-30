//
//  Result.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import Foundation


enum ResultState {
    case unknown, succeed, failed
}

struct Result {
    let mistakes: Int
    let examDate: Date?
    
    var additionalQuestionsFired: Bool {
        mistakes > 0 ? true : false
    }
    
    var succeed: Bool {
        guard mistakes > 0 else {
            return true
        }
        return mistakes > 2 ? false : true
    }
    
    var state: ResultState {
        guard let _ = examDate else {
            return .unknown
        }
        
        if succeed {
            return .succeed
        } else {
            return .failed
        }
    }
}

extension Result: Codable { }
