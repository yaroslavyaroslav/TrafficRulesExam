//
//  ExamStats.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct ExamStats: View {
    
    var result: Result
    
    let cardId: Int
    
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
                        QuestionContent(
                            question: getQuestionForStats(cardID: cardId, questionId: id),
                            selectedAnswer: getSelectedAnswer(id),
                            correctAnswer: getCorrectAnswerForQuestion(cardID: cardId, questionId: id)
                        )
                            .navigationBarTitle(Text("Вопрос \(result.mistakes[id].id.description)"))
                    } label: {
                        VStack {
                            Text("Ошибка в \(result.mistakes[id].id.description) вопросе")
                            Text("Вы ответили \(result.mistakes[id].wrongAnswer.stringValue)")
                            Text("Правильный ответ \(getCorrectAnswerForQuestion(cardID: cardId, questionId: id).stringValue)")
                        }
                    }
                }
            }
        }
    }
    
    private func getQuestionForStats(cardID: Int, questionId: Int) -> Question {
        cards.getElementById(id: cardId).questions.getElementById(id: result.mistakes[questionId].id)
    }
    
    private func getCorrectAnswerForQuestion(cardID: Int, questionId: Int) -> AnswerID {
        cards.getElementById(id: cardId).questions.getElementById(id: result.mistakes[questionId].id).correctAnswer
    }
    
    private func getSelectedAnswer(_ questionID: Int) -> Binding<AnswerID> {
        Binding<AnswerID>(
            get: { result.mistakes[questionID].wrongAnswer },
            set: { _ in }
        )
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
        ExamStats(result: results[2], cardId: 2)
        ExamStats(result: results[1], cardId: 1)
    }
}
