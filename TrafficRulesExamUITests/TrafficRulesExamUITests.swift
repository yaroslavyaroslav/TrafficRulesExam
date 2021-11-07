//
//  TrafficRulesExamUITests.swift
//  TrafficRulesExamUITests
//
//  Created by Yaroslav on 04.11.2021.
//

import XCTest
import Nimble


class TrafficRulesExamUITests: XCTestCase {
    
    private lazy var cards: [ExamCard] =  {
        cardsSource.map { ExamCard(source: $0) }
    }()

    private lazy var cardsSource: [ExamCardSource] = {
        load("ExamCards.json")
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExamFailedRandomOrderWalkthrough() throws {
        let (app, examCard) = startExam()
        
        let rndArray = [18, 9, 6, 14].shuffled()
        let nextQuestionButton = app.buttons["Следующий вопрос"]

        app.buttons["\(rndArray[0])"].tap()

        // Tap 5 questions
        for _ in 1...5 {
            let answerButton = app.buttons.containing(rndAnswerPredicate()).firstMatch
            expect(answerButton.exists).to(beTrue(), description: "Answer button doesn't exists")
            answerButton.tap()
            nextQuestionButton.tap()
        }
        
        app.buttons["\(rndArray[1])"].tap()
        
        for _ in 1...5 {
            let answerButton = app.buttons.containing(rndAnswerPredicate()).firstMatch
            expect(answerButton.exists).to(beTrue(), description: "Answer button doesn't exists")
            answerButton.tap()
            nextQuestionButton.tap()
        }
        
        app.buttons["\(rndArray[2])"].tap()
        
        for _ in 1...5 {
            let answerButton = app.buttons.containing(rndAnswerPredicate()).firstMatch
            expect(answerButton.exists).to(beTrue(), description: "Answer button doesn't exists")
            answerButton.tap()
            nextQuestionButton.tap()
        }
        
        app.buttons["\(rndArray[3])"].tap()
        
        for _ in 1...4 {
            let answerButton = app.buttons.containing(rndAnswerPredicate()).firstMatch
            expect(answerButton.exists).to(beTrue(), description: "Answer button doesn't exists")
            answerButton.tap()
            nextQuestionButton.tap()
        }
        
        // Tap last question and exit.
        app.buttons.containing(rndAnswerPredicate()).firstMatch.tap()
        app.buttons["Завершить"].tap()
        
        expect(examCard.exists).to(beTrue(), description: "App didn't go back to exam screen.")
    }

    func testExamFailedStraightforwardWalktrough() throws {
        let (app, examCard) = startExam()
        
        // Tap 19 questions
        for _ in 1...19 {
            let answerButton = app.buttons.containing(rndAnswerPredicate()).firstMatch
            let nextQuestionButton = app.buttons["Следующий вопрос"]
            
            expect(answerButton.exists).to(beTrue(), description: "Answer button doesn't exists")
            answerButton.tap()
            nextQuestionButton.tap()
        }
        
        // Tap last question and exit.
        app.buttons.containing(rndAnswerPredicate()).firstMatch.tap()
        app.buttons["Завершить"].tap()
        
        expect(examCard.exists).to(beTrue(), description: "App didn't go back to exam screen.")
    }
    
    func testExamSucceedStraightforwardWalktrough() {
        
        let randomCard = Int.random(in: 1...2)
        
        let (app, examCard) = startExam(randomCard)
        
        let appExamCard = cards[randomCard - 1]
        
        for id in 0...18 {
            let answerID = appExamCard.questions[id].correctAnswer.stringValue
            let answerPredicate = NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber" : "\(answerID)"])
            
            let answerButton = app.buttons.containing(answerPredicate).firstMatch
            let nextQuestionButton = app.buttons["Следующий вопрос"]
            
            expect(answerButton.exists).to(beTrue(), description: "Answer button doesn't exists")
            answerButton.tap()
            nextQuestionButton.tap()
        }
        
        // Tap last question and exit.
        let answerID = appExamCard.questions[19].correctAnswer.stringValue
        let answerPredicate = NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber" : "\(answerID)"])
        app.buttons.containing(answerPredicate).firstMatch.tap()
        app.buttons["Завершить"].tap()
        
        expect(examCard.exists).to(beTrue(), description: "App didn't go back to exam screen.")
    }
    
    
    /// Method to select examcard from all cards
    /// - Parameter id: card ID (1 based).
    /// - Returns: tuple: instance XCUIApplication, selected ExamCard
    private func startExam(_ id: Int? = nil) -> (XCUIApplication, XCUIElement) {
        let app = XCUIApplication()
        
        app.launch()
        let rndCardPeredicate = NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber" : "Билет \(id ?? Int.random(in: 1...2))"])
        // tap ExamCard
        let examCard = app.scrollViews.otherElements.buttons.containing(rndCardPeredicate).firstMatch
        examCard.tap()
        
        return (app, examCard)
    }
    
    private func rndAnswerPredicate() -> NSPredicate {
        // В некоторых вопросах только 2 ответа, поэтому пока ограничмся разбросом из 2.
        NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber" : "\(Int.random(in: 1...2))."])
    }
        
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
