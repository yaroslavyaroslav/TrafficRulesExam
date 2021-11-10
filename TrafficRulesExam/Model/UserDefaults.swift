//
//  UserDefaults.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 10.11.2021.
//

import Foundation

enum UDKeys: String {
    case cardResults
    
    enum CodingKeys: String, CodingKey {
        case cardResults = "CardResults"
    }
}
