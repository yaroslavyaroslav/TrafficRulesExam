//
//  QuestionCardView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import PopupView
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

struct QuestionCardView: View {
    let questions: [Question]

    @State private var result = Result(mistakes: [], examDate: Date())

    @State private var isHintShown = false

    @State private var hintPurchased = false

    @State var questionDetails: Question

    @State var selectedAnswer: AnswerID = .none

    @State var answeredQuestions: Set<Int> = []

    @State var isShowingError = false

    @Binding var resultsHistory: Results

    @EnvironmentObject var coins: Coin

    @EnvironmentObject var coinsTimer: CoinsTimer

    @EnvironmentObject var currentValues: CurrentValues

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                questionList

                QuestionContentView(question: questionDetails, selectedAnswer: $selectedAnswer, correctAnswer: nil)
                    .transition(.moveAndFade)

                HStack(spacing: 16) {
                    hintButton
                    nextQuestionButton(proxy)
                        .disabled(selectedAnswer == AnswerID.none)
                }
                .font(UIFont.sfBodySemibold.asFont)
                .foregroundColor(.DS.bgGroupedLightSecondary)
                .padding(16)
                .background(Color.DS.bgLightPrimary.edgesIgnoringSafeArea(.bottom))
                .defaultShadow(.up)
            }
            .popup(isPresented: $isHintShown, type: .toast, position: .bottom, closeOnTap: false) {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.DS.tintsDisabledDark, lineWidth: 1)
                        .frame(width: 40, height: 4)
                        .background(Color.DS.tintsDisabledDark)
                        .padding(.vertical, 16)

                    Text(questionDetails.hint)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                }
                .roundBorder(Color.DS.greysGrey6Light, cornerRadius: 30)
                .background(Color.DS.bgLightPrimary).ignoresSafeArea(.all, edges: .bottom)
                .defaultShadow()
            }
            .alert("Не хватает монет", isPresented: $isShowingError, actions: {
                Button {
                    isShowingError = false
                } label: {
                    Text("Ок")
                }
            }, message: {
                Text("Чтобы посмотреть подсказку нужно больше монет. Их можно купить в магазине.")
            })
        }
    }

    @ViewBuilder
    var questionList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 6) {
                ForEach(questions, id: \.id) { question in
                    let state: TicketButtonStyle.State = question == questionDetails
                            ? .current : (answeredQuestions.contains(question.id)
                                  ? .answered : .notAnswered)

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
                    .buttonStyle(TicketButtonStyle(state: state))                    
                }
                .cornerRadius(8)
            }
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    var hintButton: some View {
        let isEnabled = coins.amount != 0

        Button {
            if !hintPurchased {
                do {
                    try coinsTimer.spendCoin(coins.hintCost)
                } catch CoinsError.NegativeCoinsAmount {
                    isShowingError = true
                    return
                } catch {
                    print("this")
                }
            }

            withAnimation {
                self.isHintShown = true
            }

            Analytics.fire(.hintTaken(ticket: currentValues.ticket, question: currentValues.question))
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 52, alignment: .center)

                HStack {
                    Image("Coin")
                    Text("Подсказка за \(coins.hintCost)")
                }
                .foregroundColor(isEnabled ? .DS.bgLightPrimary : .DS.greysGrey3Light)
            }
        }
        .buttonStyle(InExamButtonStyle(isEnabled: isEnabled))
        .disabled(coins.amount == 0)
    }

    func nextQuestionButton(_ proxy: ScrollViewProxy) -> some View {
        let isEnabled = selectedAnswer != .none

        return Button {
            withAnimation {
                self.saveAnswer(proxy)
            }
        }  label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 52, height: 52)
                HStack {
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 24))
                        .foregroundColor(isEnabled ? .DS.bgLightPrimary : .DS.greysGrey3Light)
                }
            }
        }
        .buttonStyle(InExamButtonStyle(isEnabled: isEnabled))
        .disabled(!isEnabled)
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
                do {
                    try coinsTimer.spendCoin(coins.cardCost)
                } catch CoinsError.NegativeCoinsAmount {
                    /// Пользователь может войти сюда с 5 монетами, получить 5 подсказок и не заплатить за билет.
                    print("Not enough coins.")
                } catch {
                    print("This")
                }
                Analytics.fire(.ticketCompleted(ticketId: currentValues.ticket, success: false))
            } else {
                coinsTimer.rewardCoin(coins.cardCost)
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
