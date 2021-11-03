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

struct Results: Codable {
    
    var items: [Result] {
        didSet {
            print("Results.item did updated.")
        }
    }

    init(_ items: [Result]) {
        self.items = items
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
    
    var resultHistory: Results {
        didSet {
            print("CardResult.resultHistory did updated. ")
        }
    }
    
    init(_ id: Int, _ resultHistory: Results) {
        self.id = id
        self.resultHistory = resultHistory
    }
}

extension CardResult: Codable { }


struct CardResults: Codable {
    var items: [CardResult] {
        willSet {
            let data = try! JSONEncoder().encode(newValue)
            let string = try! String(data: data, encoding: .utf8)
            UserDefaults.standard.set(string, forKey: "CardResults")
        }
        didSet {
            print("CardResults.items did updated.")
        }
    }
}

extension CardResults {
    init() throws {
        let userDefaults = UserDefaults.standard.string(forKey: "CardResults")
        guard let data = userDefaults?.data(using: .utf8) else { throw InitError(kind: .emptyUserDefaults) }
        self.items = try JSONDecoder().decode([CardResult].self, from: data)
    }
}

struct InitError:  Error {
    let kind: ErrorKind
    enum ErrorKind {
        case emptyUserDefaults
    }
}
