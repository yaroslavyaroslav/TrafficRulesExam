//
//  TrafficRulesExamTests.swift
//  TrafficRulesExamTests
//
//  Created by Yaroslav on 04.11.2021.
//

import XCTest
import SwiftKeychainWrapper
import OSLog

@testable
import TrafficRulesExam

class TrafficRulesExamTests: XCTestCase {

    var coins = Coin()

    lazy var coinsTimer: CoinsTimer = .init(self.coins, coinsLimit: 5, timeLimit: 600, update: 1)

    let threeSubscriptions: Set<String> = [PurchasesID.subscriptionOneMonth.rawValue, PurchasesID.subscriptionThreeMonths.rawValue, PurchasesID.subscriptionSixMonths.rawValue]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        CoinsTimer.setSubscriptionKeychainValues(nil, nil, nil)
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubscriptionCoinsProvidedByNextDay() throws {
        let expectations = genExpectations(2)

        let subscription = PurchasesID(rawValue: threeSubscriptions.randomElement()!)!
        coins.amount = subscription.purchasedCoinsAmount - 10

        let currentDate = Date()
        let subscriptionStartDate = Calendar.current.date(byAdding: .day, value: -10, to: currentDate)!
        let yesturdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!

        CoinsTimer.setSubscriptionKeychainValues(subscriptionStartDate, yesturdaysDate, subscription.rawValue)

        wait(for: [expectations[0]], timeout: 0.5)

        let previousTimeInterval = KeychainWrapper.standard.double(forKey: .coinsDropDate)!
        let previousDropDate = Date(timeIntervalSinceReferenceDate: previousTimeInterval)

        XCTAssert(Calendar.current.isDateInYesterday(previousDropDate), "Previous drop date didn't set properly")

        coinsTimer.checkSubscriptionAmount()

        wait(for: [expectations[1]], timeout: 0.5)

//        let testSubscriptionLayer = KeychainWrapper.standard.string(forKey: .subscriptionLevel)
        let testStartSubscriptionTimeInterval = KeychainWrapper.standard.double(forKey: .subscriptionStartDate)
//        let testCoinsDropDateTimeInterval = KeychainWrapper.standard.double(forKey: .coinsDropDate)



        XCTAssertEqual(coins.amount, subscription.purchasedCoinsAmount, "Coins amount did not applied well: \(coins.amount)")
        XCTAssertEqual(subscriptionStartDate, Date(timeIntervalSinceReferenceDate: testStartSubscriptionTimeInterval!), "Start dates don't match: \(subscriptionStartDate.prettyPrint) vs ")
    }


    func testSubscriptionCoinsProvidedByLastDayOfPeriod() throws {
        let expectations = genExpectations(2)

        let subscription = PurchasesID(rawValue: threeSubscriptions.randomElement()!)!
        coins.amount = subscription.purchasedCoinsAmount - 10

        let currentDate = Date()
        let endDAte = Calendar.current.date(byAdding: .month, value: subscription.subscriptionLength, to: currentDate)!
        let dropDate = Calendar.current.date(byAdding: .day, value: -10, to: endDAte)

        CoinsTimer.setSubscriptionKeychainValues(currentDate, dropDate, subscription.rawValue)
        wait(for: [expectations[0]], timeout: 0.5)

        coinsTimer.checkSubscriptionAmount()

        wait(for: [expectations[1]], timeout: 0.5)

        XCTAssertEqual(coins.amount, subscription.purchasedCoinsAmount, "Coins amount did not applied well: \(coins.amount)")
    }

    func testThatSubscriptionCoinsAddsOnlyOnceADay() {
        let expectations = genExpectations(2)
        
        let subscription = PurchasesID(rawValue: threeSubscriptions.randomElement()!)!
        let staticCoinsAmount = subscription.purchasedCoinsAmount - 10
        coins.amount = staticCoinsAmount

        let currentDate = Date()
        /// hours could fail test near past the midnight
        /// since it's next day in calendar, but test don't assume that
        let pastHourDate = Calendar.current.date(byAdding: .minute, value: -2, to: currentDate)!

        CoinsTimer.setSubscriptionKeychainValues(currentDate, pastHourDate, subscription.rawValue)
        wait(for: [expectations[0]], timeout: 0.5)

        coinsTimer.checkSubscriptionAmount()

        wait(for: [expectations[1]], timeout: 0.5)

        XCTAssertEqual(coins.amount, staticCoinsAmount, "Coins amount did not applied well: \(staticCoinsAmount) vs \(coins.amount)")
        XCTAssertNotEqual(coins.amount, subscription.purchasedCoinsAmount, "Coins shoul'd be appiled on second run in a day")
    }

    func testSubscriptionEnds() {
        let expectations = genExpectations(2)

        let subscription = PurchasesID(rawValue: threeSubscriptions.randomElement()!)!
        let staticCoinsAmount: UInt = 20
        coins.amount = staticCoinsAmount

        let currentDate = Date()
        let tmpDate = Calendar.current.date(byAdding: .month, value: -subscription.subscriptionLength, to: currentDate)!
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: tmpDate)
        let dropDate = currentDate

