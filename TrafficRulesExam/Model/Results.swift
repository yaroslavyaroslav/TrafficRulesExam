//
//  Results.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import Foundation
import SwiftUI


/// Object to store Result objects for being compatiable with SwiftUI data flow.
struct Results {
    /// Array of the results of the processed exams
    var items: [Result] { didSet { print("Results.item did updated.") } }
}

extension Results: Codable { }

/// Result data stores data about one piece of a one testing
///
/// The most atomic kind of result
struct Result {
    
    /// Dictionary of the mistakes which user have made during one test
    private(set) var mistakes: [Int: AnswerID]
    
    /// When test happened
    let examDate: Date
    
    /// Is additional questions fires during a test
    ///
    /// Additional questions fires when user makes a 2 or less mistakes during the main test part (20 questions).
    /// In that case after the main part app provides additional questions in theme where user have mistaken.
    /// It's 5 more questions for each given mistake, 10 at max.
    var additionalQuestionsFired: Bool { mistakes.count > 0 ? true : false }
    
    /// Did test succeed
    ///
    /// Test comes successful in follow cases:
    /// - user takes no mistakes at all;
    /// - user takes 2 or less mistakes on main test part and no mistakes at all on additional part.
    var succeed: Bool {
        guard mistakes.count > 0 else { return true }
        
        return mistakes.count > 2 ? false : true
    }
}

extension Result {
    /// Add mistake tuple to the mistakes property
    /// - Parameter mistake: mistake *tuple* with question id *(Int)* and answer id (*AnswerID*)
    mutating func addMistake(mistake: (Int, AnswerID)) {
        let (questionID, wrongAnswerID) = mistake
        mistakes[questionID] = wrongAnswerID
    }
}

extension Result: Codable { }
