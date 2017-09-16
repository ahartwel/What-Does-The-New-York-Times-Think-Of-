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
        return mainSentimentAnalyzer
    }
}

fileprivate var mainSentimentAnalyzer = SentimentAnalyzerImplementation()
