//
//  ExamStats.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct ExamStats: View {
    
    var result: Result
    
    var body: some View {
        VStack {
            
            Text("Билет 8")
            Text("Решено \(20 - result.mistakes.count)/20")
            Text("Ошибки")
            
            List((0..<result.mistakes.keys.count)) { id in
                NavigationLink {
                    Text("This is")
                } label: {
                    VStack {
                        Text("Ошибка в \(id) вопросе")
                        Text("Вы ответили \(result.mistakes[id]?.stringValue ?? "failed")")
                        Text("Правильный ответ Такой-то.")
                    }
                }
            }
        }
    }
}

struct ExamStats_Previews: PreviewProvider {
    static var previews: some View {
        ExamStats(result: Result(mistakes: [1:.b], examDate: Date()))
    }
}


extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        get { self[index(startIndex, offsetBy: i)] }
    }
}
