//
//  Question.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 30.10.2021.
//

import Foundation
import UIKit

struct Question {
    let id: Int
    let text: String
    let picture: String?
    let answers: [Answer]
    let correctAnswer: AnswerID
    let hint: String
    let topic: String
}

extension Question {
    var image: UIImage? {
        get {
            guard let picture = picture else { return nil }
            
//            if picture.absoluteString.contains("http") {
//                do {
//                    let (data, _) = try await URLSession.shared.data(from: picture)
//                    return UIImage(data: data)
//                } catch {
//                    return nil
//                }
//            } else {
            return UIImage(named: String(picture.split(separator: ".")[0]))
//            }
        }
    }
}

extension Question: Codable { }

extension Question: Identifiable { }

extension Question: Equatable { static func == (lhs: Question, rhs: Question) -> Bool { lhs.id == rhs.id } }

extension Question: Hashable { func hash(into hasher: inout Hasher) { hasher.combine(id) } }
