//
//  Date+PrittyPrint.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import Foundation


extension Date {
    var prettyPrint: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "RU_ru")
        return dateFormatter.string(from: self)
    }
}
