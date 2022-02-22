//
//  QuestionCardView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import PopupView
import SwiftKeychainWrapper
import SwiftUI
import YandexMobileMetrica

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct QuestionCardView: View {
    let questions: [Question]

    @State private var result = Result(mistakes: [], examDate: Date())

    @State private var isHintShown = false

    @State private var hintPurchased = false

    @State var questionDetails: Question

    @State var selectedAnswer: AnswerID = .none

    @State var answeredQuestions: Set<Int> = []

    @Binding var resultsHistory: Results

    @EnvironmentObject var coins: Coin

    @EnvironmentObject var coinsTimer: CoinsTimer

    @EnvironmentObject var currentValues: CurrentValues

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                questionList
                    .padding(.vertical, 12)

                QuestionContentView(question: questionDetails, selectedAnswer: $selectedAnswer, correctAnswer: nil)
                    .transition(.moveAndFade)

                HStack(spacing: 16) {
                    Button {
                        if !hintPurchased {
                            self.hintPurchased = true
                            coinsTimer.spendCoin()
                        }
                        withAnimation {
                            self.isHintShown = true
                        }

                        Analytics.fire(.hintTaken(ticket: currentValues.ticket, question: currentValues.question))
                    } label: {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 52, alignment: .center)
                                .foregroundColor(.DS.tintsPurpleLight)

                            HStack {
                                Image("Coin")
                                Text("Подсказка за 1")
                            }
                        }
                    }


                    nextQuestionButton(proxy)
                        .disabled(selectedAnswer == AnswerID.none)
                }
                .font(UIFont.sfBodySemibold.asFont)
                .foregroundColor(.DS.bgGroupedLightSecondary)
                .padding(16)
                .background(Color.DS.bgLightPrimary.edgesIgnoringSafeArea(.bottom))
            }
            .popup(isPresented: $isHintShown, type: .toast, position: .bottom, closeOnTap: false) {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 30, height: 8)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)

                    Text(questionDetails.hint)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                }
                .background(Color(red: 0.85, green: 0.8, blue: 0.95)).ignoresSafeArea(.all, edges: .bottom)
                .cornerRadius(30.0)
            }
        }
    }

    @ViewBuilder
    var questionList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 6) {
                ForEach(questions, id: \.id) { question in
                    Button {
                        withAnimation {
                            self.saveAnswer()
                            questionDetails = question
                        }
                    } label: {
                        Text(question.id.description)
                            .font(UIFont.sfBody.asFont)
                            .foregroundColor(question == questionDetails ? .DS.bgLightPrimary : .DS.greysGrey3Dark)
                    }
                    .frame(width: 44, height: 44, alignment: .center)
                    .background(question == questionDetails
                                ? Color.DS.tintsPurpleDark : (answeredQuestions.contains(question.id)
                                   ? Color.DS.bgLightSecondary : Color.DS.bgLightPrimary))
                    .roundBorder(question == questionDetails ? Color.DS.tintsPurpleLight : Color.DS.bgLightSecondary, cornerRadius: 12)
                    .disabled(answeredQuestions.contains(question.id))
                }
                .cornerRadius(8)
            }
        }
    }

    func nextQuestionButton(_ proxy: ScrollViewProxy) -> some View {
        Button {
            withAnimation {
                self.saveAnswer(proxy)
            }
        }  label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 52, height: 52, alignment: .center)
                    .foregroundColor(.DS.tintsPurpleLight)
                HStack {
                    Image(systemName: "arrow.right")
                }
            }
        }
    }
}

extension QuestionCardView {
    func saveAnswer(_ proxy: ScrollViewProxy? = nil) {
        guard selectedAnswer != .none else { dropHint(); return }

        if questionDetails.correctAnswer != selectedAnswer {
            result.addMistake(mistake: (questionDetails.id, selectedAnswer))
        }
        selectedAnswer = .none

        answeredQuestions.insert(questionDetails.id)

        print("question.id: \(questionDetails.id)")
        currentValues.question = UInt(questionDetails.id)
        Analytics.fire(.questionShown(ticket: currentValues.ticket, question: currentValues.question))
        print(answeredQuestions.count)

        dropHint()

        if answeredQuestions.count == 20 {
            // If user made a mistake
            if !result.mistakes.isEmpty {
                coinsTimer.spendCoin()
                Analytics.fire(.ticketCompleted(ticketId: currentValues.ticket, success: false))
            } else {
                coinsTimer.rewardCoin()
                Analytics.fire(.ticketCompleted(ticketId: currentValues.ticket, success: true))
            }
            resultsHistory.items.append(result)
            presentationMode.wrappedValue.dismiss()
            return
        }

        // FIXME: Crashes if skip 20 question.
        let notAnswered = (1...19).filter { !answeredQuestions.contains($0) }

        guard let proxy = proxy else { return }

        if !answeredQuestions.contains(questionDetails.id + 1) && questionDetails.id != 20 {
            // Id 1 based, array 0 based, so to get next element of array need to do this array[id]
            questionDetails = questions[questionDetails.id]
            if questionDetails.id < 20 {
                proxy.scrollTo(questionDetails.id + 1)
            }
        } else {
            questionDetails = questions[notAnswered[0] - 1]
            proxy.scrollTo(questionDetails.id)
        }
    }

    private func dropHint() {
        isHintShown = false
        hintPurchased = false
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct QuestionCard_Previews: PreviewProvider {
    @State
    static var history: Results = {
        let result = Result(mistakes: [], examDate: Date())
        return Results(items: [result])
    }()

    static var previews: some View {
        QuestionCardView(questions: cards[1].questions, questionDetails: cards[1].questions[14], resultsHistory: $history)
            .environmentObject(Coin())
    }
}
