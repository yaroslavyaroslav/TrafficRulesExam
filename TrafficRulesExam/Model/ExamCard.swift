//
//  File.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 14.10.2021.
//

import Foundation


enum AnswerID: String, Codable {
    case a, b, v, g
    
    enum CodingKeys: String, CodingKey {
        case a = "А"
        case b = "Б"
        case v = "В"
        case g = "Г"
    }

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
