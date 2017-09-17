//
//  TestingStubs.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/17/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

#if TESTING
    class TestingStubs {
        static var sentimentAnalyzerStub: SentimentAnalyzerStub = SentimentAnalyzerStub()
        static var timesArticleApiStub: TimesArticleAPIStub = TimesArticleAPIStub()
        static var timesTagApiStub: TimesTagApiStub = TimesTagApiStub()
    }
#endif