        CoinsTimer.setSubscriptionKeychainValues(startDate, dropDate, subscription.rawValue)
        wait(for: [expectations[0]], timeout: 0.5)

        coinsTimer.checkSubscriptionAmount()

        wait(for: [expectations[1]], timeout: 0.5)

        XCTAssertEqual(coins.amount, staticCoinsAmount, "Coins amount did not applied well: \(staticCoinsAmount) vs \(coins.amount)")
        XCTAssertNotEqual(coins.amount, subscription.purchasedCoinsAmount, "Coins shoul'd be appiled on second run in a day")

    }

    func testIgnoresSubscriptionIfUserHaveMoreCoins() throws {
        let expectations = genExpectations(2)

        let subscription = PurchasesID(rawValue: threeSubscriptions.randomElement()!)!
        let staticCoinsAmount: UInt = 200
        coins.amount = staticCoinsAmount

        let currentDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: currentDate)!
        let dropDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)

        CoinsTimer.setSubscriptionKeychainValues(startDate, dropDate, subscription.rawValue)
        wait(for: [expectations[0]], timeout: 0.5)

        coinsTimer.checkSubscriptionAmount()

        wait(for: [expectations[1]], timeout: 0.5)

        XCTAssertEqual(coins.amount, staticCoinsAmount, "Coins amount did not applied well: \(staticCoinsAmount) vs \(coins.amount)")
        XCTAssertNotEqual(coins.amount, subscription.purchasedCoinsAmount, "Coins shoul'd be appiled on second run in a day")
    }

    func testSetFirstSubscriptionEver() throws {
        let expectations = genExpectations(2)

        let subscription = PurchasesID(rawValue: threeSubscriptions.randomElement()!)!
        let staticCoinsAmount: UInt = 200
        coins.amount = staticCoinsAmount

        let currentDate = Date()
        let tmpDate = Calendar.current.date(byAdding: .month, value: -subscription.subscriptionLength, to: currentDate)!
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: tmpDate)
        let dropDate = currentDate

        CoinsTimer.setSubscriptionKeychainValues(startDate, dropDate, subscription.rawValue)
        wait(for: [expectations[0]], timeout: 0.5)

        coinsTimer.checkSubscriptionAmount()

        wait(for: [expectations[1]], timeout: 0.5)

        XCTAssertEqual(coins.amount, staticCoinsAmount, "Coins amount did not applied well: \(staticCoinsAmount) vs \(coins.amount)")
        XCTAssertNotEqual(coins.amount, subscription.purchasedCoinsAmount, "Coins shoul'd be appiled on second run in a day")
    }

    // FIXME: Disabled because there's no subscriptions.
//    func testChangeSubscriptionToHigher() throws {
//
//        let expectations = genExpectations(4)
//
//        let lowerSubscription = PurchasesID(rawValue: threeSubscriptions.dropLast().randomElement()!)!
//        coins.amount = lowerSubscription.purchasedCoinsAmount
//
//        let currentDate = Date()
//        let tmpDate = Calendar.current.date(byAdding: .month, value: -lowerSubscription.subscriptionLength, to: currentDate)!
//        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: tmpDate)
//        let dropDate = currentDate
//
//        CoinsTimer.setSubscriptionKeychainValues(startDate, dropDate, lowerSubscription.rawValue)
//        wait(for: [expectations[0]], timeout: 0.5)
//
//        coinsTimer.checkSubscriptionAmount()
//
//        wait(for: [expectations[1]], timeout: 0.5)
//
//        let firstKeychainSubscription = KeychainWrapper.standard.string(forKey: .subscriptionLevel)
//
//        XCTAssertEqual(firstKeychainSubscription, lowerSubscription.rawValue, "Keychain stores wrong subscription")
//
//        CoinsTimer.setSubscriptionKeychainValues(currentDate, currentDate, PurchasesID.subscriptionSixMonths.rawValue)
//        coins.amount = PurchasesID.subscriptionSixMonths.purchasedCoinsAmount
//
//        wait(for: [expectations[2]], timeout: 0.5)
//
//        XCTAssertEqual(coins.amount, PurchasesID.subscriptionSixMonths.purchasedCoinsAmount, "Coins amount did not applied well: \(coins.amount) vs \(PurchasesID.subscriptionSixMonths.purchasedCoinsAmount)")
//        XCTAssertNotEqual(coins.amount, lowerSubscription.purchasedCoinsAmount, "Coins should be equal to lower subscription: \(coins.amount) vs \(lowerSubscription.purchasedCoinsAmount)")
//    }


    func genExpectations(_ amount: Int) -> [XCTestExpectation] {
        (1...amount).map { number -> XCTestExpectation in
            let expectation = XCTestExpectation(description: number.description)
            expectation.isInverted = true
            return expectation
        }
    }


//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
