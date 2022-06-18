//
//  QuestionCardView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

import PopupView
import SwiftKeychainWrapper
import SwiftUI
import os.log

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
    let card: ExamCard

    @State private var result = Result(mistakes: [], examDate: Date())

    @State private var isHintShown = false

    @State private var hintPurchased = false

    @State var questionDetails: Question

    @State var selectedAnswer: AnswerID = .none

    @State var answeredQuestions: Set<Int> = []

    @State var isShowingError = false

    @Binding var resultsHistory: Results
    
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var coins: Coin

    @EnvironmentObject var coinsTimer: CoinsTimer

    @EnvironmentObject var currentValues: CurrentValues

    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                questionList

                QuestionContentView(question: questionDetails, selectedAnswer: $selectedAnswer, correctAnswer: nil)
                    .transition(.moveAndFade)

                HStack(spacing: 16) {
                    hintButton
                    if answeredQuestions.count >= 19 {
                        completeTestButton(proxy)
                            .disabled(selectedAnswer == AnswerID.none)
                    } else {
                        nextQuestionButton(proxy)
                            .disabled(selectedAnswer == AnswerID.none)
                    }
                }
                .font(UIFont.sfBodySemibold.asFont)
                .foregroundColor(.DS.bgGroupedLightSecondary)
                .padding(16)
                .background()
                .defaultShadow(.up)
            }
            .popup(isPresented: $isHintShown, type: .toast, position: .bottom, closeOnTap: false) {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.DS.tintsDisabledDark, lineWidth: 1)
                        .frame(width: 40, height: 4)
                        .background()
                        .padding(.vertical, 16)

                    Text(questionDetails.hint)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                }
                .roundBorder(colorScheme == .light ? Color.DS.greysGrey6Light : Color.DS.greysGrey6Dark, cornerRadius: 30)
                .background().ignoresSafeArea(.all, edges: .bottom)
                .defaultShadow()
                .cornerRadius(30)
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
                ForEach(card.questions, id: \.id) { question in
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
                    // TODO: Make here's fireling alert on tap. Maybe with `tapGetsture` and `alert` methods.
                    .disabled(answeredQuestions.contains(question.id))
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
                    hintPurchased = true
                } catch CoinsError.NegativeCoinsAmount {
                    isShowingError = true
                    return
                } catch {
                    os_log("\(error.localizedDescription)")
                }
            }

            withAnimation {
                self.isHintShown = true
            }

            Analytics.shared.fire(.hintTaken(ticket: currentValues.ticket, question: currentValues.question))
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
    
    func completeTestButton(_ proxy: ScrollViewProxy) -> some View {
        let disabled = selectedAnswer == .none
        
        return NavigationLink {
            ExamStatsViewWrapper(resultsHistory: $resultsHistory, result: result, cardId: card.id)
        } label: {
            ZStack(alignment: .center) {
               RoundedRectangle(cornerRadius: 8)
                   .frame(width: 52, height: 52)
               HStack {
                   Image(systemName: "checkmark.circle.fill")
                       .font(.system(size: 24))
                       .foregroundColor(!disabled ? .DS.bgLightPrimary : .DS.greysGrey3Light)
               }
           }
        }
        .simultaneousGesture(TapGesture().onEnded{
            saveAnswer()
        })
    }

    func nextQuestionButton(_ proxy: ScrollViewProxy) -> some View {
        let disabled = selectedAnswer == .none

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
                        .foregroundColor(!disabled ? .DS.bgLightPrimary : .DS.greysGrey3Light)
                }
            }
        }
        .buttonStyle(InExamButtonStyle(isEnabled: !disabled))
    }
}

extension QuestionCardView {
    // TODO: This method somehow blocking to open StatsView.
    func saveAnswer(_ proxy: ScrollViewProxy? = nil) {
        /// If user didn't select any answer just drop hint and do nothing.
        guard selectedAnswer != .none else { dropHint(); return }

        /// Checking is the selected answer is correct
        if questionDetails.correctAnswer != selectedAnswer {
            /// Adding question to the list if it's not
            result.addMistake(mistake: (questionDetails.id, selectedAnswer))
        }
        /// Resetting selected answer state
        selectedAnswer = .none

        /// Adding question to selected answets set.
        answeredQuestions.insert(questionDetails.id)

        os_log("question.id: \(questionDetails.id)")
        
        /// Updating `currentValues.question` property to send it to analytics
        currentValues.question = UInt(questionDetails.id)
        Analytics.shared.fire(.questionShown(ticket: currentValues.ticket, question: currentValues.question))
        os_log("\(answeredQuestions.count)")

        /// Dropping hint state (purchased or not)
        dropHint()
        
        if answeredQuestions.count < 20 {
            /// Scroll question list to next question if needed.
            scrollQuestionList(proxy)
        }
    }
    
    private func scrollQuestionList(_ proxy: ScrollViewProxy?) {
        // FIXME: Crashes if skip 20 question.
        let notAnswered = (1...19).filter { !answeredQuestions.contains($0) }

        guard let proxy = proxy else { return }

        if !answeredQuestions.contains(questionDetails.id + 1) && questionDetails.id != 20 {
            // Id 1 based, array 0 based, so to get next element of array need to do this array[id]
            questionDetails = card.questions[questionDetails.id]
            if questionDetails.id < 20 {
                proxy.scrollTo(questionDetails.id + 1)
            }
        } else {
            questionDetails = card.questions[notAnswered[0] - 1]
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
        QuestionCardView(card: cards[1], questionDetails: cards[1].questions[14], resultsHistory: $history)
            .environmentObject(Coin())
    }
}
