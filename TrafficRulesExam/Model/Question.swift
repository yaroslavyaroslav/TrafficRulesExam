//
//  Question.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import Foundation

struct Question: Codable {
    let id: Int
    let text: String
    let picture: URL?
    let answers: [Answer]
    let correctAnswer: AnswerID
    let hint: String
    let topic: String
}

extension Question: Identifiable { }

extension Question: Equatable { static func == (lhs: Question, rhs: Question) -> Bool { lhs.id == rhs.id } }

extension Question: Hashable { func hash(into hasher: inout Hasher) { hasher.combine(id) } }
