//
//  CardRow.swift
//  TrafficRulesExam
//
//  Created by Yaroslav on 20.10.2021.
//

import SwiftUI

struct CardRow: View {
    @EnvironmentObject var coins: Coin
    
    @Environment(\.colorScheme) var colorScheme

    @State var results: CardResults = {
        var object: CardResults!

        do {
            object = try CardResults()
        } catch {
            UserDefaults.standard.removeObject(forKey: UDKeys.cardResults.rawValue)
            object = CardResults(items: (1...(cards.count)).map { CardResult(id: $0, resultHistory: Results(items: [])) })
        }
        return object
    }()

    @State var isErrorPresented = false

    var locCards: [ExamCard]

    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 160, maximum: 170)), count: 2)

        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach($results.items, id: \.id) { $result in
                    /*
                     Если использовать NavigationLink(isActive:) в ForEach тап на кнопку открывает рандомный destination.
                     Проблема закрытия DestinationView по тапу на кнопку решается через вызов в DestinationView
                     метода @Environment(\.presentationMode) переменной dismiss()
                     */
                    NavigationLink {
                        TicketView(card: locCards.getElementById(result.id), result: $result)
                    } label: {
                        CardItem(card: locCards.getElementById(result.id), result: $result)
                    }
                    .navigationTitle(Text("Билеты"))
                    .navigationBarTitleDisplayMode(.large)
                    .alert("Не хватает монет", isPresented: $isErrorPresented, actions: {
                        Button {
                            isErrorPresented = false
                        } label: {
                            Text("Ок")
                        }
                    }, message: {
                        Text("Чтобы открыть этот билет нужно больше монет. Их можно купить в магазине.")
                    })
                    // TODO: Make views blurred or transparent.
                    .disabled(coins.amount < coins.cardCost ? true : false)
                    .onTapGesture {
                        if coins.amount < coins.cardCost {
                            isErrorPresented = true
                        }
                    }
                }
            }
        }
    }
}

struct NavigationUtil {
    static func popToRootView() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let navigationController = findNavigationController(viewController: windowScene?.windows.first?.rootViewController)
        navigationController?.popToRootViewController(animated: false)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        CardRow(locCards: cards)
            .environmentObject(Coin())
    }
}
