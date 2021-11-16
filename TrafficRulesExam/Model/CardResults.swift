//
//  CardResults.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 04.11.2021.
//

import Foundation

/// Object to store all results for a given exam card
struct CardResult {
    /// Result id.
    ///
    /// Is equal to the ``ExamCard.id``.
    let id: Int

    /// History of the results processed tests.
    var resultHistory: Results
}

extension CardResult: Equatable {
    static func == (lhs: CardResult, rhs: CardResult) -> Bool { lhs.id == rhs.id }
}

extension CardResult: Codable { }

/// Object to store CardResult objects for being compatiable with SwiftUI dataflow.
struct CardResults {
    /// Array of the results of the processed exams for a given card.
    ///
    /// This var encodes itsef to the JSON and stores it to the UserDefaults by key ``CardResults``.
    var items: [CardResult] {
        willSet {
            // FIXME: Disable force unwrap.
            let data = try! JSONEncoder().encode(newValue)
            let string = String(data: data, encoding: .utf8)
            UserDefaults.standard.set(string, forKey: UDKeys.cardResults.rawValue)
        }
    }

    /// Number of tickets that user have tried to solve.
    ///
    /// Doesn't matter did them succeed or not.
    var cardsTried: Int { items.filter { $0.resultHistory.items.count > 0 }.count }

    /// Number of tickets that user have succeed.
    ///
    /// Counts only if last attemtion were suceessful.
    var cardsSucceed: Int { items.filter { $0.resultHistory.items.last?.succeed ?? false }.count }
}

extension CardResults {
    /// Initializer that loads data from ``UserDefaults`` storage.
    ///
    /// It's encodes JSON of the ``[CardResult]`` type and set it to the *items* property.
    ///
    /// - Throws: ``InitError.emptyUserDefaults``: on empty UserDefaults storage by key ``CardResults`` on init.
    init() throws {
        let userDefaults = UserDefaults.standard.string(forKey: UDKeys.cardResults.rawValue)
        guard let data = userDefaults?.data(using: .utf8) else { throw InitError(kind: .emptyUserDefaults) }
        let items = try JSONDecoder().decode([CardResult].self, from: data)
        guard items.count == 20 else { throw InitError(kind: .notEnoughTickets) }
        self.items = items
    }
}

extension CardResults: Codable { }

private struct InitError: Error {
    let kind: ErrorKind

    enum ErrorKind {
        case emptyUserDefaults
        case notEnoughTickets
    }
}
