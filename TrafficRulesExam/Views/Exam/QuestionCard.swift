//
//  QuestionCard.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 15.10.2021.
//

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
    private var result = Result(mistakes: [:], examDate: Date())
    
    let questions: [Question]
    
    @State
    var questionDetails: Question
    
    @StateObject
    var selectedAnswer: SelectedAnswer = SelectedAnswer()
    
    @Binding
    var historyRes: Results
    
    @Binding
    var isShowingExamCard: Bool
    
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
                                    .foregroundColor(question == questionDetails ? .green : .gray)
                            )
                        }
                        .cornerRadius(8)
                    }
                }
                Spacer()
                
                QuestionContent(question: questionDetails, selectedAnswer: selectedAnswer)
                    .transition(.moveAndFade)
                    .padding(8)
                
                Button(questionDetails.id < 20 ? "Следующий вопрос" : "Завершить") {
                    withAnimation {
                        guard questionDetails.id != 20 else {
                            historyRes.items.append(result)
                            isShowingExamCard = false
                            return
                        }
                        questionDetails = questions[questionDetails.id]

                        if questionDetails.id < 19 {
                            proxy.scrollTo(questionDetails.id + 2)
                        }
                        self.saveAnswer()
                    }
                }
                .disabled(selectedAnswer.answer == AnswerID.none)
                .padding(10)
            }
        }
    }
}


extension QuestionCard {
    func saveAnswer() {
        guard selectedAnswer.answer != .none else { return }
        
        if questionDetails.correctAnswer != selectedAnswer.answer {
            result.addMistake(mistake: (questionDetails.id, selectedAnswer.answer))
        }
        selectedAnswer.answer = .none
    }
}

//struct QuestionCard_Previews: PreviewProvider {
//    static var previews: some View {
////        QuestionCard(questions: cards[0].questions, questionDetails: cards[0].questions[3], resultHistory: Results([]))
//    }
//}
