//
//  QuestionCard.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import SwiftKeychainWrapper
import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct QuestionCard: View {
    @State
    private var result = Result(mistakes: [], examDate: Date())

    @State
    private var isHintShown = false

    @State
    private var hintPurchased = false

    @EnvironmentObject
    var coins: Coin

    @EnvironmentObject
    var coinsTimer: CoinsTimer

    let questions: [Question]

    @State
    var questionDetails: Question

    @State
    var selectedAnswer: AnswerID = .none

    @Binding
    var resultsHistory: Results

    @State
    var answeredQuestions: Set<Int> = []

    @Environment(\.presentationMode)
    var presentationMode

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 3) {
                        ForEach(questions, id: \.id) { question in
                            Button {
                                withAnimation {
                                    questionDetails = question
                                    self.saveAnswer()
                                }
                            } label: {
                                Text(question.id.description)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 40, height: 40, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(question == questionDetails ? .green : (answeredQuestions.contains(question.id) ? .yellow : .gray))
                            )
                            .disabled(answeredQuestions.contains(question.id))
                        }
                        .cornerRadius(8)
                    }
                }
                Spacer()


                ZStack(alignment: .center) {
                    QuestionContent(question: questionDetails, selectedAnswer: $selectedAnswer, correctAnswer: nil)
                        .transition(.moveAndFade)

                    Text("\(coins.amount)")
                        .frame(width: 20, height: 20, alignment: .center)
                        .background(Color.purple)
                        .position(x: 20, y: 20)

                    if isHintShown {
                        Text(questionDetails.hint)
                        Button("X") {
                            withAnimation {
                                self.isHintShown.toggle()
                            }
                        }
                        .background(Color.purple)
                    } else {
                        Button("Hint") {
                            if !hintPurchased {
                                self.hintPurchased = true
                                coinsTimer.spendCoin()
                            }
                            withAnimation {
                                self.isHintShown.toggle()
                            }
                        }
                        .disabled(coins.amount == 0 ? true : false)
                        .padding()
                        .background(Color.purple)
                        .position(x: 150, y: 600)
                    }
                }

                Button(answeredQuestions.count == 19 ? "Завершить" : "Следующий вопрос") {
                    withAnimation {
                        self.saveAnswer()
                        answeredQuestions.insert(questionDetails.id)
                        print(answeredQuestions.count)

                        self.hintPurchased = false

                        if answeredQuestions.count == 20 {
                            if !result.mistakes.isEmpty {
                                coinsTimer.spendCoin()
                            }
                            resultsHistory.items.append(result)
                            presentationMode.wrappedValue.dismiss()
                            return
                        }

                        let notAnswered = (1...19).filter { !answeredQuestions.contains($0) }

                        if !answeredQuestions.contains(questionDetails.id + 1) && questionDetails.id != 20 {
                            questionDetails = questions[questionDetails.id]
                            if questionDetails.id < 20 {
                                proxy.scrollTo(questionDetails.id + 1)
                            }
                        } else {
                            questionDetails = questions[notAnswered[0] - 1]
                            proxy.scrollTo(questionDetails.id)
                        }
                    }
                }
                .disabled(selectedAnswer == AnswerID.none)
                .padding(10)
            }
        }
    }
}

extension QuestionCard {
    func saveAnswer() {
        guard selectedAnswer != .none else { return }

        if questionDetails.correctAnswer != selectedAnswer {
            result.addMistake(mistake: (questionDetails.id, selectedAnswer))
        }
        selectedAnswer = .none
    }
}

struct QuestionCard_Previews: PreviewProvider {
    @State
    static var history: Results = {
        let result = Result(mistakes: [], examDate: Date())
        return Results(items: [result])
    }()

    static var previews: some View {
        QuestionCard(questions: cards[1].questions, questionDetails: cards[1].questions[16], resultsHistory: $history)
            .environmentObject(Coin())
    }
}
