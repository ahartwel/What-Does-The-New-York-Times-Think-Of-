//
//  SentimentAnalyzerDependencyInjector.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/13/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation

protocol SentimentAnalyzerRequester {
    var sentimentAnalyzer: SentimentAnalyzer { get }
}

extension SentimentAnalyzerRequester {
    var sentimentAnalyzer: SentimentAnalyzer {
        #if TESTING
            return TestingStubs.sentimentAnalyzerStub
        #else
            return mainSentimentAnalyzer
        #endif
    }
}

fileprivate var mainSentimentAnalyzer: SentimentAnalyzer = SentimentAnalyzerImplementation()
