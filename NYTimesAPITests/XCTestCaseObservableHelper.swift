//
//  XCTestCaseObservableHelper.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import XCTest
@testable import NYTimesAPI

extension XCTestCase {
    func runTestAsync(time: Double = 0.1, _ closure: @escaping () -> Void) {
        let expectation = self.expectation(description: "wait until after dispatch queue main")
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
            closure()
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 0.2, handler: nil)
    }
}
