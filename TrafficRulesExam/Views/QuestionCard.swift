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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 3) {
                    ForEach(questions) { question in
                        if question == questionDetails {
                            Button(question.id.description) {
                                withAnimation {
                                    questionDetails = question
                                }
                            }
                            .frame(width: 40, height: 40, alignment: .center)
                            .border(.green, width: 3)
                        } else {
                            Button(question.id.description) {
                                withAnimation {
                                    questionDetails = question
                                }
                            }
                            .frame(width: 40, height: 40, alignment: .center)
                            .border(.gray, width: 3)
                        }
                    }
                    .cornerRadius(8)
                }
            }
            Spacer()
            QuestionContent(question: questionDetails)
                .transition(.moveAndFade)
            
            if questionDetails.id < 20 {
                Button("Следующий вопрос") {
                    withAnimation {
                        questionDetails = questions[questionDetails.id]
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

struct QuestionCard_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCard(questions: cards[0].questions, questionDetails: cards[0].questions[3])
    }
}
