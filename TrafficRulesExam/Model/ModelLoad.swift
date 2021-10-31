//
//  ModelData.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import Foundation

var cards: [ExamCard] = cardsSource.map { ExamCard(source: $0) }

fileprivate var cardsSource: [ExamCardSource] = load("ExamCards.json")

fileprivate struct ExamCardSource: Codable {
    let id: Int
    let questions: [Question]
}

fileprivate extension ExamCard {
    init(source: ExamCardSource) {
        self.id = source.id
        self.questions = source.questions
    }
}

fileprivate func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
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
