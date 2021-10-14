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
}

struct Answer: Codable {
    let id: AnswerID
    let text: String
}

struct Question: Codable {
    let id: Int
    let text: String
    let picture: URL?
    let answers: [Answer]
}

struct ExamCardModel: Codable {
    let id: Int
    let questions: [Question]
    let correctAnswer: AnswerID
    let hint: String
    let topic: String
}
