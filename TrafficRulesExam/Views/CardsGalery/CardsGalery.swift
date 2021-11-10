//
//  CardsGalery.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 11.10.2021.
//

import SwiftUI

struct CardsGalery: View {
    
    var cards: [ExamCard]
    
    var body: some View {
//        NavigationView {
            CardRow(cards: cards)
            
//            .padding()
//        }
    }
}

struct CardsGalery_Previews: PreviewProvider {
    static var previews: some View {
        CardsGalery(cards: cards)
    }
}
