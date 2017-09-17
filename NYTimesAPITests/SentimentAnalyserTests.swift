//
//  SentimentAnalyzerTests.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest
@testable import NYTimesAPI

class SentimentAnalyzerTests: XCTestCase {
    
    func testMostCommentSentiment() {
        let sentiments: [Sentiment] = [
            .good,
            .good,
            .bad
        ]
        let mostCommon = SentimentAnalyzerImplementation().mostCommonSentiment(from: sentiments)
        XCTAssertEqual(mostCommon, .good)
    }
    
}
