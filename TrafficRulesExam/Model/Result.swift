//
//  Result.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import Foundation
import SwiftUI


struct Result {
    
    let mistakes: [Int: Int]
    
    let examDate: Date
    
    var additionalQuestionsFired: Bool { mistakes.count > 0 ? true : false }
    
    var succeed: Bool {
        guard mistakes.count > 0 else { return true }
        
        return mistakes.count > 2 ? false : true
    }
    
//    var state: ResultState {
//        guard let _ = examDate else {
//            return .undefined
//        }
//        
//        guard self.mistakes > 0 else { return .succeed }
//        
//        return self.mistakes > 2 ? .failed : .succeed
//    }
}


enum ResultState {
    case undefined, succeed, failed
}
