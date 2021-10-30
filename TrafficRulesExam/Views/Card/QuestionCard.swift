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
    
    var questions: [Question]
    
    @State
    var questionDetails: Question
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .center, spacing: 3) {
                        ForEach(questions, id: \.id) { question in
                            if question == questionDetails {
                                Button {
                                    withAnimation {
                                        questionDetails = question
                                    }
                                } label: {
                                    Text(question.id.description)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.green)
                                )
                            } else {
                                Button {
                                    withAnimation {
                                        questionDetails = question
                                    }
                                } label: {
                                    Text(question.id.description)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.gray)
                                )
                            }
                        }
                        .cornerRadius(8)
                    }
                }
                Spacer()
                QuestionContent(question: questionDetails)
                    .transition(.moveAndFade)
                    .padding(8)
                
                // FIXME: Если быстро нажать следующий вопрос — будет out of range — кнопка не успевает перерисоваться по if на завершить.
                if questionDetails.id < 20 {
                    Button("Следующий вопрос") {
                        withAnimation {
                            questionDetails = questions[questionDetails.id]
                            if questionDetails.id < 19 {
                                proxy.scrollTo(questionDetails.id + 2)
                            }
                        }
                    }
                    .padding(10)
                } else {
                    Button("Завершить") {
                        withAnimation {
                            print("this")
                        }
                    }
                }
            }
        }
    }
}

struct QuestionCard_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCard(questions: cards[0].questions, questionDetails: cards[0].questions[3])
    }
}
