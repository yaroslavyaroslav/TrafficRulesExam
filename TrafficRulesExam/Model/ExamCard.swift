//
//  File.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 14.10.2021.
//

import Foundation


enum AnswerID: Codable {
    case a, b, v, g
    
    init(from decoder: Decoder) throws {
        
        let label = try decoder.singleValueContainer().decode(String.self)
        
        switch label {
        case "А": self = .a
        case "Б": self = .b
        case "В": self = .v
        case "Г": self = .g
        default: fatalError()
        }
    }
}

extension AnswerID {
    var stringValue: String {
        switch self {
        case .a: return "А"
        case .b: return "Б"
        case .v: return "В"
        case .g: return "Г"
        }
    }
}

extension AnswerID: Identifiable { var id: Self { self }}


struct Answer: Codable, Identifiable {
    let id: AnswerID
    let text: String
}

struct Question: Codable, Identifiable {
    let id: Decimal
    let text: String
    let picture: URL?
    let answers: [Answer]
    let correctAnswer: AnswerID
    let hint: String
    let topic: String
}

struct ExamCard: Codable {
    let id: Decimal
    let questions: [Question]
}
