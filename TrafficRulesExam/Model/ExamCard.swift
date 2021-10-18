//
//  ExamCard.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 14.10.2021.
//

import Foundation


enum AnswerID: Int, Codable {
    case a, b, c, d
    
    init(from decoder: Decoder) throws {
        
        let label = try decoder.singleValueContainer().decode(Int.self)
        
        switch label {
        case 1: self = .a
        case 2: self = .b
        case 3: self = .c
        case 4: self = .d
        default: fatalError()
        }
    }
}

extension AnswerID {
    var stringValue: String {
        switch self {
        case .a: return "1."
        case .b: return "2."
        case .c: return "3."
        case .d: return "4."
        }
    }
}

extension AnswerID: Identifiable { var id: Self { self }}


struct Answer: Codable, Identifiable {
    let id: AnswerID
    let text: String
}

struct Question: Codable, Identifiable {
    let id: Int
    let text: String
    let picture: URL?
    let answers: [Answer]
    let correctAnswer: AnswerID
    let hint: String
    let topic: String
}

extension Question: Equatable { static func == (lhs: Question, rhs: Question) -> Bool { lhs.id == rhs.id } }

extension Question: Hashable { func hash(into hasher: inout Hasher) { hasher.combine(id) } }

struct ExamCard: Codable, Identifiable {
    let id: Int
    let questions: [Question]
}
