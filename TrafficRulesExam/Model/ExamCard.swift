//
//  ExamCard.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 14.10.2021.
//

import Foundation

struct ExamCard: Codable, Identifiable {
    let id: Int
    let questions: [Question]
    let results: [Result]
}

extension ExamCard: Hashable { func hash(into hasher: inout Hasher) { hasher.combine(id) }}

extension ExamCard: Equatable { static func == (lhs: ExamCard, rhs: ExamCard) -> Bool { lhs.id == rhs.id } }
