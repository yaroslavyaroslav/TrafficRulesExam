//
//  TrafficRulesExamUITests.swift
//  TrafficRulesExamUITests
//
//  Created by Yaroslav on 04.11.2021.
//

import Nimble
import OSLog
import XCTest

class TrafficRulesExamUITests: XCTestCase {
    private lazy var cards: [ExamCard] = cardsSource.map { ExamCard(source: $0) }

    private lazy var cardsSource: [ExamCardSource] = load("ExamCards.json")

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
        let nextQuestionButton = app.buttons["Вправо"]

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
        app.buttons["Вправо"].tap()

        expect(examCard.exists).to(beTrue(), description: "App didn't go back to exam screen.")
    }

    func testExamFailedStraightforwardWalktrough() throws {
        let (app, examCard) = startExam()

        // Tap 19 questions
        for id in 1...19 {
            os_log("question \(id.description) processing.")
            let answerButton = app.buttons.containing(rndAnswerPredicate()).firstMatch
            let nextQuestionButton = app.buttons["Вправо"]

            expect(answerButton.exists).to(beTrue(), description: "Answer button \(answerButton.label) in question \(id.description) doesn't exists")

            answerButton.tap()
            nextQuestionButton.tap()
        }

        // Tap last question and exit.
        app.buttons.containing(rndAnswerPredicate()).firstMatch.tap()
        app.buttons["Вправо"].tap()

        expect(examCard.exists).to(beTrue(), description: "App didn't go back to exam screen.")
    }

    func testExamSucceedStraightforwardWalktrough() {
        let randomCard = Int.random(in: 1...20)

        let (app, examCard) = startExam(randomCard)

        let appExamCard = cards.getElementById(randomCard)

        expect(app.navigationBars.firstMatch.identifier).to(contain("Билет \(randomCard)"), description: "ExamCard label \(examCard.label) doesn't match randomID \(randomCard.description)")

        for id in 1...19 {
            os_log("question \(id.description) processing.")
            let answerID = appExamCard.questions.getElementById(id).correctAnswer.stringValue
            let answerPredicate = exactAnswerPredicate(answerID)

            let answerButton = app.buttons.containing(answerPredicate).firstMatch
            let nextQuestionButton = app.buttons["Вправо"]

            expect(answerButton.exists).to(beTrue(), description: "Answer button \(answerID) in question \(id.description) doesn't exists")
            answerButton.tap()
            nextQuestionButton.tap()
        }

        // Tap last question and exit.
        let answerID = appExamCard.questions.getElementById(20).correctAnswer.stringValue
        let answerPredicate = exactAnswerPredicate(answerID)
        app.buttons.containing(answerPredicate).firstMatch.tap()
        app.buttons["Вправо"].tap()

        expect(examCard.exists).to(beTrue(), description: "App didn't go back to exam screen.")
    }

    /// Method to select examcard from all cards
    /// - Parameter id: card ID (1 based).
    /// - Returns: tuple: instance XCUIApplication, selected ExamCard
    private func startExam(_ id: Int? = nil) -> (XCUIApplication, XCUIElement) {
        let app = XCUIApplication()
        app.launch()

        let rndId = id ?? Int.random(in: 1...20)

        os_log("Ticket \(rndId.description) selected")

        let anyTicket = NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber": "Билет"])

        let rndCardPeredicate = NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber": "Билет \(rndId)"])
        // tap ExamCard

        var examCard: XCUIElement!
        for i in 1...4 {
            if app.buttons.containing(rndCardPeredicate).firstMatch.exists {
                examCard = app.buttons.containing(rndCardPeredicate).firstMatch
                break
            }

            app.scrollViews.otherElements.containing(anyTicket).firstMatch.swipeUp(velocity: XCUIGestureVelocity(500))

            if i == 4 && examCard == nil {
                XCTAssert(false, "Can't find Ticket button.")
            }
        }

        examCard.tap()

        return (app, examCard)
    }

    private func rndAnswerPredicate() -> NSPredicate {
        let rndId = Int.random(in: 1...2)
        os_log("Answer \(rndId.description) selected")

        // MARK: В некоторых вопросах только 2 ответа, поэтому пока ограничмся разбросом из 2.

        return NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber": "\(rndId),"])
    }

    private func exactAnswerPredicate(_ answer: String) -> NSPredicate {
        os_log("Answer \(answer) selected")
        return NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber": "\(answer),"])
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
