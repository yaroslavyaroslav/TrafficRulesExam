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

class Results: ObservableObject {
    
    @Published
    var items: [Result] = [Result]()
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(_ items: [Result]) {
        self.items = items
    }
    
    required init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([Result].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items.self, forKey: .items)
    }
}

extension Results: Codable {
    
}

extension Result {
    mutating func addMistake(mistake: (Int, AnswerID)) {
        let (questionID, wrongAnswerID) = mistake
        mistakes[questionID] = wrongAnswerID
    }
}

extension Result: Codable { }

class CardResult: ObservableObject {
    let id: Int
    
    @Published
    private(set) var resultHistory: Results
    
    init(_ id: Int, _ resultHistory: Results) {
        self.id = id
        self.resultHistory = resultHistory
    }
    private enum CodingKeys: String, CodingKey {
        case id, resultHistory
    }
    
    required init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.resultHistory = try container.decode(Results.self, forKey: .resultHistory)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.self, forKey: .id)
        try container.encode(resultHistory.self, forKey: .resultHistory)
    }
}

extension CardResult: Codable { }
