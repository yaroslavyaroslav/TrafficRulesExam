//
//  ExamStatsView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 08.11.2021.
//

import SwiftUI

struct ExamStatsView: View {
    
    let isModal: Bool
    
    var result: Result

    let cardId: Int
    
//    @Environment(\.)
//    @Environment(\.rootPresentationMode) var presentationMode

    var body: some View {
        VStack {
            if result.succeed {
                SuccessResult(result: result)
            } else {
                UnsuccessResult(result: result, cardId: cardId)
            }
            
            if isModal {
                Button {
                    NavigationUtil.popToRootView()
                    Analytics.shared.fire(.ticketCompleted(ticketId: UInt(cardId), success: result.succeed))
                } label: {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 52, alignment: .center)
                        HStack {
                            Text("Готово")
                                .font(UIFont.sfBodySemibold.asFont)
                        }
                        .foregroundColor(.DS.bgLightPrimary)
                    }
                }
                .padding(.horizontal, 20)
                .buttonStyle(InExamButtonStyle(isEnabled: true))
            }
            
        }
        .navigationBarTitle(result.examDate.relativeDate)
    }
}

struct SuccessResult: View {
    var result: Result
    
    var body: some View {
        VStack {
            Text("Все верно!")
                .font(.largeTitle.bold())
                .foregroundColor(.DS.tintsGreenLight)
                .padding(.bottom, 8)
                .padding(.top, 40)
            Text("Ошибок \(result.mistakes.count)/20")
                .font(.body)
                .opacity(0.8)
            Spacer()
            Image("SuccessSign")
            HStack(spacing: 0) {
                Text("+5 ")
                    .font(.title)
                Image("Coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Text("Решено: \(result.examDate.prettyPrint)")
                .padding(.bottom, 40)
        }
    }
}

struct UnsuccessResult: View {
    var result: Result
    
    var cardId: Int
    
    var body: some View {
        Text("🙁")
            .font(.system(size: 64))
            .padding(.bottom, 12)
        Text("Ошибок \(result.mistakes.count)/20")
            .font(UIFont.sfTitle2Bold.asFont)

        List(0 ..< result.mistakes.count, id: \.self) { mistakeIdx in
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
                }
            }
        }
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
        ExamStatsView(isModal: false, result: results[2], cardId: 2)
        ExamStatsView(isModal: false, result: results[1], cardId: 1)
        
        ExamStatsView(isModal: true, result: results[2], cardId: 2)
        ExamStatsView(isModal: true, result: results[1], cardId: 1)
    }
}
