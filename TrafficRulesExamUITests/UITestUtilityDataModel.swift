//
//  UITestUtilityDataModel.swift
//  TrafficRulesExamUITests
//
//  Created by Yaroslav on 07.11.2021.
//

import Foundation

struct ExamCardSource: Codable {
    let id: Int
    let questions: [Question]
}

extension ExamCard {
    init(source: ExamCardSource) { self.init(id: source.id, questions: source.questions) }
}

extension TrafficRulesExamUITests {
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle(identifier: "ru.neantess.TrafficRulesExamUITests")?.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
