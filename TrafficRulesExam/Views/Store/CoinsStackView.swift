//
//  CoinsStackView.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 19.02.2022.
//

import SwiftUI


/// This view makes Coins stacks
/// Up to 3 coins stacks have been tested.
struct CoinsStackView: View {
    private let coinsAmountInStack: Int

    private let verticalPaddingInStack: CGFloat

    private let stacksNumber: Int

    init(_ kind: Stack = .one) {
        switch kind {
        case .one:
            self.coinsAmountInStack = 4
            self.verticalPaddingInStack = 2
            self.stacksNumber = 1
        case .two:
            self.coinsAmountInStack = 4
            self.verticalPaddingInStack = 2
            self.stacksNumber = 2
        case .three:
            self.coinsAmountInStack = 4
            self.verticalPaddingInStack = 2
            self.stacksNumber = 3
        case .largeOne:
            self.coinsAmountInStack = 6
            self.verticalPaddingInStack = 2
            self.stacksNumber = 1
        case .largeTwo:
            self.coinsAmountInStack = 6
            self.verticalPaddingInStack = 2
            self.stacksNumber = 2
        case .largeThree:
            self.coinsAmountInStack = 6
            self.verticalPaddingInStack = 2
            self.stacksNumber = 3
        }
    }

    var xBias: CGFloat {
        var bias: CGFloat = 0
        if stacksNumber == 1 {
            bias = 19
        } else if stacksNumber == 2 {
            bias = 15
        } else if stacksNumber == 3 {
            bias = 11
        }
        return bias
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            ForEach(0..<stacksNumber) { stack in
                ForEach(0..<coinsAmountInStack) { index in
                    /// Since middle coins stack should be at front,
                    /// we're taking it by index
                    if stack == 1 {
                        Image("Coin")
                            .position(x: xBias + CGFloat(stack) * 8, y: 20 - (CGFloat(index) * -verticalPaddingInStack) - 2)
                            .zIndex(1)

                    /// All other coins stacks (1, 3) same layout logic
                    } else {
                        Image("Coin")
                            .position(x: xBias + CGFloat(stack) * 8, y: 20 - CGFloat(index) * -verticalPaddingInStack)
                    }
                }
            }
        }
        .frame(width: 38, height: 40)
    }
}

extension CoinsStackView {
    enum Stack: String {
        case one, two, three
        case largeOne, largeTwo, largeThree

        init?(rawValue: String) {
            guard let packSize = rawValue.split(separator: ".").last else { return nil }

            if packSize.contains("Mini") {
                self = .one
            } else if packSize.contains("Middle") {
                self = .two
            } else if packSize.contains("Max") {
                self = .three
            } else if packSize.contains("One") {
                self = .largeOne
            } else if packSize.contains("Three") {
                self = .largeTwo
            } else if packSize.contains("Six") {
                self = .largeThree
            } else {
                return nil
            }
         }
    }
}

struct CoinsStackView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .center) {
                CoinsStackView(.one)
                CoinsStackView(.two)
                CoinsStackView(.three)
                CoinsStackView(.largeOne)
                CoinsStackView(.largeTwo)
                CoinsStackView(.largeThree)
        }
    }
}
