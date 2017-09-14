//
//  SentimentAnalyserTests.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest

class SentimentAnalyserTests: XCTestCase {
    
    func testMostCommentSentiment() {
        let sentiments: [Sentiment] = [
            .good,
            .good,
            .bad
        ]
        let mostCommon = SentimentAnalyserImplementation().mostCommonSentiment(from: sentiments)
        XCTAssertEqual(mostCommon, .good)
    }
    
}
