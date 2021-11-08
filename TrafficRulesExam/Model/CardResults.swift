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
            UserDefaults.standard.set(string, forKey: "CardResults")
        }
    }
}

extension CardResults {
    /// Initializer that loads data from ``UserDefaults`` storage.
    ///
    /// It's encodes JSON of the ``[CardResult]`` type and set it to the *items* property.
    ///
    /// - Throws: ``InitError.emptyUserDefaults``: on empty UserDefaults storage by key ``CardResults`` on init.
    init() throws {
        let userDefaults = UserDefaults.standard.string(forKey: "CardResults")
        guard let data = userDefaults?.data(using: .utf8) else { throw InitError(kind: .emptyUserDefaults) }
        self.items = try JSONDecoder().decode([CardResult].self, from: data)
    }
}

extension CardResults: Codable { }

fileprivate struct InitError:  Error {
    let kind: ErrorKind
    
    enum ErrorKind {
        case emptyUserDefaults
    }
}
