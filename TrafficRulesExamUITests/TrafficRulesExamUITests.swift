//
//  TrafficRulesExamUITests.swift
//  TrafficRulesExamUITests
//
//  Created by Yaroslav on 04.11.2021.
//

import XCTest
import Nimble

class TrafficRulesExamUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExamFailedWalktrough() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // tap ExamCard
        let rndCardPeredicate = NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber" : "Билет \(Int.random(in: 1...2))"])
        app.scrollViews.otherElements.buttons.containing(rndCardPeredicate).firstMatch.tap()
        
        // Tap 19 questions
        for _ in 1...19 {
            app.buttons.containing(rndAnswerPredicate()).firstMatch.tap()
            app.buttons["Следующий вопрос"].tap()
        }
        
        // Tap last question and exit.
        app.buttons.containing(rndAnswerPredicate()).firstMatch.tap()
        app.buttons["Завершить"].tap()
        
        expect(app.buttons.containing(rndCardPeredicate).firstMatch.exists) == true
    }
    
    private func rndAnswerPredicate() -> NSPredicate {
        NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber" : "\(Int.random(in: 1...3))."])
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
