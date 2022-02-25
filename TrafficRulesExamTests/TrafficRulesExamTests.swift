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

    let coins = Coin()
    lazy var coinsTimer: CoinsTimer = .init(self.coins, coinsLimit: 5, timeLimit: 600, update: 1)

    let oneSubscription: Set<String> = [PurchasesID.subscriptionOneMonth.rawValue]
    let twoSubscriptions: Set<String> = [PurchasesID.subscriptionOneMonth.rawValue, PurchasesID.subscriptionThreeMonths.rawValue]
    let threeSubscriptions: Set<String> = [PurchasesID.subscriptionOneMonth.rawValue, PurchasesID.subscriptionThreeMonths.rawValue, PurchasesID.subscriptionSixMonths.rawValue]

    override func setUpWithError() throws {
//        KeychainWrapper.standard.remove(forKey: .coinsDropDate)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOneSubscriptionCoinsProvideByNextDay() throws {
        coins.amount = 20
        let currentDate = Date()
        guard let subscriptionStartDate = Calendar.current.date(byAdding: .day, value: -10, to: currentDate) else { XCTFail("Unable to create past month"); return }
        guard let yesturdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { XCTFail("Unable to create yesturday"); return }
        let subscriptionString = PurchasesID.subscriptionOneMonth.rawValue

        CoinsTimer.setSubscriptionKeychainValues(subscriptionStartDate, yesturdaysDate, subscriptionString)

        let previousTimeInterval = KeychainWrapper.standard.double(forKey: .coinsDropDate)!
        let previousDropDate = Date(timeIntervalSinceReferenceDate: previousTimeInterval)

        XCTAssert(Calendar.current.isDateInYesterday(previousDropDate), "Previous drop date didn't set properly")
        
        let someNewCoins = CoinsTimer.checkSubscriptionAmount(coin: coins)

        XCTAssert(someNewCoins == PurchasesID(rawValue: oneSubscription.first!)!.purchasedCoinsAmount, "Coins amount did not applied well: \(coins.amount)")
    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
