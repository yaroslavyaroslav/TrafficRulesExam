//
//  ExamCard.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 14.10.2021.
//

import Foundation

struct ExamCard {
    let id: Int
    let questions: [Question]
    
    @Storage(key: "exam_results", defaultValue: [Result]())
    var results: [Result]
}

extension ExamCard: Identifiable { }

extension ExamCard: Hashable { func hash(into hasher: inout Hasher) { hasher.combine(id) } }

extension ExamCard: Equatable { static func == (lhs: ExamCard, rhs: ExamCard) -> Bool { lhs.id == rhs.id } }
