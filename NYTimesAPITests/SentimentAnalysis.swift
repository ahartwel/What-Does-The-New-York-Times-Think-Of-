//
//  SentimentAnalysis.swift
//  NYTimesAPITests
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import XCTest

class SentimentAnalysis: XCTestCase {
    
    func testBadAnalysis() {
        let analyzer = SentimentAnalyzerImplementation()
        let sentiment = analyzer.analyze(timesArticle:
            TimesArticle(headline: "Sucks bad horrible", snippet: "worst thing ever")
        )
        XCTAssertEqual(sentiment, .bad)
    }
    
    func testGoodAnalysis() {
        let analyzer = SentimentAnalyzerImplementation()
        let sentiment = analyzer.analyze(timesArticle:
            TimesArticle(headline: "Wonderful great awesome", snippet: "happy amazing great")
        )
        XCTAssertEqual(sentiment, .good)
    }
    
    func testNeutralAnalysis() {
        let analyzer = SentimentAnalyzerImplementation()
        let sentiment = analyzer.analyze(timesArticle:
            TimesArticle(headline: "ok computer science keyboard", snippet: "floor ceiling ground")
        )
    }
}
