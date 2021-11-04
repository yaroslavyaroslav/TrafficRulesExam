//
//  TrafficRulesExamUITests.swift
//  TrafficRulesExamUITests
//
//  Created by Yaroslav on 04.11.2021.
//

import XCTest

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

    func testExamWorkflowWalktrough() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // tap ExamCard
        app.scrollViews.otherElements.buttons.element(boundBy: 0).tap()

        
        // Tap 19 questions
        for _ in 1...19 {
            app.buttons.containing(rndPredicate()).firstMatch.tap()
            app.buttons["Следующий вопрос"].tap()
        }
        
        // Tap last question and exit.
        app.buttons.containing(rndPredicate()).firstMatch.tap()
        app.buttons["Завершить"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    private func rndAnswer() -> Int { Int.random(in: 1...3) }
    
    private func rndPredicate() -> NSPredicate {
        NSPredicate(format: "label BEGINSWITH $someNumber").withSubstitutionVariables(["someNumber" : "\(rndAnswer())."])
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
