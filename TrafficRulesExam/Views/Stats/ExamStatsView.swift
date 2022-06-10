//
//  ExamStatsView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct ExamStatsView: View {
    var result: Result

    let cardId: Int

    var body: some View {
        VStack {
            if result.succeed {
                Spacer()
                Text("Решено \(result.examDate.prettyPrint)")
                    .padding()
                Text("Все верно!")
                    .padding()
                Spacer()
            } else {
                Text("🙁")
                    .font(.system(size: 64))
                    .padding(.bottom, 12)
                Text("Ошибок \(result.mistakes.count)/20")
                    .font(UIFont.sfTitle2Bold.asFont)

                List(0 ..< result.mistakes.count) { mistakeIdx in
                    NavigationLink {
                        QuestionContentView(
                            question: getQuestionForStats(cardId, mistakeIdx),
                            selectedAnswer: getSelectedAnswer(mistakeIdx),
                            correctAnswer: getCorrectAnswerForQuestion(cardId, mistakeIdx)
                        )
                        .navigationBarTitle(Text("Вопрос \(result.mistakes[mistakeIdx].id.description)"))
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Ошибка в \(result.mistakes[mistakeIdx].id.description) вопросе")
                                .font(UIFont.sfBody.asFont)

                            HStack(spacing: 0) {
                                Text("Вы ответили: ")
                                    .font(UIFont.sfCaption.asFont)
                                Text(result.mistakes[mistakeIdx].wrongAnswer.stringValue)
                                    .foregroundColor(.DS.tintsPinkLight)
                                    .padding(.trailing, 12)

                                Circle()
                                    .foregroundColor(.DS.greysGrey5Light)
                                    .frame(width: 5, height: 5)
                                    .padding(.trailing, 12)

                                Text("Правильный ответ: ")
                                Text(getCorrectAnswerForQuestion(cardId, mistakeIdx).stringValue)
                                    .font(UIFont.sfCaptionMedium.asFont)
                                    .foregroundColor(.DS.tintsGreenLight)
                            }
                            .font(UIFont.sfCaptionMedium.asFont)
                            .foregroundColor(.DS.greysGrey2Dark)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(result.examDate.relativeDate)
    }

    private func getQuestionForStats(_ cardID: Int, _ questionId: Int) -> Question {
        cards.getElementById(cardId).questions.getElementById(result.mistakes[questionId].id)
    }

    private func getCorrectAnswerForQuestion(_ cardID: Int, _ questionId: Int) -> AnswerID {
        cards.getElementById(cardId).questions.getElementById(result.mistakes[questionId].id).correctAnswer
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
        ExamStatsView(result: results[2], cardId: 2)
        ExamStatsView(result: results[1], cardId: 1)
    }
}
