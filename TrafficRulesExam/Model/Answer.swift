//
//  Answer.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import Foundation
import SwiftUI

struct Answer {
    let id: AnswerID
    let text: String
}

extension Answer: Identifiable {}

extension Answer: Codable {}

enum AnswerID: Int {
    case none, a, b, c, d, e

    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(Int.self)

        switch label {
        case 1: self = .a
        case 2: self = .b
        case 3: self = .c
        case 4: self = .d
        case 5: self = .e
        default: self = .none
        }
    }
}

extension AnswerID {
    var stringValue: String {
        switch self {
        case .a: return "1"
        case .b: return "2"
        case .c: return "3"
        case .d: return "4"
        case .e: return "5"
        case .none: return "none"
        }
    }
}

extension AnswerID: Identifiable { var id: Self { self }}

extension AnswerID: Codable {}
