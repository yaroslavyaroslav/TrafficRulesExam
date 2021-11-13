//
//  ExamCard.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 14.10.2021.
//

import Foundation

struct ExamCard: Codable {
    let id: Int
    let questions: [Question]
}

extension ExamCard: Identifiable { }

extension ExamCard: Hashable { func hash(into hasher: inout Hasher) { hasher.combine(id) } }

extension ExamCard: Equatable { static func == (lhs: ExamCard, rhs: ExamCard) -> Bool { lhs.id == rhs.id } }

extension Array where Element: Identifiable {
    func getElementById(_ id: Element.ID) -> Element {
        // FIXME: Remove force unwrap.
        self.first { $0.id == id }!
    }
}
