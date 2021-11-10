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
            
            if result.succeed {
                Spacer()
                Text("Решено \(result.examDate.prettyPrint)")
                    .padding()
                Text("Все верно!")
                    .padding()
                Spacer()
            } else {
                List((0..<result.mistakes.count)) { id in
                    NavigationLink {
                        Text("This is")
                    } label: {
                        VStack {
                            Text("Ошибка в \(result.mistakes[id].id) вопросе")
                            Text("Вы ответили \(result.mistakes[id].wrongAnswer.stringValue)")
                            Text("Правильный ответ Такой-то.")
                        }
                    }
                }
            }
        }
    }
}

struct ExamStats_Previews: PreviewProvider {
    
    static var results: [Result] = {
        let mistakes = [Mistake(id: 1, wrongAnswer: .b), Mistake(id: 10, wrongAnswer: .c), Mistake(id: 15, wrongAnswer: .a)]
        
        let results = (1...3).map { idx -> Result in
            if idx == 2 {
                return Result(mistakes: [], examDate: Date())
            } else {
                return Result(mistakes: mistakes, examDate: Date())
            }
        }
        return results
    }()
    
    static var previews: some View {
        ExamStats(result: results[0])
        ExamStats(result: results[1])
    }
}


extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        get { self[index(startIndex, offsetBy: i)] }
    }
}
